Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A0731E822;
	Sun,  7 Jun 2026 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829754; cv=none; b=N4qj9+9dZ1glC7PhQFG9y0/fM1qhpDxA6FInK9JDApyVuO0DWPOPp8fJXJ6um1RqFbgfDFlnpgcnZG1fCHpI1IvXPR6Ihvvb5gHDqbcPd1GR0gGLapEUrdid3S8E70Q9JVHZ09JA3H5BYZlY/LxXKk3zDfEXib7Y5eDMtMjnOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829754; c=relaxed/simple;
	bh=GxUlT2PaeutQIe9dfBP7I2AktzbK6z2+bByU0dydPMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1cbGvMfbSz/Bk+KOH1DFx1NHwcEizQ1yXJxQbd2nWfKaEVK/pLa3OEN8+4oUiEJgcKpruuD64hmzZOYXi/mWchxOGzeAOXxMOPnhVJusHrbZueaqzgZBJWL2kKrLfncuBDa5P+UfE48tUgX8AK9B30IsC+EOeB8edmGyu0fV7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLswW9vt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLswW9vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8141F00893;
	Sun,  7 Jun 2026 10:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829753;
	bh=CMmZfvOjtUKqLUlRwAG2CGj0JEWOEZiEgMwmsCMYIic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLswW9vtjBzScktucC3KDdeK8nnFES3yRNGzw+RgNPWxIOvzkSdbKMKiao9Lxh07d
	 qCU0WFD3hoN2XyCiRl86mj+U12s3r7WXyyOlvxMY10DGe3r01Vag1wKZKRHAj2smFH
	 b7nXrCgl5YSiry6FMUMbQ7fbfB9t68kHtDZo13bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 7.0 310/332] serial: dz: Fix bootconsole handover lockup
Date: Sun,  7 Jun 2026 12:01:19 +0200
Message-ID: <20260607095739.476100143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 7f127b2208e5e2b817243cad41fe4211a6d5a7a3 upstream.

Calling dz_reset() in the course of setting up the serial device causes
line parameters to be reset and the transmitter disabled.  We've been
lucky in that no message is usually produced to the kernel log between
this call and the later call to uart_set_options() in the course of
console setup done by dz_serial_console_init(), or the system would hang
as the console output handler in the firmware tried to access a port the
transmitter of which has been disabled and line parameters messed up.

This will change with the next change to the driver, so fix dz_reset()
such that line parameters are set for 9600n8 console operation as with
the system firmware and the transmitter re-enabled after reset.  This
also means dz_pm() serves no purpose anymore, so drop it.

Fixes: e6ee512f5a77 ("dz.c: Resource management")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.25+
Link: https://patch.msgid.link/alpine.DEB.2.21.2605062302010.46195@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/dz.c |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -571,6 +571,18 @@ static void dz_reset(struct dz_port *dpo
 	while (dz_in(dport, DZ_CSR) & DZ_CLR);
 	iob();
 
+	/*
+	 * Set parameters across all lines such as not to interfere
+	 * with the initial PROM-based console.  Otherwise any output
+	 * produced before the console handover would cause the system
+	 * firmware to produce rubbish.
+	 */
+	for (int line = 0; line < DZ_NB_PORT; line++)
+		dz_out(dport, DZ_LPR, DZ_B9600 | DZ_CS8 | line);
+
+	/* Re-enable transmission for the initial PROM-based console.  */
+	dz_out(dport, DZ_TCR, tcr);
+
 	/* Enable scanning.  */
 	dz_out(dport, DZ_CSR, DZ_MSE);
 
@@ -654,26 +666,6 @@ static void dz_set_termios(struct uart_p
 	uart_port_unlock_irqrestore(&dport->port, flags);
 }
 
-/*
- * Hack alert!
- * Required solely so that the initial PROM-based console
- * works undisturbed in parallel with this one.
- */
-static void dz_pm(struct uart_port *uport, unsigned int state,
-		  unsigned int oldstate)
-{
-	struct dz_port *dport = to_dport(uport);
-	unsigned long flags;
-
-	uart_port_lock_irqsave(&dport->port, &flags);
-	if (state < 3)
-		dz_start_tx(&dport->port);
-	else
-		dz_stop_tx(&dport->port);
-	uart_port_unlock_irqrestore(&dport->port, flags);
-}
-
-
 static const char *dz_type(struct uart_port *uport)
 {
 	return "DZ";
@@ -769,7 +761,6 @@ static const struct uart_ops dz_ops = {
 	.startup	= dz_startup,
 	.shutdown	= dz_shutdown,
 	.set_termios	= dz_set_termios,
-	.pm		= dz_pm,
 	.type		= dz_type,
 	.release_port	= dz_release_port,
 	.request_port	= dz_request_port,
@@ -894,10 +885,7 @@ static int __init dz_console_setup(struc
 	if (ret)
 		return ret;
 
-	spin_lock_init(&dport->port.lock);	/* For dz_pm().  */
-
 	dz_reset(dport);
-	dz_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);


