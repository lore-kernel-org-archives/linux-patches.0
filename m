Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138FD26AEC;
	Tue, 26 Aug 2025 11:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207836; cv=none; b=fpnK1DcmPgOiIJQ9ciEDGjTJxzvc1Lqr6L/ca87z5LZnW1xfLAV0kb8bL5cguZLRxo3fuPqZ8Mi6szWoryMSa7JyA57YD4QbaHC3vrOMM718FoP8W/1hRbzutbmi4kOOG3TxfXN822ny+Nl/60E0l6HwwDT0m99kKQdIg+gSXmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207836; c=relaxed/simple;
	bh=9dy4drRjTMvctO3a2zUNH5lQa5jGAeNBKUl5c84UyY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbtoMEF/uJnGTY/NCS9I2TSeS6sYJVg/L81Sh0HagCK8UhPkSKYzXMVm9Nakdif9VXD+EuBAAw9fjHrBr37W9HNGweVFhhGJJqU+SF1HkM5NV3QTUFTpnpeXOL0/1Gvhjn9FOQeM1TN786yB2MdkoZW9nxPkGF4xmYDb+5EGn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4S/cf6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4S/cf6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95951C4CEF1;
	Tue, 26 Aug 2025 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207835;
	bh=9dy4drRjTMvctO3a2zUNH5lQa5jGAeNBKUl5c84UyY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4S/cf6lyf6t15eEYNkUOLBrS2U+RmDdnjc0tmQm2nTy89CV5Q4Stm5A894jt7QQV
	 l3c2+3GhaWXSfnGNnlNFnB3fKjZq6e4bC2oO4AdTXq+OlrgAGBzc/93sXjYL/e7AZ1
	 TG9ANfHtBlkphtFvAhV+jHnSxVdja3t8fto6W0u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 335/457] i2c: rtl9300: Increase timeout for transfer polling
Date: Tue, 26 Aug 2025 13:10:19 +0200
Message-ID: <20250826110945.614488542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ceee7776c010c5f09d30985c9e5223b363a6172a upstream.

The timeout for transfers was only set to 2ms. Because of this relatively
low limit, 12-byte read operations to the frontend MCU of a RTL8239 POE PSE
chip cluster was consistently resulting in a timeout.

The original OpenWrt downstream driver [1] was not using any timeout limit
at all. This is also possible by setting the timeout_us parameter of
regmap_read_poll_timeout() to 0. But since the driver currently implements
the ETIMEDOUT error, it is more sensible to increase the timeout in such a
way that communication with the (quite common) Realtek I2C-connected POE
management solution is possible.

[1] https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/realtek/files-6.12/drivers/i2c/busses/i2c-rtl9300.c;h=c4d973195ef39dc56d6207e665d279745525fcac#l202

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: <stable@vger.kernel.org> # v6.13+
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250810-i2c-rtl9300-multi-byte-v5-3-cd9dca0db722@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rtl9300.c b/drivers/i2c/busses/i2c-rtl9300.c
index 4a538b266080..4a282d57e2c1 100644
--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -175,7 +175,7 @@ static int rtl9300_i2c_execute_xfer(struct rtl9300_i2c *i2c, char read_write,
 		return ret;
 
 	ret = regmap_read_poll_timeout(i2c->regmap, i2c->reg_base + RTL9300_I2C_MST_CTRL1,
-				       val, !(val & RTL9300_I2C_MST_CTRL1_I2C_TRIG), 100, 2000);
+				       val, !(val & RTL9300_I2C_MST_CTRL1_I2C_TRIG), 100, 100000);
 	if (ret)
 		return ret;
 
-- 
2.50.1



