Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016050;
	b=lp4pJpakWHt8vygT7R6kDCcfqv3b3AbRX6mx6P/rEncp1CeC+L7I++a5RVE3zyKH4A8I
	 achfC2X7ss1TMPRIo7zlfhreg1YuuKaT9W8uMAQYqLeWdXdjJyvmxrhxChma/K+NYhDhU
	 tfh6+/e0AvGTdVVr9JTQ2fkSQXTs3PkQt9HDGrFBzHHFMm+n1qitlFapwyr2iCetLynzH
	 msDKZcjtODBFsCUw9FD9GhG3jKposmcq1H0Ozm0ZCydfbtWQ/C39TLOXS7s1ITk35k4++
	 j8NJx3VnV7707p/W7RvUx9yjoWIgQal0W/v7juvGTydX0DuKrxVhqiEpoyUDWGeYF5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4QFmnUPH0vh3TivkfSf31JwhDpO2UNGfhodORje4Qs=;
	b=v8wiHEQZN2ygepIv5Hao4oYqtZb/xaoMFFtlrXKCfOe6Ur65uf9sxJr95Sy4bFtDSbmC
	 q4DoVCXJqV7lJ8ydAcCa6k0SCcJqm1d27KxIPFG3IDWiZQv5k7ygeS50DTCAOFp3qm8Zj
	 2yETXnA7ocdYB/7MBr8QaMnPVyo6ymNXy2HJwXrj8a+udxrUMCO7wVpmwRCREIW/5xYHU
	 99CGKD39WioJMD1ZQ2HrKCE+lgLSZ8I9gyA2FNPxZINii8Yuvg95/aDFKUhpMNJ2yXb2Z
	 35TlIpPMULaZ2dziYb1UldekgwidRi+h2EPargakS98dGwZ7Oi2qokwM6LgzN03aZCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psSXCn4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76666606A320;
	Wed, 18 Nov 2026 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psSXCn4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CF81F000C5;
	Wed, 18 Nov 2026 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016050;
	bh=D4QFmnUPH0vh3TivkfSf31JwhDpO2UNGfhodORje4Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psSXCn4Rq1HrslV0FAHg9Phj4BlMsc1h/9htv3KVMDoMtIXvxk726ye4noQ1XX6Zj
	 7qTR4ILdrAejE/WKnN1T4ywNppwqNoKErSeW8wVTkzjt8Y7wMKC1ReB4i8lBRXGOzu
	 a1GXSVyBfaIuJcaeNsIUFuvDDrGko7WPeF46dT4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0392/2651] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:27:12 +0100
Message-ID: <20261118150301.950157981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit ac508238898058f0b09b18a7891fb31279617781 ]

The logical AND operator uses short-circuit evaluation: the first
operand is always evaluated, while the second is evaluated only if
the first is true. Because the first operand dereferences a pointer,
it may cause an out-of-bounds access before the bounds check in the
second operand is evaluated.

Resolve this by checking the vlen prior to the pointer being dereferenced.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 75c15c8e41dba..aa2ea563f25fa 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -987,7 +987,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1018,7 +1018,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1044,7 +1044,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1067,7 +1067,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



