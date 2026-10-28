Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208064;
	b=VjblGbjognidQyxa+8bE9wDp/nhqALZ0g5FBzt610vjkPY1pzNW4OvxR+ExdqDooV6TW
	 SB/Od5XViH7KtE1nGinLfpQJ9G9MSvlgCAYSiEznfIojKc6p2zEFiJg4YHNeSP96rhUjj
	 FZsPzMeYwmg/Booa02beOltCJoto/4RlCJo9tAOfw6AuWtOKD3KCtW5szSJdep93kfsgb
	 K6T2Asu1rfHgM99Xqd+8TT3pCV6Td0lGZMkeiLybV/bYhudREX8zCn+2imEHKJe7VcS26
	 cz6J6uGN2BjpDt5H6ZZ+xPLOR2zIsUyE9rkMAaKNOYSZvcpYtK9GttdkKGuDPZCRAuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y+NjBYRbGylQgYyflWqA25vvw5/9RHZBq4fkeRLs3p4=;
	b=EMijGuBCZXvKVuW8lZzVBWAEiVzw0zKleu6Qo8tNkJI/V3ALizlqe16dZ1s+mmdnRNqw
	 MJZDhMlRs/rWM4wNwo7iaI+6WnpIIPXmnk2WXV3rlzWtDw+ob4a+jz086822X8uQ8hGeH
	 dGBIvrSlHNCyh1gdhPcxiudDe3Mk0VOO670BwuOnjIov5l7D+5Qr/gW88i0QzrtoAD8Ds
	 nggI2sFIae7xixWGez/Oo5tg8z4LM0gDvot+5vlbqzd8LyCWYInUD8zqyBSPqa/ToLFDu
	 oruMHEQxYarwh1utxpT1nlILd40/ngUbbHURvfIh9mS+Gqe0L6rFmJi9pCDHqC1yNrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT0uV60U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00665606A31C;
	Wed, 28 Oct 2026 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT0uV60U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163881F01825;
	Wed, 28 Oct 2026 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208063;
	bh=y+NjBYRbGylQgYyflWqA25vvw5/9RHZBq4fkeRLs3p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tT0uV60UuyHK1l7C3Y80KPKgul2CoYEzoGpyEX8oQyA7VCHiNSJAEWKY4kVE9pnL1
	 q+0dhDaBcnw7fsMliIghLHo6zve77Dy6K4hXLC5pNs8yAQLZhBzx8TTpaR9Zk+SHX+
	 59pl/7krpOKhd2xnWLdZPTG5To9OGDIeKrlXoSCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 237/247] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:00:40 +0100
Message-ID: <20261028165953.034178091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -970,8 +970,10 @@ static int trusted_tpm_unseal(struct tru
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


