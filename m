Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B330831E115;
	Mon, 18 Aug 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523505; cv=none; b=r/PKvXPV7FzboK+qt/P7S4pF9o8xMHswjatOfWo0nS1tgYBB7byjGU4R+0nR+qpPODLusI4aG0pvlKICVoG6HbJgAXn1OOlZBkPzuohxfq6gN+61fT4FVjxLrhIrVL5BCJ9M1fGMJCL6YTUuStV9kDEjSo5k1+yTZCK1ZyV2jJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523505; c=relaxed/simple;
	bh=VUVqEprVUvxw5i1w3KLvsXgE2aDsSAbJ/e26oYqM8vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw4BRMuHP2WbUpNtzJoDwZZ5bLgwsTFgBBRMQ6eXnW7Gqng5tXCgZb1dDqs8hPz2s0Gu2tQZOiae0kJ2SnYR070xq3Lc+0dLKNyr1wH6H6sviuwiwwPMbC3PuBISKOKIEKUBcT96PkVpqS+emselKHDygYzPU7y9R1TK8QMrbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSMUMoQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSMUMoQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21183C4CEEB;
	Mon, 18 Aug 2025 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523505;
	bh=VUVqEprVUvxw5i1w3KLvsXgE2aDsSAbJ/e26oYqM8vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSMUMoQl0l5S4pNgrLm5rftw5/vZYiL9YxUWjRY282m8OPfb6LW/hVnpvootrR2OL
	 Qs6AsYNZJtVNVDUH98x6/CAHROAind9m/Ptarms5JubsddbdIGU4UWY+jqluiXeVhU
	 YqXxGCe0fJda3fBGndoXvndiqXo6rdR304Hle7/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 159/515] pps: clients: gpio: fix interrupt handling order in remove path
Date: Mon, 18 Aug 2025 14:42:25 +0200
Message-ID: <20250818124504.505903853@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliav Farber <farbere@amazon.com>

[ Upstream commit 6bca1e955830808dc90e0506b2951b4256b81bbb ]

The interrupt handler in pps_gpio_probe() is registered after calling
pps_register_source() using devm_request_irq(). However, in the
corresponding remove function, pps_unregister_source() is called before
the IRQ is freed, since devm-managed resources are released after the
remove function completes.

This creates a potential race condition where an interrupt may occur
after the PPS source is unregistered but before the handler is removed,
possibly leading to a kernel panic.

To prevent this, switch from devm-managed IRQ registration to manual
management by using request_irq() and calling free_irq() explicitly in
the remove path before unregistering the PPS source. This ensures the
interrupt handler is safely removed before deactivating the PPS source.

Signed-off-by: Eliav Farber <farbere@amazon.com>
Link: https://lore.kernel.org/r/20250527053355.37185-1-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-gpio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 374ceefd6f2a..2866636b0554 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -210,8 +210,8 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	}
 
 	/* register IRQ interrupt handler */
-	ret = devm_request_irq(dev, data->irq, pps_gpio_irq_handler,
-			get_irqf_trigger_flags(data), data->info.name, data);
+	ret = request_irq(data->irq, pps_gpio_irq_handler,
+			  get_irqf_trigger_flags(data), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
@@ -228,6 +228,7 @@ static void pps_gpio_remove(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
 
+	free_irq(data->irq, data);
 	pps_unregister_source(data->pps);
 	timer_delete_sync(&data->echo_timer);
 	/* reset echo pin in any case */
-- 
2.39.5



