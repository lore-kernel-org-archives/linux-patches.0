Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1B847140C;
	Tue, 21 Jul 2026 20:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664468; cv=none; b=BThmonzl54MPk/j65er+bTw9PEd9ms1RntXAbH6u8KJWVsNZFSAnaIlKpm2mcXFp3/y1NE40ji0fIX0bp/Q476c3KQCTle3LCGIKJWEFOKitbyiNi0tR3aAmVAQCbpeRNrwYCa/sIxB/LpLYp8FwGgZg0pgW5vHiohupSVZOVB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664468; c=relaxed/simple;
	bh=Y5m1LGYVAqN3XMJXR2ZJGjAZ7TKY68UScauH3Kx0ssY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHJF3OY4Hg6a96jFqqKlVensHDCHoypHM2JODFBA1IHLaPd2hXmv2RR8NUnx0DvOs50MpDpSTf+PZJC6xEJ6RyKLAXkgtSZqPQgAPktHl/t5ku9Q4/QxJTDcERkjJEQuoUuGfJEJwF4hLcpk6VRNHlQ5uA8IGM/XFzlyZyl0o9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P/huS9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P/huS9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729331F000E9;
	Tue, 21 Jul 2026 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664466;
	bh=yVoAeWATt6RsvziRoUxoaGdwHEgbvXTY0MM2/nCFT10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P/huS9v7qiBbTNrBnonlURDyJdu2o90rtC9ZmChw2lWxpjJKAPFEb0N0brf6q/RA
	 7Ifb209q0VgUpcFOiBVDxo996DG42mW9YexPJgL68W1fEqGvRYPF2ttMRHzsmhfCJX
	 gbJK2dB31YXiPK0V01+FF2F+1Vltzml58jsrhALA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1212/1276] crypto: atmel-sha204a - fail on hwrng registration error in probe path
Date: Tue, 21 Jul 2026 17:27:35 +0200
Message-ID: <20260721152513.190845511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 49e05bb00f2e8168695f7af4d694c39e1423e8a2 ]

Commit 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
overwrote the hwrng registration return value when creating the sysfs
group, which allowed atmel_sha204a_probe() to succeed even if
devm_hwrng_register() failed.

Return immediately when devm_hwrng_register() fails, and report both
hwrng and sysfs registration errors with dev_err(). Adjust the sysfs
error log message for consistency.

Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -183,8 +183,10 @@ static int atmel_sha204a_probe(struct i2
 		i2c_priv->hwrng.quality = *quality;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
-	if (ret)
-		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+	if (ret) {
+		dev_err(&client->dev, "failed to register RNG (%d)\n", ret);
+		return ret;
+	}
 
 	/* otp read out */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
@@ -192,7 +194,7 @@ static int atmel_sha204a_probe(struct i2
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs entry\n");
+		dev_err(&client->dev, "failed to create sysfs group (%d)\n", ret);
 		return ret;
 	}
 


