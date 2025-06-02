Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ABA223323;
	Mon,  2 Jun 2025 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874097; cv=none; b=XaQ+Xf/Jin2o1j/HcaPa0xK3xds1S42uGEcYPMzRvy+tpQCDkaPbMSgRik80JpefAkscQW2Dzv2+Qs8hZjyBlvmVgZuumyCnSXhNfSUNRKcmezV9EWiiupqrGB3MMysaBay59kIRw8r5kPmEsG7/JA8BoUDp1hC2tg/waukSJx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874097; c=relaxed/simple;
	bh=5wnOVYkQz/HS+WFD+Z++06W31V2zXQhpcP9/DIWfWL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6Zzyuxnv/xWwn57V2mkOt5BeIA3U1Zi1V9k+uLsJ6nMPzM4FkHE4uIsn31MyOALuSw2QwR70YaYjn5t1DUiQ4vCQKQz6IUb+djO469j8Qpm8L0dIdaxBDIbrQlNu4LSHb3LydRiMQN+Aug47Qk8E17x25X1q9mHholpZc7zChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNL7y1Ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNL7y1Ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C66C4CEEB;
	Mon,  2 Jun 2025 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874097;
	bh=5wnOVYkQz/HS+WFD+Z++06W31V2zXQhpcP9/DIWfWL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNL7y1AbxuvMlXLmtkqJxMrMb3fP7ZQTWwaMeT0/j8GSl21M8E93wuiqfzLcX5EiM
	 L7dp0B/MpjK1SN+YlHWDGKRFFo0TAcaxRIKJVh9HqPV7QKhUxeIbvIxVJCp5ytjfBM
	 GOSLUXmWygxft6bCIRP5MSvKKFMcyy4/LOE4e7Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 356/444] crypto: algif_hash - fix double free in hash_accept
Date: Mon,  2 Jun 2025 15:47:00 +0200
Message-ID: <20250602134355.375200028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pravdin <ipravdin.official@gmail.com>

commit b2df03ed4052e97126267e8c13ad4204ea6ba9b6 upstream.

If accept(2) is called on socket type algif_hash with
MSG_MORE flag set and crypto_ahash_import fails,
sk2 is freed. However, it is also freed in af_alg_release,
leading to slab-use-after-free error.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -265,10 +265,6 @@ static int hash_accept(struct socket *so
 		goto out_free_state;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 out_free_state:
 	kfree_sensitive(state);


