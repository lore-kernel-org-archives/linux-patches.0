Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034CA3D8129;
	Mon,  4 May 2026 14:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904752; cv=none; b=rHlxlDRPB/QXhMhtsIEvDh0hQhjM82+nKH1kYGn57sIf2/kHBToYiYh4y2spxspW00lVaIrnWrp3Ra9+bxelO3tF4kZjUKe2E0yYsxBMH49BrrsIoF3qm0aUjfXeQtnKxll9Me+VFQoI22pNWz6lYTBNYi12/WPQluetj6rcFTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904752; c=relaxed/simple;
	bh=47nz3tBaNzSYNWIzbFa74kGlBZaHQqLHVUonu3HEM8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKDmyj50ggM5ibyqhodpPmgPm5WXY5a9Br4mIR45du/0FpjLaqcSfaB4Vus8XigZ2frkv/pjnEmOJdOROlZugqU9qy7txxNqR2DGdaoU300mCuD84969VvFEdypp9uWfe+axMV+TGLcRrePDsK2m809zMFtgGYCZATEqNizpSqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPRuQT1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPRuQT1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D195C2BCB8;
	Mon,  4 May 2026 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904751;
	bh=47nz3tBaNzSYNWIzbFa74kGlBZaHQqLHVUonu3HEM8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPRuQT1FJQtioFOEO2jQuksw5xMVnchN6c9QijnPNtgAv4K2X7mOh8+NJCz/SllKl
	 WhwcSL//eJe35BVAZFppfbJvgQU+2qwcAOUIKgeYay3F3wvsrTnS8HbrI8V8hnhvBa
	 bCFItRpX0heJWYq5qz1vtUoNWzQOi2BsGsHGwP6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 160/215] crypto: atmel-sha204a - Fix error codes in OTP reads
Date: Mon,  4 May 2026 15:52:59 +0200
Message-ID: <20260504135136.020561335@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 094c276da6a0d4971c3faae09a36b51d096659b2 upstream.

Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid addresses
instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
accordingly.

In atmel_sha204a_otp_read(), propagate the actual error code from
atmel_i2c_init_read_otp_cmd() instead of -1. Also, return -EIO instead
of -EINVAL when the device is not ready.

Cc: stable@vger.kernel.org
Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-i2c.c     |    4 ++--
 drivers/crypto/atmel-sha204a.c |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -72,8 +72,8 @@ EXPORT_SYMBOL(atmel_i2c_init_read_config
 
 int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr)
 {
-	if (addr < 0 || addr > OTP_ZONE_SIZE)
-		return -1;
+	if (addr >= OTP_ZONE_SIZE / 4)
+		return -EINVAL;
 
 	cmd->word_addr = COMMAND;
 	cmd->opcode = OPCODE_READ;
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -96,9 +96,10 @@ static int atmel_sha204a_rng_read(struct
 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 {
 	struct atmel_i2c_cmd cmd;
-	int ret = -1;
+	int ret;
 
-	if (atmel_i2c_init_read_otp_cmd(&cmd, addr) < 0) {
+	ret = atmel_i2c_init_read_otp_cmd(&cmd, addr);
+	if (ret < 0) {
 		dev_err(&client->dev, "failed, invalid otp address %04X\n",
 			addr);
 		return ret;
@@ -108,7 +109,7 @@ static int atmel_sha204a_otp_read(struct
 
 	if (cmd.data[0] == 0xff) {
 		dev_err(&client->dev, "failed, device not ready\n");
-		return -EINVAL;
+		return -EIO;
 	}
 
 	memcpy(otp, cmd.data+1, 4);


