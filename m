Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F1A34FF79;
	Tue, 16 Jun 2026 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634799; cv=none; b=p9w35Q2AzhfMcAoyDVMV/O1XsNoUbgyVbgBNL/NBPVLEpaZDt4+hwhlckeDARclarSS4ZaTX6xB4cbwZnYcvOHcARnn90TdDMO2bf7WOSopvVDFIbCgigKn/COUXww4+f/g3Z88/Zn8ifIyuQonfGGk4PjGzfEyFm7Ilz0oTmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634799; c=relaxed/simple;
	bh=wz1np52QW1NSKTom4y2vBFXAfy0Tb4MnSkuU30btq4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTRy8FOYdDtCpfdLzonAFHPN9JnrEa/6IQtXFYLHGBxZv3SHaLEO0ZRekVgjsTOpbOrk1xj8Pigi+n6LzXyJYi84yPArB12tYajyjdYLC9WjeLBLA8AGRT933pwKHAZADF94n4Ypa0B3IImi2RF2vH2eQYrCmpgrIKiUm4T/1qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3Qhgnq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3Qhgnq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370AD1F000E9;
	Tue, 16 Jun 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634798;
	bh=wmCwcb81R3qUjkB9CxwRvZp6PqKykiEZ3GLKk9dIjWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3Qhgnq2NhWrCK4ELYtSJ9qxqFu5iKtPMiLXpkOznyR5SEegZI1EOTpdV4OwZ/BQL
	 +ofz6bFQKbHzLU6Y065ayG87q4mfUxlzhn0Vi4pW9ZWfQHZSM5CiGK6DIOkGB4hKjc
	 AYvVoEs71BG/eP8en+nnlIEG6ZqIkiSHVd2IlVSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/411] crypto: caam - guard HMAC key hex dumps in hash_digest_key
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145117.141774778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


