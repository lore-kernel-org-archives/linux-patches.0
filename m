Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCF43DEAC2;
	Mon,  4 May 2026 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904216; cv=none; b=NPcCD3G8yO7v+YcprMGsdvMy9CMTyWoOdBwwcy1bOy5kx52+124nLIrlnQXgqJV6D16Jkq6YLPi0nKnvOIE54MIVC8jLKz4GiDW6yiewwY5pd1ZPOx3hPpSoG/Ez1q7ply9poW7I+UnvR2+GBQ7MzMBtoZbZzU2GPgRxO05sQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904216; c=relaxed/simple;
	bh=wj/Cq7DLEGIGQubolADg9ugqVabSruRR5eHyGIwD07U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am8Gty2DVXNNrkGz11jNirBCELOSoZS9BsM/NP7WdsoTim6h781M28BNwVQEw6lZuacCan2LRSRt+1bviO0a/eGpUvFxu+sy7+7Bg932zDP0sx+/EzTGic+lAMh7+pRZCI5/dqWr0tXDopVCGEGWpdoy5r0sTwWNYLuxavi3qvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZbmTQYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZbmTQYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6245C2BCB8;
	Mon,  4 May 2026 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904216;
	bh=wj/Cq7DLEGIGQubolADg9ugqVabSruRR5eHyGIwD07U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZbmTQYL4wdsACKa2+oraBGvDB0DG5YNwvrHqt6HkSdW46XT8cnDCK4fpJ0HY8A5Q
	 r0j5gCJxGL4p/qdFFlC8ZuQhUiqmCkzBOmVl4fc46UMvvDXUdf01RIherwn/rGUUVF
	 VX7yjxpM+nwQZReVz7/2YtpJppQkzgQWXs+gnFJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 227/275] crypto: atmel-sha204a - Fix error codes in OTP reads
Date: Mon,  4 May 2026 15:52:47 +0200
Message-ID: <20260504135151.495343936@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


