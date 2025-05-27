Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC52798E6;
	Tue, 27 May 2025 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366038; cv=none; b=mqCGkcynRMYHMTmWaK8rjjYVDcxX7dijB3DlKwn43u0YA3wG2ob45m3DA8wWUClQnLmsdsqvTz5NRAzNWpy7UTUaLTentvarUTPogqWcKjQMmhWahkZ1BNDfHx5kkLUO858+QKPZk7aQNfWtRnDRZ3vP73VyQ3kla5nnfYxzSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366038; c=relaxed/simple;
	bh=FWi0NDMw1ap4IuVv5zIhoOu+kSNJ272bkKGcQRA12OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOjo7H4xK4Eed/0BHfwFWC6sW/tiUVAKR8XrHjSlYCMlz2BL1a3XxFYmsiUob/DAuJOfBRQaLBzxyAQn0G31fxAoQbQYq6kywR2yxQGwc87r+k8YXSY/wnhCr8T9HfZk9Ez7rVs9u/QYd7TE8FHutbEMTZnGHu9bydB0gKwdh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOF0ZgcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOF0ZgcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792C7C4CEE9;
	Tue, 27 May 2025 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366037;
	bh=FWi0NDMw1ap4IuVv5zIhoOu+kSNJ272bkKGcQRA12OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOF0ZgcEZHQXQZQFdTDn9ZmKMUF0Vsrj7v9NoU3dHE10QdloeoXXfdb5IxdvtZIOq
	 u+5gTEsOFNoJAH6ZchWEXgqv+NAf3UbAapteCAbxx17oJ2SeA8oTDek+l4pSc4sIoq
	 TH2m+wOtLZnwLhOgBcuinEvGpARlxY66O6k0O1C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 570/626] crypto: algif_hash - fix double free in hash_accept
Date: Tue, 27 May 2025 18:27:43 +0200
Message-ID: <20250527162508.126390157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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


