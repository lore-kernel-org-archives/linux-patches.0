Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95CA2E4980;
	Tue, 15 Jul 2025 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586364; cv=none; b=Ru4qM9EaXUx9KZ1XL+kq7uim3kxwxGMs5EErnTj6UNEKxmyvFePrPHtPMaYWtUat3MCbVCD/MihcMXRh4pKfL5vzoqYAHxFEQQ3RRknz3/SIYEaEjSFpXybLeXUIKNbKFIMIGII/qlEZ/6sWq8p+Q/OQ5Kudes6HJBrGdaqfiGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586364; c=relaxed/simple;
	bh=GVUGYWjz9mg8RTjF6q6sRxpjp7hxd0eUqBbSFHwNh/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYSFdkYdkROjO1ZApAiqi2QhPufWSM02t+CNwNk1m4QwD+go1qHGcgowOj2b7n+si0bMDvASQXjh4jCJfKpD4tW3GhOmQG6HgI+MLT1JsTk2mh0yUytfvgCCLRJ7dyaiwMNrKQx4p0k+WkD90qy0rTkhwgDj+n3E41h4h97lPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcC4A9s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcC4A9s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3A5C4CEE3;
	Tue, 15 Jul 2025 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586364;
	bh=GVUGYWjz9mg8RTjF6q6sRxpjp7hxd0eUqBbSFHwNh/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcC4A9s3X7V/J8t61TxIolqh46yY7g633bArwkC4PyTCcrgURlF99J7Vy1BtWZVkt
	 2tP6b6BoHZRtgpVZ0i5tKltpbT2ZHskBZU4r4xvNFlhYbfxAvtONHTtfQ6Vhq6sm+N
	 M08/UFYwTIdlhqR+/zV98KHEqRibjYAe0vtvzmBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Lewalski <jakub.lewalski@nokia.com>,
	Elodie Decerle <elodie.decerle@nokia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/148] tty: serial: uartlite: register uart driver in init
Date: Tue, 15 Jul 2025 15:12:10 +0200
Message-ID: <20250715130800.636958682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/uartlite.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 9a4049c894f7a..e323e9c0a321e 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -874,16 +874,25 @@ static struct platform_driver ulite_platform_driver = {
 
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



