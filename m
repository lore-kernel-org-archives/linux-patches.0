Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA6D335BBF;
	Mon, 18 Aug 2025 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525249; cv=none; b=bC/Wo7Hr3Wnm57jwwqLyllzhaKdBplDZCCITIBwPksHMILQlxx6b2HgNQpHxaeRAJbWOR9l0QRXhbWjjlwBG/UZ3bba/CDpqnPsnW15S1a5AAOlk3+uHQB/vbq1GK2rxqdEOWCL2aaIaSic8zmEGgR2qOyQ5krAX3DxZF68qN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525249; c=relaxed/simple;
	bh=jvxZ7aPJASls7EkJx2jmeKx7WOWMXrTxQN5fahuAE5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ogh5cB3g80/HamTP3xKR1Pc9SBqbSS38MnCKlwWW+J/F72+RRqOpk5+V8KWBA1f3youyAq4NmpK0T1u8I1uZxrnLf01NCLPICPinnWCFWDWUDtfg1kY41rkX1YS1i5ktyuxgVyWdHA9dozhqFYrJpgrO6trH3LUmK6McKnbpR1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrbhNIpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrbhNIpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82603C4CEEB;
	Mon, 18 Aug 2025 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525248;
	bh=jvxZ7aPJASls7EkJx2jmeKx7WOWMXrTxQN5fahuAE5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrbhNIpz1du0uw+r8i/DmU1jvKOD1N56BiyB9q9vMM3ALRpKWNvyqizZ9Zv+Mq6w0
	 49cPotue1vNsjSzkhKfx5sj/YKpJCacNkXxblIXUixXOait+L7vyq08T0KQYjBLcni
	 FDKDXFiJRq9ktKYrE/kAFBkWuSc3Uz4mbAXJkAWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 172/570] pps: clients: gpio: fix interrupt handling order in remove path
Date: Mon, 18 Aug 2025 14:42:39 +0200
Message-ID: <20250818124512.424417925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 47d9891de368..935da68610c7 100644
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



