Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F8D47D949;
	Thu, 20 Aug 2026 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244152; cv=none; b=hOAO1rfwrICKgC5+1NXATYMb8XgsRQmSzFa0/s9V8eR0KMpK0N1xsYdEjZ5qLPxxm36KKV0EbjZftu0OHN1uFHNGxqKYRp7jQ4ZuoGEYxOekaxbNqLYtB89zMWtEbvdi0wiTbdqJt8r+FYYPCs12Hq31uuCRwRP4WzuIjTYuQI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244152; c=relaxed/simple;
	bh=sp5dNbTMRe96zshHdSm3kZOD4c/TiTH1Kd7iER/1LAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/8nGCrR6lY2iosqTct3ltFUK2wQr4iQ0WpQo+H0fJMOQPYPk1DDCq/+OSegWfAEgNHqdgVmIu8PRIJFmlRBrnRjMs5cXJqQ1k3cutz5QODf2VzpPkVKaTS8otsYWHQz4D5z0Q7jkP3S4oMJNbeikT22qFsWRTSSu05jJgSByXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnKVKJlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnKVKJlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C411F000E9;
	Thu, 20 Aug 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244150;
	bh=Zek9GPwHFZjh8UFe+nGvweL1TcqVQa6aL/Xw04VaMMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnKVKJlzgMgt6Phkqfhi0lc9B1WYXOkvMuJjG+5UZUIoCQIM+EjOlPUWCP4kVKrj1
	 MYzh9ey02Rdue/GuV6Z2rcE13CmtHzRetQQ6Xn1VYL/YF/hmT7ivgtRRDwOl+KpDuT
	 DXBUXn1Bsouw7/NmMnwjnNS8M7nDOgnNdzTs9l9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/235] octeontx2-vf: clear stale mailbox IRQ state before request_irq()
Date: Thu, 20 Aug 2026 16:55:06 +0200
Message-ID: <20260820145218.565909930@linuxfoundation.org>
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
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -230,6 +230,9 @@ static int otx2vf_register_mbox_intr(str
 	char *irq_name;
 	int err;
 
+	/* Clear stale mailbox interrupt state before installing the handler. */
+	otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
+
 	/* Register mailbox interrupt handler */
 	irq_name = &hw->irq_name[RVU_VF_INT_VEC_MBOX * NAME_SIZE];
 	snprintf(irq_name, NAME_SIZE, "RVUVFAF Mbox");
@@ -241,10 +244,7 @@ static int otx2vf_register_mbox_intr(str
 		return err;
 	}
 
-	/* Enable mailbox interrupt for msgs coming from PF.
-	 * First clear to avoid spurious interrupts, if any.
-	 */
-	otx2_write64(vf, RVU_VF_INT, BIT_ULL(0));
+	/* Enable mailbox interrupt for msgs coming from PF. */
 	otx2_write64(vf, RVU_VF_INT_ENA_W1S, BIT_ULL(0));
 
 	if (!probe_pf)


