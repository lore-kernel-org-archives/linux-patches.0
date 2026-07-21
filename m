Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C02346771;
	Tue, 21 Jul 2026 22:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673472; cv=none; b=FLyOVC5RVbJ6CrE5UmdH+WhRxz/Kz41jJmWu+lti5iZUhmlkyKUbP4ZCyJWfCCf9AVAW2qENRqvmD4JkX9mdxCUTwPQ4LVIjxidGq+VdrF8i9l8N/21Ix8f6PlptpJTC7+Z8cWBroh7aaTqgtu+9s4JFyvLdmu+XftJi8s4CSsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673472; c=relaxed/simple;
	bh=dtB6q/glweO79BUL05ejaNatG4lNQrPzkpdfj3cbzX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC9ozz2xasWfgENCAxu2QxMaBY/O6uj2dOgL39rJfXLdkSA2R/nKi7jQDTdb7Epgio5gXMck63RSN4lh/kJSHgnc4GMICS0VYZB/8Dq6E9s8qanaZ1SBjKZMx509CiNMimIPHOtx+GCN1cn18eJYyuMij7goZYv6Q6h4PdJ8ggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMGgz8DW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMGgz8DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F9E1F000E9;
	Tue, 21 Jul 2026 22:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673468;
	bh=PglpJa1D4ngPGMkf/A6bUFIpm9SU3oT0+YJPA/ov9IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMGgz8DWkQGuBIjPAnOgwmEwNWQPSVgUJcWZFnznAuyz62HpBLiEFlJaP+wgPGvaN
	 TF/eb8uEdUKk/xo444OPXaFzfp2TC/DiKiU6cLZKpUgixKX8+tqEC+rYebxgu2NgjR
	 prCdqPGo3H1nPypMcOWcjOaN34trJnzenvlKJTo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 131/699] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152358.665602519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 39a31ad9e2a5ed7e9c9c6f711dca96c8c8f5f26b upstream.

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -601,7 +601,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


