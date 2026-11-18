Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060529;
	b=KZouKMVvI8F4kCP8KxpZc4lU/LvN+/gQImzf7hQqVs+5ICzltbSesUFAHF37cLXjoq2O
	 79VdDx+7mVbpotQXWW7qF0QtnDDIKEt5xWyeameSUIn9PhlaEhcyHpqS8ARNhYpFhj6FD
	 s6YnsvB2y3tbTE02Jb6629qVIxpBZ/w/ZJtALJK1l4CXUAaa6Xq70s3Y0I2QFE8C1tRVq
	 UhGd7xfS0Txet0mZwg2pKhJwcUEju+Ql5GaYkZKmmcoCx/jgJOFKHd/Fuon44iGXJ+1WZ
	 F0uvJQzoPyo4WCGm07Y8EnKMgaebnNlEY3W1FXwivfXIf4J7r7s4GnVX76HMmh/9VwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0Q/ulOw0mjcTetgHgDKGvlVpBOIXviw2z6B2j/2WK0=;
	b=K5+XyKjup9fdtt2irs+tsClpfZEIqWeX0jgDlfk/zIkDN3/bbTA8KumoGvxJCsB/E19e
	 lFXS0QN/Y/8ZJZBEqOlBl2oA/4AGYw7TNepmaVL30qIKo73ZDbHUAex3Pi2X2boCa+qWu
	 Qn8g24am6Ax5mQWzLpuKqY2qH0Jmj55j+ymcROValtcmTcj0FP2qJ/l7e/JSPUSBZaHGq
	 odgoZ4X6q4q2EVCqNpQd7wIXk6J4H5/fEefXC/X+X/WdETu50Xp7EU2mdlTv2yFkevZ6x
	 GCJCb0nx6pv5dNXqR/l50He95oAPGANlTzaP4k1+YYDgiROMT1xl/kMGX45DSH7lYQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUEgLeNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2D3606A32F;
	Thu, 19 Nov 2026 03:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUEgLeNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616B81F000C4;
	Thu, 19 Nov 2026 03:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060528;
	bh=x0Q/ulOw0mjcTetgHgDKGvlVpBOIXviw2z6B2j/2WK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUEgLeNFQABdGDDw4QMCSP0M+8873VLmFJy/CblZNfGqaY6fBGmXDjpzKvxvyNA/F
	 ArEQIpnvccEBWtAkmyc/NIEvYeRe+j/QA2F26agDllipLDokVLCHRtWUHfwzT6/Ppg
	 Gn+Wcnw6QMUPRlK7NAZuXwCJkEOaFVnqn/3x7ZuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1230/1848] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:54:28 +0100
Message-ID: <20261118150011.387990849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 63e5569838455..16cd16b7d9a1f 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -932,7 +932,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -963,7 +963,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -989,7 +989,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1012,7 +1012,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



