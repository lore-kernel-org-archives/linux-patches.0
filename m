Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4191F472D;
	Tue, 21 Jan 2025 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482589; cv=none; b=jI6GXcRl8ZV3iEtHBFr199ISp3UvuDbRBO24mTgsQMsuxS1O4JKwvYejw23EZwVeQkdz3vkfyrWHifhdAF5FgqeUCcfaSbQKgTyISioK28xNcuPV7osn7RKN4txc8O9P/USOR4HwnUmHjXqFFKfGuSxF42ozQisnyyJmWp2aoAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482589; c=relaxed/simple;
	bh=OahGTnNgpmzQEq/jXTq6ADvDp/X7D2pIuw4VROCR3C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQT+ilyZAImwptV3C20MvLGVEPjJqkjvanT41ketrwRCXrAiOwpoAkjDYoQz+BGbk6gdWzlDayMimVh4CynlQ6pQskZndqjO9yLLWB0HM00X4GlihLHcoZpf5jGFe8gnjWQGCgFDK7HNSLpeBOfBWk7wjVDbrWOgr6I6Xwnbl8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zodxX1ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zodxX1ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83632C4CEDF;
	Tue, 21 Jan 2025 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482588;
	bh=OahGTnNgpmzQEq/jXTq6ADvDp/X7D2pIuw4VROCR3C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zodxX1MEND6bBVsiOdNidJn+frs9mZdUwU8rxLEPmSuYWKkAJPTQLCD2DVVgEmAXO
	 NN1GDZzmZQDGcKYp8s11IMFRPw2soU0WLJb4UfvvH3NDoRX/AISSRYHj/VPQlHesV0
	 ZSxbvs7qje7kKm/VKSH7M4KXhcMdzidultvxjXUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 103/122] irqchip: Plug a OF node reference leak in platform_irqchip_probe()
Date: Tue, 21 Jan 2025 18:52:31 +0100
Message-ID: <20250121174537.009729712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 9322d1915f9d976ee48c09d800fbd5169bc2ddcc upstream.

platform_irqchip_probe() leaks a OF node when irq_init_cb() fails. Fix it
by declaring par_np with the __free(device_node) cleanup construct.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: f8410e626569 ("irqchip: Add IRQCHIP_PLATFORM_DRIVER_BEGIN/END and IRQCHIP_MATCH helper macros")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241215033945.3414223-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irqchip.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -35,11 +35,10 @@ void __init irqchip_init(void)
 int platform_irqchip_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *par_np = of_irq_find_parent(np);
+	struct device_node *par_np __free(device_node) = of_irq_find_parent(np);
 	of_irq_init_cb_t irq_init_cb = of_device_get_match_data(&pdev->dev);
 
 	if (!irq_init_cb) {
-		of_node_put(par_np);
 		return -EINVAL;
 	}
 
@@ -55,7 +54,6 @@ int platform_irqchip_probe(struct platfo
 	 * interrupt controller can check for specific domains as necessary.
 	 */
 	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY)) {
-		of_node_put(par_np);
 		return -EPROBE_DEFER;
 	}
 


