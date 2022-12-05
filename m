Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50415C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB38C433C1;
	Mon,  5 Dec 2022 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268751;
	bh=McP0+briOGhVaJpmew8bbbCbyWwbRHYWfCG/WRYegB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpa0KAd9TvLJaH7JLlHVQfCq6N8j25Pvs6CcS/fEgsqT1jGPEtvXJUvKz3W0yEp3m
	 1qm4ShQocS6HUlivZda9c8NWdq2TyivAxUEdUlRKjbzf8lLNDK1GuqK9H/2IsnZ8eY
	 OmbyDTYqdCxpqsMavc+KCehX+hHX+1ZIokqlqOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 91/92] Input: raydium_ts_i2c - fix memory leak in raydium_i2c_send()
Date: Mon,  5 Dec 2022 20:10:44 +0100
Message-Id: <20221205190806.464625503@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 8c9a59939deb4bfafdc451100c03d1e848b4169b upstream.

There is a kmemleak when test the raydium_i2c_ts with bpf mock device:

  unreferenced object 0xffff88812d3675a0 (size 8):
    comm "python3", pid 349, jiffies 4294741067 (age 95.695s)
    hex dump (first 8 bytes):
      11 0e 10 c0 01 00 04 00                          ........
    backtrace:
      [<0000000068427125>] __kmalloc+0x46/0x1b0
      [<0000000090180f91>] raydium_i2c_send+0xd4/0x2bf [raydium_i2c_ts]
      [<000000006e631aee>] raydium_i2c_initialize.cold+0xbc/0x3e4 [raydium_i2c_ts]
      [<00000000dc6fcf38>] raydium_i2c_probe+0x3cd/0x6bc [raydium_i2c_ts]
      [<00000000a310de16>] i2c_device_probe+0x651/0x680
      [<00000000f5a96bf3>] really_probe+0x17c/0x3f0
      [<00000000096ba499>] __driver_probe_device+0xe3/0x170
      [<00000000c5acb4d9>] driver_probe_device+0x49/0x120
      [<00000000264fe082>] __device_attach_driver+0xf7/0x150
      [<00000000f919423c>] bus_for_each_drv+0x114/0x180
      [<00000000e067feca>] __device_attach+0x1e5/0x2d0
      [<0000000054301fc2>] bus_probe_device+0x126/0x140
      [<00000000aad93b22>] device_add+0x810/0x1130
      [<00000000c086a53f>] i2c_new_client_device+0x352/0x4e0
      [<000000003c2c248c>] of_i2c_register_device+0xf1/0x110
      [<00000000ffec4177>] of_i2c_notify+0x100/0x160
  unreferenced object 0xffff88812d3675c8 (size 8):
    comm "python3", pid 349, jiffies 4294741070 (age 95.692s)
    hex dump (first 8 bytes):
      22 00 36 2d 81 88 ff ff                          ".6-....
    backtrace:
      [<0000000068427125>] __kmalloc+0x46/0x1b0
      [<0000000090180f91>] raydium_i2c_send+0xd4/0x2bf [raydium_i2c_ts]
      [<000000001d5c9620>] raydium_i2c_initialize.cold+0x223/0x3e4 [raydium_i2c_ts]
      [<00000000dc6fcf38>] raydium_i2c_probe+0x3cd/0x6bc [raydium_i2c_ts]
      [<00000000a310de16>] i2c_device_probe+0x651/0x680
      [<00000000f5a96bf3>] really_probe+0x17c/0x3f0
      [<00000000096ba499>] __driver_probe_device+0xe3/0x170
      [<00000000c5acb4d9>] driver_probe_device+0x49/0x120
      [<00000000264fe082>] __device_attach_driver+0xf7/0x150
      [<00000000f919423c>] bus_for_each_drv+0x114/0x180
      [<00000000e067feca>] __device_attach+0x1e5/0x2d0
      [<0000000054301fc2>] bus_probe_device+0x126/0x140
      [<00000000aad93b22>] device_add+0x810/0x1130
      [<00000000c086a53f>] i2c_new_client_device+0x352/0x4e0
      [<000000003c2c248c>] of_i2c_register_device+0xf1/0x110
      [<00000000ffec4177>] of_i2c_notify+0x100/0x160

After BANK_SWITCH command from i2c BUS, no matter success or error
happened, the tx_buf should be freed.

Fixes: 3b384bd6c3f2 ("Input: raydium_ts_i2c - do not split tx transactions")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Link: https://lore.kernel.org/r/20221202103412.2120169-1-zhangxiaoxu5@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/raydium_i2c_ts.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -210,12 +210,14 @@ static int raydium_i2c_send(struct i2c_c
 
 		error = raydium_i2c_xfer(client, addr, xfer, ARRAY_SIZE(xfer));
 		if (likely(!error))
-			return 0;
+			goto out;
 
 		msleep(RM_RETRY_DELAY_MS);
 	} while (++tries < RM_MAX_RETRIES);
 
 	dev_err(&client->dev, "%s failed: %d\n", __func__, error);
+out:
+	kfree(tx_buf);
 	return error;
 }
 


