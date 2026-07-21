Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB246F499;
	Tue, 21 Jul 2026 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656195; cv=none; b=G8Z5v1/y3WK4mxQBL4i60yA/eBDQJY9mS/KZ7UHxpOgQcM8SSfBS46/mn/tQiOic20QfzXifjEZMENItiL2i4sxrWx9m2g8JMwEVvkDKIYsvRfCISLuavdECGCojFaqox6WnlKQHA/EtKsL8gBGBfIgVCFHqRn81rgm/eGZU+vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656195; c=relaxed/simple;
	bh=8xpYMdVSfpx4+mmw9p8udxFV9KbX8LHyprEClk7qQt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUCpHGuZbM/zMNVCs3e0Wnk//bruAFYTniK2HOKrQxQmvi7fOxLo/cCS/CA4V9uViytX8J0Ru0raNWvHiv/cXeKtv8N+qg+fgWmCr1N+xsw6nyPJmvQZCJ0tvtXnFtFZkCJi6MIjHcKo17bepJNmWnhAXUvZbCj7bevYIZ94Aho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psot8lSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psot8lSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F11F000E9;
	Tue, 21 Jul 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656194;
	bh=pYWAez2TLSV6hybetJc0VWWXU9DaLROHt+/BLQnDLpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psot8lSn8yCNoHdoNeO/GAgXMI6yPgQP/4iOTNGxSnsbVOJOpQqzun4SgLM8B1RtP
	 4U8xcgls6WlfUejCx7W0QLWuMYnoA0sLs/ee6eiRNLZldxYjz2ApzLkNgv1laqgeCx
	 p3JcvFzD9lfqj6wqIYq2IQaHS0mF5lJmm4AlXIAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0296/1611] wifi: ath12k: fix NULL deref in change_sta_links for unready link
Date: Tue, 21 Jul 2026 17:06:52 +0200
Message-ID: <20260721152521.727533465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Zhang <wei.zhang@oss.qualcomm.com>

[ Upstream commit 47809a7c8348bc4a332ccc26a37c7145a5f609f8 ]

_ieee80211_set_active_links() calls _ieee80211_link_use_channel() for
each newly-added link and WARN_ON_ONCE()s if it fails. The call uses
assign_on_failure=true, which allows mac80211 to continue despite
driver failures, but when a mac80211-level channel validation fails
(e.g., combinations check, DFS, or no available radio),
drv_assign_vif_chanctx() is never reached. Since ath12k_mac_vdev_create()
is only called from that path, arvif->is_created remains false and
arvif->ar remains NULL for the failed link.

The subsequent drv_change_sta_links() call reaches
ath12k_mac_op_change_sta_links(), which allocates an arsta and sets
ahsta->links_map |= BIT(link_id) for the broken link before checking
whether the link is ready. When the vdev was never created, only
station_add() is skipped, but the link remains in links_map.

Any subsequent operation iterating links_map and dereferencing arvif->ar
without a NULL check will crash. Two observed examples are NULL deref in
ath12k_mac_ml_station_remove() on disconnect and in ath12k_mac_op_set_key()
when wpa_supplicant installs PTK keys.

  BUG: Unable to handle kernel NULL pointer dereference at 0x00000000
  pc : ath12k_mac_station_post_remove+0x40/0xe8 [ath12k]
  Call trace:
   ath12k_mac_station_post_remove+0x40/0xe8 [ath12k]
   ath12k_mac_op_sta_state+0xb60/0x1720 [ath12k]
   drv_sta_state+0x100/0xbd8 [mac80211]
   __sta_info_destroy_part2+0x148/0x178 [mac80211]
   ieee80211_set_disassoc+0x500/0x678 [mac80211]

  BUG: Unable to handle kernel NULL pointer dereference at 0x00000000
  pc : ath12k_mac_op_set_key+0x1f8/0x2c0 [ath12k]
  Call trace:
   ath12k_mac_op_set_key+0x1f8/0x2c0 [ath12k]
   drv_set_key+0x70/0x100 [mac80211]
   ieee80211_key_enable_hw_accel+0x78/0x260 [mac80211]
   ieee80211_add_key+0x16c/0x2ac [mac80211]
   nl80211_new_key+0x138/0x280 [cfg80211]

Fix this by checking arvif->is_created before calling
ath12k_mac_alloc_assign_link_sta(). This prevents the broken link from
entering links_map, so all subsequent operations iterating the bitmap
are protected. The reliability of arvif->is_created across all error
paths is ensured by the preceding patch.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: a27fa6148dac ("wifi: ath12k: support change_sta_links() mac80211 op")
Signed-off-by: Wei Zhang <wei.zhang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260512044906.1735821-3-wei.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index b97469dca0467c..368c377ab9b55d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7330,16 +7330,16 @@ static int ath12k_mac_op_change_sta_links(struct ieee80211_hw *hw,
 			continue;
 
 		arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
-		arsta = ath12k_mac_alloc_assign_link_sta(ah, ahsta, ahvif, link_id);
+		if (!arvif || !arvif->is_created)
+			continue;
 
-		if (!arvif || !arsta) {
+		arsta = ath12k_mac_alloc_assign_link_sta(ah, ahsta, ahvif, link_id);
+		if (!arsta) {
 			ath12k_hw_warn(ah, "Failed to alloc/assign link sta");
 			continue;
 		}
 
 		ar = arvif->ar;
-		if (!ar)
-			continue;
 
 		ret = ath12k_mac_station_add(ar, arvif, arsta);
 		if (ret) {
-- 
2.53.0



