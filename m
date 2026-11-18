Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049635;
	b=x3dMAxR3UuYDRkwd5S2z2OkiasujMmMNzfC8CaDRq2IbPAXY39BUea3eGndWVQImDqyM
	 X5vvc0IuLoT7hOXQg2K9+akbQ3ZYUpi9E1UdziDwsCigOpcCg0Y52IaoUskyIXu19ju+p
	 JtD7pqrCZ3jjAW/T4j6FzH9vOg/+NZG6Uq0E6MzNS+19HprBNl6vb2lYzsnK1cBV6pBJL
	 EjZczRlC0vC8kF7+bdopzFvh72VlPPRexAlRCxZuJyWft4JEejKax0KfTW/+CilEHuXYU
	 ZKqBfSDqn5co5j76ge8VmIVCuj8o5peL+vS/qw5UjXO9AWbGAjL13Ia1qAcQe9XIGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7r1oakzVtBELMYxhcvyXj7ha49FlQClPT8XUxylTyMU=;
	b=lde7mGorALB6f6QiPxY/uovMDx+JotQWMrXADU2R8VcXJEw71zsca1xf851RLNgpegDW
	 vPg76qv2JhQ3AkgooH4sqCE9so+ngWvi7Td2kbDe6ejk7JsOi0Sy3UurhJYjITXGDxQEs
	 YrLqD0aATh1bT6gm0khqGbrWTNB/kBdRwSImUByE3Kv9UlaVIgVR5Ojt6LNEr73mMciq/
	 4SKUKXsMTh+PjOsRwTZbwXemOEjlCB6n/6XGcHONrp4uxzGXRdQRuOlYr+Yf7D3tjKWUl
	 dLgDmN7rtkTz34EMp3h68j7nJ6gLwRzYU5tUcOEqSnKQz8IL8nFvz7eqNVVNY48S2BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhxjvniV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDAA606A31C;
	Thu, 19 Nov 2026 00:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhxjvniV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC49C1F000C4;
	Thu, 19 Nov 2026 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049635;
	bh=7r1oakzVtBELMYxhcvyXj7ha49FlQClPT8XUxylTyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhxjvniVRtKBgie9Vz2C82vuM08hv0Ac6eAp4DK20CvhuwTWBNxk1NF+0SHybJoiU
	 13YAHJNPBefAmeVJrzuEZkqeoKWvHJEKxdAsTudEJ11df/ZHsx+JfDPfOstwnwDFVI
	 i+hbp5wpJ+TDVHctblb1m9jfaI0oNobwFouBZ2pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2405/2857] serial: max310x: simplify probe() and remove() error handling
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150328.137718148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 5d888f1c32e2281843d58eef963e3ebd625b77a9 ]

Simplify error handling and only call uart_remove_one_port() if line bit
is set, instead of having to manually set s->p[i].port.dev to NULL.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-10-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index d08970f73cbe1..204ea3d16a41f 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1448,10 +1448,9 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 		/* Register port */
 		ret = uart_add_one_port(&max310x_uart, &s->p[i].port);
-		if (ret) {
-			s->p[i].port.dev = NULL;
+		if (ret)
 			goto out_uart;
-		}
+
 		set_bit(line, max310x_lines);
 
 		/* Go to suspend mode */
@@ -1487,10 +1486,8 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 out_uart:
 	for (i = 0; i < devtype->nr; i++) {
-		if (s->p[i].port.dev) {
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
 			uart_remove_one_port(&max310x_uart, &s->p[i].port);
-			clear_bit(s->p[i].port.line, max310x_lines);
-		}
 	}
 
 out_clk:
@@ -1508,8 +1505,10 @@ static void max310x_remove(struct device *dev)
 		cancel_work_sync(&s->p[i].tx_work);
 		cancel_work_sync(&s->p[i].md_work);
 		cancel_work_sync(&s->p[i].rs_work);
-		uart_remove_one_port(&max310x_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, max310x_lines);
+
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
+			uart_remove_one_port(&max310x_uart, &s->p[i].port);
+
 		s->devtype->power(&s->p[i].port, 0);
 	}
 
-- 
2.53.0



