Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AA539FEE;
	Fri, 24 Nov 2023 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN3MQQ2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8F9C433C8;
	Fri, 24 Nov 2023 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850815;
	bh=mANm+bOBHCyfONuzeq8+PfjYNMWG9I6Opifo4/cFvYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN3MQQ2IOSCPuMKNNuUJ3hUicG3ExBtNHKZkkzMbooj2tE90QLxmvMjvC9+AujT0+
	 gfOYx1J4wBJSnUS2ChvrJr/PFJ+UtoEcveMoDnQkhOJoVieO867ItwnzayqlY+/BXK
	 l3O2Jm8Eunyk9YQxEbUn+ys6LKFeUsMJmOM4ngl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 200/491] pds_core: use correct index to mask irq
Date: Fri, 24 Nov 2023 17:47:16 +0000
Message-ID: <20231124172030.514889254@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 09d4c14c6c5e6e781a3879fed7f8e116a18b8c65 ]

Use the qcq's interrupt index, not the irq number, to mask
the interrupt.  Since the irq number can be out of range from
the number of possible interrupts, we can end up accessing
and potentially scribbling on out-of-range and/or unmapped
memory, making the kernel angry.

    [ 3116.039364] BUG: unable to handle page fault for address: ffffbeea1c3edf84
    [ 3116.047059] #PF: supervisor write access in kernel mode
    [ 3116.052895] #PF: error_code(0x0002) - not-present page
    [ 3116.058636] PGD 100000067 P4D 100000067 PUD 1001f2067 PMD 10f82e067 PTE 0
    [ 3116.066221] Oops: 0002 [#1] SMP NOPTI
    [ 3116.092948] RIP: 0010:iowrite32+0x9/0x76
    [ 3116.190452] Call Trace:
    [ 3116.193185]  <IRQ>
    [ 3116.195430]  ? show_trace_log_lvl+0x1d6/0x2f9
    [ 3116.200298]  ? show_trace_log_lvl+0x1d6/0x2f9
    [ 3116.205166]  ? pdsc_adminq_isr+0x43/0x55 [pds_core]
    [ 3116.210618]  ? __die_body.cold+0x8/0xa
    [ 3116.214806]  ? page_fault_oops+0x16d/0x1ac
    [ 3116.219382]  ? exc_page_fault+0xbe/0x13b
    [ 3116.223764]  ? asm_exc_page_fault+0x22/0x27
    [ 3116.228440]  ? iowrite32+0x9/0x76
    [ 3116.232143]  pdsc_adminq_isr+0x43/0x55 [pds_core]
    [ 3116.237627]  __handle_irq_event_percpu+0x3a/0x184
    [ 3116.243088]  handle_irq_event+0x57/0xb0
    [ 3116.247575]  handle_edge_irq+0x87/0x225
    [ 3116.252062]  __common_interrupt+0x3e/0xbc
    [ 3116.256740]  common_interrupt+0x7b/0x98
    [ 3116.261216]  </IRQ>
    [ 3116.263745]  <TASK>
    [ 3116.266268]  asm_common_interrupt+0x22/0x27

Reported-by: Joao Martins <joao.m.martins@oracle.com>
Fixes: 01ba61b55b20 ("pds_core: Add adminq processing and commands")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231113183257.71110-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 045fe133f6ee9..5beadabc21361 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -146,7 +146,7 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data)
 	}
 
 	queue_work(pdsc->wq, &qcq->work);
-	pds_core_intr_mask(&pdsc->intr_ctrl[irq], PDS_CORE_INTR_MASK_CLEAR);
+	pds_core_intr_mask(&pdsc->intr_ctrl[qcq->intx], PDS_CORE_INTR_MASK_CLEAR);
 
 	return IRQ_HANDLED;
 }
-- 
2.42.0



