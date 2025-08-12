Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7AF2D3ED6;
	Tue, 12 Aug 2025 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023693; cv=none; b=gqi3vKOvAtcYIE/MhP+KQ0+X+GT33/nozlQNEKd0kafcskwFO+ifM/seOkofFAwt2MI3HraYLKjLVYN0YokHkPW5n2gokxft3rjxnd+zJ8rM8bxWC+DxvvYDpWz/wFUQ31JY1lBiVnDLG9yo/eIw4Bcv/KH9o/CuCFHB36xZPko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023693; c=relaxed/simple;
	bh=6V1YHLkg9MHbI/QhvSk7zX+/g/a9ZqO+21ZmHq/i9vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6/fGZMWzlVZc7b5mIgr8yu7ejlLVmHNhvZKsv7S7TnjPhfKzYcyKJFAONJlWlJJzs1MKx+XwTuUEBu2BCgKNd8280HGCphKk+B6OtT8M+XF2DgMG1VtNfOlK6rHADPFs2wCdbceXh6pVOUr65DHo/Zr5J7bK5rcod3ofZ9uUZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5BxdYHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5BxdYHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D71C4CEF0;
	Tue, 12 Aug 2025 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023693;
	bh=6V1YHLkg9MHbI/QhvSk7zX+/g/a9ZqO+21ZmHq/i9vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5BxdYHprTcehdZqpty6VgGLZYmJpzL4lMD9laihwNnyoLsHEqg2K0L7qW89GfCu7
	 vCnohYFbBfbY0MY6QcSD01f5abtNtrihVqVkKeirhcx3/IXZLYgKrzXra91GnZ79MD
	 kvmaiUGBRzLmxf5FhhzaCQueXMZ8wiUQ8waomAgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 154/627] wifi: mac80211: Fix bssid_indicator for MBSSID in AP mode
Date: Tue, 12 Aug 2025 19:27:29 +0200
Message-ID: <20250812173425.147071455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit 2eb7c1baf46aea134e908cd6d37907d92f823251 ]

Currently, in ieee80211_assign_beacon() mbssid count is updated as link's
bssid_indicator. mbssid count is the total number of MBSSID elements in
the beacon instead of Max BSSID indicator of the Multiple BSS set.
This will result in drivers obtaining an invalid bssid_indicator for BSSes
in a Multiple BSS set.
Fix this by updating link's bssid_indicator from MBSSID element for
Transmitting BSS and update the same for all of its Non-Transmitting BSSes.

Fixes: dde78aa52015 ("mac80211: update bssid_indicator in ieee80211_assign_beacon")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20250530040940.3188537-1-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 954795b0fe48..bc64c1b83a6e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -178,6 +178,7 @@ static int ieee80211_set_ap_mbssid_options(struct ieee80211_sub_if_data *sdata,
 
 		link_conf->nontransmitted = true;
 		link_conf->bssid_index = params->index;
+		link_conf->bssid_indicator = tx_bss_conf->bssid_indicator;
 	}
 	if (params->ema)
 		link_conf->ema_ap = true;
@@ -1218,8 +1219,11 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		}
 		/* update bssid_indicator */
-		link_conf->bssid_indicator =
-			ilog2(__roundup_pow_of_two(mbssid->cnt + 1));
+		if (new->mbssid_ies->cnt && new->mbssid_ies->elem[0].len > 2)
+			link_conf->bssid_indicator =
+					*(new->mbssid_ies->elem[0].data + 2);
+		else
+			link_conf->bssid_indicator = 0;
 	}
 
 	if (csa) {
-- 
2.39.5



