Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5D586332;
	Mon,  6 Jan 2025 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177858; cv=none; b=q8alN8xb73RrKXOqoB2We1bv+2Jih4a/8VkDJVrji8ojCCdVoO5i/NGVBf/+dDiVU6oflCHwk872E/zx/+ll+NBpEoAGbm6H6w825odHWAOiiRsw5D+ZnjBxgHTRqIXgsduLtJqjj3mT0TCA9fDnvYkoSL6I68+e8Y4meExgjiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177858; c=relaxed/simple;
	bh=ADIYJ0lJGYQlmtgYK3syHPEIydVGwkgUlIrDaYYqUuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kX5jstaFx041o5LU8C09/+5u/Tlo08SfAvZzosncjsO8lmtWcHhwZWqmw4cBVsWyrFoCRLbuBtur3HwGfleu4pNpOnC8sE7mr/uvMmFbkCDk2V5xFdg+SqQSV9o2OgOysfG566OehSx7kormZ34Kg5HpFyIdmBFFCi3YvsxXvgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S35j8syB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S35j8syB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF97C4CED2;
	Mon,  6 Jan 2025 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177858;
	bh=ADIYJ0lJGYQlmtgYK3syHPEIydVGwkgUlIrDaYYqUuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S35j8syBLe+GDSN/U6c3uxjrbBHJbxB8n7hxbo4KxQbs7jPhf134pIJAQiAhSgDS1
	 rB+V6V+wLvbnqKVC16DRZ2J/RSJ99gJ6AfwjWXlHvdbKSaCYgbLE3foNAlTC3e0vBu
	 o614O/wpyBnu52L8yRWh5ToRE/07BGOG7cAvo6K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/156] wifi: cfg80211: clear link ID from bitmap during link delete after clean up
Date: Mon,  6 Jan 2025 16:16:05 +0100
Message-ID: <20250106151144.707551242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit b5c32ff6a3a38c74facdd1fe34c0d709a55527fd ]

Currently, during link deletion, the link ID is first removed from the
valid_links bitmap before performing any clean-up operations. However, some
functions require the link ID to remain in the valid_links bitmap. One
such example is cfg80211_cac_event(). The flow is -

nl80211_remove_link()
    cfg80211_remove_link()
        ieee80211_del_intf_link()
            ieee80211_vif_set_links()
                ieee80211_vif_update_links()
                    ieee80211_link_stop()
                        cfg80211_cac_event()

cfg80211_cac_event() requires link ID to be present but it is cleared
already in cfg80211_remove_link(). Ultimately, WARN_ON() is hit.

Therefore, clear the link ID from the bitmap only after completing the link
clean-up.

Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Link: https://patch.msgid.link/20241121-mlo_dfs_fix-v2-1-92c3bf7ab551@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c  | 8 +++++++-
 net/wireless/util.c | 3 +--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1b1bf044378d..f11fd360b422 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4992,10 +4992,16 @@ static void ieee80211_del_intf_link(struct wiphy *wiphy,
 				    unsigned int link_id)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	u16 new_links = wdev->valid_links & ~BIT(link_id);
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	ieee80211_vif_set_links(sdata, wdev->valid_links, 0);
+	/* During the link teardown process, certain functions require the
+	 * link_id to remain in the valid_links bitmap. Therefore, instead
+	 * of removing the link_id from the bitmap, pass a masked value to
+	 * simulate as if link_id does not exist anymore.
+	 */
+	ieee80211_vif_set_links(sdata, new_links, 0);
 }
 
 static int
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f49b55724f83..18585b1416c6 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2843,10 +2843,9 @@ void cfg80211_remove_link(struct wireless_dev *wdev, unsigned int link_id)
 		break;
 	}
 
-	wdev->valid_links &= ~BIT(link_id);
-
 	rdev_del_intf_link(rdev, wdev, link_id);
 
+	wdev->valid_links &= ~BIT(link_id);
 	eth_zero_addr(wdev->links[link_id].addr);
 }
 
-- 
2.39.5



