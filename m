Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A08837;
	Mon, 28 Oct 2024 06:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098090; cv=none; b=dQhD+nhIKZV7QiwYik1u8JpPEYYZ+yKlX2ZcmlTWSM+jUjiuYv3aolXaHyKYjw/4D9blg7bTm1TZjfVCxx6DdrmCS+jEyoLswSj5xjwqtm9/MSRjotL3zNi+Y5wmsJkEfdwN2Sn68/MDaFB2kjaJCVmYTicklWI6T55jTQIYHXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098090; c=relaxed/simple;
	bh=YyHjvEWTsByn7U1KgT+CmSarySK2q3NWgeoVo6qteqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNOMm+DiAoivY5tlLtlEBmGNfsoQgcztKt2y6gPK72jgIYgUkPEGHeqwl8TDpiyK1gFLQHyqbNKCE7SFa5GWeFdJNhDiNj+erv23wijjOuOdJ9dd9mQ9zjH16ogCc0cbaXuaWnTvO2UrHNo1NXhxG0v7ks/o7aaRFTjIgo9KpI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7REGWcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7REGWcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADB4C4CEC3;
	Mon, 28 Oct 2024 06:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098090;
	bh=YyHjvEWTsByn7U1KgT+CmSarySK2q3NWgeoVo6qteqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7REGWcZWWt9hgKhjr5nHjz6uZsVh/h2qKKAehP0dpAHDHMT+CdSThHXWXdh4tza2
	 UXh1x/rV5SS25V4OlBzVIQSzF7ey0OqBtRlcb3n8fknlR2bt6aOZsNCVRNqZjUhkeI
	 2cHLopQmsY2tFCUQKjMF+gpvn7h4IOTzOcnq1VwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 073/261] irqchip/renesas-rzg2l: Fix missing put_device
Date: Mon, 28 Oct 2024 07:23:35 +0100
Message-ID: <20241028062313.858771596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit d038109ac1c6bf619473dda03a16a6de58170f7f ]

rzg2l_irqc_common_init() calls of_find_device_by_node(), but the
corresponding put_device() call is missing.  This also gets reported by
make coccicheck.

Make use of the cleanup interfaces from cleanup.h to call into
__free_put_device(), which in turn calls into put_device when leaving
function rzg2l_irqc_common_init() and variable "dev" goes out of scope.

To prevent that the device is put on successful completion, assign NULL to
"dev" to prevent __free_put_device() from calling into put_device() within
the successful path.

"make coccicheck" will still complain about missing put_device() calls,
but those are false positives now.

Fixes: 3fed09559cd8 ("irqchip: Add RZ/G2L IA55 Interrupt Controller driver")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241011172003.1242841-1-fabrizio.castro.jz@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 693ff285ca2c6..99e27e01b0b19 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -530,12 +531,12 @@ static int rzg2l_irqc_parse_interrupts(struct rzg2l_irqc_priv *priv,
 static int rzg2l_irqc_common_init(struct device_node *node, struct device_node *parent,
 				  const struct irq_chip *irq_chip)
 {
+	struct platform_device *pdev = of_find_device_by_node(node);
+	struct device *dev __free(put_device) = pdev ? &pdev->dev : NULL;
 	struct irq_domain *irq_domain, *parent_domain;
-	struct platform_device *pdev;
 	struct reset_control *resetn;
 	int ret;
 
-	pdev = of_find_device_by_node(node);
 	if (!pdev)
 		return -ENODEV;
 
@@ -591,6 +592,17 @@ static int rzg2l_irqc_common_init(struct device_node *node, struct device_node *
 
 	register_syscore_ops(&rzg2l_irqc_syscore_ops);
 
+	/*
+	 * Prevent the cleanup function from invoking put_device by assigning
+	 * NULL to dev.
+	 *
+	 * make coccicheck will complain about missing put_device calls, but
+	 * those are false positives, as dev will be automatically "put" via
+	 * __free_put_device on the failing path.
+	 * On the successful path we don't actually want to "put" dev.
+	 */
+	dev = NULL;
+
 	return 0;
 
 pm_put:
-- 
2.43.0



