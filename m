Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D14F3904;
	Thu, 17 Sep 2026 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660477; cv=none; b=RHWzliry/9tPlMdptGSLZmHgbJmxAgNprxLODeoOx9wneTv2+7bCr38MvhsNb5dGqWCWDSMxiERjEuQpwMQo0VrI/RCKvz9e68WsxkN4JSzL+shmd90L9jXHZcx/BBLS9WewotqveagblsRy6r91lKZ3szuwrzZHofliEyA+Csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660477; c=relaxed/simple;
	bh=/n3NdSr4kLh31+glUO5sk6inVtmRytNlZNaVM+SoU/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOlPv1viw3gZZsFLhHwfU7hIo5Sb4f8jhR5OIN852og/xOymvCnfr7jVckODtQT+oFkpVh4lLF1x+zoLoXQ98NsSVB36MCE14ERZA/OW3aphINPDB2elI8BkXGMoESlbyszbaB/IcW37BKLpBojNabKvunO71I2rnc4Ve5LziT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKZRBGpL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKZRBGpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ABF1F000FF;
	Thu, 17 Sep 2026 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660475;
	bh=nS2QB/1Juh28xu5xqDJeinejkHrStd0yhIf2phGXFbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKZRBGpLFlon8nvtTlYnFVstn+HInJWQKJh84yrGHXkSk3JFxmxtzW+gvfTtEW/vR
	 xHHkjAXLNHs7dsJJ1puaiE53fxaApbH/OoRUihmgxXjAnx0lp3qxK670S4rD5XW+H8
	 DxQ51fXgXkBvn5S3jXhEOF0VDB+UBEWgq1uqU9wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.2 578/733] s390/crypto: Fix missing cra_flags in paes_s390
Date: Thu, 17 Sep 2026 16:14:46 +0100
Message-ID: <20260917151406.779750215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
@@ -576,6 +576,7 @@ static struct skcipher_engine_alg ecb_pa
 		.base.cra_name	      = "ecb(paes)",
 		.base.cra_driver_name = "ecb-paes-s390",
 		.base.cra_priority    = 401,	/* combo: aes + ecb + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -842,6 +843,7 @@ static struct skcipher_engine_alg cbc_pa
 		.base.cra_name	      = "cbc(paes)",
 		.base.cra_driver_name = "cbc-paes-s390",
 		.base.cra_priority    = 402,	/* cbc-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   = AES_BLOCK_SIZE,
 		.base.cra_ctxsize     = sizeof(struct s390_paes_ctx),
 		.base.cra_module      = THIS_MODULE,
@@ -1150,6 +1152,7 @@ static struct skcipher_engine_alg ctr_pa
 		.base.cra_name	      =	"ctr(paes)",
 		.base.cra_driver_name =	"ctr-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	1,
 		.base.cra_ctxsize     =	sizeof(struct s390_paes_ctx),
 		.base.cra_module      =	THIS_MODULE,
@@ -1593,6 +1596,7 @@ static struct skcipher_engine_alg xts_pa
 		.base.cra_name	      =	"xts(paes)",
 		.base.cra_driver_name =	"xts-paes-s390",
 		.base.cra_priority    =	402,	/* ecb-paes-s390 + 1 */
+		.base.cra_flags	      = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NO_FALLBACK,
 		.base.cra_blocksize   =	AES_BLOCK_SIZE,
 		.base.cra_ctxsize     =	sizeof(struct s390_pxts_ctx),
 		.base.cra_module      =	THIS_MODULE,


