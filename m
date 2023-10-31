Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C282031D
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhXoJ82r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C566FC433C9;
	Tue, 31 Oct 2023 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771996;
	bh=DNMHHOvFHOWXJSBvYaweh8aRuLPnjNOivcGOM5LtpKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhXoJ82rTsFewQWev2VbVUAjNkKSaxyazYmQRGem86VKBAyDbdJNFXcA86C4GGcvC
	 KwHG5ryTDHnWbLRGFLUpulWVKXa8j6WQZhQPZuVH/SHkocWUnzuQu9uEuVj36qOfBq
	 lUVptDaV5cCJQNO3wrhaE3gIOhgJwIH/JupGJxhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 68/86] i2c: aspeed: Fix i2c bus hang in slave read
Date: Tue, 31 Oct 2023 18:01:33 +0100
Message-ID: <20231031165920.671772535@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Zhang <zhangjian.3032@bytedance.com>

commit 54f1840ddee9bbdc8dd89fbbfdfa632401244146 upstream.

When the `CONFIG_I2C_SLAVE` option is enabled and the device operates
as a slave, a situation arises where the master sends a START signal
without the accompanying STOP signal. This action results in a
persistent I2C bus timeout. The core issue stems from the fact that
the i2c controller remains in a slave read state without a timeout
mechanism. As a consequence, the bus perpetually experiences timeouts.

In this case, the i2c bus will be reset, but the slave_state reset is
missing.

Fixes: fee465150b45 ("i2c: aspeed: Reset the i2c controller when timeout occurs")
Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Tested-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-aspeed.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-aspeed.c
+++ b/drivers/i2c/busses/i2c-aspeed.c
@@ -749,6 +749,8 @@ static void __aspeed_i2c_reg_slave(struc
 	func_ctrl_reg_val = readl(bus->base + ASPEED_I2C_FUN_CTRL_REG);
 	func_ctrl_reg_val |= ASPEED_I2CD_SLAVE_EN;
 	writel(func_ctrl_reg_val, bus->base + ASPEED_I2C_FUN_CTRL_REG);
+
+	bus->slave_state = ASPEED_I2C_SLAVE_INACTIVE;
 }
 
 static int aspeed_i2c_reg_slave(struct i2c_client *client)
@@ -765,7 +767,6 @@ static int aspeed_i2c_reg_slave(struct i
 	__aspeed_i2c_reg_slave(bus, client->addr);
 
 	bus->slave = client;
-	bus->slave_state = ASPEED_I2C_SLAVE_INACTIVE;
 	spin_unlock_irqrestore(&bus->lock, flags);
 
 	return 0;


