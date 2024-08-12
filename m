Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA101494B8;
	Mon, 12 Aug 2024 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480490; cv=none; b=Lb9eIoqX1pXU0UTtXO6uX0CF0HNTkMBRK53cCvxkObomij7GKEIWfE/jb9AoD+w9iA37lyR/UZ/bNK0vCYh4lsO0wemRN9txdJTthCGSk2uz8+kJZcn8PJGZFrrbMkdvDhJ6e6KkJ+5/FG8tndR0Sm9K4R6Gbl9HnVdFdsH3hTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480490; c=relaxed/simple;
	bh=KDkJEUCnXegMVRNJrVYrmc8w6YuNGkpMxMJ28XQiouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyuRkJ9YfQwrg/DtR49XArY1zOeT2wPadaKhUxbPW4w2uKW55vZwmQ2NEHi5VhbxAnqfZjPZl+SL6e+/JHlVbhP6CnHxx73eCDTWcxqwhWVWDL7zcDq4DrLLMBWYmEhR9agtNzM9HHpljMhVqbFiKMZoSD/WeRyXY8FKMP5Bngo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xD/K/e5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xD/K/e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72EC32782;
	Mon, 12 Aug 2024 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480489;
	bh=KDkJEUCnXegMVRNJrVYrmc8w6YuNGkpMxMJ28XQiouI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xD/K/e5g+jD8934IUSacYrYc46ctiYz34EQNSVL6KFux6LgHdEee1pzZ5anRh/qA
	 8IxeSj5NPcr3LauZOuETCGbJWMSFjYXct9bxbb6REm3/IgAjp1KhZ0g1eSyIHyDNKS
	 WMnvMkKVLjpLYMG93QCMKz+xcR7CyCIm5Earm9KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.10 211/263] serial: sc16is7xx: fix invalid FIFO access with special register set
Date: Mon, 12 Aug 2024 18:03:32 +0200
Message-ID: <20240812160154.622175193@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 7d3b793faaab1305994ce568b59d61927235f57b upstream.

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
---
 drivers/tty/serial/sc16is7xx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -591,6 +591,8 @@ static int sc16is7xx_set_baud(struct uar
 			      SC16IS7XX_MCR_CLKSEL_BIT,
 			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
+	mutex_lock(&one->efr_lock);
+
 	/* Backup LCR and access special register set (DLL/DLH) */
 	lcr = sc16is7xx_port_read(port, SC16IS7XX_LCR_REG);
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
@@ -605,6 +607,8 @@ static int sc16is7xx_set_baud(struct uar
 	/* Restore LCR and access to general register set */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
+	mutex_unlock(&one->efr_lock);
+
 	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
 


