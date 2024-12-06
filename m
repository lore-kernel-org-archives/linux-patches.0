Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DDC32C8B;
	Fri,  6 Dec 2024 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496550; cv=none; b=XQKDrIF2bxGMAikHdC/a28vxAy9p7OFO+s3DHfvYcFW1agiCvkHBt83zY3vJTGDO1ClpLmGZBut1U1Fw1E1RqDvZ+aQCMZvVsfPoUZLTcfROpQQIJHIwzPClPp0wahmhMS5XTlPoBzzxh06DVQLW8o4X7boe48qd56j16VZ/1k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496550; c=relaxed/simple;
	bh=s5/rYCoV2g1bbwLT/gEFrLWcG92teFmWKRr2mvZBQgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIMeagdDDyz1rMRIPQ45D3kYbFqpe5dVg4NNJlMlYftjaEyMCAOX++nGjYTdiBK2IZIYzVGW01ApRONts9aIG779G83zg1kF7AsxWhC9rWkyymkT7j1awT7q7nW7XHEM6iaOXtwfrb96TNEuftSqksIsfVnQ+Ajaw8XjIGlUPJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzq5R0od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzq5R0od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8311BC4CEDC;
	Fri,  6 Dec 2024 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496550;
	bh=s5/rYCoV2g1bbwLT/gEFrLWcG92teFmWKRr2mvZBQgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzq5R0odENIZvX3/gT83VuCEGlHTpdwtR9t850hxFzu9FE2Sr1T2j5pgY8e/Qt3xk
	 ZZ93kNytqlaWLp9zYgHbsQad8raH1AFzKraI5A1xI6WD2Oc63qYjNzYAPrOHPFcysg
	 a+9XaK7kIV7SfToa1mlxoNQH6Tfqz4hZcy0gM+mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/676] serial: sc16is7xx: fix invalid FIFO access with special register set
Date: Fri,  6 Dec 2024 15:27:35 +0100
Message-ID: <20241206143654.765180497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 7d3b793faaab1305994ce568b59d61927235f57b ]

When enabling access to the special register set, Receiver time-out and
RHR interrupts can happen. In this case, the IRQ handler will try to read
from the FIFO thru the RHR register at address 0x00, but address 0x00 is
mapped to DLL register, resulting in erroneous FIFO reading.

Call graph example:
    sc16is7xx_startup(): entry
    sc16is7xx_ms_proc(): entry
    sc16is7xx_set_termios(): entry
    sc16is7xx_set_baud(): DLH/DLL = $009C --> access special register set
    sc16is7xx_port_irq() entry            --> IIR is 0x0C
    sc16is7xx_handle_rx() entry
    sc16is7xx_fifo_read(): --> unable to access FIFO (RHR) because it is
                               mapped to DLL (LCR=LCR_CONF_MODE_A)
    sc16is7xx_set_baud(): exit --> Restore access to general register set

Fix the problem by claiming the efr_lock mutex when accessing the Special
register set.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240723125302.1305372-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Resolve minor conflicts ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7a9924d9b294e..f290fbe21d633 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -545,6 +545,8 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 			      SC16IS7XX_MCR_CLKSEL_BIT,
 			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
+	mutex_lock(&one->efr_lock);
+
 	/* Open the LCR divisors for configuration */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_A);
@@ -558,6 +560,8 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
+	mutex_unlock(&one->efr_lock);
+
 	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
 
-- 
2.43.0



