Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF82E62CD;
	Thu,  3 Jul 2025 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553957; cv=none; b=K60rotmzWposdLEJ3gV9cx059lYgm/tsZYG2k3feNmI6vttdrOWdCbSNeVYKSByxBEO6296Hob0nNaPQYUG1Poyi1EpjAF28mLiT0qaGCAOZMU+xSeouzDW6lw1uR2m6ocrONREI1g1d3MypRCOfZJl0PTlQOZlFvKc77TzWJ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553957; c=relaxed/simple;
	bh=p2qqZXXTGG/OFaf/nwmEWhn5IAKDbgaKe73sZcMl9jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fto509DAt4mEIW4+C+0dAjSXkciEoKct6tVrW7HlP/z1tOh+C/vR0hQqH5+wx1O/Ip92TTrfJhH5I9YELUryFeMWle3lRc+0PBueqEt3wa8BxCmiRtBee5EkhCxMOKzSqaeHCXzo81/AoxSs53rkJ/7iaJBWEa6qbPQDajvFw4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVGqd+Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVGqd+Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF8C4CEE3;
	Thu,  3 Jul 2025 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553957;
	bh=p2qqZXXTGG/OFaf/nwmEWhn5IAKDbgaKe73sZcMl9jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVGqd+TxbwgIxVkQciglQFEUAtmycdqfaoV4GbxuyC2zrxJOG4k/t28XXk6jIkO0p
	 7JyLZN+3cZ5ebx6EN6BMaK9uH3wxGVu2PjTlFypKS+//yh3FQOG24bQztDbPIAd7bZ
	 UD3xjCoYFWkljsQTxhoVNwgtAjQXsw/39m12Y8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/218] 8250: microchip: pci1xxxx: Add PCIe Hot reset disable support for Rev C0 and later devices
Date: Thu,  3 Jul 2025 16:39:44 +0200
Message-ID: <20250703143957.393156603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit c40b91e38eb8d4489def095d62ab476d45871323 ]

Systems that issue PCIe hot reset requests during a suspend/resume
cycle cause PCI1XXXX device revisions prior to C0 to get its UART
configuration registers reset to hardware default values. This results
in device inaccessibility and data transfer failures. Starting with
Revision C0, support was added in the device hardware (via the Hot
Reset Disable Bit) to allow resetting only the PCIe interface and its
associated logic, but preserving the UART configuration during a hot
reset. This patch enables the hot reset disable feature during suspend/
resume for C0 and later revisions of the device.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250425145500.29036-1-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci1xxxx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci1xxxx.c b/drivers/tty/serial/8250/8250_pci1xxxx.c
index f462b3d1c104c..d6b01e015a96b 100644
--- a/drivers/tty/serial/8250/8250_pci1xxxx.c
+++ b/drivers/tty/serial/8250/8250_pci1xxxx.c
@@ -115,6 +115,7 @@
 
 #define UART_RESET_REG				0x94
 #define UART_RESET_D3_RESET_DISABLE		BIT(16)
+#define UART_RESET_HOT_RESET_DISABLE		BIT(17)
 
 #define UART_BURST_STATUS_REG			0x9C
 #define UART_TX_BURST_FIFO			0xA0
@@ -620,6 +621,10 @@ static int pci1xxxx_suspend(struct device *dev)
 	}
 
 	data = readl(p + UART_RESET_REG);
+
+	if (priv->dev_rev >= 0xC0)
+		data |= UART_RESET_HOT_RESET_DISABLE;
+
 	writel(data | UART_RESET_D3_RESET_DISABLE, p + UART_RESET_REG);
 
 	if (wakeup)
@@ -647,7 +652,12 @@ static int pci1xxxx_resume(struct device *dev)
 	}
 
 	data = readl(p + UART_RESET_REG);
+
+	if (priv->dev_rev >= 0xC0)
+		data &= ~UART_RESET_HOT_RESET_DISABLE;
+
 	writel(data & ~UART_RESET_D3_RESET_DISABLE, p + UART_RESET_REG);
+
 	iounmap(p);
 
 	for (i = 0; i < priv->nr; i++) {
-- 
2.39.5



