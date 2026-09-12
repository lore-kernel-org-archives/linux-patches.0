Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7053B3F077C;
	Sat, 12 Sep 2026 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197510; cv=none; b=uYDV1bIiyCk8TVNjhuf1F42NAmxYuN/hrMJJgvgeiKvfNVZYrkp2pWORXs+ws4DThxH3Ka5kgIoBrchYJ1WUt2J6iJZ2atTJmsVbnK63CGQe5FsojxJdLJlDeRX6jGLkn4vdj81+XyL8XaPh7aYRjy7OiihzEJdkuUEseh2Yl9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197510; c=relaxed/simple;
	bh=SH7ZMMqjGOswP4ocz+4/EhGQWwnuwtMLTnETwi1jZY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlVCPP06rO4ms4EYORJJv6OhhUaT5WTHNdu5kmUbFvNvAwSdempUG+WlisCX0F86b3gQBtubaE1GhuzaIEt0ACNfXYDeeLjmcWU3+cI6m3ek8hNZA2B9E8Wkln/FW5gbCzMcNVoLzoGOHpGSRwoA9dlBmR2e3Nrsw5iZS7qKXAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS7j4EA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS7j4EA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC3B1F000FF;
	Sat, 12 Sep 2026 07:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197509;
	bh=hfazDdXwSfz+5qnG6gPF+0QhiOKOOtCZK+1v+6MBbNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xS7j4EA+eOSujx8U6hXFRn5JAznwSh91hq0FANmfuVJG2oqWniU40CznamjQp4vxr
	 Nosluzeua50+sGry0RHqY5xSICEnztBmgHUTXbH/OTut1LBa0YePRrOkeUHeN3Qu+v
	 FerlEQ46Rs2EUTF9XDtjzoiFQ4eRRlWWfi2KhggM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0190/1815] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 08:32:20 +0200
Message-ID: <20260912065653.463071410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit f240f9b588f4e2de89822adebf560a96b5d263ed ]

The hardware ECDH path in atmel_ecdh_compute_shared_secret() uses the
private key stored in the device. However, the public key is cached only
after atmel_ecdh_set_secret() successfully generated that private key
for the current tfm.

atmel_ecdh_generate_public_key() already rejects requests when no public
key is cached. Add the same check to atmel_ecdh_compute_shared_secret()
to prevent the device from using a private key that was not generated
for the current tfm.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 4dc34c5bc0f6c..bd1664ad5c0ea 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -165,6 +165,9 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 		return crypto_kpp_compute_shared_secret(req);
 	}
 
+	if (!ctx->public_key)
+		return -EINVAL;
+
 	/* A P-256 public key must contain two 32-byte coordinates */
 	if (req->src_len != ATMEL_ECC_PUBKEY_SIZE)
 		return -EINVAL;
-- 
2.53.0



