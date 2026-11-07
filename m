Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063621;
	b=iO5PKUVTTuTbd6Nj6RLAUhZ4VQ1GimYu0HcalRF6ybXxABsKYoabMbMBV969j07Ec9j0
	 AesbKo5RMO5lmdLwAZuiskYM+QgjoHQk1ec8fKFI2L2DLLoJO7O1zKnHoN0/wCJSDcZmc
	 Xh39mnjKeSwjwmdXvjw5zQKW2wI65+ESFUpaGjvuOa4+El2NoLSmPXtln3q76yKp3pgQn
	 p7PgnU/3fMgGNx8aiq7zYWfCHyeT+KivYzA114ESd09e/Z+qAU9fJbHcJ5XwfYU8HsPWO
	 RZk517lF2b7898L8ChHba8bt3RdDs/+uMsHJzxeXOw+59U1mCuSZQvjWJowpr3OVK/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HNZeKscwB/BtbLFMH+moNds+bX4Q6CJcIaI6b8vrXHE=;
	b=c23Jcq5mLLI+eQjY/g55ZD0b7KUnx3/IH3KI5TdWSSg+Oqi9y245PMRYo4lSM0cIxE/l
	 ktaWkSYW5b6D4WoZpGKKQTvgdEeuA34UCUMyQJbS8QQqoQaSEamoozzFbqV9UNXN0ZnGF
	 xvHZrrlzaUS+O9UxRhHbPL25ZFWY3dc1FiUKSRXCR/zinmr2nJ6CauNWVwMBRMXzea71w
	 lJYqhWON3qcI/mBCIBhJUNlBQyd6hnp39hVks9LvhszIxofvHb1Gqs3NWi6R7oOQ172un
	 NPW7BdUkzu3i1ImiHJ41vkudsq960aVtNKe3YALuNMYL3NLIvUk3zV2Pzo41StSoNTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXNGTN2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E310C606EE9F;
	Sat,  7 Nov 2026 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXNGTN2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5491F0089F;
	Sat,  7 Nov 2026 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063620;
	bh=HNZeKscwB/BtbLFMH+moNds+bX4Q6CJcIaI6b8vrXHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXNGTN2xoIbPPzw52b6ZIeG1oYrNCp1H54bBWMNnwPwmrrztVg+6T9GfNbuhV6Z1d
	 WRwmkvWx2jEX/of0Npse1MBWP28Nxcb6K2pcypmnoMeO6Ct4YmdZIyRJDDyXCL6MkO
	 EByQe6Jx2vqUkyeXjTbpYChZCJyiG6xG/Nk7LEPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 723/869] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Sat,  7 Nov 2026 08:56:45 -0500
Message-ID: <20261107134917.331919762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit b7fd977fec0d3f2bdd4f13bb59949c817a365652 ]

When a page_len is less than 5 bytes in mtk_i2c_xfer, uninitialized kernel
stack data is copied and written to REG_SM0D1_REG. Equally on the read
part, an unnecessary read is done.

Guard these extra copy/write and read for the page_len to fix leaking
uninitialized stack memory.

Fixes: d04913ec5f89 ("i2c: mt7621: Add MediaTek MT7621/7628/7688 I2C driver")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261022193853.670625-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt7621.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt7621.c b/drivers/i2c/busses/i2c-mt7621.c
index 0a288c998419b..9ea5e3f9a7632 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -144,7 +144,6 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	u16 addr;
 	int i, j, ret, len, page_len;
 	u32 cmd;
-	u32 data[2];
 
 	i2c = i2c_get_adapdata(adap);
 
@@ -186,6 +185,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 		/* transfer data */
 		for (len = pmsg->len, j = 0; len > 0; len -= 8, j += 8) {
+			u32 data[2] = { };
+
 			page_len = (len >= 8) ? 8 : len;
 
 			if (pmsg->flags & I2C_M_RD) {
@@ -194,7 +195,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			} else {
 				memcpy(data, &pmsg->buf[j], page_len);
 				iowrite32(data[0], i2c->base + REG_SM0D0_REG);
-				iowrite32(data[1], i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					iowrite32(data[1], i2c->base + REG_SM0D1_REG);
 				cmd = SM0CTL1_WRITE;
 			}
 
@@ -204,7 +206,8 @@ static int mtk_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 			if (pmsg->flags & I2C_M_RD) {
 				data[0] = ioread32(i2c->base + REG_SM0D0_REG);
-				data[1] = ioread32(i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					data[1] = ioread32(i2c->base + REG_SM0D1_REG);
 				memcpy(&pmsg->buf[j], data, page_len);
 			} else {
 				if (!(pmsg->flags & I2C_M_IGNORE_NAK)) {
-- 
2.53.0



