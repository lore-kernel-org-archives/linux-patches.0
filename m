Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEF32EAD1B;
	Thu,  3 Jul 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554691; cv=none; b=LydmlaL5xPYIdRycXyY8MbzpMeMc8wHoRBZUy7IIgNUQc9apcy9QvyFoquFXIM7zFzJO7OJ2pBtOeylXCsB6bgPJN0KURNoHblNeAWfneifDU2k/SzDUAgp0AA/mvaBvilzfml4VDrhQZILFJHKDqKRuHmzORZHSn125/ayO8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554691; c=relaxed/simple;
	bh=wQKjzXbs7/WBp13tb4f5uDJpjn23GseZWwQX8Fx/uk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl4iZv5dQ0nXWXRZRE/zqSrB+XrI9fpJftRF4h8hyAvFCQ5cL3alVpgZhh0qbyAsKEMMwGlOn/5hfS5DBi2bbSYR8Zob8p5+5vfWe1VEy2U9YF8BZ1wcPeC0PG0FRQtRsK3WqEZGVXUAg9aK9gtfBIF+csZB2aTCz6NKezDfASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eabzi5bQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eabzi5bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB1CC4CEED;
	Thu,  3 Jul 2025 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554691;
	bh=wQKjzXbs7/WBp13tb4f5uDJpjn23GseZWwQX8Fx/uk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eabzi5bQofuSkWRNPnhGmpWtXRpTZxb1X+tt7Ql57ChXAemJKDjRbTQaQiSJy/FQX
	 Y2fOPMYgo6v3KUnezZgUYjPji3466DtytFzRTPk/1KPfuIaD1zLAIFj+91lhalctEB
	 ht/vcEQg/xsoHJRsPGMg/3zerFb2ZHr0Fb5vFFFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 048/263] 8250: microchip: pci1xxxx: Add PCIe Hot reset disable support for Rev C0 and later devices
Date: Thu,  3 Jul 2025 16:39:28 +0200
Message-ID: <20250703144006.232241478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e9c51d4e447dd..4c149db846925 100644
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



