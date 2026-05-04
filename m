Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4783DE42E;
	Mon,  4 May 2026 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903517; cv=none; b=Rk9i6M4a5PAVidfkSSXcHRq2v52OfUWSe/ei+AVpSDOohNKshPmreKzC2LAV5qKWZgfKxx3nMRbOOriE4gVEtQzBw81xrXzf5kErCmlM6TJwlAkz9A8QpPLVccomGY9cDdlXOYctUscviyCZ3KxnKSQdBmIR+7arW0TCZ4NmL3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903517; c=relaxed/simple;
	bh=45B4nQgkZbEtiBjLfP+5b1YXXgfhxdHjf1wDt7+AqVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQwm2qbm3KoayCedwqUK/XBBtV0qJZzOJ9qY2o5k6rbnDPzxQwFD0/Ag8Vn0ws+FM0BlKVZuM+yQKw/+j4SwTqcA+UZKLanJIg7OTvridskQBlqfASWNXDdoNUgTT+9fk4XdHxq2TOQPEYMIWSP7uygoJj/3ZrQ01JwJCsW1sB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwSFNMxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwSFNMxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0812AC2BCC4;
	Mon,  4 May 2026 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903516;
	bh=45B4nQgkZbEtiBjLfP+5b1YXXgfhxdHjf1wDt7+AqVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwSFNMxA9WcnilIEU9ZV11Qf0jkRTKkT3dx4ydhUo7OCzqL0G5S7fwCsJr0gBuMPv
	 24IyDR1DeIE1LNtalxi4oL7CncMdrp4Rq08+4+FxL1N+LKvhaLPTGDwkgggAbCT+Pc
	 48EKcoPy9Vd8Wi2WuojNnQ3joE2sXfBvijj7DEec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 264/307] crypto: atmel-sha204a - Fix error codes in OTP reads
Date: Mon,  4 May 2026 15:52:29 +0200
Message-ID: <20260504135152.745186289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


