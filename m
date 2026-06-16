Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D4D47AF43;
	Tue, 16 Jun 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633726; cv=none; b=RN2zHkZ23iurdedH9hvpdJAzrIXkcnd73S/J5ObC6tjGExdBVZs671eRjbIUh9zsGbRVpPDmfLg6L3subaPMzFOIC6uyclWM9gwTbn524JtAMBSSjxAzOs4qW1DkNG3eyKIoIAGyc8UC2L6ZY6+y4TiIMWVkgrwLqgCk27NNwjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633726; c=relaxed/simple;
	bh=80C885eq/KyvDf9ofhFly7f0dnidf8xt6slzNnsoNZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eplydyWM+rDHYqI1a57r7RbJ4KVR52LViF40hAoLZiVqQIAYn7SENx+Z49rlwMbwirt+vUTNxE3ZTLBsGYKHqfE+AdBwodOBzboWMgF2ORKEjkpdclV3gkTzzS7WQFWJjHk6YHihG9UQ94NnMndZPvessJxxJHcFO0mgaZRDzRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJtmPBou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJtmPBou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC61F000E9;
	Tue, 16 Jun 2026 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633724;
	bh=2GBqNKGEooGNRySeT9etNErUf5foKal3/XmoFzO/C00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJtmPBouAxk/PjRreMbQfCFm87B2v1Y6rDrmNUMUlq4H+/H8RqyL/jSCyNFIZ+1RV
	 CuLlCZrou8oHtJVTCQ9xh1/ZOk5tMufn0gjxSQUKAD9kngrHhUPd26JnbhYgTHfkeQ
	 HgPYZyr4degN4D3JYVeTCZdlua2Q87NQWQ8Ggiog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.15 134/411] serial: zs: Switch to using channel reset
Date: Tue, 16 Jun 2026 20:26:12 +0530
Message-ID: <20260616145107.471950122@linuxfoundation.org>
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


