Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F248A4DF4DC;
	Wed,  9 Sep 2026 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961771; cv=none; b=YD7u4R/w3EvieBUjRbHBmA3jfUWEyZnhVeHRxDg3DWxd4GPe0M+yXbDJ7Cvq4SWZmy71Dywt9WEQ4m33bE/Tk2M10ADxTK+l4ABwcSdFp6gCPYtHck6gPXWW2tHoZpiirJn2rPJIuDTv1BsX72kcWdAcgqOIpC7muROlS1FC/vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961771; c=relaxed/simple;
	bh=KujaqWtzeS6p8CgmJXGagZbmiKOQlfWS65zwyBefkC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOgOtp8ErwWQSVhs4+OortvFdVjcBrhtSL9jgDVXQVN93tI6XsU9MG/9H8lZYvbIHSBc6NdNC+5m62oltvOPolz9lcEYvULLPCAnowJCnt/+/PfnGJ+SOp71RcT4BtJITDkkxMP/jlldGKHW+fYeMsyaWzdZdPGa0rfTF1RlkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTF9UFAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTF9UFAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A271F00A3A;
	Wed,  9 Sep 2026 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961769;
	bh=vRKfJm5hINd5XNRUH2maac9Rcv/G93MxIziQH3/0Df0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTF9UFAotqf5AmbltUJnG3XLx5kCI5vAOL6DTDl6FQpbgQAO9PwUL7rOZFewTXhBO
	 vnjdwG7CqWr30gzeBlRolycHpGmheWPr4CpWYlxpLcQwKbTyXkqb6f1DVKXG9MVQku
	 TZoAp2qCp3TQnDAX8TtwZDZg+GXQRALqkV4HWHt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	stable@kernel.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: [PATCH 7.2 061/556] soc: fsl: qe: Add chained_irq_{enter,exit}() calls in cascade handler
Date: Wed,  9 Sep 2026 15:35:41 +0200
Message-ID: <20260909134232.613282883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 7e47fe56415847732419ca8cef9307bf111dd368 upstream.

Wrap the cascade handler body with chained_irq_{enter,exit}() to
properly inform the parent IRQ chip that a chained interrupt is being
serviced.

Fixes: f0bcd784e1b76 ("soc: fsl: qe: Add an interrupt controller for QUICC Engine Ports")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Cc: stable@kernel.org
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Link: https://lore.kernel.org/r/20260708-qe-pic-gpios-v2-1-1972044cfbd1@bootlin.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qe_ports_ic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/soc/fsl/qe/qe_ports_ic.c
+++ b/drivers/soc/fsl/qe/qe_ports_ic.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/platform_device.h>
 
@@ -79,7 +80,13 @@ static int qepic_get_irq(struct irq_desc
 
 static void qepic_cascade(struct irq_desc *desc)
 {
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	chained_irq_enter(chip, desc);
+
 	generic_handle_irq(qepic_get_irq(desc));
+
+	chained_irq_exit(chip, desc);
 }
 
 static int qepic_host_map(struct irq_domain *h, unsigned int virq, irq_hw_number_t hw)


