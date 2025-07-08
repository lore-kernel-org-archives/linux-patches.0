Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C248F5E;
	Tue,  8 Jul 2025 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993784; cv=none; b=MAfSe4KeiMwmrNryZs3jE68ovuCjpDYzr639sVG7Ux0hwAQUPaB+UoY/IqkxGHgb2WIo+T/VJfUDsv6cjthZuV4YmdRDj475LfpnW1dubVGt5Sk/zJ1mHFAbG+YwZZHBB0jnsKMm6kpxW7W8Kp26lSq4YkR3xkfP3rWjUMVrRSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993784; c=relaxed/simple;
	bh=wpH3g0F6YVNXEImPUMwygfGv8A+7eaH0C5qf6SD3V1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkRm2XfmBx8B7MUFVMEdjZ307wX7nXlF0NXMED90AqEDB5UsPi2n7Vl8SaMuYkY1tDOk95YdlFOY/TLpx8+7HoYvGMdoqkFpwJB8PGRsfYtcNjns3q0QeTQ8jAxgn4ga9JtWlN9Jap3ckFQX4/QDX7Fxn7W9au1kFaGG3nwpO0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lxh8NE8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxh8NE8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62219C4CEF0;
	Tue,  8 Jul 2025 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993783;
	bh=wpH3g0F6YVNXEImPUMwygfGv8A+7eaH0C5qf6SD3V1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lxh8NE8wrv59qqey8ogaTdEeKOPumNlpg2l+Q2tm4/NJY4Kt4Lyvkwh2FB5xFtcaX
	 VTLNiOrOfb4ezM+oJztPHyCikGPTBA9zX78MsVuXzySRZA5a5LIX2qOf0D6Tp/lYRH
	 2BXBPRQkXu4RU+tB9suQWZ1PWNWAAuwYkzu31pdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Lewalski <jakub.lewalski@nokia.com>,
	Elodie Decerle <elodie.decerle@nokia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/160] tty: serial: uartlite: register uart driver in init
Date: Tue,  8 Jul 2025 18:20:54 +0200
Message-ID: <20250708162231.985264456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Lewalski <jakub.lewalski@nokia.com>

[ Upstream commit 6bd697b5fc39fd24e2aa418c7b7d14469f550a93 ]

When two instances of uart devices are probing, a concurrency race can
occur. If one thread calls uart_register_driver function, which first
allocates and assigns memory to 'uart_state' member of uart_driver
structure, the other instance can bypass uart driver registration and
call ulite_assign. This calls uart_add_one_port, which expects the uart
driver to be fully initialized. This leads to a kernel panic due to a
null pointer dereference:

[    8.143581] BUG: kernel NULL pointer dereference, address: 00000000000002b8
[    8.156982] #PF: supervisor write access in kernel mode
[    8.156984] #PF: error_code(0x0002) - not-present page
[    8.156986] PGD 0 P4D 0
...
[    8.180668] RIP: 0010:mutex_lock+0x19/0x30
[    8.188624] Call Trace:
[    8.188629]  ? __die_body.cold+0x1a/0x1f
[    8.195260]  ? page_fault_oops+0x15c/0x290
[    8.209183]  ? __irq_resolve_mapping+0x47/0x80
[    8.209187]  ? exc_page_fault+0x64/0x140
[    8.209190]  ? asm_exc_page_fault+0x22/0x30
[    8.209196]  ? mutex_lock+0x19/0x30
[    8.223116]  uart_add_one_port+0x60/0x440
[    8.223122]  ? proc_tty_register_driver+0x43/0x50
[    8.223126]  ? tty_register_driver+0x1ca/0x1e0
[    8.246250]  ulite_probe+0x357/0x4b0 [uartlite]

To prevent it, move uart driver registration in to init function. This
will ensure that uart_driver is always registered when probe function
is called.

Signed-off-by: Jakub Lewalski <jakub.lewalski@nokia.com>
Signed-off-by: Elodie Decerle <elodie.decerle@nokia.com>
Link: https://lore.kernel.org/r/20250331160732.2042-1-elodie.decerle@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/uartlite.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 36871cebd6a0f..0345eaf969630 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -808,16 +808,6 @@ static int ulite_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	if (!ulite_uart_driver.state) {
-		dev_dbg(&pdev->dev, "uartlite: calling uart_register_driver()\n");
-		ret = uart_register_driver(&ulite_uart_driver);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "Failed to register driver\n");
-			clk_disable_unprepare(pdata->clk);
-			return ret;
-		}
-	}
-
 	ret = ulite_assign(&pdev->dev, id, res->start, irq, pdata);
 
 	pm_runtime_mark_last_busy(&pdev->dev);
@@ -859,16 +849,25 @@ static struct platform_driver ulite_platform_driver = {
 
 static int __init ulite_init(void)
 {
+	int ret;
+
+	pr_debug("uartlite: calling uart_register_driver()\n");
+	ret = uart_register_driver(&ulite_uart_driver);
+	if (ret)
+		return ret;
 
 	pr_debug("uartlite: calling platform_driver_register()\n");
-	return platform_driver_register(&ulite_platform_driver);
+	ret = platform_driver_register(&ulite_platform_driver);
+	if (ret)
+		uart_unregister_driver(&ulite_uart_driver);
+
+	return ret;
 }
 
 static void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	if (ulite_uart_driver.state)
-		uart_unregister_driver(&ulite_uart_driver);
+	uart_unregister_driver(&ulite_uart_driver);
 }
 
 module_init(ulite_init);
-- 
2.39.5



