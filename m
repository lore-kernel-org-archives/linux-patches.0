Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C5D17BED0;
	Sat, 17 Oct 2026 16:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253877; cv=none; b=ShPK2kQXhhifVXJXRBYYXFbfC+KjOMtJu12MItGjlMHA+OeLdtnkuLkUkwIkYRPUDqiO6agC3pb1vhVlbZvHiuvyEWj+nbKvaiLP8YHdF9RUPS03NDBPL0r+wWTE848VYxsO9p3BpKR9IqQenXP/9ho4FTlVGJ2syibVej2R1Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253877; c=relaxed/simple;
	bh=uxIIPOiKGg6DWGynmHdA/RvxKcSZrxmAFi4Tb31mWto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGDZQhSYQJ0garEauYxjaX3fNSPhVcHgx1yM/Z//2bI8LLgWSgWuLsu37J07seSk4GwvFua7RzBr2odWGLmLbKLU8aeF9P6/zViom0xu4ADsTSUTKoJ26bbE/UndY4Qq8j37Zbg+Ek4OV3UI6E/rbKoiVtJDKH+Uc2yyMMspz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC0uEAxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC0uEAxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7A1F000C4;
	Sat, 17 Oct 2026 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253876;
	bh=D8D+BObHPScUjE9WvuAEcRsIxpo3CjDonNkNqFPnH9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TC0uEAxeacatvP/PISUFDXd1DBsbO2BjkacsiHO31AUCJlTAp/ZAHec3Ot2vk+/gn
	 T7WayRSYnRjYhV+/r+KsQYiW+aMuE+64TOeO5sI0m2hEWMjQ4R5Dl9lGeo591afP3b
	 EdHvC5ZZvQS3aQ55DmLr8EtImE290PE9vNo+yvtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/869] wifi: rtw89: pci: validate sequence number of TX release report
Date: Sat, 17 Oct 2026 17:51:26 +0200
Message-ID: <20261017160043.340551170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 957eda596c7665f2966970fd1dcc35fe299b38e8 ]

Hardware rarely reports abnormal sequence number in TX release report,
which will access out-of-bounds of wd_ring->pages array, causing NULL
pointer dereference.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 PID: 1085 Comm: irq/129-rtw89_p Tainted: G S   U
             6.1.145-17510-g2f3369c91536 #1 (HASH:69e8 1)
  Call Trace:
   <IRQ>
   rtw89_pci_release_tx+0x18f/0x300 [rtw89_pci (HASH:4c83 2)]
   rtw89_pci_napi_poll+0xc2/0x190 [rtw89_pci (HASH:4c83 2)]
   net_rx_action+0xfc/0x460 net/core/dev.c:6578 net/core/dev.c:6645 net/core/dev.c:6759
   handle_softirqs+0xbe/0x290 kernel/softirq.c:601
   ? rtw89_pci_interrupt_threadfn+0xc5/0x350 [rtw89_pci (HASH:4c83 2)]
   __local_bh_enable_ip+0xeb/0x120 kernel/softirq.c:499 kernel/softirq.c:423
   </IRQ>
   <TASK>
   rtw89_pci_interrupt_threadfn+0xf8/0x350 [rtw89_pci (HASH:4c83 2)]
   ? irq_thread+0xa7/0x340 kernel/irq/manage.c:0
   irq_thread+0x177/0x340 kernel/irq/manage.c:1205 kernel/irq/manage.c:1314
   ? thaw_kernel_threads+0xb0/0xb0 kernel/irq/manage.c:1202
   ? irq_forced_thread_fn+0x80/0x80 kernel/irq/manage.c:1220
   kthread+0xea/0x110 kernel/kthread.c:376
   ? synchronize_irq+0x1a0/0x1a0 kernel/irq/manage.c:1287
   ? kthread_associate_blkcg+0x80/0x80 kernel/kthread.c:331
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
   </TASK>

To prevent crash, validate rpp_info.seq before using.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260110022019.2254969-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 43285d341870e..d24dcbf26caa9 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -578,11 +578,16 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev,
 	tx_status = le32_get_bits(rpp->dword, RTW89_PCI_RPP_TX_STATUS);
 	txch = rtw89_core_get_ch_dma(rtwdev, qsel);
 
-	if (txch == RTW89_TXCH_CH12) {
+	if (unlikely(txch == RTW89_TXCH_CH12)) {
 		rtw89_warn(rtwdev, "should no fwcmd release report\n");
 		return;
 	}
 
+	if (unlikely(seq >= RTW89_PCI_TXWD_NUM_MAX)) {
+		rtw89_warn(rtwdev, "invalid seq %d\n", seq);
+		return;
+	}
+
 	tx_ring = &rtwpci->tx_rings[txch];
 	wd_ring = &tx_ring->wd_ring;
 	txwd = &wd_ring->pages[seq];
-- 
2.53.0



