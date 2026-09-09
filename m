Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8FD56C643;
	Wed,  9 Sep 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964598; cv=none; b=bY3d7nDOPLV4/uTAI9/pvtV8iSIa2PWC2+kG/PW+2G8BTT1CV+0LlUyELzpfwoS7XTQpp7+XtEhJxeGaS1OuR+EPhkBrNQKNDhnZUmhEaXqaB43PxzAQlh9lSH/BMrLoGnmpt3dPgjDbDxgRFCJBxN2yZSIeQag6N/CjFfyAEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964598; c=relaxed/simple;
	bh=50RI4bZoSTDK/xtpgEYjglSaHsu3EchVhfssJn/2vBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHJGopW8LOVK4B5jE6OPPy6j9hFP5VUFmT8+zTN9Dt2130O8Rb26InBWfpVjz02kPlQXeScVynqnc36/Hq9lZYehOPxbzZCB8v8PYNJr2HTn3CmwWmQ4iUgH7QaUwR1//Uy7pTjZfN11Ng65EbchKqpfg+r64YQDWYtUz4gn14M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDOpxJgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDOpxJgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6881F00A3A;
	Wed,  9 Sep 2026 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964597;
	bh=ek86lw9w8xQq25+wmiaq3neb8Zv2lW9T4COEa+yIbjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDOpxJgF7S5yyFTqllGaT0SNWOACaqcpGZm65A9iktvEndvm3hlCJphcO7OjzuVwl
	 ccT9QZg+cMUlDu2XRkU4tZoEwricB4RXm3iyNKjhaka6934l1oY2ASu/ZeoaibxOJD
	 KKx54daJoGOWLJ4vy7UdysslofG387z2GwoRnep8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/583] crypto: atmel-ecc - avoid stale fallback key after set_secret failure
Date: Wed,  9 Sep 2026 15:42:06 +0200
Message-ID: <20260909134253.261803821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

[ Upstream commit f07a0d251db7606e4792d2610788fbcc7b2c0d12 ]

Clear ->do_fallback before decoding a new ECDH secret and enable it only
after the software fallback accepts a caller-provided private key. This
avoids using a stale fallback key should crypto_kpp_set_secret() fail.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -84,6 +84,7 @@ static int atmel_ecdh_set_secret(struct
 
 	kfree(ctx->public_key);
 	ctx->public_key = NULL;
+	ctx->do_fallback = false;
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(&ctx->client->dev, "crypto_ecdh_decode_key failed\n");
@@ -91,8 +92,9 @@ static int atmel_ecdh_set_secret(struct
 	}
 
 	if (params.key_size) {
-		ctx->do_fallback = true;
-		return crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ret = crypto_kpp_set_secret(ctx->fallback, buf, len);
+		ctx->do_fallback = !ret;
+		return ret;
 	}
 
 	cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
@@ -103,8 +105,6 @@ static int atmel_ecdh_set_secret(struct
 	if (!public_key)
 		goto free_cmd;
 
-	ctx->do_fallback = false;
-
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);


