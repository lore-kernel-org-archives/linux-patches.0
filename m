Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B1B1CCB5F;
	Wed,  6 Nov 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899242; cv=none; b=Mlb+Fw4z3/thO9s2VCRUtvEtvyTH+SSCWEpSir3G3W2fGsw2yTu1FT+5emKeMhVM6mmoFxoCHUB0hyLn/NIFTiIJIZSdYo7FDJR5ylzFnrJbTE1WI7F6r8kRkatdJkyhEH3gHe1S6FE7LrTNo3tootiRZUIm/uUo/M14og/heN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899242; c=relaxed/simple;
	bh=ogn3P0CNGpfPVdvBd3Dak4uT9+hZXuCfptnjaCV4Dh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnzCeXPxZ6VDWfAqI6dQ+kihq6wmHq0kzuU2c18VY9kXrpu1C3CjN6qyEX4yqoJcoj3FBLlO/9tFjBN//ItYe4zqgmrflRZRzjKFuqA02z+xTQGOKQDUqu4nBiISd7D9QncPq3AC1kMEkP7vfwnC+gbbaTHSvrdsvJADAeeRqBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVxh0uCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVxh0uCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19F3C4CECD;
	Wed,  6 Nov 2024 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899242;
	bh=ogn3P0CNGpfPVdvBd3Dak4uT9+hZXuCfptnjaCV4Dh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVxh0uCPqA+zMBPPyDIdiO3g6LSj5Tw/e0jPgQxoWBTmxAPTpxTjduDIgiwZMngko
	 j2bY1bLOqtKpjeqAqURtVmLrL1x1HMrycua6uOQbgrBpcrz1MSL/zqzZKsgE+p8Y3m
	 lwXJwaS2wexXCf8RVW/mZNX/Re0ORtVyRKaiQhyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 5.15 45/73] wifi: ath10k: Fix memory leak in management tx
Date: Wed,  6 Nov 2024 13:05:49 +0100
Message-ID: <20241106120301.309353588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

commit e15d84b3bba187aa372dff7c58ce1fd5cb48a076 upstream.

In the current logic, memory is allocated for storing the MSDU context
during management packet TX but this memory is not being freed during
management TX completion. Similar leaks are seen in the management TX
cleanup logic.

Kmemleak reports this problem as below,

unreferenced object 0xffffff80b64ed250 (size 16):
  comm "kworker/u16:7", pid 148, jiffies 4294687130 (age 714.199s)
  hex dump (first 16 bytes):
    00 2b d8 d8 80 ff ff ff c4 74 e9 fd 07 00 00 00  .+.......t......
  backtrace:
    [<ffffffe6e7b245dc>] __kmem_cache_alloc_node+0x1e4/0x2d8
    [<ffffffe6e7adde88>] kmalloc_trace+0x48/0x110
    [<ffffffe6bbd765fc>] ath10k_wmi_tlv_op_gen_mgmt_tx_send+0xd4/0x1d8 [ath10k_core]
    [<ffffffe6bbd3eed4>] ath10k_mgmt_over_wmi_tx_work+0x134/0x298 [ath10k_core]
    [<ffffffe6e78d5974>] process_scheduled_works+0x1ac/0x400
    [<ffffffe6e78d60b8>] worker_thread+0x208/0x328
    [<ffffffe6e78dc890>] kthread+0x100/0x1c0
    [<ffffffe6e78166c0>] ret_from_fork+0x10/0x20

Free the memory during completion and cleanup to fix the leak.

Protect the mgmt_pending_tx idr_remove() operation in
ath10k_wmi_tlv_op_cleanup_mgmt_tx_send() using ar->data_lock similar to
other instances.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Fixes: dc405152bb64 ("ath10k: handle mgmt tx completion event")
Fixes: c730c477176a ("ath10k: Remove msdu from idr when management pkt send fails")
Cc: stable@vger.kernel.org
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Link: https://patch.msgid.link/20241015064103.6060-1-quic_mpubbise@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    7 ++++++-
 drivers/net/wireless/ath/ath10k/wmi.c     |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3035,9 +3035,14 @@ ath10k_wmi_tlv_op_cleanup_mgmt_tx_send(s
 				       struct sk_buff *msdu)
 {
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(msdu);
+	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
 	struct ath10k_wmi *wmi = &ar->wmi;
 
-	idr_remove(&wmi->mgmt_pending_tx, cb->msdu_id);
+	spin_lock_bh(&ar->data_lock);
+	pkt_addr = idr_remove(&wmi->mgmt_pending_tx, cb->msdu_id);
+	spin_unlock_bh(&ar->data_lock);
+
+	kfree(pkt_addr);
 
 	return 0;
 }
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2440,6 +2440,7 @@ wmi_process_mgmt_tx_comp(struct ath10k *
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
 			 msdu->len, DMA_TO_DEVICE);
 	info = IEEE80211_SKB_CB(msdu);
+	kfree(pkt_addr);
 
 	if (param->status) {
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
@@ -9581,6 +9582,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_p
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
 			 msdu->len, DMA_TO_DEVICE);
 	ieee80211_free_txskb(ar->hw, msdu);
+	kfree(pkt_addr);
 
 	return 0;
 }


