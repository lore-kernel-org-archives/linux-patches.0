Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37D539FEA;
	Fri, 24 Nov 2023 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V09qRRu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F5DC433C8;
	Fri, 24 Nov 2023 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848842;
	bh=EDRnqxepnqG6ISc/UnqOUZifRHU0UgVcdSR1n6oiROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V09qRRu6lAIG3j0Rjs/Ikz0olWUulM6YEQKURF+/9uIdgSz2YEU7ffYAd6uI9fsRJ
	 IVWtAV1+gc05YNkgGR6dPs7l+hoFHeEv1+7VixEaUaD+yrkyjCfONqZ2VDuqQTTBxy
	 /aFDn87/Qmypid02/r6EHApvja3DJ4Fa+cuiaa/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Loys Ollivier <lollivier@baylibre.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 76/97] tty: serial: meson: if no alias specified use an available id
Date: Fri, 24 Nov 2023 17:50:49 +0000
Message-ID: <20231124171937.001263843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loys Ollivier <lollivier@baylibre.com>

[ Upstream commit a26988e8fef4b258d1b771e0f4b2e3b67cb2e044 ]

At probe, the uart driver tries to get an id from a device tree alias.
When no alias was specified, the driver would return an error and probing
would fail.

Providing an alias for registering a serial device should not be mandatory.
If the device tree does not specify an alias, provide an id from a reserved
range so that the probing can continue.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Loys Ollivier <lollivier@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2a1d728f20ed ("tty: serial: meson: fix hard LOCKUP on crtscts mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/meson_uart.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index 1838d0be37044..849ce8c1ef392 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -72,7 +72,8 @@
 #define AML_UART_BAUD_USE		BIT(23)
 #define AML_UART_BAUD_XTAL		BIT(24)
 
-#define AML_UART_PORT_NUM		6
+#define AML_UART_PORT_NUM		12
+#define AML_UART_PORT_OFFSET		6
 #define AML_UART_DEV_NAME		"ttyAML"
 
 
@@ -667,10 +668,20 @@ static int meson_uart_probe(struct platform_device *pdev)
 	struct resource *res_mem, *res_irq;
 	struct uart_port *port;
 	int ret = 0;
+	int id = -1;
 
 	if (pdev->dev.of_node)
 		pdev->id = of_alias_get_id(pdev->dev.of_node, "serial");
 
+	if (pdev->id < 0) {
+		for (id = AML_UART_PORT_OFFSET; id < AML_UART_PORT_NUM; id++) {
+			if (!meson_ports[id]) {
+				pdev->id = id;
+				break;
+			}
+		}
+	}
+
 	if (pdev->id < 0 || pdev->id >= AML_UART_PORT_NUM)
 		return -EINVAL;
 
-- 
2.42.0



