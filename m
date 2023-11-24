Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C4439FEA;
	Fri, 24 Nov 2023 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkEwi3XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5E5C433C7;
	Fri, 24 Nov 2023 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849021;
	bh=gcKeFBGcoKRzkTG6pSjtPE+OWUrFpYD+1ROTKxF1h+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkEwi3XZYbf5UVorDjgSeH8wz3Gi69TYddP9m3xX+K1WWmd5Kd7xiRlPV+NK4QQoM
	 CVOdujTKFrY7XCqC8SD1n8OII5Yjcl9ZtRvHj84tk/K84A8RZgob5nZryb9kaKR0aI
	 YU3Bb8YIaY3jcHrov0BEHvLuoMb4Ua8JpUyz72EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshitha Prem <quic_hprem@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/530] wifi: ath12k: Ignore fragments from uninitialized peer in dp
Date: Fri, 24 Nov 2023 17:43:03 +0000
Message-ID: <20231124172028.612844007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshitha Prem <quic_hprem@quicinc.com>

[ Upstream commit bbc86757ca62423c3b6bd8f7176da1ff43450769 ]

When max virtual ap interfaces are configured in all the bands with
ACS and hostapd restart is done every 60s, a crash is observed at
random times.

In the above scenario, a fragmented packet is received for self peer,
for which rx_tid and rx_frags are not initialized in datapath.
While handling this fragment, crash is observed as the rx_frag list
is uninitialized and when we walk in ath12k_dp_rx_h_sort_frags,
skb null leads to exception.

To address this, before processing received fragments we check
dp_setup_done flag is set to ensure that peer has completed its
dp peer setup for fragment queue, else ignore processing the
fragments.

Call trace:
    PC points to "ath12k_dp_process_rx_err+0x4e8/0xfcc [ath12k]"
    LR points to "ath12k_dp_process_rx_err+0x480/0xfcc [ath12k]".
    The Backtrace obtained is as follows:
    ath12k_dp_process_rx_err+0x4e8/0xfcc [ath12k]
    ath12k_dp_service_srng+0x78/0x260 [ath12k]
    ath12k_pci_write32+0x990/0xb0c [ath12k]
    __napi_poll+0x30/0xa4
    net_rx_action+0x118/0x270
    __do_softirq+0x10c/0x244
    irq_exit+0x64/0xb4
    __handle_domain_irq+0x88/0xac
    gic_handle_irq+0x74/0xbc
    el1_irq+0xf0/0x1c0
    arch_cpu_idle+0x10/0x18
    do_idle+0x104/0x248
    cpu_startup_entry+0x20/0x64
    rest_init+0xd0/0xdc
    arch_call_rest_init+0xc/0x14

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Harshitha Prem <quic_hprem@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230821130343.29495-2-quic_hprem@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c    | 1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c | 9 +++++++++
 drivers/net/wireless/ath/ath12k/peer.h  | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index f933896f2a68d..6893466f61f04 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -38,6 +38,7 @@ void ath12k_dp_peer_cleanup(struct ath12k *ar, int vdev_id, const u8 *addr)
 
 	ath12k_dp_rx_peer_tid_cleanup(ar, peer);
 	crypto_free_shash(peer->tfm_mmic);
+	peer->dp_setup_done = false;
 	spin_unlock_bh(&ab->base_lock);
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 17da39bd3ab4d..690a0107f0d68 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2748,6 +2748,7 @@ int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev
 	}
 
 	peer->tfm_mmic = tfm;
+	peer->dp_setup_done = true;
 	spin_unlock_bh(&ab->base_lock);
 
 	return 0;
@@ -3214,6 +3215,14 @@ static int ath12k_dp_rx_frag_h_mpdu(struct ath12k *ar,
 		ret = -ENOENT;
 		goto out_unlock;
 	}
+
+	if (!peer->dp_setup_done) {
+		ath12k_warn(ab, "The peer %pM [%d] has uninitialized datapath\n",
+			    peer->addr, peer_id);
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
 	rx_tid = &peer->rx_tid[tid];
 
 	if ((!skb_queue_empty(&rx_tid->rx_frags) && seqno != rx_tid->cur_sn) ||
diff --git a/drivers/net/wireless/ath/ath12k/peer.h b/drivers/net/wireless/ath/ath12k/peer.h
index b296dc0e2f671..c6edb24cbedd8 100644
--- a/drivers/net/wireless/ath/ath12k/peer.h
+++ b/drivers/net/wireless/ath/ath12k/peer.h
@@ -44,6 +44,9 @@ struct ath12k_peer {
 	struct ppdu_user_delayba ppdu_stats_delayba;
 	bool delayba_flag;
 	bool is_authorized;
+
+	/* protected by ab->data_lock */
+	bool dp_setup_done;
 };
 
 void ath12k_peer_unmap_event(struct ath12k_base *ab, u16 peer_id);
-- 
2.42.0



