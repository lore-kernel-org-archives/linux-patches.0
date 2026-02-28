Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3699313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301084; cv=none; b=SXGHLURF+ro2oAwVVGtTn+T9BX11+YnjYmEe+rIqyfgBELEPQt39Uip5nhLah8gcuhNze49AlYe9FOJaS/54Nzwn2Eoc3q0FzbNeOPIe1ZqoxwjdlQ3HBYptWpmKeF70QcmxqOsNdEamUtfNazlH2mXcXrdNJjpanctGAbrQZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301084; c=relaxed/simple;
	bh=xKxyAY1+OAVspjCJHQZBWrUf5oTS0VCHRQWh1N1RuqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoFELUS1aBCTEveyCth8Iwyto83LMuDDVGkBsytitxVHnfgzLHiUygu90IkvJtl6LQynaaYMA1021Aj+Xr7ieFmokS9/0RKAbMB4uddqrAYiZKgl4AaawpxgA7pM46VmeOcE5LiTi1QyqujUJWFUS9ALrKNZHG1QB65/evKAgD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5EB/sth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5EB/sth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483A2C116D0;
	Sat, 28 Feb 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301084;
	bh=xKxyAY1+OAVspjCJHQZBWrUf5oTS0VCHRQWh1N1RuqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5EB/sthF1Vwt9sLpv35Hy8ucaJrc5zl/oUmprZVH+N+OrLxg/MVcF8dWgc/VqDh6
	 +jcPXfZikJzivOoKyAa7UnrVzg43i5ICsURSWwQJ7V+tQ1JLp1lZkcjO6CusUZgJ50
	 8PUnskI6AL9wt5AjfKaQfcalk4dApCROftiYLq5hIlwio+lhSKrF6z6UK+K0CQDJxN
	 9WUk0FHuvd9Kjzi3cVsmLm36yhURRNgOncl4bhvq4+KU3Qx2UFmRDr1okZPSXgeaKQ
	 ETICKbalg8JzX/n+oLtT3KJKJrYDH1keJBLABouj0S3OQNxKBHBTgOGWyvFaJ7sHqY
	 pTNDpUh6n6hpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/752] wifi: rtw89: pci: validate sequence number of TX release report
Date: Sat, 28 Feb 2026 12:39:04 -0500
Message-ID: <20260228174750.1542406-233-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 0ee5f85794476..6395c53b3e170 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -604,11 +604,16 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev, void *rpp)
 
 	info->parse_rpp(rtwdev, rpp, &rpp_info);
 
-	if (rpp_info.txch == RTW89_TXCH_CH12) {
+	if (unlikely(rpp_info.txch == RTW89_TXCH_CH12)) {
 		rtw89_warn(rtwdev, "should no fwcmd release report\n");
 		return;
 	}
 
+	if (unlikely(rpp_info.seq >= RTW89_PCI_TXWD_NUM_MAX)) {
+		rtw89_warn(rtwdev, "invalid seq %d\n", rpp_info.seq);
+		return;
+	}
+
 	tx_ring = &rtwpci->tx.rings[rpp_info.txch];
 	wd_ring = &tx_ring->wd_ring;
 	txwd = &wd_ring->pages[rpp_info.seq];
-- 
2.51.0

