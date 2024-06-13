Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C57143867;
	Thu, 13 Jun 2024 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278859; cv=none; b=dhE8J/oostBx7LSzbziUtKSeIS9w/nlE++Hqj3BiGI/Ar9jPD2/oY9ZKrBr8FzNoggZsoE01oO9sxLBN2ZEwg24oP9F3wWPxF1xcd0TnzF07Y9zVtlGf+nul2wXCaf2PTJLS4KfzX3pi7YEZFNIAd+uDzNcjrgzXXZCF4U3vckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278859; c=relaxed/simple;
	bh=At9CZgrFdC6qjzsbYSUj9EFJduqbm29yCAv/QNyCew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6ZKxfGWWGNDHV0N9rKW9AboI9ycG92KrvgFoRh4DSSvWW35AlLPyFiUsq4Ya7AeT7ZhMVPpsCuneb8f7Jr0s8Bl3ZhRK6HuifWmHMK2A3U2ipvQbxWrqNnEs56/84KqKDdbQO9ukgowSDvKTreLiaIpVr9tc2pjcWmtSKHNiLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14KFPC2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14KFPC2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA0DC2BBFC;
	Thu, 13 Jun 2024 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278858;
	bh=At9CZgrFdC6qjzsbYSUj9EFJduqbm29yCAv/QNyCew8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14KFPC2OjG5t5xueAASruZ1MMVO/DjbV3EVAeCA7JX3Sm4v23RhWU/vTet29srHpp
	 FC5HzmijfNOSeAEjRibwR88kHCgbCuXRVnS7CFWGhaNMDvY5+WnrMEpILoXHuKcA8b
	 0vDbxT5EnltCxuQm1GQKPTvFkReHmSdE7pAAPLpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/213] serial: max3100: Update uart_driver_registered on driver removal
Date: Thu, 13 Jun 2024 13:32:22 +0200
Message-ID: <20240613113231.635955071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 915d7753eec2f..c1ee88f530334 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -754,13 +754,14 @@ static int max3100_probe(struct spi_device *spi)
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
@@ -846,6 +847,7 @@ static int max3100_remove(struct spi_device *spi)
 		}
 	pr_debug("removing max3100 driver\n");
 	uart_unregister_driver(&max3100_uart_driver);
+	uart_driver_registered = 0;
 
 	mutex_unlock(&max3100s_lock);
 	return 0;
-- 
2.43.0



