Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28882269D18;
	Tue, 21 Jul 2026 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660162; cv=none; b=k9/0c9A07Mb7atVpyUGifagVJe1NERqTiLDxSscBJEpme5XNniNYS3cGVITdwvduCF1LBGKpO4Jm8PY4GmynRt+cRbissPEm/kYuE+VdRK3b3xNkI2Cl7WtkHk3GZDtmEbg1qcOUyD0pMTPMreIhXJ5pA8oFUC7IJrGrzLZ0GPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660162; c=relaxed/simple;
	bh=+16u7DZPkrNyUHlIkDbiPrDFFDjMpjCiSJRxEDcVaag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPLSqwBl5Nkckls8dS2JfPU40wRCR9mWHgZCqG21nm4QUuUfUUUq5KLSSWwsyIWT3fM0hcbhR90mKaJq1CUYVq6sRPRwTZbExC3/QORYLzTl3GPkyAM0hThwXMYjyUX9XMa953Ef8O+uEDjYllcTH52L8rAU+2CYChvyC5hsjxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6yQl6V1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6yQl6V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69151F000E9;
	Tue, 21 Jul 2026 18:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660161;
	bh=p4rwAzw1OAnQyBSyUm1ZCDDoxLDw81U3Tz+1OWThOeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6yQl6V1jUF2/6xHd0t7yUiSZNUkrzyWwz5U4WB7Tj8W2ouzMCLY6LPTSULjCSXue
	 IeOMx7cBghZNEq3rC1cYwWv0SWxJS3e95XaVdlo783MEBmSEU1MK/UvonPvQdb+Jay
	 bba7x+KVdGPdiijehlPERlHEMBjmOpGrlNID0/Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0832/2077] i3c: master: svc: Fix missed IBI after false SLVSTART on NPCM845
Date: Tue, 21 Jul 2026 17:08:25 +0200
Message-ID: <20260721152612.410464929@linuxfoundation.org>
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
index e2d99a3ac07da7..63063741fbd129 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -672,10 +672,18 @@ static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
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
 
 	/*
 	 * The SDA line remains low until the request is processed.
-- 
2.53.0



