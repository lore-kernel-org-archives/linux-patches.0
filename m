Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C6E611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3EC433EF;
	Sun, 28 May 2023 19:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302970;
	bh=/8z3MiwoOdYuQFrOq2H2udGKJOPohiLlE+2VyN2i7cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5X4o3TH/TMLyrT9Pmb6ccezWfJr+LeiHrP7qvvmwAWrD4lshhIEMwnbxyuayQy05
	 /o6eOlltM9XJ0c6I57EYgdIu/SWgiuuqDzpXuBtE0U3+FbmE+aK2sXLtV/bk93P2EL
	 IOR4HVIDYtM1TUhBA9a4+yZ99QhUhxdtWSh0ikaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ke Zhang <m202171830@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/211] serial: arc_uart: fix of_iomap leak in `arc_serial_probe`
Date: Sun, 28 May 2023 20:10:22 +0100
Message-Id: <20230528190846.099854548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ke Zhang <m202171830@hust.edu.cn>

[ Upstream commit 8ab5fc55d7f65d58a3c3aeadf11bdf60267cd2bd ]

Smatch reports:

drivers/tty/serial/arc_uart.c:631 arc_serial_probe() warn:
'port->membase' from of_iomap() not released on lines: 631.

In arc_serial_probe(), if uart_add_one_port() fails,
port->membase is not released, which would cause a resource leak.

To fix this, I replace of_iomap with devm_platform_ioremap_resource.

Fixes: 8dbe1d5e09a7 ("serial/arc: inline the probe helper")
Signed-off-by: Ke Zhang <m202171830@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230428031636.44642-1-m202171830@hust.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/arc_uart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 17c3fc398fc65..6f7a7d2dcf3aa 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -609,10 +609,11 @@ static int arc_serial_probe(struct platform_device *pdev)
 	}
 	uart->baud = val;
 
-	port->membase = of_iomap(np, 0);
-	if (!port->membase)
+	port->membase = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(port->membase)) {
 		/* No point of dev_err since UART itself is hosed here */
-		return -ENXIO;
+		return PTR_ERR(port->membase);
+	}
 
 	port->irq = irq_of_parse_and_map(np, 0);
 
-- 
2.39.2



