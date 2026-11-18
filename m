Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036974;
	b=OesIFJtQPLm8B/2e0Ym3TwQ7IHRuzJ+/yo+rSL/hsL8PAcJlcIdx2RjFSriRCfSu6FSZ
	 8jpzpzo3Xo3DW+Txq+l52eaw5SRilVC8h5/Hivd2WDDB8VFAFfLD8YM99mKeG2IFN98PC
	 zQQjf0FOJgrLfPw3Wdc2F0J2D8dGglm7QK1FK7XbtQaGsC2S6wfji3JMdl8uFCV+UIAMu
	 vB8OaHVeNHj2LegM1m9E5WJq74gDItSHAeafTZb5r4xVgvJVK8iD5YZ5Ln0EUjmzDaEg5
	 llbpT0sCfLm16Dam8yGC6eecXE8SVJYu/5OOQTPJArLvCXoouk89nW0GUqbDMGLsAAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGBs+P2C8400TQdlN6tyd9yyK+AfA5lZl+BqNllbjdM=;
	b=lp1r5Bs93B1ZzNF5wr3/KhS767QDavJFMc/R5k3nzGFY8AfXUquCv+Il+vKiCLhM3U4U
	 Rxt7gIT1gP2f6yhQN4PRR6twM7Ei7nMRRbLDFGIWJZ1sF2FQUaGJzgLA6IbhHm+aKbR7D
	 VRCVN8hOLwlgNewluGxKikOCnsieYXLledtoPwMBxCgurCkqYNOsynEb6l9iurIhMxSy3
	 sczid9qkQ7l5fdqumcpx1wCXk6lnZBSmNB+4bVeZIMoP0DMrgsaHz3yC6bKmagghx2F9a
	 hnKh9CKewXaNWzYftJSlFXws6cvbaDbHdsp6O1Q4+hYH+anFQXJxMVKqoo0SMRK5Geg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylD7Xn6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7392D606A31C;
	Wed, 18 Nov 2026 21:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylD7Xn6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1CF1F000C4;
	Wed, 18 Nov 2026 21:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036974;
	bh=CGBs+P2C8400TQdlN6tyd9yyK+AfA5lZl+BqNllbjdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylD7Xn6ZeKGITQPFuKgYYjVyRjzasY83/Fjh0/AvUNB43+zEScBpHekrmn5RnTcmU
	 yp/Sxhh2rFiUP9FvTmFW62r42JHT+eRnpARqFeakgMxs/DVszTMiB7nhJd+Dib7LY+
	 F41yo8EQHnjuAgb4tlT+lkOGNjIsAYmC4NqtMBIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1206/3318] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Wed, 18 Nov 2026 15:30:28 +0100
Message-ID: <20261118150356.350177121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 81d46169bc1f9..0d0c58384663d 100644
--- a/drivers/i2c/busses/i2c-mt7621.c
+++ b/drivers/i2c/busses/i2c-mt7621.c
@@ -144,7 +144,6 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	u16 addr;
 	int i, j, ret, len, page_len;
 	u32 cmd;
-	u32 data[2];
 
 	i2c = i2c_get_adapdata(adap);
 
@@ -190,6 +189,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
 		/* transfer data */
 		for (len = pmsg->len, j = 0; len > 0; len -= 8, j += 8) {
+			u32 data[2] = { };
+
 			page_len = (len >= 8) ? 8 : len;
 
 			if (pmsg->flags & I2C_M_RD) {
@@ -198,7 +199,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 			} else {
 				memcpy(data, &pmsg->buf[j], page_len);
 				iowrite32(data[0], i2c->base + REG_SM0D0_REG);
-				iowrite32(data[1], i2c->base + REG_SM0D1_REG);
+				if (page_len > 4)
+					iowrite32(data[1], i2c->base + REG_SM0D1_REG);
 				cmd = SM0CTL1_WRITE;
 			}
 
@@ -208,7 +210,8 @@ static int mtk_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 
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



