Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B1025E446;
	Tue, 11 Mar 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705802; cv=none; b=inGn1QoJ6eR8CoHYlw9y4HuEHz/ytbMK4+p9vqAsa0A51XnT9vQghNWLs31gRkVkqv+MGpEzf6OS5Z/eyAjRGhj70s93OhYQ/8MFR4xlrYVOLeFImXXhlr47rSovYK/fUx35zRtXawtrFUQCv54Kp332PBFsikOdCX8DPuUuTV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705802; c=relaxed/simple;
	bh=nDz1qzy88pNIKrtqcOf8CZ/E49/BKMb29IRzkKdQabA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk4SSJah2P3Xjt3ZXKG9q6LlOyxpO2n6hynTs+fVQD7GpSzeZN8PSWOYZ1AReXn2gQbL0h0uaLrkvHCp3GXq2JDZy+WzAolajZxpdhxpNrQFfxNgQYrvKKFrPLojGp3jXX9VX0hria2hqQQ/lWySCbEJvfKFa9ACZ0vWA+TAEjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGzF4ctL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGzF4ctL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ABBC4CEE9;
	Tue, 11 Mar 2025 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705802;
	bh=nDz1qzy88pNIKrtqcOf8CZ/E49/BKMb29IRzkKdQabA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGzF4ctLXfrkBSMWTxuMwKgVaHX0TW5ZExLp5iXLG12qCiK4ZrY0a2jvUEvFNNjZq
	 no5dqryKftOpRu46NHjm7wGVLntQzm3RaT+NA2apCumhQW0c1eDQ4oMPnyEXOdVSwW
	 MvpIgE8mQ65jVqjvMUNO+yXmS7jkj9P3xSBUAq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.4 141/328] serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use
Date: Tue, 11 Mar 2025 15:58:31 +0100
Message-ID: <20250311145720.513594999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 9f7dea875cc7f9c1a56a5c688290634a59cd1420 upstream.

In the sh-sci driver, sci_ports[0] is used by earlycon. If the earlycon is
still active when sci_probe() is called and the new serial port is supposed
to map to sci_ports[0], return -EBUSY to prevent breaking the earlycon.

This situation should occurs in debug scenarios, and users should be
aware of the potential conflict.

Fixes: 0b0cced19ab1 ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250116182249.3828577-4-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -166,6 +166,7 @@ struct sci_port {
 static struct sci_port sci_ports[SCI_NPORTS];
 static unsigned long sci_ports_in_use;
 static struct uart_driver sci_uart_driver;
+static bool sci_uart_earlycon;
 
 static inline struct sci_port *
 to_sci_port(struct uart_port *uart)
@@ -3345,6 +3346,7 @@ static int sci_probe_single(struct platf
 static int sci_probe(struct platform_device *dev)
 {
 	struct plat_sci_port *p;
+	struct resource *res;
 	struct sci_port *sp;
 	unsigned int dev_id;
 	int ret;
@@ -3372,6 +3374,26 @@ static int sci_probe(struct platform_dev
 	}
 
 	sp = &sci_ports[dev_id];
+
+	/*
+	 * In case:
+	 * - the probed port alias is zero (as the one used by earlycon), and
+	 * - the earlycon is still active (e.g., "earlycon keep_bootcon" in
+	 *   bootargs)
+	 *
+	 * defer the probe of this serial. This is a debug scenario and the user
+	 * must be aware of it.
+	 *
+	 * Except when the probed port is the same as the earlycon port.
+	 */
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (sci_uart_earlycon && sp == &sci_ports[0] && sp->port.mapbase != res->start)
+		return dev_err_probe(&dev->dev, -EBUSY, "sci_port[0] is used by earlycon!\n");
+
 	platform_set_drvdata(dev, sp);
 
 	ret = sci_probe_single(dev, dev_id, p, sp);
@@ -3470,6 +3492,7 @@ static int __init early_console_setup(st
 	port_cfg.type = type;
 	sci_ports[0].cfg = &port_cfg;
 	sci_ports[0].params = sci_probe_regmap(&port_cfg);
+	sci_uart_earlycon = true;
 	port_cfg.scscr = sci_serial_in(&sci_ports[0].port, SCSCR);
 	sci_serial_out(&sci_ports[0].port, SCSCR,
 		       SCSCR_RE | SCSCR_TE | port_cfg.scscr);


