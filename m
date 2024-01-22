Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9CC651AD;
	Tue, 23 Jan 2024 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971573; cv=none; b=DjC59kUBa9u1Br23nMP+mB5vO2neSNNoUHLvHcifK+NRLVLWX/GmoWFy67w+SYnIE8c8V4qjBWJN0ZFxFKmXJF0aGWpPq6x4CRwhODwB9ALFNtA73o7th2Z0xHwQafJE67cWtDSamaBULaJylUGGYo5ikCzFf6Um/psktm3KQJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971573; c=relaxed/simple;
	bh=+oNPItChcscsU4la6nUQvieAtFd3P4sp+nvXIKKfZiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MfYaKfBhKLEE2AVq7Ad8l+UBJ62VgcudRyscWn5DWGc9Bq6E+WkO3G8+TCWiA7vpBPNM6VjibT4dqjD/Xngz1NPCAsIgKGhLb5PGfOAIAne0oIBDXn3xtlttXsRgZoYFodZxYb4HSLbyRKZTQO6TIf/c9b7XWD53ReLkyYEgD20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWK9DCoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWK9DCoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7146BC433C7;
	Tue, 23 Jan 2024 00:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971573;
	bh=+oNPItChcscsU4la6nUQvieAtFd3P4sp+nvXIKKfZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWK9DCoBVr6mZdRG47X3+FQrMMv9jI9Fj479BOXpjoRRoHqyFS52uQsxhVKZvthuU
	 wmYAY+wayCiB3hqbyTDw0f7AkpXdCp3MDU6EDX965nLOSejL5FsyRBhgeFCOdvjb4p
	 a4lSVGc5O8RAaBqTGibaDg0ZagLpgpB6RjNcuAxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.1 271/417] serial: core: make sure RS485 cannot be enabled when it is not supported
Date: Mon, 22 Jan 2024 15:57:19 -0800
Message-ID: <20240122235801.239732478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1436,7 +1436,7 @@ static int uart_set_rs485_config(struct
 	int ret;
 	unsigned long flags;
 
-	if (!port->rs485_config)
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
 		return -ENOTTY;
 
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))


