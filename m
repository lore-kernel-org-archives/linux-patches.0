Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B2143D4E9;
	Tue, 16 Jun 2026 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631387; cv=none; b=QA3M+glQMrqwJsR2zIIhdnhQuaWQinFpWLhgXazWdZLWT7RJG7TNUZ9QSX/fQZT7cWDaGvc5i8MeqpWjY6J3vTaRTQX1LnVRkHryZZ5uN6yez9qhckR5VRivWOU6mCZmuXKDufoJWFpy+jpGwCVWjlegNQwyyrIe4MskAckzmeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631387; c=relaxed/simple;
	bh=WYzCbLbrIYnNYjC72hiMl+sACLXl7bQU2TOrE2ltu1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCvfFlpVlncCCmZp7x5DbK2P5gZMrYbRMT0A20IvFgb3tBkNYOoLIX0M8mCTVukEEsgkPOoA6qW5yhhbPetWp8hQG2QbIEsTrjhJN0xTW9FHPS3a7JN573OiX0Fo0aGuiqwe0xZgHiMMnKq47v3yj0xZC0CJE6RXARjeYxwmgXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RE8YuvDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RE8YuvDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFEF1F000E9;
	Tue, 16 Jun 2026 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631386;
	bh=Vvz4V5QSDIs0LwFgjU7ecVYvEGxk7LL17f1veKAxcQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RE8YuvDQsY/Y2hapMKonoEzUqu61PFygApO7hZRWylRt3QBCmb2Q3/lAwS9hvKMRu
	 5GWRF2N6q6nfwJyoXtJbhYiraMzZIGCckklRSjdDABc1x39tbAVQJgl+QpORjinSR5
	 HBHqreHs2f021AYZVR32Duma9t512yjx0ZXbR48o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.1 178/522] serial: zs: Switch to using channel reset
Date: Tue, 16 Jun 2026 20:25:25 +0530
Message-ID: <20260616145134.464412150@linuxfoundation.org>
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

commit 8572955630f30948837088aa98bcbe0532d1ceac upstream.

Switch the driver to using the channel reset rather than hardware reset,
simplifying handling by removing an interference between channels that
causes the other channel to become uninitialised afterwards.

There is little difference between the two kinds of reset in terms of
register settings that result, and we initialise the whole register set
right away anyway.  However this prevents a hang from happening should
the console output handler in the firmware try to access the other port
whose transmitter has been disabled and line parameters messed up.

For example this will happen if the keyboard port (port A) is chosen for
the system console, unusually but not insanely for a headless system, as
the port is wired to a standard DA-15 connector and an adapter can be
easily made.  Or with the next change in place this would happen for the
regular console port (port B), since the keyboard port (port A) will be
initialised first.

Just remove the unnecessary complication then, a channel reset is good
enough.  We still need the initialisation marker, now per channel rather
than per SCC, as for the console port zs_reset() will be called twice:
once early on via zs_serial_console_init() for the console setup only,
and then again via zs_config_port() as the port is associated with a TTY
device.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.23+
Link: https://patch.msgid.link/alpine.DEB.2.21.2605062323430.46195@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    7 ++++---
 drivers/tty/serial/zs.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -831,21 +831,22 @@ static void zs_shutdown(struct uart_port
 
 static void zs_reset(struct zs_port *zport)
 {
+	struct zs_port *zport_a = &zport->scc->zport[ZS_CHAN_A];
 	struct zs_scc *scc = zport->scc;
 	int irq;
 	unsigned long flags;
 
 	spin_lock_irqsave(&scc->zlock, flags);
 	irq = !irqs_disabled_flags(flags);
-	if (!scc->initialised) {
+	if (!zport->initialised) {
 		/* Reset the pointer first, just in case...  */
 		read_zsreg(zport, R0);
 		/* And let the current transmission finish.  */
 		zs_line_drain(zport, irq);
-		write_zsreg(zport, R9, FHWRES);
+		write_zsreg(zport, R9, zport == zport_a ? CHRA : CHRB);
 		udelay(10);
 		write_zsreg(zport, R9, 0);
-		scc->initialised = 1;
+		zport->initialised = 1;
 	}
 	load_zsregs(zport, zport->regs, irq);
 	spin_unlock_irqrestore(&scc->zlock, flags);
--- a/drivers/tty/serial/zs.h
+++ b/drivers/tty/serial/zs.h
@@ -22,6 +22,7 @@
 struct zs_port {
 	struct zs_scc	*scc;			/* Containing SCC.  */
 	struct uart_port port;			/* Underlying UART.  */
+	int		initialised;		/* For the console port.  */
 
 	int		clk_mode;		/* May be 1, 16, 32, or 64.  */
 
@@ -41,7 +42,6 @@ struct zs_scc {
 	struct zs_port	zport[2];
 	spinlock_t	zlock;
 	atomic_t	irq_guard;
-	int		initialised;
 };
 
 #endif /* __KERNEL__ */


