Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0D43D4E9;
	Tue, 16 Jun 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632214; cv=none; b=ExJLb+x0EjT4sbHLvuYwzqYEqG3K95G0W1Iwuot17aRKfwwZnh2qTgKOeBOt8mP9i5NGw0UNU21xM0q+JlwcPy++H6GTo6v1XX3JVcZeGoZtjWBSofKATMp9Y7wBDw8ssBZ5FNO1pgOygiJ/Ex5k8ErzdQsy1/7e6zqJgkye3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632214; c=relaxed/simple;
	bh=d++nFxTDhzagcjaSyOLSqLQvPDfPwcGgEO5RUsGZSe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd9byCA6wHXnqQoF2IocPdIqQEWmhzEVbTu7EZtHjMZjJZQnS1lm/hOKTGoQdUPlGxE1VQDU4Le8RMJR0CkY97O8xpMpRmlnLi5cfN0OZXb6qc/+GZY1oDK4Q3xJ9KU2gGEC17D5OwxvtzKCAzxobwi18suImxWUTSjlphMAnmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OReylYCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OReylYCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07761F000E9;
	Tue, 16 Jun 2026 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632213;
	bh=oRrjkxxkLFvvRtO/Shc5HH1xNrwhJnRwzSaHV+jpj9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OReylYCz8Ya5a98XtuaivNeD8XkipCQLsIrBQZuOYznljqNwQEwBQtJPjpG3kztRw
	 m1dUfq2ClWB4Wxl//EBwcLQUrqkQWuIISWHVXA8AFPoiczz0PxW5DJGXzck0MLHL8X
	 PgtmPzX2GmSDn9ldBpXWOaJYWMW9tbUEqMzMbGI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/522] crypto: caam - guard HMAC key hex dumps in hash_digest_key
Date: Tue, 16 Jun 2026 20:28:34 +0530
Message-ID: <20260616145142.950428109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 177730a273b18e195263ed953853273e901b5064 ]

Use print_hex_dump_devel() for dumping sensitive HMAC key bytes in
hash_digest_key() to avoid leaking secrets at runtime when
CONFIG_DYNAMIC_DEBUG is enabled.

Fixes: 045e36780f11 ("crypto: caam - ahash hmac support")
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caamalg_qi2.c |    4 ++--
 drivers/crypto/caam/caamhash.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3264,7 +3264,7 @@ static int hash_digest_key(struct caam_h
 	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
-	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key_in@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
@@ -3284,7 +3284,7 @@ static int hash_digest_key(struct caam_h
 		/* in progress */
 		wait_for_completion(&result.completion);
 		ret = result.err;
-		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
+		print_hex_dump_devel("digested key@" __stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -390,7 +390,7 @@ static int hash_digest_key(struct caam_h
 	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
-	print_hex_dump_debug("key_in@"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key_in@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("jobdesc@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
@@ -405,7 +405,7 @@ static int hash_digest_key(struct caam_h
 		wait_for_completion(&result.completion);
 		ret = result.err;
 
-		print_hex_dump_debug("digested key@"__stringify(__LINE__)": ",
+		print_hex_dump_devel("digested key@"__stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}


