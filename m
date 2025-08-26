Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A621DAC95;
	Tue, 26 Aug 2025 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214316; cv=none; b=tPhu41aztJAZtUpGymVlV/KywQ23uFN5yL1ADJj2+QcQpbjX/6HRYC4gQtibbDSc66lgSTve08nYv7VqYsmORvNaKhdYExrNOPNW66a1BrGg8AXm3iUDMWI/hVQgW+wZmqP3JN4gaPW0y2NdErDr1ys2MpXWVnW6jWRS5XYvI1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214316; c=relaxed/simple;
	bh=EFlAC02XwrjbH4yWZaeNupxlmh90o6MCKihjlL9DCng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmAifMN75F/VW0MtgC6sClXJvTrmX9uwJ749MFOMiCaXsTy8dCI4bX+ywaWR4ZfW4hbwIT/dNGy6ij4QGWSyXa0TAyTZc4hnvV8LiV+IqRtPyjsc3ddEYR9aaoYcG9ib6jurSlIALMskzlBnY70DE3YsfsdwUooei0kXbkxqR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBztmmRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBztmmRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E4C4CEF1;
	Tue, 26 Aug 2025 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214315;
	bh=EFlAC02XwrjbH4yWZaeNupxlmh90o6MCKihjlL9DCng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBztmmRP2Xwy3oh2meOGw2PNgWneSB4GAaMF2m9x8ozVZc0zb8bT0TriZoiWErisL
	 GcfESTSNjgRucCPfLfXQubcebc/eTom5dt/ux1bTSYYESTT8HjMxwXTff3TO5gtmX1
	 64lXWGVSxj3SqiLF9tHGJqnN8x3tih6ZVIV109q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/482] pps: clients: gpio: fix interrupt handling order in remove path
Date: Tue, 26 Aug 2025 13:05:46 +0200
Message-ID: <20250826110933.124134209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



