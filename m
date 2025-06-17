Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BB82F2369;
	Tue, 17 Jun 2025 15:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175338; cv=none; b=bZycvDuso7ypqoNrtLqWUrY8Q3LYR0vszcMwsVIZrYjExjpMEr4HmhLCRD1iyhThlVTD+Rt3DzuLJs85pqbHrInc0kgtMxMyNxTY5EdDn7ylgTdnqZd7tLNzkOaq4tSBJtMrBcrZLf9/tuLoZPETNMXntr9O8a5CMHQYZAgZVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175338; c=relaxed/simple;
	bh=NYOiHT4GSmJzG9F3+jJDsHy98HRltk1ACE78uZcvrsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbnZ6sVjDQBQaGMnTXkbVQrjwKFELyUt6Dz51AYbK9Td50bk2FDqj9DIlfsVvpcnpgfs7XINyiQJXJnksbEw7onvA2DR+oqf7tjTf709FXcbH5veQ2jke548sVyREBxgEcLRgTPCkkDoqILXxjVGzMc56ZVle5g1pQx8PvxBcZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G19Fo1lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G19Fo1lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38226C4CEE3;
	Tue, 17 Jun 2025 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175338;
	bh=NYOiHT4GSmJzG9F3+jJDsHy98HRltk1ACE78uZcvrsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G19Fo1lTB/Q4lDQ0+U9AVWJILivk9GEaaR34aqljWhLn83zylnIMuKUCDgqm6HYh8
	 s2/9Nrker+4xixV4w0mL9iICWGhlxmxxXzrR7k8IeC6TrPEOkYV/zuZYHkNyWYGlDj
	 zFVr7f8vl5yjsA6UexEiFrrvOSXZ8i16Tzm3g4Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 052/780] crypto: api - Redo lookup on EEXIST
Date: Tue, 17 Jun 2025 17:16:00 +0200
Message-ID: <20250617152453.619109060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3416e98128a05..8592d3dccc64e 100644
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



