Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837742032D;
	Tue, 30 Sep 2025 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246079; cv=none; b=f+W7052nIKVizDtsGG+8ggqrs+DPyEjmvWTElBIf1qU+BVFTHlJ2NTsh5N/9qghcJPNVgYE23cHHN1S7AIQAbPycpdr8+ErfKed/jhGRRuJKpqw0Uej3fchqCT8fD8FTyaqPEgcR9JcymOHXzcH662Pxs9gCLg3gpWbpKj8DkIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246079; c=relaxed/simple;
	bh=CFvWTAlaodFbE0o2Hq9TmUBVoeowRhnyKEmGwY8Vkq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI0mlRbaEJTmMuwVj+HRllGW9y9ZxADqYeNQmoq26g5uwRTdscis92HuujBFe/qBloMFazFf4q7gjk1SvUFimQRWD5nWr/3DZGyXoXHbUHXKJhn5kzNdtx9Uk+MCeLRMGYrviizTbrwcDS7h55USePlVN1s48c95xXXRsrrVAaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU8JNqTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU8JNqTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B115EC4CEF0;
	Tue, 30 Sep 2025 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246079;
	bh=CFvWTAlaodFbE0o2Hq9TmUBVoeowRhnyKEmGwY8Vkq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RU8JNqTfAeji2W+qcr+e6L0XhxV864NELBuZGZ5sKYN1i3GmPGY6pRosmvD4d6wRE
	 z39OxEGw8cHJq6Jas5dMlh2ZJRjZYvbyI7PENrU+adEwYLiinJisGUEWPCe20H75Fl
	 9wS6qD9Z53UL1rkEMl/iasa4FHr49CmRLrH4meLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 46/89] net/smc: fix warning in smc_rx_splice() when calling get_page()
Date: Tue, 30 Sep 2025 16:48:00 +0200
Message-ID: <20250930143823.829462057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Sidraya Jayagond <sidraya@linux.ibm.com>

[ Upstream commit a35c04de2565db191726b5741e6b66a35002c652 ]

smc_lo_register_dmb() allocates DMB buffers with kzalloc(), which are
later passed to get_page() in smc_rx_splice(). Since kmalloc memory is
not page-backed, this triggers WARN_ON_ONCE() in get_page() and prevents
holding a refcount on the buffer. This can lead to use-after-free if
the memory is released before splice_to_pipe() completes.

Use folio_alloc() instead, ensuring DMBs are page-backed and safe for
get_page().

WARNING: CPU: 18 PID: 12152 at ./include/linux/mm.h:1330 smc_rx_splice+0xaf8/0xe20 [smc]
CPU: 18 UID: 0 PID: 12152 Comm: smcapp Kdump: loaded Not tainted 6.17.0-rc3-11705-g9cf4672ecfee #10 NONE
Hardware name: IBM 3931 A01 704 (z/VM 7.4.0)
Krnl PSW : 0704e00180000000 000793161032696c (smc_rx_splice+0xafc/0xe20 [smc])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000000 001cee80007d3001 00077400000000f8 0000000000000005
           0000000000000001 001cee80007d3006 0007740000001000 001c000000000000
           000000009b0c99e0 0000000000001000 001c0000000000f8 001c000000000000
           000003ffcc6f7c88 0007740003e98000 0007931600000005 000792969b2ff7b8
Krnl Code: 0007931610326960: af000000		mc	0,0
           0007931610326964: a7f4ff43		brc	15,00079316103267ea
          #0007931610326968: af000000		mc	0,0
          >000793161032696c: a7f4ff3f		brc	15,00079316103267ea
           0007931610326970: e320f1000004	lg	%r2,256(%r15)
           0007931610326976: c0e53fd1b5f5	brasl	%r14,000793168fd5d560
           000793161032697c: a7f4fbb5		brc	15,00079316103260e6
           0007931610326980: b904002b		lgr	%r2,%r11
Call Trace:
 smc_rx_splice+0xafc/0xe20 [smc]
 smc_rx_splice+0x756/0xe20 [smc])
 smc_rx_recvmsg+0xa74/0xe00 [smc]
 smc_splice_read+0x1ce/0x3b0 [smc]
 sock_splice_read+0xa2/0xf0
 do_splice_read+0x198/0x240
 splice_file_to_pipe+0x7e/0x110
 do_splice+0x59e/0xde0
 __do_splice+0x11a/0x2d0
 __s390x_sys_splice+0x140/0x1f0
 __do_syscall+0x122/0x280
 system_call+0x6e/0x90
Last Breaking-Event-Address:
smc_rx_splice+0x960/0xe20 [smc]
---[ end trace 0000000000000000 ]---

Fixes: f7a22071dbf3 ("net/smc: implement DMB-related operations of loopback-ism")
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Link: https://patch.msgid.link/20250917184220.801066-1-sidraya@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_loopback.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_loopback.c b/net/smc/smc_loopback.c
index 3c5f64ca41153..85f0b7853b173 100644
--- a/net/smc/smc_loopback.c
+++ b/net/smc/smc_loopback.c
@@ -56,6 +56,7 @@ static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
 {
 	struct smc_lo_dmb_node *dmb_node, *tmp_node;
 	struct smc_lo_dev *ldev = smcd->priv;
+	struct folio *folio;
 	int sba_idx, rc;
 
 	/* check space for new dmb */
@@ -74,13 +75,16 @@ static int smc_lo_register_dmb(struct smcd_dev *smcd, struct smcd_dmb *dmb,
 
 	dmb_node->sba_idx = sba_idx;
 	dmb_node->len = dmb->dmb_len;
-	dmb_node->cpu_addr = kzalloc(dmb_node->len, GFP_KERNEL |
-				     __GFP_NOWARN | __GFP_NORETRY |
-				     __GFP_NOMEMALLOC);
-	if (!dmb_node->cpu_addr) {
+
+	/* not critical; fail under memory pressure and fallback to TCP */
+	folio = folio_alloc(GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC |
+			    __GFP_NORETRY | __GFP_ZERO,
+			    get_order(dmb_node->len));
+	if (!folio) {
 		rc = -ENOMEM;
 		goto err_node;
 	}
+	dmb_node->cpu_addr = folio_address(folio);
 	dmb_node->dma_addr = SMC_DMA_ADDR_INVALID;
 	refcount_set(&dmb_node->refcnt, 1);
 
@@ -122,7 +126,7 @@ static void __smc_lo_unregister_dmb(struct smc_lo_dev *ldev,
 	write_unlock_bh(&ldev->dmb_ht_lock);
 
 	clear_bit(dmb_node->sba_idx, ldev->sba_idx_mask);
-	kvfree(dmb_node->cpu_addr);
+	folio_put(virt_to_folio(dmb_node->cpu_addr));
 	kfree(dmb_node);
 
 	if (atomic_dec_and_test(&ldev->dmb_cnt))
-- 
2.51.0



