Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D495830E847;
	Sat, 30 May 2026 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161705; cv=none; b=FoAqxl7VLNVg50rUKZzI8W9EhCS1JJHIJylVDI1yeTNZC/ovFzipkRC08rTdgVPRS3qZ3O2iz6nlnPVtDfAlR3B7J10kr5qDUIR9h2f/aZ+/akJN5Nv42V9Mb3FQ26jR2O4gUMmelbEOWpyFxEy+YiR6IVfLTOjPHhBTR4z/6HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161705; c=relaxed/simple;
	bh=tH/lHhkRbYTIbS0xd2P5ghglVlJdjLT8bSui6ZIWbVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTQ2E9MLgdvypml5v3dLsRoJgM2QwNtjvm/qQMVDYablyH1wGlANLC3SDTGfPIvSkjHQXVGuKkGC5b4ilLFsGBktvdiNtcO3zqMxoeoy8MVOCWgy5xDc33fd/jbf15XpTMJJtl4JrdGz6oBUBy792UpfaOe9uOba0cF3FupVj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owAX/YcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owAX/YcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D381F00893;
	Sat, 30 May 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161704;
	bh=q8vEPTD6u8f0xqW7W4Bf7AgrlVGhVUqMwcslY88TgpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owAX/YcSlckpMueVRDyVbbMGO6Vonr0+YwIAIuYQBa/IOWMdOrR0TDB5a3FvJ9pAF
	 c4bvqMSINq+RffqXAEnukXJcf858sqkshCIs6vRfmtYeeV8WXOKev2G0qS8Fl0DC4G
	 D5dQgoI2+PgKKiWRPOad1M/1SRMsoZoeuvBf7Ljo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 673/969] crypto: sa2ul - Fix AEAD fallback algorithm names
Date: Sat, 30 May 2026 18:03:17 +0200
Message-ID: <20260530160319.076458332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T Pratham <t-pratham@ti.com>

[ Upstream commit 8451ab6ad686ffdcdf9ddadaa446a79ab48e5590 ]

For authenc AEAD algorithms, sa2ul is trying to register very specific
-ce version as a fallback. This causes registration failure on SoCs
which do not have ARMv8-CE enabled/available. Change the fallback
algorithm from the specific driver name to generic algorithm name so
that the kernel can allocate any available fallback.

Fixes: d2c8ac187fc92 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index e7efebf8127f0..2677062d33b8b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1774,13 +1774,13 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha1",
-				"authenc(hmac(sha1-ce),cbc(aes-ce))");
+				"authenc(hmac(sha1),cbc(aes))");
 }
 
 static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha256",
-				"authenc(hmac(sha256-ce),cbc(aes-ce))");
+				"authenc(hmac(sha256),cbc(aes))");
 }
 
 static void sa_exit_tfm_aead(struct crypto_aead *tfm)
-- 
2.53.0



