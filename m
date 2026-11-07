Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065349;
	b=yHcR0HMdVcV1xLqruk9ncVp2gj6n34ASRJoO2mJyTwDJK+nuPSuuwNACF1pfWDEBmG5Y
	 /heeFR/ucA0RsdeBNFvvj40Di41MACwE9gQxI4hOh3QLThxRlZ583FHRnpg1mlHRTQQt6
	 MHnsK+pCdk0rQ0ND452c2j1u1D9TdbJygs8TGK6Dc9WFnSEwCsGq1h7bGeRpWsNzavuRv
	 K3Xh54qEGzLBVJJXWQ6DiW/rDNqgPHoXunqE1ILoM6Mtm5FQhYytHuVadL31GbZupzve8
	 JdlOvcHzCqHrwOASdlu1CtmcxsNYTP8Pj2jIAnlVBoyYuOKL15SfgMQb9phSJHPJtog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUTmN1YJF6hYPha3b9ycf9IiyCxf0e58RB8b5z/dWdw=;
	b=I6IffFHgcYcF7ATJM3kRPJ5vNw6/CNBGtP5e3F7RZY2S0cJmUA8afeY3r1u9evoe3GYO
	 v7NEy6l3DwBgl3NYsWbIOXbnSNbJTqhNPGdzm4aAj/ckE3iWJDkZYWjxWwvv35wYoKt8H
	 nhmC+mqsdf2dlFqJm2EkbmDX/W0SD8sBJTGEhST2+dDL8Wp3IZ91CreTUaasTlUM5l+Rb
	 D80vkDUSV+gwziLZ/liT8c0+natRmgAyj0GplWr2TJjJSOItrwwvESd55MPINfUg3sNVj
	 sxk0eirUWM2BMdrI7UV61qlw9EYXDW8bazWKMJ9frPh8UvIdiL2QWSWF8Bjd9i+Mqug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgBs4gla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D79B606A326;
	Sat,  7 Nov 2026 15:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgBs4gla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17951F0089F;
	Sat,  7 Nov 2026 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065349;
	bh=qUTmN1YJF6hYPha3b9ycf9IiyCxf0e58RB8b5z/dWdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgBs4glaBZiyQgVPXNTqfptGx0Z6GaxpYmXrfjPCuSM9aKZC6Qyd8UyQf25LXbiOF
	 02SYHiqnYb1Z0bpEO2FEzxlNrHP8yPn1HAFvIjnszP62EHV7g27b1YolU994EYNPny
	 yrBOebYloV1QHNlz9BNspo1kD/dItcXTtSxgouQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1036/1257] i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len
Date: Sat,  7 Nov 2026 08:55:32 -0500
Message-ID: <20261107135007.932249926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



