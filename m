Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB82E736D;
	Tue, 21 Jul 2026 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653971; cv=none; b=OHHTNgw15/S9U907MTElm60zSsaJsgw3sjOiig6rotMCq2dMlBEDVBvnflVulFi8OXhk10ENsjwI5elQmwhFl1cax+bf5/4fEwCXQprrFVcJlzVM5fIpb49hyOzLa90M7cYMRWSfuhVNDwycRXEMCq5rKUBln7p2gV0QgxNXnlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653971; c=relaxed/simple;
	bh=jGAUYPWqk6N+0rYaEWOgmiDs/0e9SQDEd4zyYK4pg2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ2N1NTLC7gPI3/9V7UIME0Acp8/43KecYl5lWkYLN/Ryfvzk+VA9B2nxmDKoUO8MP5YF99sAgCVlRq9dWFaXgdhbjufd3hyFCKu7gqkDy0UF6yy/0AYe3+fK6nUOCeHrZ/DSu7gM4oqHluJo7EbKQQ9sNlX4T/9mvwEN5aV0s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWLxENhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWLxENhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37CB1F000E9;
	Tue, 21 Jul 2026 17:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653970;
	bh=8xZ/L7C3A0qUatQBN5IDbcQeBBO0Yszw0Mfe0BONznY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWLxENhRTdrjv3O7bIGSk6tBEY/oqtXoicn/5X5ChNqH++zHKkbve/O+l8VX/0D+W
	 IHgT3g6VjY1L2WZQlnEx1aaUg4J4v1ABw0psDI1v4SbR1MLRrB8zxVZ3TuD3hAXSHq
	 5fBQiOitbHMjPcPvCiKUw9qxtb6vrTzSvXrVaHXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1529/2077] octeontx2-vf: clear stale mailbox IRQ state before request_irq()
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152628.843650728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


