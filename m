Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFABB42982F;
	Wed,  4 Feb 2026 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217773; cv=none; b=DnsrjTLzQguGv3ZMyCwdogYw0yUM7IdIPohAZ0k30AgZJDZkiYI/EUTU6eqeTsE9THOT2Xk8NpsI5aT5lrH74/uruqrTw6YDowgaxLQvA/HRObytqax5/5pfjSV8EL7wU9c1131Bbtge9fa2z2bPn0XnShyA6OxK1lNOUAuOraA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217773; c=relaxed/simple;
	bh=1IJn8hV4ZHjfI86tXU+QQIAgIUPVpBh9AA0k7cMXkxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Yt8abK5dbAYoUrMyRbh+pZSJAnq2mPT7XmCzoVs8JMy5TjatiIfSQlzifQ5v8sC46SUclAYhvtsBjAKwqqPvD0Sj3HFQfzrNKwHXoTxofB/geCy1QrXYJdijGn4pqqeO33yA2HogfRXuL2oCRV4QsmkUe9ZJ6AxcC24r1g9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9bseGIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9bseGIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44044C116C6;
	Wed,  4 Feb 2026 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217772;
	bh=1IJn8hV4ZHjfI86tXU+QQIAgIUPVpBh9AA0k7cMXkxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9bseGIftsa1LCmQrmaieFCY9A351BU1ISi59+9bKsxEQLiX822ThOQXxeLsYKnm1
	 BZRHTl77LHh9Y/lnQR9OFMq6ArkmkfjFew+Ka+LLqvgSRCzO+xa+xTB0p1YDIfir8O
	 NpkOOUsx6Zzps9reihSw64eZGmpr+zcBujZpIIFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/280] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed,  4 Feb 2026 15:38:08 +0100
Message-ID: <20260204143913.745346686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 2397e9264676be7794f8f7f1e9763d90bd3c7335 ]

authencesn assumes an ESP/ESN-formatted AAD. When assoclen is shorter than
the minimum expected length, crypto_authenc_esn_decrypt() can advance past
the end of the destination scatterlist and trigger a NULL pointer dereference
in scatterwalk_map_and_copy(), leading to a kernel panic (DoS).

Add a minimum AAD length check to fail fast on invalid inputs.

Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Reported-By: Taeyang Lee <0wn@theori.io>
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/authencesn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index b60e61b1904cb..6487b35851d54 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -191,6 +191,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
@@ -284,6 +287,9 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	cryptlen -= authsize;
 
 	if (req->src != dst) {
-- 
2.51.0



