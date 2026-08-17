Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C73F23B1;
	Mon, 17 Aug 2026 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978305; cv=none; b=qMGbrzAT1ZMHyoRGmYmv9x0h8n5uPXHo+SYew4NwD3YDIMkrC3/jyl5o3DmCTUSDRh6uj7jarSEo+4T/RGy5sXuV6G6m8KI8l9SYpdmnzoOIJTBHj5hjtV6aNJicBncrF0WIwCgbwkDkxVS3mFTmKGczhJLF/iVZ9g7KHOaFFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978305; c=relaxed/simple;
	bh=VpDfjrKxFVqbt83amYezWDS5qTlDwvB5SAkDylwLpHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8JiGy2AGCEiNKej8xPpzqzjC5jnmBZrzzz1Nc5Pkrb27Kus97aOhJuF+QD47H/WkquJpcrDQ7UHfFBbiodhCI8RWaH0cA4Ddex2IocprGV8WyycMWg1JB1jBluAkcgRecZHY/V4E+5OqjXY2eqWE0ehNvnN04aVqqeNKf1oRgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5lx2FCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5lx2FCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A3E1F000E9;
	Mon, 17 Aug 2026 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978304;
	bh=hGicOVokmf+r0fVqBUm+OxL23CSU3WejRlEtwk+9h1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5lx2FCbgR53ZLyRLIuFVw4hCoPzUjbwaq1UsKzMdCGiZZvN3xqvYGoD++Q+DbQP7
	 0Cd2eH1IUXbg9vGv+LLtCZO1OgUj7sq8HZ+KnIN0ImXax6B7BsLLexkxhjfIPGj+SZ
	 5L7Iu2dLCXfwEhjMLN6GyjfEU17wdPOHIIvrTkoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 6.12 173/181] fsverity: Fix silent truncation in bpf_get_fsverity_digest()
Date: Mon, 17 Aug 2026 15:34:27 +0200
Message-ID: <20260817132542.496557535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 7c68ed5c5ad4c185ea9654f5d8ee36560277b7dd upstream.

bpf_get_fsverity_digest() silently truncates the digest if the provided
buffer is too small.  This is a footgun, and it doesn't match the
semantics of the equivalent UAPI (FS_IOC_MEASURE_VERITY).

Change it to return -EOVERFLOW instead, matching FS_IOC_MEASURE_VERITY.

Fixes: 67814c00de31 ("bpf, fsverity: Add kfunc bpf_get_fsverity_digest")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803181232.14743-3-ebiggers@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/measure.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -143,14 +143,15 @@ __bpf_kfunc int bpf_get_fsverity_digest(
 
 	hash_alg = vi->tree_params.hash_alg;
 
+	out_digest_sz = dynptr_sz - sizeof(struct fsverity_digest);
+	if (out_digest_sz < hash_alg->digest_size)
+		return -EOVERFLOW;
+
 	arg->digest_algorithm = hash_alg - fsverity_hash_algs;
 	arg->digest_size = hash_alg->digest_size;
 
-	out_digest_sz = dynptr_sz - sizeof(struct fsverity_digest);
-
 	/* copy digest */
-	memcpy(arg->digest, vi->file_digest,
-	       min(hash_alg->digest_size, out_digest_sz));
+	memcpy(arg->digest, vi->file_digest, hash_alg->digest_size);
 
 	/* fill the extra buffer with zeros */
 	if (out_digest_sz > hash_alg->digest_size)


