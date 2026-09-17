Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF263B776A;
	Thu, 17 Sep 2026 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663911; cv=none; b=LFbXguoHfvGr2Bg5YjMCQJtJNV1IW9+Yk3UMLqE7ws/bx2AiK6gywajrd7gH/43fMuT+BimeDr7PbTlx8iQIEwK+PW5oyMudYDKGmesel5BnvU6mvae0yli3+3rnmD3nkssvLVgGLxhp1RGIIh4X2NZd3nGEgl7KTMna6XXAjUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663911; c=relaxed/simple;
	bh=N259yJ+5u2109oEDT9V3x4PeyboWiGHOZ53H7vhWqgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l68W0cP5XloKgmRW5SU4FKQojSQFGUHUabzSsXsNKzY/dDlCegOMB+Smrc6+GxLKIxAXxHPSGBE4WoVf9K7elh5R9tsXtydmheeYGRlw2AOsCN5di129tSNX0n/1qDiL0+GzAXmVh1VCKZ9NNxmXrZSFzAWDm30DK7FO4anMIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR+ikUgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR+ikUgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA51F000FF;
	Thu, 17 Sep 2026 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663909;
	bh=61dMd2cwIF5nekUYJnLe2BS8pCAmtBKE6iAjnwslwlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gR+ikUgD956FftfGJoX9kUM4fqxVtSQ6oS66z4icBFx65yKEMUyL7z5pRypVH0kce
	 +0ElMEg24zJ8xnIb3YCW//vnd8MnZwdOcCT149+FykYqTJBK1ycDkZ0ezqGx6WhRgA
	 qrTR08vyC0pUcq03nZBkZbqIPyTY8wvtYtRCZFEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0195/1250] crypto: atmel-sha204a - remove sysfs group before hwrng
Date: Thu, 17 Sep 2026 15:59:50 +0100
Message-ID: <20260917151557.402605439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit d58b4a09d7f06750a706b70d068f5a678dad8233 ]

atmel_sha204a_probe() registers the hwrng before creating the sysfs
group. Mirror this order in atmel_sha204a_remove() by removing the sysfs
group before unregistering the hwrng.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index d2031abbd8efa..3e52e604ded39 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -209,11 +209,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
-
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-- 
2.53.0



