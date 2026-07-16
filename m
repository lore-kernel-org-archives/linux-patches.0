Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1554B403E82;
	Thu, 16 Jul 2026 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212337; cv=none; b=qNnxLg278KbIPNdp+K6ilKiPut2fPpaY4mO7JPZ2E08naCTvvVEMZC5qS9pO/EuM50rHtbB+HJSaQzlzGDb9lz8tGSeJESRdkSeBr/DWnNp1VA4EBPr9sQTrmkehSBq/0kxIyPe1//eyeISWuS3XUKHSBFYTPPtFZJ7SDlbwZOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212337; c=relaxed/simple;
	bh=Yez3htJtmZ8rwKaEXCkh1jQP3hzWB6eq5xbl3OztTfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXNy+FxmBYzDPBP1EGHIC8TejoW/7TeZ0H/pJiYySOuhyMgLNaRcyamWJTkYNOciTqe/DBXk7ljF/8OuRtiSTrVXluzgGsfPI4afA3SAmXl4MSV65GoglNeFohQr9Lgj+pDhErLjqBooHcokbBeWwqEpqlTEEX5SVaLx/e8B3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5G9u9Ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5G9u9Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA61F00A3E;
	Thu, 16 Jul 2026 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212334;
	bh=zTHJsuUC6bD28a20T+NFLIzwl/Kd3G0NvliZnkA1PVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5G9u9KylGTtraiU2d2jltkH6zeqKppXFU8uKEzVY7t71+lxo0dVE3oAOsEeGAEZu
	 5TflCaVcB2lulbKMp8E3mWvEgUWClgaWlIrYTpjWL2GVLfghK2jfh7cPexQU053ukB
	 uPomSTu/2xjKcZJ1pjb/KAhMcvA5eHLOupn06PAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 281/349] crypto: drbg - Fix the fips_enabled priority boost
Date: Thu, 16 Jul 2026 15:33:35 +0200
Message-ID: <20260716133039.626785824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -2081,7 +2081,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;


