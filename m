Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4035C378838;
	Fri,  4 Sep 2026 06:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501753; cv=none; b=j+NzMpwssgJkq0nFqsujutXFIkZ8DrpiaQVyt7bMX0tXifNEYR6JSqZEE38Ap8AJeQ7IdKopYtW8B/BjLu96aedCKFiVNOK8cDTWvqg+MFyEcEfxjuY1Sj/1RGmNw7VSY58dpMg32h7lZodGZyydGNVLD7IPfZApz9AXg+exAxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501753; c=relaxed/simple;
	bh=uSU3dXEmziGxvXTkqhHNVrlQ2Yn2Dgth91QPhscxGYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMzhVf64d9L+pQznCKHaOEmQkLdz6q0XhxGsghPQD+SKW0/iGHyLnPojYEercC2qBQdH8SJJeL6aqZHWESj2ZfpaC8kKvjDRnLNrQeMxawrDl/a0pmH4dyDkzjbeuxa7fEFuJe3rRSANAcGDj3OIeJR0IflvJuPvRMeemCjKI4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOOgWxGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOOgWxGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F031F00A3E;
	Fri,  4 Sep 2026 06:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501752;
	bh=BCBoYm4Yx7abpx9WfTgPshCxFoBLDtrlu2CMa3omHLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOOgWxGMUHYvwR5v3xyJ41Othb24Tmw6+2ysdcHyHFeVMvIJKirSZmac6GMaORYaM
	 b/L5WqNF+1Tk5jW2C3dgD1xma1wN5NUWvzNpXvcAGCXoMNUOoyw1Jf9TuR8QavFlO8
	 wYAZu5mnoiXpnrkZe20r9DZaM/8FxmMlRCBnKc7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 519/552] i3c: renesas: Check that the transfer is valid before accessing it
Date: Fri,  4 Sep 2026 07:01:16 +0200
Message-ID: <20260904045802.396080698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 5f1a76ecfe90544a28d657306c9b3caa66ba0e63 upstream.

The Renesas I3C driver uses an asynchronous model to transfer data. It
prepares a struct renesas_i3c_xfer, enqueues it, and waits for completion.
The interrupt handler dequeues the transfer, updates/uses it, and signals
the waiting thread.

If the completion times out, the waiting thread dequeues the transfer and
free it. If an interrupt fires after that, the handler may access freed
memory, leading to crashes.

Check that the transfer is still valid before accessing it in the
interrupt handler. With it clear any status flags and disable all
the interrupts to avoid triggering the same interrupts again.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-2-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   52 +++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -428,6 +428,21 @@ static void renesas_i3c_enqueue_xfer(str
 	}
 }
 
+static void renesas_i3c_irqs_mask_and_clear_locked(struct renesas_i3c *i3c)
+{
+	/* Disable all the interrupts. */
+	renesas_writel(i3c->regs, BIE, 0);
+	renesas_writel(i3c->regs, NTIE, 0);
+
+	/* Clear normal transfer status flags. */
+	renesas_writel(i3c->regs, NTST, 0);
+
+	/* Clear bus status flags. */
+	renesas_writel(i3c->regs, BST, 0);
+	/* Read back registers to confirm writes have fully propagated. */
+	renesas_readl(i3c->regs, BST);
+}
+
 static void renesas_i3c_wait_xfer(struct renesas_i3c *i3c, struct renesas_i3c_xfer *xfer)
 {
 	unsigned long time_left;
@@ -1000,6 +1015,11 @@ static irqreturn_t renesas_i3c_tx_isr(in
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1040,6 +1060,11 @@ static irqreturn_t renesas_i3c_resp_isr(
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		/* Clear the Respone Queue Full status flag*/
@@ -1124,6 +1149,11 @@ static irqreturn_t renesas_i3c_tend_isr(
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1170,6 +1200,11 @@ static irqreturn_t renesas_i3c_rx_isr(in
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1220,15 +1255,13 @@ static irqreturn_t renesas_i3c_stop_isr(
 	struct renesas_i3c_xfer *xfer;
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
-		xfer = i3c->xferqueue.cur;
-
-		/* read back registers to confirm writes have fully propagated */
-		renesas_writel(i3c->regs, BST, 0);
-		renesas_readl(i3c->regs, BST);
-		renesas_writel(i3c->regs, BIE, 0);
-		renesas_clear_bit(i3c->regs, NTST, NTST_TDBEF0 | NTST_RDBFF0);
+		renesas_i3c_irqs_mask_and_clear_locked(i3c);
 		renesas_clear_bit(i3c->regs, SCSTRCTL, SCSTRCTL_RWE);
 
+		xfer = i3c->xferqueue.cur;
+		if (!xfer)
+			return IRQ_HANDLED;
+
 		xfer->ret = 0;
 		complete(&xfer->comp);
 	}
@@ -1245,6 +1278,11 @@ static irqreturn_t renesas_i3c_start_isr
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {


