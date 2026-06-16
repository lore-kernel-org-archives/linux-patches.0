Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A035292A;
	Tue, 16 Jun 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633767; cv=none; b=J/SkKoucLG/7aBm2AQ2znofzp+wPmmD8zD0Dy4J8ff7JOwmo/GnWMeMrg3JyMqJ2FyLi8H7srCJUtJvTtW+bqZ7TgYbM79JmDT8Tl5pBKiEYjTt4jjjYl1hMFQkHBVBiXf93MLJ7IAzstvXUyAwD9HkSYhzzE1snXreO7fAwGec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633767; c=relaxed/simple;
	bh=rDRRedisskJkBTJK/n2mfRoHcZA12pxsVj5Btbu8nHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaUj5lLYQIG3NL2ysH2uepbAZhoI4HCyB5jTNtBk1dvXnqt5IRljFEML215wy8vOCHEkqTmeYyMos2kUTLn7CCQ6VNjBo9UOoWiDUwoDsFI6rTd/GnsXzcxQsns2yVxWRo6mEnCIYR0fjZLarEdn8dSy/WPOiKEJ43kdpPfdj0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW3KQhb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW3KQhb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F51F000E9;
	Tue, 16 Jun 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633765;
	bh=A3QQVK+1v1A2y/pUKZ7n/l1tVakip42zD2QDE1qaKD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SW3KQhb85EY/gfPQgJKP+STChTPfNLJQQsc2pWL9JKktszP9socVYiFBwwhMNqBfx
	 3mg7FoQcpr7Oj54Nd1TqjSEqG64O1qK0OmQS04q9WsKIec8hQxbnOnm9LPJ3J+gp1z
	 naasbIxH46iyLDqYItOdhV6W4LPXByp5W1SZojlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/411] serial: dz: Fix bootconsole handover lockup
Date: Tue, 16 Jun 2026 20:26:19 +0530
Message-ID: <20260616145107.868406795@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Avoid C99+ 'for' loop initial declaration for 5.15.y. ]
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/dz.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index 6d74ba5a5a431c..05f22e76a50893 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -546,6 +546,7 @@ static void dz_reset(struct dz_port *dport)
 	struct dz_mux *mux = dport->mux;
 	unsigned short tcr;
 	int loops = 10000;
+	int line;
 
 	if (mux->initialised)
 		return;
@@ -573,6 +574,18 @@ static void dz_reset(struct dz_port *dport)
 	while (dz_in(dport, DZ_CSR) & DZ_CLR);
 	iob();
 
+	/*
+	 * Set parameters across all lines such as not to interfere
+	 * with the initial PROM-based console.  Otherwise any output
+	 * produced before the console handover would cause the system
+	 * firmware to produce rubbish.
+	 */
+	for (line = 0; line < DZ_NB_PORT; line++)
+		dz_out(dport, DZ_LPR, DZ_B9600 | DZ_CS8 | line);
+
+	/* Re-enable transmission for the initial PROM-based console.  */
+	dz_out(dport, DZ_TCR, tcr);
+
 	/* Enable scanning.  */
 	dz_out(dport, DZ_CSR, DZ_MSE);
 
@@ -653,26 +666,6 @@ static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
 	spin_unlock_irqrestore(&dport->port.lock, flags);
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
-	spin_lock_irqsave(&dport->port.lock, flags);
-	if (state < 3)
-		dz_start_tx(&dport->port);
-	else
-		dz_stop_tx(&dport->port);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
-}
-
-
 static const char *dz_type(struct uart_port *uport)
 {
 	return "DZ";
@@ -768,7 +761,6 @@ static const struct uart_ops dz_ops = {
 	.startup	= dz_startup,
 	.shutdown	= dz_shutdown,
 	.set_termios	= dz_set_termios,
-	.pm		= dz_pm,
 	.type		= dz_type,
 	.release_port	= dz_release_port,
 	.request_port	= dz_request_port,
@@ -893,10 +885,7 @@ static int __init dz_console_setup(struct console *co, char *options)
 	if (ret)
 		return ret;
 
-	spin_lock_init(&dport->port.lock);	/* For dz_pm().  */
-
 	dz_reset(dport);
-	dz_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
-- 
2.53.0



