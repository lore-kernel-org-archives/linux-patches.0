Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7441F7572;
	Tue,  3 Dec 2024 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236459; cv=none; b=jkMVGCzgHNkPy2tsY8lHn9NemW7/5JqU6VsQBrIiX2h/IUWCOJtMcGrfakLW+6o0SiWUFsQHOQtNY4YfrlZpckSyq/E0ne7OKGr/p8GUqno3haGhqlIy0J1JQa1BuvTn482rNTTm8e8wlZ9hJB+oNChsSWs+qNTb34qQ7qXbu7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236459; c=relaxed/simple;
	bh=tfDp4vsxb9QvPsLE7sLFN6/ZWgxXKvDeW3XJqsxpL8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OshK/qnK9R715YkSmfdRF4MrywvHvnEsswnSJMLt0e0lJqXxx7d6GGBMtNXdXfLEH+/uRFGjl8tXTTghbgJSTydEoxhZuNTck0fkZChmkMCSOVGGLz/zzFsSK9yvl/G9RX6MmK2uOqHOyU9NnWtGGHaw+/3bmOlWYny0w3EjDW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3wW8ZZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3wW8ZZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7941EC4CED6;
	Tue,  3 Dec 2024 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236459;
	bh=tfDp4vsxb9QvPsLE7sLFN6/ZWgxXKvDeW3XJqsxpL8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3wW8ZZiSm9cndDD2T/lVlvmVW5mvGDLE3DzMVMKOUFFkPT5PGp6xvFH3y7PsvFXB
	 DlNyA8DQ0PE2fk/5iBe3Am5H6yI92mD5FRJZpiJ7GRf8IhqYbEXk/nYLltce4Rv6iM
	 C1bnu0MfkeMUkOFsG55L4VcNHgR2OBpNY4k66Ck4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/138] crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY
Date: Tue,  3 Dec 2024 15:30:54 +0100
Message-ID: <20241203141924.508906047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1e9de81ef84fa..d18e18141cb05 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -174,8 +174,10 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
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
@@ -220,8 +222,10 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pdecrypt);
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



