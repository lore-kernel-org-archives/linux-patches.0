Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899C18E37C;
	Mon, 28 Oct 2024 06:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097226; cv=none; b=PjBUWWN4qkE4dDwT9xnSXvLJxKM6jY2UlhC2v/Y3gzP7Lvi8DaBm1Nss4fUW+bS/rj5m/mTc9grIlEokea+rOBniAO1wLV1H7WLlwttyoYS8FMSz9Kl7vFBm2jZxj3aFBcL/LPbOCGnElheXfFJVUeszb6PJnI/JGq+bPpJZwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097226; c=relaxed/simple;
	bh=T55sEEFlA5F/umx8mK4PY9vhYREc6Cu8RKw7j4m2yDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0oHov2Gr5J1/N7ufXb/XgKuzDnDu3BrnM2aJjhM4oFT3ZCz5zTyCtMr5b44XCi6aSwR7huGUSpOgvR8r+w9HHmJd+TzjKwBkQ3MEfC2/vVLnMexw8QQAJk6V2tT601sHv/LrV5qYqIZO0axRT5EhAOW4zoav7vvauPYpCFd1Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCxKsk40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCxKsk40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5608FC4CEC7;
	Mon, 28 Oct 2024 06:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097226;
	bh=T55sEEFlA5F/umx8mK4PY9vhYREc6Cu8RKw7j4m2yDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCxKsk40mYcFxwvQ0VBFLzoA2KvADVbxQgQojMtLq7hrld3qHCcY2ApTY55P4/mEp
	 lCzprK5MJwWghWfi+1rYuxJ4mjns3/itaeHBhAZTi79nf+wLH16ZHdrELJKjyThxkT
	 tRDmcn/+7927Ytv7p7UnJzu//hx4we1oRPETwajM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/137] irqchip/renesas-rzg2l: Fix missing put_device
Date: Mon, 28 Oct 2024 07:24:36 +0100
Message-ID: <20241028062259.812634441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6905f78855ffa..5df559252c6ef 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -408,12 +409,12 @@ static int rzg2l_irqc_parse_interrupts(struct rzg2l_irqc_priv *priv,
 
 static int rzg2l_irqc_init(struct device_node *node, struct device_node *parent)
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
 
@@ -467,6 +468,17 @@ static int rzg2l_irqc_init(struct device_node *node, struct device_node *parent)
 
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



