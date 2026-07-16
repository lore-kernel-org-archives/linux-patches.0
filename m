Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7946A3195EF;
	Thu, 16 Jul 2026 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211268; cv=none; b=gUXrlS0Xhsov1K2P9VV4dgbWbLua/zJuobPUEEMiBjPm2P43z2HT2R8SKx+RTy7mEPsYhmGESxHEEEyRrzlytDNyGGCg8QWeY7Kg0tBTvqATpV5Q98C4DILjCg9qLFXcFG/LXl38BCfR18BftYm7SDBWdLKdWev1gW6kh350AGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211268; c=relaxed/simple;
	bh=n/JB1I+r6hDZeBpDUv/Hps6022SsNUv1xAn2EAWYcqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNH/mpNvoiw05lDZWGT7aHs88CDbDQRLRy5vLAML8mrOgNnjeH1WZD0tfrTzb4GXom5i7HUEsxCI7T7gIXqbppy5pBOKOG7AMew4sPY9M7bi/0thmn9cywdgiVkMWtXTx8Z2nqMZ25YLdjvzcAR5qcWRpPaF19E/EiZ9ep4G+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reDLAN36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reDLAN36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDF71F000E9;
	Thu, 16 Jul 2026 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211267;
	bh=QAYNa690ZnyefrCiV9k6vsoGCU71AZ3a0PeJmNA3ATI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reDLAN36wa9s/RHVlz+y+7BRY1XZrwn67jY+ZCyAEWAaEA2dnAnE35ijiKWB4Lhsj
	 kSL8VIlDPGZkL7j+j8oMjhQ81hVObBHAxo3Lhqq2dc8oXnhlqKPpqbW0G6Pfq+DAvm
	 gh9TCdbwrbYVioQu0kHfYnVfnEONfY2ZC/0ovel8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 362/480] crypto: drbg - Fix the fips_enabled priority boost
Date: Thu, 16 Jul 2026 15:31:49 +0200
Message-ID: <20260716133052.635031681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit a8a1f93080efc83a9ff8452954429ae379e9e614 upstream.

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2082,7 +2082,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;


