Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A6E3242DF;
	Sun,  7 Jun 2026 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829777; cv=none; b=Oi3NkuQyphtq7nn98AgxCnX2n5+3awKYshPEzbtIDMLzqBv1s7mTppm3AKZMfVhNt0/SrszJ6BsxvdX25envSPT8lPZZ+p7vaQe4ps0zPwvv+nNpt8OFg6JhRkQ/a3I/dSRh8g+IYV0SBtZHLxeAL2ePRNVRJU2ijv11uTJcPTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829777; c=relaxed/simple;
	bh=FdN9/KCG/O//iyDqYlY2857OOoxFpL/sTb6f+gqCTkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn7oB/+L7k3rWLOqwkn82mywS7XhLk7XilqYZZ1gTeMxpl7NSsvr3qbc5EFb03t6YmRjmSWkqGciYpMVdhtyCtLok23g2UFJOKqy53HNo4OFRQ5XyCZM1okkygPANI1WUEF0OO0ydOlqCyd4IAciaOm2sYgATOa3Rs0Ne8Lx9Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwjqEu1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwjqEu1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23BC1F00893;
	Sun,  7 Jun 2026 10:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829776;
	bh=RmfBRCqGW68zzm3z4ZtrRn4XrolsVBwTwFX5mYQhfMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwjqEu1CjsLZsv61LZNCTbbo1fqwWuLAII6nlvr2boRDr/nY6Z9E2VWMDVCYwH02v
	 /GIBlrraAQ38MdiFl8N6YCChsxi8fbmbLudERBQiqaO1dGMmwbkJqm9VpYBbZRc9XM
	 bX8du+iQDbJJ6oil4vxWJeNeiYevsD835fLK6bFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 7.0 312/332] serial: zs: Fix bootconsole handover lockup
Date: Sun,  7 Jun 2026 12:01:21 +0200
Message-ID: <20260607095739.559424979@linuxfoundation.org>
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
@@ -956,23 +962,6 @@ static void zs_set_termios(struct uart_p
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
@@ -1055,7 +1044,6 @@ static const struct uart_ops zs_ops = {
 	.startup	= zs_startup,
 	.shutdown	= zs_shutdown,
 	.set_termios	= zs_set_termios,
-	.pm		= zs_pm,
 	.type		= zs_type,
 	.release_port	= zs_release_port,
 	.request_port	= zs_request_port,
@@ -1210,7 +1198,6 @@ static int __init zs_console_setup(struc
 		return ret;
 
 	zs_reset(zport);
-	zs_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);


