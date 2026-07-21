Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07456429822;
	Tue, 21 Jul 2026 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658345; cv=none; b=VfcYv2nTzIQniGO1hxJz2s9IwdEENMeejwGGpK+SVFoihTxfbwOG5U9VBsjX5LBQ2nbiFrkzyr7x2he8RgyCuV3Nxw1x9B4BRixviIxstJ3YZ9qmgZqVsV5WnFZt4rqwhCQVrSP7+o3vwCbV3qcdUTSfNvyscQH/VjHHEAYclII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658345; c=relaxed/simple;
	bh=S43s89nPrI0WsdLjUlCOc+L94q/clpsQBK1fEXCkpJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBTqYrwlnugS+8TTjVKeBw6q1VG8Pft8mM29UUopxfSJST60kPmKd7OPbbL5Lx982kNaLkXL4PPBoGK6TzhjhTQxEoioiU3gz53YlPMJ4JKALmXV6Xipb6n9X9Q3x5nosuT5U+/bmGYPCCdwi0TcdHvcPVH914gX8yW8L/WP3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USSrmaZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USSrmaZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0051F000E9;
	Tue, 21 Jul 2026 18:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658343;
	bh=fu+iAczfdxH4f5TvdWZBmN9WJNj017L06/KvUcjd5sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USSrmaZqVrrd4jwj3IJSFaS1pFMvHAgizIVuD9BrGu5/RGomXFCDtYxPciqIixxc4
	 nK5uwMHY/y2BQvXfS91CcN3qZyDJdLsJJwtW2mlSTAb/nDqa/5p95BsdnGoQ5Ujl89
	 lIWgcx4mSMLyZwZj432O41rKt/S958nD7y/tBQ/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1106/1611] octeontx2-pf: clear stale mailbox IRQ state before request_irq()
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152540.291211769@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit f918554fb7246e89b98ef90abe80801f038258b3 upstream.

otx2_register_mbox_intr() currently installs the PF mailbox IRQ handler
before clearing stale mailbox interrupt state. The function itself then
comments that the local interrupt bits must be cleared first to avoid
spurious interrupts, but that clear happens only after request_irq() has
already exposed the handler to irq delivery.

A running system can reach this during PF mailbox interrupt registration
while stale or latched RVU_PF_INT state is still present. If delivery
happens in the request_irq()-to-clear window,
otx2_pfaf_mbox_intr_handler() can run before local quiesce and touch
the same pf->mbox and pf->mbox_wq carrier that probe and teardown later
reuse or destroy.

Move the stale mailbox interrupt clear ahead of request_irq(), but keep
interrupt enabling after the handler is installed. This closes the
pre-clear early-IRQ window without creating a new enable-before-handler
window.

Fixes: 5a6d7c9daef3 ("octeontx2-pf: Mailbox communication with AF")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260611160014.3202224-2-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |   20 ++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1119,9 +1119,16 @@ int otx2_register_mbox_intr(struct otx2_
 {
 	struct otx2_hw *hw = &pf->hw;
 	struct msg_req *req;
+	u64 mbox_int_mask;
 	char *irq_name;
 	int err;
 
+	mbox_int_mask = !is_cn20k(pf->pdev) ? BIT_ULL(0) :
+				BIT_ULL(0) | BIT_ULL(1);
+
+	/* Clear stale mailbox interrupt state before installing the handler. */
+	otx2_write64(pf, RVU_PF_INT, mbox_int_mask);
+
 	/* Register mailbox interrupt handler */
 	if (!is_cn20k(pf->pdev)) {
 		irq_name = &hw->irq_name[RVU_PF_INT_VEC_AFPF_MBOX * NAME_SIZE];
@@ -1147,17 +1154,8 @@ int otx2_register_mbox_intr(struct otx2_
 		return err;
 	}
 
-	/* Enable mailbox interrupt for msgs coming from AF.
-	 * First clear to avoid spurious interrupts, if any.
-	 */
-	if (!is_cn20k(pf->pdev)) {
-		otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
-		otx2_write64(pf, RVU_PF_INT_ENA_W1S, BIT_ULL(0));
-	} else {
-		otx2_write64(pf, RVU_PF_INT, BIT_ULL(0) | BIT_ULL(1));
-		otx2_write64(pf, RVU_PF_INT_ENA_W1S, BIT_ULL(0) |
-			     BIT_ULL(1));
-	}
+	/* Enable mailbox interrupt for msgs coming from AF. */
+	otx2_write64(pf, RVU_PF_INT_ENA_W1S, mbox_int_mask);
 
 	if (!probe_af)
 		return 0;


