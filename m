Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBDC246790;
	Tue, 26 Aug 2025 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213746; cv=none; b=phSIcB5mB8KwSRs7d0UEF/9levdKWaaj+706OtbIErtsQyrAseVq/WRVTa8WqMg6a7hiRCJIZp020tE7NVfCzrJUvYetQbRThzDkyohpPgpXJXZjLrDrwwUf3vLGIFvzdWicmos3MCRSow9o2Hq0OeH3i+d2n7FRuoa+B+AVxEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213746; c=relaxed/simple;
	bh=2PVrLuFdUTXDrykGiRZqQkmTUwAJPPI0qPYT5lLJmZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aFd94+QqiNIRGu0ZNoF2YT7RX81cMY2mlxyGaCjF7gdaV/nOIU07OC3Fnl5ytGYGnKB5PIOKyEeG0Pj4B9OAi1xnVY8PBsTiLOzKykXzhRL2+nUr0kxyUiDRP1zz8qMWuY553WP3R+zb+HiCakksHEtAvUNBGQIqGwWMm0i83QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mzYxF3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mzYxF3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78994C4CEF1;
	Tue, 26 Aug 2025 13:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213744;
	bh=2PVrLuFdUTXDrykGiRZqQkmTUwAJPPI0qPYT5lLJmZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mzYxF3DgB5juAH804YhLa5WtK/ZehXcqvL469PI+DUd17xw3M98I8O9GDOkCEidI
	 aMzuelz7fxwouBBlPlqsG+Lm4fhmfAJTUEyxGmnF5+xWarzto2srGJUFAMbWI7eZaQ
	 mdiKT22TpurG/5H5DfdYAeRJcSq44RNbWTtfb2d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 6.6 463/587] wifi: mac80211: check basic rates validity in sta_link_apply_parameters
Date: Tue, 26 Aug 2025 13:10:12 +0200
Message-ID: <20250826111004.757469290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: "Hanne-Lotta Mäenpää" <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1847,12 +1847,12 @@ static int sta_link_apply_parameters(str
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


