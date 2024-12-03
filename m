Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186B11DA4E;
	Tue,  3 Dec 2024 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238028; cv=none; b=XCYseHI/JwEJbmP5E9LjgLoXLeN/ULbo+37rWbFRYzydr+ARJCbHtxOANzOeEwrTgOwSeAlTYOFL/D6sXEYwSboc4WTuyS08LKNP0jqS352tFkcv4Zn5dhqYG2V8CU5hVUFasPJoodewxXenW3e7MyV1mzHk3mRwJwlMm5r9sHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238028; c=relaxed/simple;
	bh=wpIhYpd2UcAIWtvr2IoK1QIKbMtHItE0hz4a1EVjAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p37iFQDraZvlkeOf0TYB7F8xf0Yb117zn/oB8CYfIyfTT2cWUQsgvTcuLf3WRHd1r1eeRjstqKZu923qLfDgM+92bOtqWWwitBljvsMtW27pZRZNGzl0J3gu6vYIXj6IrckXkf8s2uNEze+ZU4M/pUbik11IxU/RU76H8FGuI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWJ8s0gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWJ8s0gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A497C4CECF;
	Tue,  3 Dec 2024 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238028;
	bh=wpIhYpd2UcAIWtvr2IoK1QIKbMtHItE0hz4a1EVjAFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWJ8s0guSPL6Xgar6ZhJagMbd8Btfoo3qMjIHdze4e4d6HF/N3dT3kpXk6Zxo3qwO
	 sNzC53lZZquiOM5WJEri9s6xfJ/zbVbyirZFVKLbFn2U2FuWgFLGeBsp2YRzQlZ9N4
	 AP+w/fgBsUQC7vvGMROywdNeLKI8byNDW8T/vtL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 107/817] crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY
Date: Tue,  3 Dec 2024 15:34:39 +0100
Message-ID: <20241203143959.887020480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 662f2f13e66d3883b9238b0b96b17886179e60e2 ]

Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for
PADATA_RESET"), the pcrypt encryption and decryption operations return
-EAGAIN when the CPU goes online or offline. In alg_test(), a WARN is
generated when pcrypt_aead_decrypt() or pcrypt_aead_encrypt() returns
-EAGAIN, the unnecessary panic will occur when panic_on_warn set 1.
Fix this issue by calling crypto layer directly without parallelization
in that case.

Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d0d954fe9d54f..7fc79e7dce44a 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -117,8 +117,10 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_encrypt(creq);
+	}
 
 	return err;
 }
@@ -166,8 +168,10 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_decrypt(creq);
+	}
 
 	return err;
 }
-- 
2.43.0



