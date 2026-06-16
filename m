Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8233B26CE05;
	Tue, 16 Jun 2026 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631382; cv=none; b=Q7nKe0nnFVF4cP4EhoMk5fBYS6faqF6tTmc1KkfjtSVhkAegEXLe3s0HwD84DILgPdIYcce0XgwV+9Y0z8pmhYxaJ/mWEBIZKzb6Y49ajb5rrRVf4YHyzvweC8jEQvGA9DUzuuspuJNWSFJ6vc7nc/h0CMlesv4wNTVMDpOD9GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631382; c=relaxed/simple;
	bh=6Y4Ren6Is4L6f5ChhYJgnaH87nHnClAcF1XbMlx8qh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALeu8iGsYaFVPlLoJRdFYQk0I450phmbvqtjywRhia92YkY2sj2wCiEEhG1V6ae2lJaw6t3g76FiWKgtkArwuBQ8LKuL8ibdTxHMz+MQEd6FneAsUKE7m8SdqopuGdKZ1DRCRWgLAGI1ziDhuIPYBYXTnofS1kamcV0C/6Ci4ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC+RguUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC+RguUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBD1F000E9;
	Tue, 16 Jun 2026 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631381;
	bh=p76aWtIM3bH0pltuvhoyacgv9UpFO+FcwrJxYiqG8sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sC+RguUn3FbFdi7wAPRhGcLqldDumzld32hoWvmFIJWcc2Q8/vXDjrmTgpOo7zxyT
	 rTY+iC37zd3lav9lmOr2GDJ+8hQpvuwrHCXHEZY2Ckm3ffr2vg3ae/O2jK9jsusMY7
	 G9AfeM7nl8fdCP8A5IJu0fyMYhoTT+SC0lLHyA4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.1 177/522] serial: zs: Fix bootconsole handover lockup
Date: Tue, 16 Jun 2026 20:25:24 +0530
Message-ID: <20260616145134.420384627@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 6c05cf72e13314ce9b770b5951695dc5a2152920 upstream.

Calling zs_reset() in the course of setting up the serial device causes
line parameters to be reset and the transmitter disabled.  We've been
lucky in that no message is usually produced to the kernel log between
this call and the later call to uart_set_options() in the course of
console setup done by zs_serial_console_init(), or the system would hang
as the console output handler in the firmware tried to access a port the
transmitter of which has been disabled and line parameters messed up.

This will change with the next change to the driver, so fix zs_reset()
such that line parameters are set for 9600n8 console operation as with
the system firmware and the transmitter re-enabled after reset.  This
also means zs_pm() serves no purpose anymore, so drop it.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.23+
Link: https://patch.msgid.link/alpine.DEB.2.21.2605062308040.46195@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -105,18 +105,24 @@ struct zs_parms {
 
 static struct zs_scc zs_sccs[ZS_NUM_SCCS];
 
+/*
+ * Set parameters in WR5, WR12, WR13 such as not to interfere
+ * with the initial PROM-based console.  Otherwise any output
+ * produced before the console handover would cause the system
+ * firmware to hang (TxENAB) or produce rubbish (Tx8, B9600).
+ */
 static u8 zs_init_regs[ZS_NUM_REGS] __initdata = {
 	0,				/* write 0 */
 	PAR_SPEC,			/* write 1 */
 	0,				/* write 2 */
 	0,				/* write 3 */
 	X16CLK | SB1,			/* write 4 */
-	0,				/* write 5 */
+	Tx8 | TxENAB,			/* write 5 */
 	0, 0, 0,			/* write 6, 7, 8 */
 	MIE | DLC | NV,			/* write 9 */
 	NRZ,				/* write 10 */
 	TCBR | RCBR,			/* write 11 */
-	0, 0,				/* BRG time constant, write 12 + 13 */
+	0x16, 0x00,			/* BRG time constant, write 12 + 13 */
 	BRSRC | BRENABL,		/* write 14 */
 	0,				/* write 15 */
 };
@@ -955,23 +961,6 @@ static void zs_set_termios(struct uart_p
 	spin_unlock_irqrestore(&scc->zlock, flags);
 }
 
-/*
- * Hack alert!
- * Required solely so that the initial PROM-based console
- * works undisturbed in parallel with this one.
- */
-static void zs_pm(struct uart_port *uport, unsigned int state,
-		  unsigned int oldstate)
-{
-	struct zs_port *zport = to_zport(uport);
-
-	if (state < 3)
-		zport->regs[5] |= TxENAB;
-	else
-		zport->regs[5] &= ~TxENAB;
-	write_zsreg(zport, R5, zport->regs[5]);
-}
-
 
 static const char *zs_type(struct uart_port *uport)
 {
@@ -1054,7 +1043,6 @@ static const struct uart_ops zs_ops = {
 	.startup	= zs_startup,
 	.shutdown	= zs_shutdown,
 	.set_termios	= zs_set_termios,
-	.pm		= zs_pm,
 	.type		= zs_type,
 	.release_port	= zs_release_port,
 	.request_port	= zs_request_port,
@@ -1209,7 +1197,6 @@ static int __init zs_console_setup(struc
 		return ret;
 
 	zs_reset(zport);
-	zs_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);


