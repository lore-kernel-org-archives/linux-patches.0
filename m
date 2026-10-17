Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE604392829;
	Sat, 17 Oct 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258564; cv=none; b=uNmwoH9D9b6EkPJty6aAiktHRYwGc4PJ3mAZ7QXhe/SDrL9D28su5kVGTihhe/IwuKa42kzv3n21jIo+DV5fyf/HJPNAIY9I5U2i+CZyFfmm69f4/EA8TYJuFfQZK1XttdXNUVH2F4PMw0TFgxB73u506BwCUsn6hOZGXy9HSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258564; c=relaxed/simple;
	bh=6viGlvnWYWLjVAdvaWrIrQXqxyeuk7E3PBUe6bui5oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV84TqNrtNEQRdBtJf9evhlY9FNbVPLv3PvrdebVmLRdRjnYOqu46v/U/1owyUTvs9ppMIwtVNgcgSABOr5EC6s/HziK9WCxoyXBmje+4KatNtQqwI7VNdo3QLITwESOFeWzKhNz4plXX7nw+uYNlOQcjbtBF+Qi5a23ueMREPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBwzl0+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBwzl0+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD061F000C4;
	Sat, 17 Oct 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258563;
	bh=aiKwW9RPsZcdklfnhMxVBC/IoKlc+h1Z808nqaoIBHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBwzl0+ECpFfunLa+o4ZLwTRtu+JvZla7VDqWvfmh93b2IlqwTegt/YiKarzgT2Ul
	 eAZVkHcscIk2eThJQ/pgXdQC+4iCG3Rd8LJUiMpEjsXkGNx48OQOcYmql2KoA2v3vx
	 Zm3VZXp8A8IhVNjddfyKO4zIahs03FzUy3u5c8GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0924/1674] wifi: rtw89: pci: validate sequence number of TX release report
Date: Sat, 17 Oct 2026 17:53:16 +0200
Message-ID: <20261017160454.851190716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a1027dd01d3e..7b0630d5d5283 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -484,11 +484,16 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev,
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



