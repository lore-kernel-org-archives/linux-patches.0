Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16608188CB3;
	Tue, 10 Sep 2024 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961591; cv=none; b=F6SsPc+m9ObwUNlIdcX9iZlC9vl1nCAzhu2b1JzwOGyx2QgpqLwYTzj/6d/ctsOolGevnmPxD6rkNsaCXeF1aPfPeBsK62bf88NAxibkSBtjleqPl6oFN2RxyZIFQ+5ERwB6jqyWJ7oezfl69sBVI1Q9a4Snjva3zODEzu2J8NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961591; c=relaxed/simple;
	bh=tpU0BoNQSxMcLWrvmw+rgxf8DHAFnF2wJex/z0XKdOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp+2CJd5RCrTCjH3n0UoZ2yxFJrFproW5A2PqC3+42DokGkCypaQ3mohKWSt432g06vZ5aLXmsNveQ6X/sQ2wElA8xzsv1r4uzgjZac2z7o24ZNkQTR2UfAZrm12XL6o/l7y0uSVaU+zocfOuBykbf+EZdCDVj6shb/bVboanec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcasK0wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcasK0wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9387AC4CEC3;
	Tue, 10 Sep 2024 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961591;
	bh=tpU0BoNQSxMcLWrvmw+rgxf8DHAFnF2wJex/z0XKdOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcasK0wfmdrAEPS7cgOUrVCLZBCuViZDfrxRmxq02GU0y2J/WEzW3EFuAmwutiw2G
	 xM9myqEaY39HEwYEM/mrUkazFqbYsrVhwkBSR7BpcTOVxUJWAZZ42qp6AneLU9j5Gk
	 //apnE/0kORbNW9EQ/G8r8SCmGP+a6BbZbhGfZO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.10 104/375] irqchip/renesas-rzg2l: Reorder function calls in rzg2l_irqc_irq_disable()
Date: Tue, 10 Sep 2024 11:28:21 +0200
Message-ID: <20240910092625.882779350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 492eee82574b163fbb3f099c74ce3b4322d0af28 ]

The order of function calls in the disable operation should be the reverse
of that in the enable operation. Thus, reorder the function calls to first
disable the parent IRQ chip before disabling the TINT IRQ.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com> # on RZ/G3S
Link: https://lore.kernel.org/r/20240606194813.676823-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index f6484bf15e0b..5a4521cf3ec6 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -162,8 +162,8 @@ static void rzg2l_tint_irq_endisable(struct irq_data *d, bool enable)
 
 static void rzg2l_irqc_irq_disable(struct irq_data *d)
 {
-	rzg2l_tint_irq_endisable(d, false);
 	irq_chip_disable_parent(d);
+	rzg2l_tint_irq_endisable(d, false);
 }
 
 static void rzg2l_irqc_irq_enable(struct irq_data *d)
-- 
2.43.0



