Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B6713D52B;
	Wed,  5 Feb 2025 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763446; cv=none; b=Az0WOnUtZOcswNa5IJG7SFs2KGYq5JKhu8gwyxH4q656TscQYy86591PuNKyulEFof9nsRqLasjOa3ZgfmLsWxz1SiUEuFsigo78v+CQE+MRqvFtg6Wark5kHPecBjhWCM7f/7gTPefCfRv/9AxKGKiLYxp4lGlEGeShzAyJpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763446; c=relaxed/simple;
	bh=Wa58cmcTuP2zdgPyJAZNtN4K/yH0qxZIRCGEjX0gMNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNsld/LOUAujjQW8620pKuQMe2dxJUAprhItx/iEI49l2igdgOZlf7AUfQuPPQ5RVpVPcgAFOoVd1oYQnzkgaaEUjxBIkKOG9MF6Rta7q0f+a+UXAe8Lgb4saEmJwc1DB4yykFca2VM8nzfAZwQrEFRjIoOd0LocL5/IRq6nkEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIDmPIAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIDmPIAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF03EC4CED1;
	Wed,  5 Feb 2025 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763446;
	bh=Wa58cmcTuP2zdgPyJAZNtN4K/yH0qxZIRCGEjX0gMNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIDmPIAKUi3Xg7NjuoMCfN/3wCT/yA/Cov2Nsg5o+h7nDSZGopAz8GcM4o98p9Tbl
	 OxlhQaS66v0s5SqMIcBLK5QCpTWY1j5ddXwMQayQqAzY69gij8eXfSJPwGuOlL+6eB
	 clw4/O+OlTLf6MgtDVrm/+sdozvj0QfF/aNrTcAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/393] serial: sc16is7xx: use device_property APIs when configuring irda mode
Date: Wed,  5 Feb 2025 14:39:40 +0100
Message-ID: <20250205134422.629587859@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1a0a2a1e57aa8dcdae25229f6e95cf6bd4817faf ]

Convert driver to be property provider agnostic and allow it to be
used on non-OF platforms.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20230927160153.2717788-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 28fa3291cad1 ("clk: fix an OF node reference leak in of_clk_get_parent_name()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index f290fbe21d633..8a2ce2ca6b394 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1410,6 +1410,29 @@ static int sc16is7xx_setup_gpio_chip(struct sc16is7xx_port *s)
 }
 #endif
 
+static void sc16is7xx_setup_irda_ports(struct sc16is7xx_port *s)
+{
+	int i;
+	int ret;
+	int count;
+	u32 irda_port[2];
+	struct device *dev = s->p[0].port.dev;
+
+	count = device_property_count_u32(dev, "irda-mode-ports");
+	if (count < 0 || count > ARRAY_SIZE(irda_port))
+		return;
+
+	ret = device_property_read_u32_array(dev, "irda-mode-ports",
+					     irda_port, count);
+	if (ret)
+		return;
+
+	for (i = 0; i < count; i++) {
+		if (irda_port[i] < s->devtype->nr_uart)
+			s->p[irda_port[i]].irda_mode = true;
+	}
+}
+
 /*
  * Configure ports designated to operate as modem control lines.
  */
@@ -1603,16 +1626,7 @@ static int sc16is7xx_probe(struct device *dev,
 		sc16is7xx_power(&s->p[i].port, 0);
 	}
 
-	if (dev->of_node) {
-		struct property *prop;
-		const __be32 *p;
-		u32 u;
-
-		of_property_for_each_u32(dev->of_node, "irda-mode-ports",
-					 prop, p, u)
-			if (u < devtype->nr_uart)
-				s->p[u].irda_mode = true;
-	}
+	sc16is7xx_setup_irda_ports(s);
 
 	ret = sc16is7xx_setup_mctrl_ports(s, regmaps[0]);
 	if (ret)
-- 
2.39.5



