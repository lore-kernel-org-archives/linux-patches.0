Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334413D8105;
	Tue, 16 Jun 2026 18:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635046; cv=none; b=pylcv8IFsfRfIKTnaCrUoJqd9GkzQXwxA/m1t6fpB7i29OAXBkN3BuBxfvpes5bteDbJcHd9b/1V2SBxPdCc8Hoxz8hPTLOSsWAhHOGVBiO27djW3Wu3cmEI6CoFpMKqDxvjcvAllhZ5claD1OM61ZflizYYhMTZzQ6c6Clcr0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635046; c=relaxed/simple;
	bh=Tji2aXtQlr/grkJQTnCAouXq/0XRmLbGfdtnGJjdsS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHZ8+9FxB5fEodBuQekk0nWaybfKvLyb/ktV4Cy0SpQUVLwx/77RkO883koJUh8aTwdeHSP8ECRD0FjW2e3OO3iX696NsYqpe+sJgp2tQr0ekNMBuQYw+6LyqfyBdH63Clq0BvDtU91+57UfRhtDpwowCUtz1Hpjf2Yq9jAIj1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9rGDC/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9rGDC/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DE31F000E9;
	Tue, 16 Jun 2026 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635045;
	bh=2z71P/r/entEIwtH0qmWrxaGMvBYwqvDLMhEuEZsFWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9rGDC/2FQTkkQ8B/2SgCWYPtLKTy0sgCO21I+Nd1mypAiJSSchnoiNRxZj4O9fUb
	 nEZFQmuKxF9hGO0CMQeimC/DzZGY38875Jf9vAKppaJBuiMk44c1XhdA8lYnZWtqfr
	 Ey6zaAnQ6SoNPJ2YrXoC7s2SeUjlT72rVI/saD4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 381/411] serial: altera_jtaguart: Use platform_get_irq_optional() to get the interrupt
Date: Tue, 16 Jun 2026 20:30:19 +0530
Message-ID: <20260616145121.528316852@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 60302276caff50f907bc3391a364691ab4a21b43 ]

platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
allocation of IRQ resources in DT core code, this causes an issue
when using hierarchical interrupt domains using "interrupts" property
in the node as this bypasses the hierarchical setup and messes up the
irq chaining.

In preparation for removal of static setup of IRQ resource from DT core
code use platform_get_irq_optional().

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20211224142917.6966-7-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ea66be25f0e9 ("serial: altera_jtaguart: handle uart_add_one_port() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/altera_jtaguart.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -418,8 +418,9 @@ static int altera_jtaguart_probe(struct
 	struct altera_jtaguart_platform_uart *platp =
 			dev_get_platdata(&pdev->dev);
 	struct uart_port *port;
-	struct resource *res_irq, *res_mem;
+	struct resource *res_mem;
 	int i = pdev->id;
+	int irq;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -438,9 +439,11 @@ static int altera_jtaguart_probe(struct
 	else
 		return -ENODEV;
 
-	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res_irq)
-		port->irq = res_irq->start;
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq < 0 && irq != -ENXIO)
+		return irq;
+	if (irq > 0)
+		port->irq = irq;
 	else if (platp)
 		port->irq = platp->irq;
 	else


