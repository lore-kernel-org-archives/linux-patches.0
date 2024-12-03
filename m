Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D81F75B4;
	Tue,  3 Dec 2024 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240762; cv=none; b=S40TQ3DBnd/csDwZW4SAAzNClbcxo90yYTP7pe+Mc1TKnrUPBrDvHImSSrjCbTmGLws2EjiItX6hzoqll9+gDUCQ12eunvU/0aR2QH0clHsXTieLamQJt8k1ThPq5PveZMFw83axIGHIIkBiIsTIpj+QJ67Jjx7UMCgOUCptdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240762; c=relaxed/simple;
	bh=r3jiba7hvYFBzw7CNUOdcGSb7483AzmMSQFPg9JT9tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOkMPhHhB+68P/D3fSU3IrtT4C2fMGyk6t4N2+40borc3VIZ366DsFkEwVvqx/tFcqTLA7HgSBtUCCCE1Q36ZCFQv46WENjpI+aEXqckd4qe5rTOkFuuct2Vytudb7KX1fqt22LLk0+uoewhuPDk+UmqsNuFtykZpvv/wRM9JRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+B3vbh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+B3vbh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3848BC4CED6;
	Tue,  3 Dec 2024 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240762;
	bh=r3jiba7hvYFBzw7CNUOdcGSb7483AzmMSQFPg9JT9tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+B3vbh3FDAmccwB6G6snXdt3uHGafaSHnivCiI+YWy7xnmbJUdaEGButbqiBUMRM
	 lG44LYrg2vAjMTeObIvrKPLwPZ/GVBQjNeuEo8OmbHuUXiQi5glAN1zHh5QbuGuHzX
	 SCm4FDTF2AvzXT8N2S3pWBbFV6YUxDpTMRd7Nhv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <quic_ramess@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/826] wifi: ath12k: fix use-after-free in ath12k_dp_cc_cleanup()
Date: Tue,  3 Dec 2024 15:39:14 +0100
Message-ID: <20241203144752.592781607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <quic_ramess@quicinc.com>

[ Upstream commit bdb281103373fd80eb5c91cede1e115ba270b4e9 ]

During ath12k module removal, in ath12k_core_deinit(),
ath12k_mac_destroy() un-registers ah->hw from mac80211 and frees
the ah->hw as well as all the ar's in it. After this
ath12k_core_soc_destroy()-> ath12k_dp_free()-> ath12k_dp_cc_cleanup()
tries to access one of the freed ar's from pending skb.

This is because during mac destroy, driver failed to flush few
data packets, which were accessed later in ath12k_dp_cc_cleanup()
and freed, but using ar from the packet led to this use-after-free.

BUG: KASAN: use-after-free in ath12k_dp_cc_cleanup.part.0+0x5e2/0xd40 [ath12k]
Write of size 4 at addr ffff888150bd3514 by task modprobe/8926
CPU: 0 UID: 0 PID: 8926 Comm: modprobe Not tainted
6.11.0-rc2-wt-ath+ #1746
Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS
HNKBLi70.86A.0067.2021.0528.1339 05/28/2021

Call Trace:
  <TASK>
  dump_stack_lvl+0x7d/0xe0
  print_address_description.constprop.0+0x33/0x3a0
  print_report+0xb5/0x260
  ? kasan_addr_to_slab+0x24/0x80
  kasan_report+0xd8/0x110
  ? ath12k_dp_cc_cleanup.part.0+0x5e2/0xd40 [ath12k]
  ? ath12k_dp_cc_cleanup.part.0+0x5e2/0xd40 [ath12k]
  kasan_check_range+0xf3/0x1a0
  __kasan_check_write+0x14/0x20
  ath12k_dp_cc_cleanup.part.0+0x5e2/0xd40 [ath12k]
  ath12k_dp_free+0x178/0x420 [ath12k]
  ath12k_core_stop+0x176/0x200 [ath12k]
  ath12k_core_deinit+0x13f/0x210 [ath12k]
  ath12k_pci_remove+0xad/0x1c0 [ath12k]
  pci_device_remove+0x9b/0x1b0
  device_remove+0xbf/0x150
  device_release_driver_internal+0x3c3/0x580
  ? __kasan_check_read+0x11/0x20
  driver_detach+0xc4/0x190
  bus_remove_driver+0x130/0x2a0
  driver_unregister+0x68/0x90
  pci_unregister_driver+0x24/0x240
  ? find_module_all+0x13e/0x1e0
  ath12k_pci_exit+0x10/0x20 [ath12k]
  __do_sys_delete_module+0x32c/0x580
  ? module_flags+0x2f0/0x2f0
  ? kmem_cache_free+0xf0/0x410
  ? __fput+0x56f/0xab0
  ? __fput+0x56f/0xab0
  ? debug_smp_processor_id+0x17/0x20
  __x64_sys_delete_module+0x4f/0x70
  x64_sys_call+0x522/0x9f0
  do_syscall_64+0x64/0x130
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f8182c6ac8b

Commit 24de1b7b231c ("wifi: ath12k: fix flush failure in recovery
scenarios") added the change to decrement the pending packets count
in case of recovery which make sense as ah->hw as well all
ar's in it are intact during recovery, but during core deinit there
is no use in decrementing packets count or waking up the empty waitq
as the module is going to be removed also ar's from pending skb's
can't be used and the packets should just be released back.

To fix this, avoid accessing ar from skb->cb when driver is being
unregistered.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00214-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 24de1b7b231c ("wifi: ath12k: fix flush failure in recovery scenarios")
Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241001092652.3134334-1-quic_ramess@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 61aa78d8bd8c8..abddeafabfa1b 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1202,10 +1202,16 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 			if (!skb)
 				continue;
 
-			skb_cb = ATH12K_SKB_CB(skb);
-			ar = skb_cb->ar;
-			if (atomic_dec_and_test(&ar->dp.num_tx_pending))
-				wake_up(&ar->dp.tx_empty_waitq);
+			/* if we are unregistering, hw would've been destroyed and
+			 * ar is no longer valid.
+			 */
+			if (!(test_bit(ATH12K_FLAG_UNREGISTERING, &ab->dev_flags))) {
+				skb_cb = ATH12K_SKB_CB(skb);
+				ar = skb_cb->ar;
+
+				if (atomic_dec_and_test(&ar->dp.num_tx_pending))
+					wake_up(&ar->dp.tx_empty_waitq);
+			}
 
 			dma_unmap_single(ab->dev, ATH12K_SKB_CB(skb)->paddr,
 					 skb->len, DMA_TO_DEVICE);
-- 
2.43.0



