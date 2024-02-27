Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB7313B2B8;
	Tue, 27 Feb 2024 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043810; cv=none; b=jWw/CnKK+bI/6xJcmviI+RdVfTLKWXJtJ0NW+12H8OJ9Z7+XP2sN3iAnAeRFVPzPynPpX06o2jtbKXTSq8wyEpPhAzZVLzDJ2FWU3CFHpqTaWinqMPnsRCMkjpAu+pnh2EgARanEHGU4X3M+WuwnzfH1MYBmg/Colc/cuQudS8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043810; c=relaxed/simple;
	bh=wlBQUu//PhNsITu0h53iaQFtgGlIk02rogsF4bEltYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcI15/RkGB6JHI7HJeub4/WU4P0PWJ3fzotI8AqHr1IzfUAiMQGy/YJ0r/MaxfLsFNc96sqPObKKCbAmwq7PV8mn4GftIquya4t6S1Pgtj+EWPugMt4U9KJ+W3uUkxdSu1mM1gS0pthTzpxvdd7ePkujGCdQ70l6nLVhv6NmQSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6CctYKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6CctYKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4FBC433F1;
	Tue, 27 Feb 2024 14:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043810;
	bh=wlBQUu//PhNsITu0h53iaQFtgGlIk02rogsF4bEltYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6CctYKAPvBtBYdRiZeVc/AD7ljJcjQ3IFNRuwM66WMeBpM2T9jYcuYSrMg8pe9VK
	 4laM7j8v+dUqw7m80EOvcEiXxT2385/H+L8NBAYpA0KjBzO54WmtNwv1VrKBk+LiS1
	 4nvUD8uflcLqfz8l1cPqvui3RQnVkC8kZ6RMR2aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/84] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:26:43 +0100
Message-ID: <20240227131553.401289308@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bcbc84af1183c8cf3d1ca9b78540c2185cd85e7f ]

fast-xmit must only be enabled after the sta has been uploaded to the driver,
otherwise it could end up passing the not-yet-uploaded sta via drv_tx calls
to the driver, leading to potential crashes because of uninitialized drv_priv
data.
Add a missing sta->uploaded check and re-check fast xmit after inserting a sta.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://msgid.link/20240104181059.84032-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 ++
 net/mac80211/tx.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0f97c6fcec174..e330036e02eac 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -683,6 +683,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8bd01dfa75cb1..5fd9a6f752a1d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2919,7 +2919,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



