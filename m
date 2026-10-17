Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C663E3166;
	Sat, 17 Oct 2026 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255387; cv=none; b=jom8EyC8UeZH4i94AU6fXyOPXaAa0WRr1tZrx6/YHGRaM0Jlg8jhOrdD3IApyiLAgM58nvyoBweynbqkbikPP97ZiRxGgN9Sw4gNeBcvqfY2hZoqNGiVjkRTaxfgmbIYNhIzM+F8OEfi+AenWegS2AszGTB1UZRbKZmOWxXA86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255387; c=relaxed/simple;
	bh=irhB91tdYtmOAa06W/P7Jjb8jgFDHsw7XkV2EM9HGJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfr3OcLVNkY+bRKbVP2Fn6DA27FnLPicw4c5iScCIcHjrBE+teKv+W/4WMSkpiea+QZK52TXLEgjmpsOWRncxN+MSgmVLHUGOo6r6DGBlOUHxTwDF5XDeuVG68XTa4T0LB8t9Kuw/CZ1zoX8s/LMkae2Jev6UYhOrSiLXaiWf2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLKoDsGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLKoDsGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BECD1F000C9;
	Sat, 17 Oct 2026 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255386;
	bh=LRuRYLLEYa5HYnv3er9rLq1e8UtlOwNZ1HPH1VuiU4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLKoDsGL2dC79CjBbbPi3xr2I7/SDgm3rAOlpVeqPks2StHeKJFH5FtMHebjYBk7L
	 idVwTU58ybjctRVJoen4+cOPEWcMiAfpeRX5asJYV2ynXoDb7Yho5mzWTTy1YkEPjJ
	 LFWy6ulNsKz5OG0bWMsAYn0gc8nzXRPIJLtVhDZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Stanley Chu <yschu@nuvoton.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 760/869] i3c: master: svc: Fix npcm845 invalid slvstart event
Date: Sat, 17 Oct 2026 18:00:01 +0200
Message-ID: <20261017160056.415349211@linuxfoundation.org>
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

[ Upstream commit 4dd12e944f07013ac280d7f46463c19157898bd1 ]

I3C HW may generate an invalid SlvStart event when emitting a STOP.
If it is a true SlvStart, the MSTATUS state is SLVREQ. Check the
MSTATUS state to ignore the false event.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Link: https://lore.kernel.org/r/20250306075429.2265183-5-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 1effa3adfe53 ("i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index a9107aef1eefe..0b709be2544c2 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -58,6 +58,7 @@
 #define SVC_I3C_MSTATUS      0x088
 #define   SVC_I3C_MSTATUS_STATE(x) FIELD_GET(GENMASK(2, 0), (x))
 #define   SVC_I3C_MSTATUS_STATE_DAA(x) (SVC_I3C_MSTATUS_STATE(x) == 5)
+#define   SVC_I3C_MSTATUS_STATE_SLVREQ(x) (SVC_I3C_MSTATUS_STATE(x) == 1)
 #define   SVC_I3C_MSTATUS_STATE_IDLE(x) (SVC_I3C_MSTATUS_STATE(x) == 0)
 #define   SVC_I3C_MSTATUS_BETWEEN(x) FIELD_GET(BIT(4), (x))
 #define   SVC_I3C_MSTATUS_NACKED(x) FIELD_GET(BIT(5), (x))
@@ -143,6 +144,12 @@
  * Fill the FIFO in advance to prevent FIFO from becoming empty.
  */
 #define SVC_I3C_QUIRK_FIFO_EMPTY	BIT(0)
+/*
+ * SVC_I3C_QUIRK_FLASE_SLVSTART:
+ * I3C HW may generate an invalid SlvStart event when emitting a STOP.
+ * If it is a true SlvStart, the MSTATUS state is SLVREQ.
+ */
+#define SVC_I3C_QUIRK_FALSE_SLVSTART	BIT(1)
 
 struct svc_i3c_cmd {
 	u8 addr;
@@ -584,6 +591,11 @@ static irqreturn_t svc_i3c_master_irq_handler(int irq, void *dev_id)
 	/* Clear the interrupt status */
 	writel(SVC_I3C_MINT_SLVSTART, master->regs + SVC_I3C_MSTATUS);
 
+	/* Ignore the false event */
+	if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART) &&
+	    !SVC_I3C_MSTATUS_STATE_SLVREQ(active))
+		return IRQ_HANDLED;
+
 	svc_i3c_master_disable_interrupts(master);
 
 	/* Handle the interrupt in a non atomic context */
@@ -2008,7 +2020,8 @@ static const struct dev_pm_ops svc_i3c_pm_ops = {
 };
 
 static const struct svc_i3c_drvdata npcm845_drvdata = {
-	.quirks = SVC_I3C_QUIRK_FIFO_EMPTY,
+	.quirks = SVC_I3C_QUIRK_FIFO_EMPTY |
+		SVC_I3C_QUIRK_FALSE_SLVSTART,
 };
 
 static const struct svc_i3c_drvdata svc_default_drvdata = {};
-- 
2.53.0



