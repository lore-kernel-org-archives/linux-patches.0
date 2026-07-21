Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048346D083;
	Tue, 21 Jul 2026 18:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658347; cv=none; b=UqdvGPwT0qE+w0ca26xSW5A7Sm2yegqcudH3T4CV0I2zpL/vW9U2eC3I7uODrTvFXj4FGI1jtxkvYS4PM3UbdW+tGBPICCN1hPjJY2t1eDj1zDtJSLSxlhdhtO+p/rWNYERxoIm+EPfUufFIdKD8H7zoYlGfm1VyhND2wZsujm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658347; c=relaxed/simple;
	bh=JkOomcPIhEN8pygpvU2mNX0O77uHUjVlpPQgeGeCzSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXMzGPuv3WMNtaRwijJa6wPEOFAtqrM2jGuKSZ5guQ5Hc6pgo33abriwjYefmkhpjfPYPDncuz3tjP6eoye3OSV/YQS0thogflqeZ0sls9Dep2dzx84szp44aLCVn7TDnCM2qlfRhciTZmXnFan6v7lyjNLznTRw3e1dKwaubxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSkZ+Af8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSkZ+Af8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B4B1F000E9;
	Tue, 21 Jul 2026 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658346;
	bh=AeylPrAf3hVGNQZ/ZvCiyRAamkHfStDKBY7NZmax/kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSkZ+Af8PBOjXzAhK9ZkENrQWEXQ5ZmiwSGCu2PDZ29UGhuw2k9Je8Dx7PLQGRqLZ
	 wp0rs+cBxYyEXkiq8T2Vl9BNp7flNvJBDEGpuPhOgZHKIgoOtlvftsx57IgWT3qxru
	 bjrHuLAdAyMcCqZquafVEqYzouOYONW5jT0n29/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1107/1611] octeontx2-vf: clear stale mailbox IRQ state before request_irq()
Date: Tue, 21 Jul 2026 17:20:23 +0200
Message-ID: <20260721152540.312995123@linuxfoundation.org>
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

commit 0b352f04b9be2c83c0240aa6dae7257fefa90464 upstream.

otx2vf_register_mbox_intr() currently installs the VF mailbox IRQ
handler before clearing stale mailbox interrupt state. The code then says
that local interrupt bits should be cleared first to avoid spurious
interrupts, but that clear still happens only after request_irq() has
already made the handler reachable.

A running system can reach this during VF mailbox interrupt registration
while stale or latched RVU_VF_INT state is still present. If delivery
happens in the request_irq()-to-clear window,
otx2vf_vfaf_mbox_intr_handler() can run before local quiesce and touch
the same vf->mbox and vf->mbox_wq carrier that probe and teardown later
reuse or destroy.

Move the stale mailbox interrupt clear ahead of request_irq(), but keep
interrupt enabling after the handler is installed. This closes the
pre-clear early-IRQ window without creating a new enable-before-handler
window.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260611160014.3202224-3-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |   22 ++++++++-----------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -251,9 +251,17 @@ static int otx2vf_register_mbox_intr(str
 {
 	struct otx2_hw *hw = &vf->hw;
 	struct msg_req *req;
+	u64 mbox_int_mask;
 	char *irq_name;
 	int err;
 
+	mbox_int_mask = !is_cn20k(vf->pdev) ? BIT_ULL(0) :
+				BIT_ULL(0) | BIT_ULL(1) |
+				BIT_ULL(2) | BIT_ULL(3);
+
+	/* Clear stale mailbox interrupt state before installing the handler. */
+	otx2_write64(vf, RVU_VF_INT, mbox_int_mask);
+
 	/* Register mailbox interrupt handler */
 	irq_name = &hw->irq_name[RVU_VF_INT_VEC_MBOX * NAME_SIZE];
 	snprintf(irq_name, NAME_SIZE, "RVUVF%d AFVF Mbox", ((vf->pcifunc &
@@ -274,18 +282,8 @@ static int otx2vf_register_mbox_intr(str
 		return err;
 	}
 
-	/* Enable mailbox interrupt for msgs coming from PF.
-	 * First clear to avoid spurious interrupts, if any.
-	 */
-	if (!is_cn20k(vf->pdev)) {
-		otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
-		otx2_write64(vf, RVU_VF_INT_ENA_W1S, BIT_ULL(0));
-	} else {
-		otx2_write64(vf, RVU_VF_INT, BIT_ULL(0) | BIT_ULL(1) |
-			     BIT_ULL(2) | BIT_ULL(3));
-		otx2_write64(vf, RVU_VF_INT_ENA_W1S, BIT_ULL(0) |
-			     BIT_ULL(1) | BIT_ULL(2) | BIT_ULL(3));
-	}
+	/* Enable mailbox interrupt for msgs coming from PF. */
+	otx2_write64(vf, RVU_VF_INT_ENA_W1S, mbox_int_mask);
 
 	if (!probe_pf)
 		return 0;


