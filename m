Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625775;
	b=VZGXYkZi/tCpQU/6IrhxYr2xYR0/vmbaaX9qZa+HkpR3cgDjJTtMz6/vvgI+iW6AP4jO
	 CI1PRdn+yHkLtW13q3166XWjTgQ50xzr0AypM6Q+5fM+aX/x8GS+0tfZXTOCHdfW5tU2o
	 +f5LIPHBOmmbyqWRGz2BZP5d04yD27pIM953W99qAremuXEWVTmusTDLXnENjdwuSLarp
	 Iz8z7Pl03YhhvkhBB+zs73LVQncpzuBeDSwkc5nCR8bcQCOe1YONp25MyNh4jLKqORM9K
	 Ic7BBpYmHlPvs/FKAhGZYNP18Bii4WSBPGCpgEDHZys2ON3Y2GLORwr1XdnWxgmNmrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hh69PgAv5G/ihrQ5gQ5QvL/7Lha0j0wkEMnWlhf2ZM=;
	b=OQ9rRXs/6/4w3zUSht4osF4ZFr+JBgfQBqAdDrFW8ycyqfwRW7JiMRtgVdgkU7J0KrGd
	 IIeYtPijCnUgrcx42Pbx/RbzNcTwPmdnq57LSjdqiZIqiLNtMe7BzDtNe1wjW6lNH50/s
	 BbG6uu4JkINH/PMUk/Yyp1dntGrzCbU9D5HQVK4riSk1FgXaC78h2ki3NIrG/fmC4bY2Y
	 i9KRuEYuzcGxzKRXwLq1degqUJWOcIXR5G3dL26Hq725BqshEc7wCzxICJgDeYBrpKl7u
	 tTySMrrn5jdwbB9LwQZpuhWAPhaL5IV01hJShAJI9yHu/7XC8/R/l7hyCUPL+9dbiPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPepGl8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD059606A6B8;
	Wed, 25 Nov 2026 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPepGl8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1353F1F000EB;
	Wed, 25 Nov 2026 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625775;
	bh=+hh69PgAv5G/ihrQ5gQ5QvL/7Lha0j0wkEMnWlhf2ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPepGl8UfvFRrpkrIUN8E9e4Dnkif5dMpMCZoPWowWdcnZ0H/+rs8yrbrC64sBh3o
	 8M8V1fAcWLEEA6FvMwQV6p58qxIUu5MgU9clmtSohsEq+dnsdOSa/HBUg9mpGSFbv1
	 bWM+ERjIQUpRhXSoKeL5e+GhJHfAvUMsuTH1GLUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 628/816] tpm: Check return value of crypto_kpp_set_secret()
Date: Wed, 25 Nov 2026 15:36:16 +0100
Message-ID: <20261125143903.720745023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 8cff8f1c89d33e55c9af82177b14f6f9f6a899fe upstream.

crypto_kpp_set_secret() can fail, for example if the kernel is booted
with fips=1 and the broken-by-design FIPS RNG used for ECC private key
generation doesn't feel like generating random bytes at the moment.
Check for error, cancelling the TPM session creation rather than
proceeding with a zero or uninitialized private key.

Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261025211119.138277-1-ebiggers@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -579,7 +579,9 @@ static int tpm_buf_append_salt(struct tp
 	}
 	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
 	/* this generates a random private key */
-	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	if (rc)
+		goto err_free_kpp;
 
 	/* salt is now the public point of this private key */
 	req = kpp_request_alloc(kpp, GFP_KERNEL);


