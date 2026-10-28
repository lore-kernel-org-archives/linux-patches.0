Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207355;
	b=GwUiNoMcT2ZPDGZEo6s46edhVxfKHiXNlVMW+n1tJ2lPp/Do5hevJmi7HUnml5wQFn6S
	 ZDWjVzbkDd9dhgeGo9bMpx9aQDH2mL8G3/VMp/fslHtuCEFCtlOJN9eBQCK1VAhqk/ZEt
	 Zx4E1UHAQUTOn+iD0667VIu/9MHPKsP1bdbbCJa1Y6IrzCaxrEzW3iqQU61Xv8o8UCQzX
	 6AWg1JN9BWSh0BGCbfSQgu+QjrQJjjcGFk6XrEijys8ZW6aOSOeJf2dP656uVaOE6nGvz
	 KOU3ecaQpS9NMLGm7OB8ensopjPJ1jSv8/9kD0kh1Q1PYFy5hr1RVVR7qAwkRZWfHaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wvb6Btui1/B24hFBc9fW+jHar4YfgNFbFTOWaAV8CEI=;
	b=3pjPTtZNkgxq6MO7oKdZtTyVlB3J6646YlTTp+CLyg6iQcgjRHzdW4kt6m4tiM/QFKcA
	 mxSNzA4JxkoTuzR7sP8KGSmqMjQyYjqRaXvJiHg3Veo0xxktmnFEzDsOOlP0jiiRVaLIR
	 MzK9NjWzdVBhX3DjVv1/xLfcYMLzk9NR/LyYpQ7xg9BckP5vcwUTmXOzk6S2sqLHDsyvw
	 gIYdqc31H2b01L1YlkczbG6WZt1p4DEzahvWdNn/ysIUgrpfP8jWLL7utStpUSHMh91Jc
	 XVjdJ5Ww186WBq96TvRKt+SWpjSgRfjAnfvE5nSigG8GQZdgMPjFPV+ocD3moxLxudA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbXXLy72;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B171A606A31A;
	Wed, 28 Oct 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dbXXLy72
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A61F031E4;
	Wed, 28 Oct 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207354;
	bh=wvb6Btui1/B24hFBc9fW+jHar4YfgNFbFTOWaAV8CEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbXXLy72QSvqrWFbzHG2ywJ3w0OjEgttghCiURfm/CanzdIovCXmgcNbCm7ISexDR
	 YKrg2UZr5SW/bFOped1OR/jyfrbVMXKGmfnv9PPERW077Mhgor1lmeFTxZOo5NNLdR
	 u8tei6GzMMW8VSJio2L7y2dnE7H0AIhi4Wiz/f5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 77/88] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028165943.927383315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

commit f92d0ccb05bf9089072cb067dda0dffd5394c4ef upstream.

trusted_tpm_unseal() proceeds to pcrlock() when the TPM unseal operation
fails. If pcrlock() succeeds, its return value overwrites the unseal error,
causing key instantiation to succeed.

Return immediately when unseal fails to preserve the original error.

Cc: stable@vger.kernel.org # v5.15+
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260912062950.279104-2-ssrish@linux.ibm.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -928,8 +928,10 @@ static int trusted_tpm_unseal(struct tru
 		ret = tpm2_unseal_trusted(chip, p, options);
 	else
 		ret = key_unseal(p, options);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_info("key_unseal failed (%d)\n", ret);
+		goto out;
+	}
 
 	if (options->pcrlock) {
 		ret = pcrlock(options->pcrlock);


