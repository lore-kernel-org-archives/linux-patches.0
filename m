Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062979;
	b=ApBr/csUpW9vJ12fCpda6IQWjAoH/vpvz0klAbOPKch2d1VVp6VRNNvBAPLN6cQ4YNF6
	 RKk0VXkW/nDSm5C/qo22dy6v6Mg2WiJY26m31M8bqIqfOLunOX+g2CM3FF9iWZcL/CVQ/
	 3b+estkK+Gof0MAAqg/w8mj6J3JirRa2cfTE/Mk7wzbd9WvqKJ7ThoJa4nuzvg7WjZRFQ
	 Typ5DGo8yC7cE6UPEefR5+1vQUJOt55yS107dZvRPwCNdGdrVirHPDodEAF05fIGncuwh
	 5g6hRgDzlU3Em6ne1K6a178wqtLBlE0OiUKNTroEGbVOzOq8yDZyOiMmOtkmIIxB9AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/dewe3QzfImDF5CBq3NGcm2kiSDeAnmiRlrDXwymA5Q=;
	b=Zj7/H2xYpc9sh94mC9IhlZxdpewtSZrB3Zoo87zwhdkpUesTkUPo1zNN+ARI3TOB35tW
	 ZhCq9Zrqyx6/SY9oDCRo5M+Uyla95Zmw70OCiYnh0bPfSuDbAvPW+a+iQHtcKMC3lAp64
	 WsQuIekxfW0ILpQLw4jraDdwzcgtXENRyHpmDJral06Chj4ScJkt2LDLRueAeO6cw8mcv
	 TbW2DCdbFe6FffJNyH6eYdv+r2zL8siPwLqwLyyMtRcTdcHKvwPFQ0rmOenipq2KLFrUS
	 5eES2xipt/gCYerW2EQXYgNs7XV+cf2IPuoFoKRbjS/RshPFozmuYgsAmkCu/9LdzYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqX1LZGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7845F606A32C;
	Sat,  7 Nov 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqX1LZGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264831F0089F;
	Sat,  7 Nov 2026 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062979;
	bh=/dewe3QzfImDF5CBq3NGcm2kiSDeAnmiRlrDXwymA5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqX1LZGW9wp/JNgMSkJqrxTBGS/MTSum1JwDt4XdWsFw4/5ahUr3R2fU/aCMnLKop
	 CQpXaDVpIYSikk5c8cizZy6QaTAHEs3Zea3hixVf7Qr4Loo/XdJLgfQzrl+lQ/eApu
	 40KtKpzYly8d55S2sVOaeogxGC1wkwJKINTe9TOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/869] hwmon: (lm95245) Fix negative temperature conversion
Date: Sat,  7 Nov 2026 08:48:42 -0500
Message-ID: <20261107134859.963382529@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit f58c16056f8585ebafb0f1f5d90c23085443a4b9 ]

temp_from_reg_signed() uses only the high byte when the sign bit is set
and drops the fractional bits in the low byte. Writing -500 to
temp2_offset stores 0xff80 (-0.5 degrees C) in the offset registers,
but reading temp2_offset back returns -1000.

Negative temp1_input and temp2_input values are rounded down to the
next whole degree the same way. The chip reports -0.125 degrees C as
0xffe0, which the driver returns as -1000.

Treat the register pair as a single 16-bit two's complement value.

Fixes: fffd80ccc1e6 ("hwmon: LM95245 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260923172551.1593798-1-khurana.ridham222@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm95245.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index 3bdc305308479..9c977d2820f9c 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -98,9 +98,9 @@ static int temp_from_reg_unsigned(u8 val_h, u8 val_l)
 
 static int temp_from_reg_signed(u8 val_h, u8 val_l)
 {
-	if (val_h & 0x80)
-		return (val_h - 0x100) * 1000;
-	return temp_from_reg_unsigned(val_h, val_l);
+	s16 val_hl = (val_h << 8) | val_l;
+
+	return val_hl * 1000 / 256;
 }
 
 static int lm95245_read_conversion_rate(struct lm95245_data *data)
-- 
2.53.0



