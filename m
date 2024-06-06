Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664B5198A3B;
	Thu,  6 Jun 2024 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683408; cv=none; b=Y1yh+XQFCMQi7hVPXWuzExNb/MHpwsiGmXW7zOr1D0pgPP6sIn/Dg+Qr6+YhkoqvEC3PhLt1Bu7DZ8sQy0eMgjrIwNyYYvJhLoQMS+NB6zrMukPG/xK4YVooSI0bIULY2kAltfH8LnAoHdeL3ZLLc4HVnA/muZDuFcfYHn5beCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683408; c=relaxed/simple;
	bh=U/T+lo9ZN/r9q8cYwuRFMQ+9EXqLwqeik2W9ThzV+5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIliiRd9D525lhZ2gUyStqkTfQ7ovSbIOjyQYP3lZSFZOqyuxcpI1AH8ErvqhN4JmGpj1RsTHuv8quN5oONGuBVjVWMkkJLQ6m3UZHNP+oQlqpq33egomJZhLD3rzLJ0h6MoO4msiUJJ4vrlWScr3vbZbkrVGHU0o8xwznRxQeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qx9puoIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qx9puoIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46570C32782;
	Thu,  6 Jun 2024 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683408;
	bh=U/T+lo9ZN/r9q8cYwuRFMQ+9EXqLwqeik2W9ThzV+5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx9puoIRGE+RZNpeJP/ZvnyZ4VfQJuo8w5sSUJPczuO60FnfzF0Of250X0SRDlAIl
	 JjVRgkFYzMtfZVIPwd0nmh7pGppyt0s4jXYaKtXGNXaGtxvjpEg0tUU8NJfJa7lDG5
	 oL0Xa0BksAbZwG6MViE9dRGPjumOWCGcFj76iEO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/473] serial: max3100: Update uart_driver_registered on driver removal
Date: Thu,  6 Jun 2024 16:03:40 +0200
Message-ID: <20240606131709.503682016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 712a1fcb38dc7cac6da63ee79a88708fbf9c45ec ]

The removal of the last MAX3100 device triggers the removal of
the driver. However, code doesn't update the respective global
variable and after insmod — rmmod — insmod cycle the kernel
oopses:

  max3100 spi-PRP0001:01: max3100_probe: adding port 0
  BUG: kernel NULL pointer dereference, address: 0000000000000408
  ...
  RIP: 0010:serial_core_register_port+0xa0/0x840
  ...
   max3100_probe+0x1b6/0x280 [max3100]
   spi_probe+0x8d/0xb0

Update the actual state so next time UART driver will be registered
again.

Hugo also noticed, that the error path in the probe also affected
by having the variable set, and not cleared. Instead of clearing it
move the assignment after the successfull uart_register_driver() call.

Fixes: 7831d56b0a35 ("tty: MAX3100")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240402195306.269276-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 1c4a2b1b1f690..b71676e1f612f 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -750,13 +750,14 @@ static int max3100_probe(struct spi_device *spi)
 	mutex_lock(&max3100s_lock);
 
 	if (!uart_driver_registered) {
-		uart_driver_registered = 1;
 		retval = uart_register_driver(&max3100_uart_driver);
 		if (retval) {
 			printk(KERN_ERR "Couldn't register max3100 uart driver\n");
 			mutex_unlock(&max3100s_lock);
 			return retval;
 		}
+
+		uart_driver_registered = 1;
 	}
 
 	for (i = 0; i < MAX_MAX3100; i++)
@@ -842,6 +843,7 @@ static void max3100_remove(struct spi_device *spi)
 		}
 	pr_debug("removing max3100 driver\n");
 	uart_unregister_driver(&max3100_uart_driver);
+	uart_driver_registered = 0;
 
 	mutex_unlock(&max3100s_lock);
 }
-- 
2.43.0



