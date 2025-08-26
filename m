Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F3B334717;
	Tue, 26 Aug 2025 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215252; cv=none; b=ZCFH6H4A8wp3gm3c+gTzrz62tb0wNKeBit6auwBCJNp/cfQKjig/6Lx9XiHN5AHMen+R0cmijg0g4+w+8ezNg3KusMwdZGwRNucRb9FrSMvEtikkVi3YPVSHnbrg1cVjTijO9kBYNlTc8gR//V0fPbdEb1FsEPejEWICdhe5gvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215252; c=relaxed/simple;
	bh=bfDnmWsSETdMDxgFTni/qf35fIzwvEO0eKnkrfOBDe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZ9Ii9823a3NDqgXaWKXsQTkYsKy6TWd6UVEKP4RLMwP79BrlpRzZv5kL0erg1r8nwioZ0770AMYQRzsMtw0B2YORAuuW62ui5jWkdG7tlBx3v608Q8J1grhsFS0Wg0rgRDzkExZoVa1z5RcS20g3I6u51EMA887K1pkHB+FrgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIlLOwav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIlLOwav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F8BC4CEF1;
	Tue, 26 Aug 2025 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215252;
	bh=bfDnmWsSETdMDxgFTni/qf35fIzwvEO0eKnkrfOBDe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIlLOwavUYJVnUJczlq+UXlCNdj2+nrJhn+V5nDGlXCEit270aLWyerp18joraOow
	 AU2unO9/Nt7RQg4vOvTyOCc9mT31v/gOZwzuN+BjG5bEZsXLFntlesgfzQdHOfO6jT
	 kW0+mcwlLUnC5wr4gMa24EP8M9ois+RNDUyIJ4jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 6.1 444/482] wifi: mac80211: check basic rates validity in sta_link_apply_parameters
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826110941.799148884@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
  - The function ieee80211_parse_bitrates() takes channel width as
    its first parameter, and the chandef struct has been refactored
    in kernel version 6.9, in commit
    6092077ad09ce880c61735c314060f0bd79ae4aa so that the width is
    contained in chanreq.oper.width. In kernel version 6.1 the
    width parameter is defined directly in the chandef struct. ]
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1735,12 +1735,12 @@ static int sta_link_apply_parameters(str
 	}
 
 	if (params->supported_rates &&
-	    params->supported_rates_len) {
-		ieee80211_parse_bitrates(link->conf->chandef.width,
-					 sband, params->supported_rates,
-					 params->supported_rates_len,
-					 &link_sta->pub->supp_rates[sband->band]);
-	}
+	    params->supported_rates_len &&
+	    !ieee80211_parse_bitrates(link->conf->chandef.width,
+				      sband, params->supported_rates,
+				      params->supported_rates_len,
+				      &link_sta->pub->supp_rates[sband->band]))
+		return -EINVAL;
 
 	if (params->ht_capa)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,


