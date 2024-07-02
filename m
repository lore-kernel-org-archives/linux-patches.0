Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A21514DC;
	Tue,  2 Jul 2024 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941386; cv=none; b=ES8gxEcJSOMgh/ffHhbUVk/e+GSt96BPHysJ9VJWLwoLF2OOqSzQlIyWUqCuM1GTlrvcqahwKwIey32gEtYQRpec87M5ZIyzIFilrEBF6snRRos4UubE6evQYabvemxm5bCg1wa3pM5NSx3n5ODVMuISWGZk1VsAjsWL23BkI08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941386; c=relaxed/simple;
	bh=OjiZu7I9NU/c4fH945zFo2yj6m/p5Pf9Jhg8DfflOpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfZE2/wi2lR1G7cEHhUbLMU431lIstaBDdHKFFubT9njKLsCa72iYrAQkGoEk3/ctY02U/q5uhoYnt7oz/4EnO4PMxUqgpLi+J0BAHbyT9qznoKLetQabH2c+O37BIfBYetqdlwULXn9f+zBy8NCUTxSXAq2DdCELzS1ii7KyMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0lemFa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0lemFa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB33C116B1;
	Tue,  2 Jul 2024 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941386;
	bh=OjiZu7I9NU/c4fH945zFo2yj6m/p5Pf9Jhg8DfflOpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0lemFa1uoH/UdJ/M84tIcsE6ZC/KoGM3jCUCIybtOX5LLdrEMsZ+tiA74VFMuWI5
	 3ClsjepQZYTBJLUKRWbErmafKCFY7MkaBpBYOVzTVAjDPYnTt8YJ4c4MBweun8bBP9
	 z04NLp0wlWLK/3RdP+Kvmr6+R/YQWM7JqUCjscUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/128] crypto: ecdh - explicitly zeroize private_key
Date: Tue,  2 Jul 2024 19:04:09 +0200
Message-ID: <20240702170228.051727350@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Vandersmissen <git@jvdsn.com>

[ Upstream commit 73e5984e540a76a2ee1868b91590c922da8c24c9 ]

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 80afee3234fbe..3049f147e0117 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
-- 
2.43.0



