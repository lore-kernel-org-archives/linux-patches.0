Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A32529BDB5;
	Sat, 17 Oct 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255687; cv=none; b=dpH++nNUCp87yvEZ8Wfbf+SRDmqtMjju7f/wSEcB8aZFZZ1GXamv6b5svG7RKICP5TmUMaTrjmvAFh7tWpyX62mIHpafmFFKEkw6bga5DlsnrXTtsvASSaFZ+hydU3ApJhL7u59jLGAp2w1fyb6ZEqy+IdunyBy/txnqfeXoUFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255687; c=relaxed/simple;
	bh=lEv/Yqirq1Fkqx5cDwQz99DRUs1yubtbuHkYu//Ayq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/YC0drWoU73NngUoDQ3DJY653zC3o0S4DWcDbQTr8FeUbM65Ng0G8EU1+LbnPAzLLqTe5uZVXc/0UNAbT89RwK9U9hbVm46DxOyeJ94Y+8C3mXNTEDkmhqN7K9ZOJIzMenCD2TiiMkPeyQvOyWAEWWWDFMMHSx6k+7RN9TDFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9Pe5Swf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9Pe5Swf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15D11F000C4;
	Sat, 17 Oct 2026 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255686;
	bh=vNvIcoDJG7CAN2mUueMx/RxhJJBq2p4lZl4gtpZZ2vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9Pe5Swf4MX+inYH2z7XGw0htvgSMVkNGUQbnwmxVJnf/oE+ezhPkV2+Z35iqhwUD
	 CcQ7ovgh+SfsPbH5CilRCh2iKK4Le5jy3ylTqAKUdfbC8mgyc+DARShT8Zn+wHK59O
	 SM9obTrdHwL4qWSP5uui52da6Kav2ZqSR98VP9kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 858/869] i3c: master: svc: Fix missed IBI after false SLVSTART on NPCM845
Date: Sat, 17 Oct 2026 18:01:39 +0200
Message-ID: <20261017160058.856252941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit fa1d4fa118f4229168e9ca88cea260c5e5a94652 ]

The NPCM845 I3C controller may raise a false SLVSTART interrupt. The
handler first latches MSTATUS and then clears SLVSTART. If a real IBI
request arrives after the handler latches MSTATUS but before it clears
the SLVSTART interrupt status, HW sets the SLVREQ state. However, the
handler still relies on the stale MSTATUS snapshot, returns early, and
misses the real IBI. No further interrupt is generated for this pending
IBI.

Re-read MSTATUS to obtain the latest state and avoid missing a real IBI
due to this race condition.

Fixes: 4dd12e944f07 ("i3c: master: svc: Fix npcm845 invalid slvstart event")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260413005040.1211107-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 1948d398ce503..25cdb77973c09 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -600,10 +600,18 @@ static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
 	/* Clear the interrupt status */
 	writel(SVC_I3C_MINT_SLVSTART, master->regs + SVC_I3C_MSTATUS);
 
-	/* Ignore the false event */
-	if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART) &&
-	    !SVC_I3C_MSTATUS_STATE_SLVREQ(active))
-		return IRQ_HANDLED;
+	if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART)) {
+		/*
+		 * Re-read MSTATUS to obtain the latest state and avoid
+		 * missing an IBI that arrives after MSTATUS is latched
+		 * but before SLVSTART is cleared.
+		 */
+		active = readl(master->regs + SVC_I3C_MSTATUS);
+
+		/* Ignore the false event */
+		if (!SVC_I3C_MSTATUS_STATE_SLVREQ(active))
+			return IRQ_HANDLED;
+	}
 
 	svc_i3c_master_disable_interrupts(master);
 
-- 
2.53.0



