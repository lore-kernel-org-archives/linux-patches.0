Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306E3624D4;
	Tue, 16 Dec 2025 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886935; cv=none; b=A/cwDvTlNwtMnTniI49dv7SGcC8JMkh0H/RP2Pk6DHmirG507qy+caZBkvck9PtBB3VNRvQlxlfKv3kGn/m0TRCVBkOBs4/HPV4kV7XoJJzgC5yS4V7n+OZx2QYAtNQShCR+2Gg9MFumXYmug/au+proCpfdIggwVbmv6LspTfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886935; c=relaxed/simple;
	bh=ROk1mLLHcACxYDlCAJPPwCFUd94lAZGEgJJ2ltYOk3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbeWgkX7pRIEVDJsAzAr6JSKxRjWPFPPafNEL85rPGrFrsPUfC64fAJdClfpdJ8X3UwyG9RgJfRSsI21M1mdzlWzBABcQXXQVxopqtWaXq1Q6kVhD5fYfJWk8YDz9X8W5QfNyRu/45AF2prS/hh7PNwMj3JuJsZhLFhYYrvwXZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+zJ6uoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+zJ6uoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A94C4CEF1;
	Tue, 16 Dec 2025 12:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886935;
	bh=ROk1mLLHcACxYDlCAJPPwCFUd94lAZGEgJJ2ltYOk3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+zJ6uoEu8RXLmg8nrds+2CW2MnszEnY9RJbpqHn9ZsDZUvzHsRzkxKpHZBeDOvsr
	 aCN7kde+XC9/Jf8JIRi2uF2NKNLbD6GiwZW3KrOxNqjB5NUNW7G9Pu6LXiEoXDvUrj
	 fDkAUXFxyuC5/4Bq5XpD2kU2RwdadqrefANh6AdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/614] tty: serial: imx: Only configure the wake register when device is set as wakeup source
Date: Tue, 16 Dec 2025 12:07:25 +0100
Message-ID: <20251216111404.143747469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit d55f3d2375ceeb08330d30f1e08196993c0b6583 ]

Currently, the i.MX UART driver enables wake-related registers for all
UART devices by default. However, this is unnecessary for devices that
are not configured as wakeup sources. To address this, add a
device_may_wakeup() check before configuring the UART wake-related
registers.

Fixes: db1a9b55004c ("tty: serial: imx: Allow UART to be a source for wakeup")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251002045259.2725461-2-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 500dfc009d03e..90e2ea1e8afe5 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2697,8 +2697,22 @@ static void imx_uart_save_context(struct imx_port *sport)
 /* called with irq off */
 static void imx_uart_enable_wakeup(struct imx_port *sport, bool on)
 {
+	struct tty_port *port = &sport->port.state->port;
+	struct device *tty_dev;
+	bool may_wake = false;
 	u32 ucr3;
 
+	scoped_guard(tty_port_tty, port) {
+		struct tty_struct *tty = scoped_tty();
+
+		tty_dev = tty->dev;
+		may_wake = tty_dev && device_may_wakeup(tty_dev);
+	}
+
+	/* only configure the wake register when device set as wakeup source */
+	if (!may_wake)
+		return;
+
 	uart_port_lock_irq(&sport->port);
 
 	ucr3 = imx_uart_readl(sport, UCR3);
-- 
2.51.0



