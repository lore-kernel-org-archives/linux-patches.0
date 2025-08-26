Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E72935207F;
	Tue, 26 Aug 2025 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217060; cv=none; b=IQ6LVRyKc13hUKCgyWFVSou+UfC5RGhqtSYcM9oZM7VfpooW3uUFoSp0UclJoMC0fUgDWjFBsewj641vD3ZGRI7yokgkq72ztrBLPNZ6lDkBp5UtXDOVG8Hi695/pJaSY1IisesKbLNuxUaEIoOnJLITBNOJ4ZmUoqeu1DZ37/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217060; c=relaxed/simple;
	bh=ERxh9k1FfPJbP/URNUx94Idt40kDjD2z6tBeQfA3VLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlzXNcssliI0YjdllY9w0jmRDlqtQcgYKAg5FL8a+3X2ilthL1fB7AT3omCqMzV1hj9SOnn0nUp4BLs2z7Nt+xspss2wdsdUmkp0ktWG5d4bMZi7au4NyNBsgJdWxvy1Y4NY3LB5aLhi20tD3adYNB9WmV33Teustk2VZp22XLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLfyVKWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLfyVKWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB640C4CEF1;
	Tue, 26 Aug 2025 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217060;
	bh=ERxh9k1FfPJbP/URNUx94Idt40kDjD2z6tBeQfA3VLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLfyVKWt4x8Gp8l4+1ENwRq5ymNbbVBlDBhEx84ZHLv/H7//cIbkfa11v3RVlei+f
	 xCVtGuf1O+ciNatw0OW2phc0B0w3BZDwAon8DggXjH9UnL+3ASKRg+W2qtMYHXY2Kj
	 HLFcJgWlnYcKqror22JkC4L6/1rDcYnC6MAp8Hvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 5.15 644/644] wifi: mac80211: check basic rates validity in sta_link_apply_parameters
Date: Tue, 26 Aug 2025 13:12:15 +0200
Message-ID: <20250826111002.523760019@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosa.ru>

commit 16ee3ea8faef8ff042acc15867a6c458c573de61 upstream.

When userspace sets supported rates for a new station via
NL80211_CMD_NEW_STATION, it might send a list that's empty
or contains only invalid values. Currently, we process these
values in sta_link_apply_parameters() without checking the result of
ieee80211_parse_bitrates(), which can lead to an empty rates bitmap.

A similar issue was addressed for NL80211_CMD_SET_BSS in commit
ce04abc3fcc6 ("wifi: mac80211: check basic rates validity").
This patch applies the same approach in sta_link_apply_parameters()
for NL80211_CMD_NEW_STATION, ensuring there is at least one valid
rate by inspecting the result of ieee80211_parse_bitrates().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: b95eb7f0eee4 ("wifi: cfg80211/mac80211: separate link params from station params")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Link: https://patch.msgid.link/20250317103139.17625-1-m.lobanov@rosa.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Summary of conflict resolutions:
  - Function ieee80211_parse_bitrates() takes channel width as its
    first parameter in mainline kernel version. In v5.15 the function
    takes the whole chandef struct as its first parameter.
  - The same function takes link station parameters as its last
    parameter, and in v5.15 they are in a struct called sta,
    instead of a struct called link_sta. ]
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1658,12 +1658,13 @@ static int sta_apply_parameters(struct i
 			return ret;
 	}
 
-	if (params->supported_rates && params->supported_rates_len) {
-		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
-					 sband, params->supported_rates,
-					 params->supported_rates_len,
-					 &sta->sta.supp_rates[sband->band]);
-	}
+	if (params->supported_rates &&
+	    params->supported_rates_len &&
+	    !ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
+				      sband, params->supported_rates,
+				      params->supported_rates_len,
+				      &sta->sta.supp_rates[sband->band]))
+		return -EINVAL;
 
 	if (params->ht_capa)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,


