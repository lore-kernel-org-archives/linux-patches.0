Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09E3CFF51;
	Thu, 17 Sep 2026 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666464; cv=none; b=l2kIBcb+MNW8tNxZ+g8uJ+rhT5jVs1JkSXN54qG/mMS74L8McTqjJPM6FhvdyutbAb9a60inpJGi8M9AixIVZHtgnAh+kp8LF4rr3APjevmhMnJFqpwGFQaoDp6hNNaAiMbKXQXOdzijbidj70ElNKcoTZDfagq7SUaV9mz4uSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666464; c=relaxed/simple;
	bh=Y0Ie3JdzjfLtomaySOfheyAEj2azAb8R1acd9Apv/GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0TCKnV0qvehbtNyF7qGUBas6d00P68jY+snu1CJ10Ml3S27y/J0FhueRB0dnev8FJ+UsGHNH09/167wVSoSHuQsiZtkYU7z8bA9XVFci31mUBXPwYVbhjrXQOs21pdLmI5VrqBjiJu938dwtCMqSJdY1CR0M45bJUAJa/2kq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVRmWN3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVRmWN3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D491F000FF;
	Thu, 17 Sep 2026 17:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666461;
	bh=V2BOKJqD5xqREm+WDG1CzuMAl3/YEKSoKg1d0giW0e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVRmWN3LLdNEwFMUIGGyye2X9yk8Eh6gAVM2pSPZnyhp2IzdsgagRAX8aHIjgU5g+
	 Y+4L7Qde768CHAvP7+zQqhWNOhWW+Cz25WX3FdhN7FAPuYa21JSz0qmgpst/eKUfB9
	 h3NOj80xCgRUkePk2TtP6SI6Yi0Vx4BhL/170+fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1045/1250] s390/crypto: Fix missing cra_flags in paes_s390
Date: Thu, 17 Sep 2026 16:14:00 +0100
Message-ID: <20260917151620.404125947@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 5b97b969030c099333d973be420edef0d6452e0f upstream.

The 4 algorithms implemented in paes_s390 never had any cra_flags
set. So add code which sets the cra_flag to CRYPTO_ALG_ASYNC and
CRYPTO_ALG_NO_FALLBACK.

Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/paes_s390.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -566,6 +566,7 @@ static struct skcipher_engine_alg ecb_pa
 		.base.cra_name	      = "ecb(paes)",
 		.base.cra_driver_name = "ecb-paes-s390",
 		.base.cra_priority    = 401,	/* combo: aes + ecb + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -829,6 +830,7 @@ static struct skcipher_engine_alg cbc_pa
 		.base.cra_name	      = "cbc(paes)",
 		.base.cra_driver_name = "cbc-paes-s390",
 		.base.cra_priority    = 402,	/* cbc-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -1134,6 +1136,7 @@ static struct skcipher_engine_alg ctr_pa
 		.base.cra_name	      =	"ctr(paes)",
 		.base.cra_driver_name =	"ctr-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	1,
 		.base.cra_ctxsize     =	sizeof(struct s390_paes_ctx),
 		.base.cra_module      =	THIS_MODULE,
@@ -1573,6 +1576,7 @@ static struct skcipher_engine_alg xts_pa
 		.base.cra_name	      =	"xts(paes)",
 		.base.cra_driver_name =	"xts-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	AES_BLOCK_SIZE,
 		.base.cra_ctxsize     =	sizeof(struct s390_pxts_ctx),
 		.base.cra_module      =	THIS_MODULE,


