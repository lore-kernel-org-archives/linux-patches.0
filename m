Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3026C145B30;
	Tue, 23 Jan 2024 00:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969700; cv=none; b=ThcAFRp0Bj7jnqwqwvqvVFUfjKTHgf6t7ByKFbf/wKiG0+azqnzgidHIqX5MkVyM4GTcDmNx50NQmdQ7PnXhOKU6iJk4RYQ4ZYHAqCsxe2r/cG9qjNBRl8zGjC5OEKTh17+Hk39+U0VEGD5iw0A8v3t8ZaKbxVlUGDhY5XyZkA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969700; c=relaxed/simple;
	bh=ZBEt6Y58HhS+t2MpWWN8nxi6M4RjRpdrYZ9O9XgbFYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okJV92O/FXzwOPJlAEJZ3ZVK6E48mrzqHq8lKZLY+b6RVVngjMUdma5enq/oXyQzQnNxigAInLXXWZ8jG3nM1v7OOpBIvQ11U0TD1UTdXPUWWcluCIKkjr8MZ/Nbg/2Gh12pgnwqTGXxo2rBfYcvckE7mmZGI//mOGpDCBuGm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHZPDxXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHZPDxXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5396C433C7;
	Tue, 23 Jan 2024 00:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969700;
	bh=ZBEt6Y58HhS+t2MpWWN8nxi6M4RjRpdrYZ9O9XgbFYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHZPDxXWJq76A6ISrf6grr4SDlZwxN+6ztnCG6IN+usBkBbIKlpu+OYpMmeJspzHs
	 AJx8L4HJNCIKfjZAk1Y6faH+YIUIZFU64ktG9cqBjy0iHBm+uL14Yc1G6bvWrNX79A
	 3StCbd7mmOkhT/ApVNBW9+iG/uf04ny4wEgZEt4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 411/641] serial: core: make sure RS485 cannot be enabled when it is not supported
Date: Mon, 22 Jan 2024 15:55:15 -0800
Message-ID: <20240122235830.842776316@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit c73986913fa47e71e0b1ad7f039f6444915e8810 upstream.

Some uart drivers specify a rs485_config() function and then decide later
to disable RS485 support for some reason (e.g. imx and ar933).

In these cases userspace may be able to activate RS485 via TIOCSRS485
nevertheless, since in uart_set_rs485_config() an existing rs485_config()
function indicates that RS485 is supported.

Make sure that this is not longer possible by checking the uarts
rs485_supported.flags instead and bailing out if SER_RS485_ENABLED is not
set.

Furthermore instead of returning an empty structure return -ENOTTY if the
RS485 configuration is requested via TIOCGRS485 but RS485 is not supported.
This has a small impact on userspace visibility but it is consistent with
the -ENOTTY error for TIOCGRS485.

Fixes: e849145e1fdd ("serial: ar933x: Fill in rs485_supported")
Fixes: 55e18c6b6d42 ("serial: imx: Remove serial_rs485 sanitization")
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc:  <stable@vger.kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-5-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1469,7 +1469,7 @@ static int uart_set_rs485_config(struct
 	int ret;
 	unsigned long flags;
 
-	if (!port->rs485_config)
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
 		return -ENOTTY;
 
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))


