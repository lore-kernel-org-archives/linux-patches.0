Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054998;
	b=sFb5T7pDz1dcFPrqnWXF9iolF6IQAHJz+A012dR7DdYZT7oJHVGXiPbs7f+gMVijVX7z
	 fpfGo8q89rWMO+bV8WSvaU1gGQhmw12EhZ/Uisx78QuNb/PpwJUmzcRxr7yL9wnemM2dJ
	 haL+IWyPVPtYEirhDwbtqo4DQlgJ3c7FaSU3mv0b1mVgbKyHR2dNRLN4TItqEpjIh4NVj
	 GbBseYrfskKATuR7F6tbkDqtr6/ipMeXyvas5EDD1Qw3NsDufgCLzk/6fquw/GKyewR6o
	 vtS7VyIxf7/9LMTxUXU5ojSg9jM2buOIf8rn6JX4uCH1Z4xV+35MVvSDUtNHGhdL2Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d57UgFI5+rYISxa2Ldsh7pxTVixDTU80MYXhneW+hrI=;
	b=A5+/c43o1hKk9Gh12nx0Oz4QDCc4lepGjh/xTsfmrzy/sX66U5AWhKUWfoNh8Dtq8RnK
	 Zq1YNonfF/uvI3XDOMlw2241we1aISUTZu6lHWh1eed/quAjaX6LWzWRjAKOR+IT5HG6Z
	 Yk8dJ3zcTvpqouEhXcYKb55of/gyaYzrbxpOZpR7AcSqc7bi3FPn4LxlbYvXPVPoMJQCM
	 Z+ECB+jpPk1yD3CRl2EKufem1NMZV9/jXGmYntmKuNHxoWaoemUig/hYqz0woycuUixNj
	 OEcBrCK8sWzOmnPcKXHIBJqowiorFEs5jfpzqRl7Cd5QXkOy22ENYHyZdIqJsEWuC0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azohoyUR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA82606A31C;
	Thu, 19 Nov 2026 02:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azohoyUR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EF31F000C4;
	Thu, 19 Nov 2026 02:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054998;
	bh=d57UgFI5+rYISxa2Ldsh7pxTVixDTU80MYXhneW+hrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azohoyURr59ZkBAvIFJTNJmxzd8CFikO+rRyNyGeeaVXgQHVkoiBy0Ixl551+BzA7
	 MKrd07KXsCjAcsxvZv7j8yUROgZH2/bUzIs8nu4EdTu81wDSx+jM/8byyXS5xqKdXq
	 RVd9BkzL1cYtKQYuAFKKIsC2xmzaFeCM0DFaK5nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1475/2214] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150110.178052256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4437c3a5c6dd7..fc0613f37b7e1 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -934,7 +934,7 @@ static int qat_rsa_set_n(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -965,7 +965,7 @@ static int qat_rsa_set_e(struct qat_rsa_ctx *ctx, const char *value,
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	const char *ptr = value;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -991,7 +991,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 	const char *ptr = value;
 	int ret;
 
-	while (!*ptr && vlen) {
+	while (vlen && !*ptr) {
 		ptr++;
 		vlen--;
 	}
@@ -1014,7 +1014,7 @@ static int qat_rsa_set_d(struct qat_rsa_ctx *ctx, const char *value,
 
 static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



