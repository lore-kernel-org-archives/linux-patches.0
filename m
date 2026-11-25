Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623141;
	b=OJu1alf0ARL24dash2fA7Q81wHzZyU1Kvu0V5k7m7J4By2+4qQOVf11x8M8vWqwCsu1q
	 ge8zQm8v/+E5H19a3pEOVNTcFtkgkCR4QoXCig69ebz5e4P1wWexD6Ty3bZkhPC55TSBA
	 Mv/qnvu6HLwj+EFLG/fVwJ+z2Dl6lmheyy8OrEl2HZCVzVMYyQrIIrHiPOWPzRTj5+GhJ
	 XiJn9w7Wp96oeaThZPG99RMuKSQinexn2eBKS7LupBguDhvNxBhiloUHkYf51ZTmXsu/H
	 mznmGPKRhtOfeFP1i6tujKIFxVTOv2B2SblkoQ19N7gqKW2yJkDoxzzWd67dHvs4RrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K17lgwMv1Goqo2aQqCKBjtPKnjeQ4q+F8c/F98zwvGQ=;
	b=wTAmnMXRv3fpNV0po1lpJT1h/dnoqbbovSlGFsP+P+rNlVV2hZ8BkB1jiQePGLbKdcYW
	 8JSnWE1Ca7lqh0H+Y+LYGc1QjGoz8W9wAdq4Dko/j+ZD2J1U0RIlKMhGxxDxqpzbIql+6
	 gMvXO1PJ6d8OCyQOAxk75qsWAk8OgmJsvRlZK0v3mpnHDPUFW7II3wEajJ/ZS3jI2sLw0
	 z8WDt5CxcLCq1+cUISyzNUyafaqKDLYUHGTfRL7bVH0lr0/KsSDaKeA/5BrB6/aLaDPVY
	 H7HB8b4q+YW7wpo4EMwmkUTG+o+o+XhE/uPasWLne692N+5doBAga7rc5iRwsNcxmZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJlXXIxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60812606A31E;
	Wed, 25 Nov 2026 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJlXXIxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316111F000C0;
	Wed, 25 Nov 2026 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623140;
	bh=K17lgwMv1Goqo2aQqCKBjtPKnjeQ4q+F8c/F98zwvGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJlXXIxjdcb6bSf8Hp485VhIGZwc/dq1bRoD0tGWMQ+ppMmo8DD4T1MXFv/pLRbMF
	 I1Ki766PFn0tmz26tfe2USxVZv9p/XBt5Bku0TFhoTWfDZOoUBVji5LcmkSZOgBOZG
	 IGYj6haL5icUaCJoIH6/xxJzcacLF3hDqXSPjxQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 764/990] tpm: Check return value of crypto_kpp_set_secret()
Date: Wed, 25 Nov 2026 15:35:31 +0100
Message-ID: <20261125143839.950220483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -535,7 +535,9 @@ static int tpm_buf_append_salt(struct tp
 	}
 	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
 	/* this generates a random private key */
-	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
+	if (rc)
+		goto err_free_kpp;
 
 	/* salt is now the public point of this private key */
 	req = kpp_request_alloc(kpp, GFP_KERNEL);


