Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4178647F2EB;
	Mon, 31 Aug 2026 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184749; cv=none; b=oFpc4oEOXwT/DcJZ+yIxNwL7meyzskdsujqppOSF6IO/ewoXX2679jgpG6MBHr8QCnD/PGlhW4oPJOToarujRn+BKdK6fsMikl+0h/8fD8w4o+sCUrjD+FyP4aX5aREl2ZkJGzahbnvmMJGwT580wbbd5HvHCF9HlONO5CA59qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184749; c=relaxed/simple;
	bh=V64Iu0MQJnwz0A3OsEwm0Ygfpa1cCaCM2u/Uj3lQRQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP+c+TXAIjiGLnoTo8HRt/m6D+a0HGqKFvRlM5Ue9+mm0Z8KooyEb34JbvfJ6BI0U5BcWJJw9VaPMzfJwLZQMn84/DQfBwh+If1qBjrl4GVwvvjdGlWJfjPtU548fhFG1So/0zp6BovC+jiVhG+ZgQjRJRUD+TajkHPRARWasrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1fHvygB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1fHvygB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B19F1F000E9;
	Mon, 31 Aug 2026 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184748;
	bh=CYZG2aqDmeGA00HB9ptZStmdSaKVzgqmEdj6TQg/3W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1fHvygBdb+IcZG8EHwB27FoI/rM734/zQIkGNFmG2DuzOVst9m6BEWBnZ9h84R2s
	 yeuNVIxlt+3y4FgV5eHSKxi4tbZ5wCBbwQG2gJ6ufl13SbOIntu/jDCX4phLWcbFD2
	 1Afr7LXJAQQpVH6L03y7KGCN1XNCCecjltjvblwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Huang <hzyitc@outlook.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/92] wifi: ath11k: Add missing hw_ops->get_ring_selector() for IPQ5018
Date: Mon, 31 Aug 2026 15:34:06 +0200
Message-ID: <20260831133359.904450963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyang Huang <hzyitc@outlook.com>

[ Upstream commit ce282d8de71f07f0056ea319541141152c65f552 ]

During sending data after clients connected, hw_ops->get_ring_selector()
will be called. But for IPQ5018, this member isn't set, and the
following NULL pointer exception will be occurred:

	[   38.840478] 8<--- cut here ---
	[   38.840517] Unable to handle kernel NULL pointer dereference at virtual address 00000000
	...
	[   38.923161] PC is at 0x0
	[   38.927930] LR is at ath11k_dp_tx+0x70/0x730 [ath11k]
	...
	[   39.063264] Process hostapd (pid: 1034, stack limit = 0x801ceb3d)
	[   39.068994] Stack: (0x856a9a68 to 0x856aa000)
	...
	[   39.438467] [<7f323804>] (ath11k_dp_tx [ath11k]) from [<7f314e6c>] (ath11k_mac_op_tx+0x80/0x190 [ath11k])
	[   39.446607] [<7f314e6c>] (ath11k_mac_op_tx [ath11k]) from [<7f17dbe0>] (ieee80211_handle_wake_tx_queue+0x7c/0xc0 [mac80211])
	[   39.456162] [<7f17dbe0>] (ieee80211_handle_wake_tx_queue [mac80211]) from [<7f174450>] (ieee80211_probereq_get+0x584/0x704 [mac80211])
	[   39.467443] [<7f174450>] (ieee80211_probereq_get [mac80211]) from [<7f178c40>] (ieee80211_tx_prepare_skb+0x1f8/0x248 [mac80211])
	[   39.479334] [<7f178c40>] (ieee80211_tx_prepare_skb [mac80211]) from [<7f179e28>] (__ieee80211_subif_start_xmit+0x32c/0x3d4 [mac80211])
	[   39.491053] [<7f179e28>] (__ieee80211_subif_start_xmit [mac80211]) from [<7f17af08>] (ieee80211_tx_control_port+0x19c/0x288 [mac80211])
	[   39.502946] [<7f17af08>] (ieee80211_tx_control_port [mac80211]) from [<7f0fc704>] (nl80211_tx_control_port+0x174/0x1d4 [cfg80211])
	[   39.515017] [<7f0fc704>] (nl80211_tx_control_port [cfg80211]) from [<808ceac4>] (genl_rcv_msg+0x154/0x340)
	[   39.526814] [<808ceac4>] (genl_rcv_msg) from [<808cdb74>] (netlink_rcv_skb+0xb8/0x11c)
	[   39.536446] [<808cdb74>] (netlink_rcv_skb) from [<808ce1d0>] (genl_rcv+0x28/0x34)
	[   39.544344] [<808ce1d0>] (genl_rcv) from [<808cd234>] (netlink_unicast+0x174/0x274)
	[   39.551895] [<808cd234>] (netlink_unicast) from [<808cd510>] (netlink_sendmsg+0x1dc/0x440)
	[   39.559362] [<808cd510>] (netlink_sendmsg) from [<808596e0>] (____sys_sendmsg+0x1a8/0x1fc)
	[   39.567697] [<808596e0>] (____sys_sendmsg) from [<8085b1a8>] (___sys_sendmsg+0xa4/0xdc)
	[   39.575941] [<8085b1a8>] (___sys_sendmsg) from [<8085b310>] (sys_sendmsg+0x44/0x74)
	[   39.583841] [<8085b310>] (sys_sendmsg) from [<80300060>] (ret_fast_syscall+0x0/0x40)
	...
	[   39.620734] Code: bad PC value
	[   39.625869] ---[ end trace 8aef983ad3cbc032 ]---

Fixes: ba60f2793d3a ("wifi: ath11k: initialize hw_ops for IPQ5018")
Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/TYZPR01MB5556D6E3F63EAB5129D11420C953A@TYZPR01MB5556.apcprd01.prod.exchangelabs.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 6b4355a68e266..1e7009743c976 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -1175,7 +1175,7 @@ const struct ath11k_hw_ops ipq5018_ops = {
 	.mpdu_info_get_peerid = ath11k_hw_ipq8074_mpdu_info_get_peerid,
 	.rx_desc_mac_addr2_valid = ath11k_hw_ipq9074_rx_desc_mac_addr2_valid,
 	.rx_desc_mpdu_start_addr2 = ath11k_hw_ipq9074_rx_desc_mpdu_start_addr2,
-
+	.get_ring_selector = ath11k_hw_ipq8074_get_tcl_ring_selector,
 };
 
 #define ATH11K_TX_RING_MASK_0 BIT(0)
-- 
2.53.0



