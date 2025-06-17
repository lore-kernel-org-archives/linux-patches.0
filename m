Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B362ECD2A;
	Tue, 17 Jun 2025 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174737; cv=none; b=sj3qas0dD8mXMha/hFlO+1ZKbOX+F5efOfM48dVRNJRkw6Zlp19JKi7REz5nVBi0yT9JfsO66hUzJkrG02ddreTM1FdppE3Y3CBfw/HORISiojnx9Keau7h2iVwrVR98n5AC1gL/KF87cq+0V070w6ItB29JNyS7JzB/hXA9t6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174737; c=relaxed/simple;
	bh=QUUGa9j/IXY8IwN1O0Z37yERnMfreYAXDiFRUabtMag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhNfabZPy5lzMhpleMvDEAA49lYQ81LbOR+XLvrTBM+4Wn8EOtllbHq3iJUIqfKUkOcA1MR0ofFTpAaeaTofIz688QvNCftnMoCYaFVpfQ5bEW93x6489TBpJfIX33hLw6MRUPoKVNUlqSNuTnsk0Xv0Sn21lsjONEF3jOQtUYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixQUYIF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixQUYIF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97231C4CEE3;
	Tue, 17 Jun 2025 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174737;
	bh=QUUGa9j/IXY8IwN1O0Z37yERnMfreYAXDiFRUabtMag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixQUYIF5v+iHPKifSDqKeSUc4QTu7vjymwFHMmw6ebuMXlQI48ufczn64ez8Ph1Tb
	 xFFbV2CO8i4DA5Ge1Y5mAvhZih6mk1JVU6qeY5ufOuIYSHsOW16P4tgJ45EHLVf0yg
	 y+WnZAHf7qvHgEVbnC6KG7bt+TYi9+nHVSj+95hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/512] crypto: api - Redo lookup on EEXIST
Date: Tue, 17 Jun 2025 17:20:01 +0200
Message-ID: <20250617152420.977170898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 0a3cf32da469ff1df6e016f5f82b439a63d14461 ]

When two crypto algorithm lookups occur at the same time with
different names for the same algorithm, e.g., ctr(aes-generic)
and ctr(aes), they will both be instantiated.  However, only one
of them can be registered.  The second instantiation will fail
with EEXIST.

Avoid failing the second lookup by making it retry, but only once
because there are tricky names such as gcm_base(ctr(aes),ghash)
that will always fail, despite triggering instantiation and EEXIST.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 2825982d9d66 ("[CRYPTO] api: Added event notification")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/api.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index c2c4eb14ef955..5ce54328fef11 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -220,10 +220,19 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
 		if (crypto_is_test_larval(larval))
 			crypto_larval_kill(larval);
 		alg = ERR_PTR(-ETIMEDOUT);
-	} else if (!alg) {
+	} else if (!alg || PTR_ERR(alg) == -EEXIST) {
+		int err = alg ? -EEXIST : -EAGAIN;
+
+		/*
+		 * EEXIST is expected because two probes can be scheduled
+		 * at the same time with one using alg_name and the other
+		 * using driver_name.  Do a re-lookup but do not retry in
+		 * case we hit a quirk like gcm_base(ctr(aes),...) which
+		 * will never match.
+		 */
 		alg = &larval->alg;
 		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
-		      ERR_PTR(-EAGAIN);
+		      ERR_PTR(err);
 	} else if (IS_ERR(alg))
 		;
 	else if (crypto_is_test_larval(larval) &&
-- 
2.39.5



