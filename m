Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AAC47D94D;
	Thu, 20 Aug 2026 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244146; cv=none; b=XtXbiJDQk08+X6OJMMsAQ64a4B7tTeyDk3Wxlu1vxScYc+wqEtEqC4phLeUdDHfL8i6iE62P4Zge4euYb9oX95LRT4OEpF850xrJFAMvGePdQ4o5yWnFaOs8KdgNf9VF4/Yo9/L5ElmWHxrNurPscpcBo611BKxHCLV0mH1mC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244146; c=relaxed/simple;
	bh=sA+rt2RiIHJyzrpWG44J8UilZL6SJUSCV4v4oVycc4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfG1eBb+70u+TK2Td6PB2cNMsvyBl6AYpjio85N7ijMxylAAxvhg3akjdiNIuwPy6YtRIXsGD9l84SM+j6ELiTkyNengNBFEDchEGc1oEtiMVGfMY+0VKp3IfuhXuIeTGsfdg+iOLfQqG5D2di2tn08qQPLQFmLH06L58G0R3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW4zxYLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW4zxYLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3F1F000E9;
	Thu, 20 Aug 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244145;
	bh=bACpeXIh9vMtRSKxrKvjS1JDzJX/M+xGNt4265eiPkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BW4zxYLLkex6EFApVMUwZeuxl2aH2t85VLH15SxCgp7bBS46TeJOy8bKoe7nz8C+c
	 Ug1ooDxCJrmHknxH9O73Rv6msC7FtJHtPC24wFq2tS80Hp9VDh13KP0UMQUpRDjGvC
	 baiNzFFkeySZIEByVnh5sBlqv9rRdlmw3Bi5Mp+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/235] octeontx2-pf: clear stale mailbox IRQ state before request_irq()
Date: Thu, 20 Aug 2026 16:55:04 +0200
Message-ID: <20260820145218.508267582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit f918554fb7246e89b98ef90abe80801f038258b3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -979,6 +979,9 @@ static int otx2_register_mbox_intr(struc
 	char *irq_name;
 	int err;
 
+	/* Clear stale mailbox interrupt state before installing the handler. */
+	otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
+
 	/* Register mailbox interrupt handler */
 	irq_name = &hw->irq_name[RVU_PF_INT_VEC_AFPF_MBOX * NAME_SIZE];
 	snprintf(irq_name, NAME_SIZE, "RVUPFAF Mbox");
@@ -990,10 +993,7 @@ static int otx2_register_mbox_intr(struc
 		return err;
 	}
 
-	/* Enable mailbox interrupt for msgs coming from AF.
-	 * First clear to avoid spurious interrupts, if any.
-	 */
-	otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
+	/* Enable mailbox interrupt for msgs coming from AF. */
 	otx2_write64(pf, RVU_PF_INT_ENA_W1S, BIT_ULL(0));
 
 	if (!probe_af)


