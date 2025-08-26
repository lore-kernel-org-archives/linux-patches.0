Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC01E5718;
	Tue, 26 Aug 2025 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212822; cv=none; b=pITldc5F8Adx3ZUR0o5sMO1+fi1N/aPxElbaDLk/JceXiIelFHHblpd0Qjx4FknyhCHZZAuYdxnGxs+BdD7PY4wJ5nt2pR5/EvnvK22U/qhs1wfXrDK4NMRrzs4HMUh7BhikcMiBXUn1zud3O1vfTHI+QDRC55F9KrAkXGPq/jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212822; c=relaxed/simple;
	bh=j4AL1wIda8cYkK/hhxQ7Kt8VIVcXS21ZPb7cFUsVTvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlgDWKuWmBUvcWXwpTC5gAB2mIz3CoO93mctjlnd6cKpQbi8dwDAJh69qUODMvGbxyn16PIyiUeOe3KuIjoQgE7//lRE9o1YbacFdeePAu/gMSFnoS562SBioD+hDMCDW6S5E3VIQ2D4LB00PW+HRsPHu7H60W6grDN+5jc0kQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n01riOBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n01riOBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FEC4CEF1;
	Tue, 26 Aug 2025 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212822;
	bh=j4AL1wIda8cYkK/hhxQ7Kt8VIVcXS21ZPb7cFUsVTvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n01riOBZ5xmN5f3DjSXQ1be6IVs+85nWCmh40myi1t0/pO3pOmCu5J1T3aykVZPHa
	 YkHqc44i0soHhaiv9Vfb9/Y3ceaE2VAj+lj4GxSisZHtR5TMPep9ycv1AUkpgMBoLb
	 tYzJVrDuLWCblaRrjfoaUz0QIU0cN4LM2huyT8eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/587] pps: clients: gpio: fix interrupt handling order in remove path
Date: Tue, 26 Aug 2025 13:04:24 +0200
Message-ID: <20250826110955.887594304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf3b6f1aa984..41e1fdbcda16 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -206,8 +206,8 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	}
 
 	/* register IRQ interrupt handler */
-	ret = devm_request_irq(dev, data->irq, pps_gpio_irq_handler,
-			get_irqf_trigger_flags(data), data->info.name, data);
+	ret = request_irq(data->irq, pps_gpio_irq_handler,
+			  get_irqf_trigger_flags(data), data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
@@ -224,6 +224,7 @@ static int pps_gpio_remove(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
 
+	free_irq(data->irq, data);
 	pps_unregister_source(data->pps);
 	del_timer_sync(&data->echo_timer);
 	/* reset echo pin in any case */
-- 
2.39.5



