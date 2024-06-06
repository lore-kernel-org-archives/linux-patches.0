Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFA51BA860;
	Thu,  6 Jun 2024 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683473; cv=none; b=ZkaF/OTUS5Z6zwdKgqXfqkdzrmYAe8CDMfC8su4jWTs+l7mTJMr4F3vHwKaNloX3WsUMQX4b1a01FjIaZjTLfL3thAOmY9N9ZxvidfVg69kuHUqnhynMLsN3RJ4mfpYtNKAt+1GAmzQXCFW75tWOYkFuQU0cZJZhyLqtw9JCZqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683473; c=relaxed/simple;
	bh=/4ThQOyO2gBJdQVIhzCOJO5MDISBjrUjsHOPx0FB0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B96rnPj/b7CiGXiFxmEKezvltu4wj7LW5Z6HPsTYsrNyDov13eefo8+9AWApV+ehPkcY43bRYMChtA1lX64ElnN4QKKhrBhd/f/rpw3cK+xezghIGAnpqXXklqlpmJSQJVo56bsJvMGR2nKxNutALWwoZw/TAjlzmP/cVJ/aZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wl2ZmFn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wl2ZmFn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20954C2BD10;
	Thu,  6 Jun 2024 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683473;
	bh=/4ThQOyO2gBJdQVIhzCOJO5MDISBjrUjsHOPx0FB0HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wl2ZmFn+LEI9MLdr2/gYfOBaP0LkVq7nj9v5j5Fx4eMVhLKaCtoXkz9qhLrBL3iJ6
	 DtLYJhx2y3wHFmoCaiBU1f7ffBOdMPuqqo1qtYjgKYBRBNsi/X0Rl0o9hrVVpV445J
	 Ls/00NXzDKdnPKXyVew6HEjJNTGBCjn0gh1Y6jYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 416/744] serial: max3100: Update uart_driver_registered on driver removal
Date: Thu,  6 Jun 2024 16:01:28 +0200
Message-ID: <20240606131745.816736500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45022f2909f0a..b3e63b6a402e1 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -749,13 +749,14 @@ static int max3100_probe(struct spi_device *spi)
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
@@ -841,6 +842,7 @@ static void max3100_remove(struct spi_device *spi)
 		}
 	pr_debug("removing max3100 driver\n");
 	uart_unregister_driver(&max3100_uart_driver);
+	uart_driver_registered = 0;
 
 	mutex_unlock(&max3100s_lock);
 }
-- 
2.43.0



