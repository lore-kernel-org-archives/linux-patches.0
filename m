Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FEF3EC6AE;
	Fri,  4 Sep 2026 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500153; cv=none; b=upX2k6+kr4TsovbMgruEnkl1tx6HciutteGNL7jAwvW6rA3MQ9fa4lQFiUo0tIQpDWWTAWXzB7fM0l3KSNy0afC5cd2j8dTJpr6veAN2zl7SN+NJbvqFTCun+fpdZtmFWPk+sySa417R1DQFv1o7QmE6bCLiQ9aDMVhUb9VnsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500153; c=relaxed/simple;
	bh=cRSQ+yrTF7ud9XHcL9vm842Pi0IYZtECgkn9nan2rCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASaVp21FKGZ5xTTlP5QwJ3o+I2p4bWgGd9llqCM9dJKZDH1gQ5jXUr5LO9vWWCcIyD1VPmzXo3bsoCJy50viyjo1ZJmFn0yOHJ1v4KKhhZabNkcMG08nXVJEcjE83qiSt/K/Q/1PLOL9KEF7uar7OHtHRnZd9wykhCiKm9wHk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAOrluWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAOrluWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEE31F00A3D;
	Fri,  4 Sep 2026 05:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500152;
	bh=+bcC0FPI6fm17+qVBSakTaWYh0qIV6IkPDD+i+TfgLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAOrluWWQ8jcUKS0ecV9WWKD7ArN9OJE0t4GIO0pu5qRdqZhFxifnaNLS4ObpRw97
	 VZtZuiAvOIoBR9MOT/znCPB+q402a4dDHmkAkuCThqyymjHiNO3rvRI6Q+olPZGx9i
	 GcvtZj25beZmaWvmWgQlIT/BtSHovjfEJFUAclYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 668/713] i3c: renesas: Check that the transfer is valid before accessing it
Date: Fri,  4 Sep 2026 07:00:36 +0200
Message-ID: <20260904045818.808557027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,6 +433,21 @@ static void renesas_i3c_enqueue_xfer(str
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
@@ -1018,6 +1033,11 @@ static irqreturn_t renesas_i3c_tx_isr(in
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1058,6 +1078,11 @@ static irqreturn_t renesas_i3c_resp_isr(
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		/* Clear the Respone Queue Full status flag*/
@@ -1142,6 +1167,11 @@ static irqreturn_t renesas_i3c_tend_isr(
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1188,6 +1218,11 @@ static irqreturn_t renesas_i3c_rx_isr(in
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {
@@ -1238,15 +1273,13 @@ static irqreturn_t renesas_i3c_stop_isr(
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
@@ -1263,6 +1296,11 @@ static irqreturn_t renesas_i3c_start_isr
 
 	scoped_guard(spinlock, &i3c->xferqueue.lock) {
 		xfer = i3c->xferqueue.cur;
+		if (!xfer) {
+			renesas_i3c_irqs_mask_and_clear_locked(i3c);
+			return IRQ_HANDLED;
+		}
+
 		cmd = xfer->cmds;
 
 		if (xfer->is_i2c_xfer) {


