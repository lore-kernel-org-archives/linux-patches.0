Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DB1439359;
	Thu, 30 Jul 2026 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426651; cv=none; b=gSBXnlmFLi0j3ZXxi2N6o+NPjaEMSUUjfEUd8IsmIM242wHAaM8cRiEYQ5E4DRaq6+L/HcpTDDWyLqMX6UKUfHTzRwP/jMR4/pX2gWqlL1Vdt2hLMkOJ2TsMPLEitdWJZpzySdSn7hDjTu4nf8VG+rXn34lT2oZ5ZUgToISaM84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426651; c=relaxed/simple;
	bh=Gik87eU+oyvzYqCfZLfoZx3PV0UqmmKQrbmq9Yym9Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKPguadL5i0E7Uh+8dLv9rw9NI9aeGzuOvdHnzZ2tIDcG+DTXBYpNU5fAzh11QzzwUgwym/d8ats0I35iddzua+vgFLYxVjhFDraCU6rcrPcOkpJs1UE36bzD2oe8NEjy35tOmub2OV+bQnHAY5aTlY3JGVtXtrdDj24pne7JNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtnWIvVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtnWIvVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704A01F000E9;
	Thu, 30 Jul 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426650;
	bh=64yp1LQ5nMdXHFK5DD4OxgzmW6FTlEV0ooREdxNISLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtnWIvVzOKlKOdHJiK9E1l7I2MBoVtt7C1LRGbgvg//DnS9gQxhxmKVZ+qOJzYLfs
	 Me3EGi1lFyL97JBr39GPN6NqXROYYNNpX0xtJuIWo4uS+Oy0YqtM4lzdfutm5NPAe/
	 a68guv92fPJ0IomyXJfpEoo+txgZxMuWZsfqAKuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 494/602] octeontx2-vf: clear stale mailbox IRQ state before request_irq()
Date: Thu, 30 Jul 2026 16:14:46 +0200
Message-ID: <20260730141446.352515078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 0b352f04b9be2c83c0240aa6dae7257fefa90464 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -245,9 +245,15 @@ static int otx2vf_register_mbox_intr(str
 {
 	struct otx2_hw *hw = &vf->hw;
 	struct msg_req *req;
+	u64 mbox_int_mask;
 	char *irq_name;
 	int err;
 
+	mbox_int_mask = BIT_ULL(0);
+
+	/* Clear stale mailbox interrupt state before installing the handler. */
+	otx2_write64(vf, RVU_VF_INT, mbox_int_mask);
+
 	/* Register mailbox interrupt handler */
 	irq_name = &hw->irq_name[RVU_VF_INT_VEC_MBOX * NAME_SIZE];
 	snprintf(irq_name, NAME_SIZE, "RVUVFAF Mbox");
@@ -259,11 +265,8 @@ static int otx2vf_register_mbox_intr(str
 		return err;
 	}
 
-	/* Enable mailbox interrupt for msgs coming from PF.
-	 * First clear to avoid spurious interrupts, if any.
-	 */
-	otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
-	otx2_write64(vf, RVU_VF_INT_ENA_W1S, BIT_ULL(0));
+	/* Enable mailbox interrupt for msgs coming from PF. */
+	otx2_write64(vf, RVU_VF_INT_ENA_W1S, mbox_int_mask);
 
 	if (!probe_pf)
 		return 0;


