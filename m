Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048160;
	b=aTbyAHPVAIQ30dG3UFgQXp+dOvo9sQimQIDIf6sYagbRVY5O+p2MDChf3uJOYZH8tzK5
	 bvoXhPgUBhNdd/GFqVixkvvhONg4xuC5Xhg0el/Gl67XhN/czOL87mL5S9iJjwedrCvsH
	 ggeEfL+4sKs0nGbkYrN06zHtdQjW8EQzuHVnD+dvtTpw3fX4/sPsXvOtkKwUQHg4FGp6i
	 qyMOf5l8BzYZtyBHvnZCHOP74GbOqI7ZCRyVXq0oQw3DoFCa1CN12XYx+4Ie143Ixo2sm
	 dwen9ubz2Nn74tORUOIqvJvSurSWN2pPb70NVZimkl0OFo7Uqm1UlHRxcbyPMFIiDVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f16DxITyPPcYNRC5+T1cxtl0vY701xL2ETtBbfy/dmA=;
	b=OrLa6RsQ3/d+AkxLAXihR7hUQStUhU8VHzxy81WdzvkFX547oXMgJqBalW9QHGV5Poss
	 2dcrxzTbZE8aInnoRdSHJI9uWzxSd4wo7JndjT6l6WZY539JrK3SbAHqr+4FwUt/gfRMY
	 8qRnxMIBJ2MIv9QPwhDVri+kiTAgpvBNF17VyTRWCDYFDKcQKLJP9looM6Vc4YXuwgh59
	 z39ymQMagiTTTcQ/3pDi3DfJd8lGdtiOPRuTi7u7zUJLQK9rSBjjyUlcrDwLQ8AAf3E2J
	 Xhkhi3o0tmm+V1XB/DYOPPGUaMltOZsM+BfvpELzoWjLGN1ixd2B0zlMOcUXoQKY8Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4KiWWuQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F72F606A325;
	Thu, 19 Nov 2026 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4KiWWuQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0FC1F000C4;
	Thu, 19 Nov 2026 00:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048160;
	bh=f16DxITyPPcYNRC5+T1cxtl0vY701xL2ETtBbfy/dmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4KiWWuQpBncFh+FSg56t/hd5r4tGo/Wavue+dgb+ibiHn0Ibj8NxEsY36Qo3jVvb
	 DCzVnJBABTje/OQCIS/3lAdcqZFpBKtZm59QNXzGgqz/LTuLCJ13okq7agfvlU47OV
	 lNMG5cjlO18Pd19FolU5AXtstpGypJPmV1pwCY2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1895/2857] crypto: qat - avoid OOB read when stripping RSA leading zeros
Date: Wed, 18 Nov 2026 15:48:49 +0100
Message-ID: <20261118150309.463460902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



