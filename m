Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1753AB5B8;
	Mon, 17 Aug 2026 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975347; cv=none; b=Zg4AsQmnS6+21GlF0Oiw8Jr+cQzXkLatY+4VfbZEIQludUcAzZ1nwKRPfeKOxy22b8fhp3cRKMXglEbsuK+20AUW+SIO3Yd6lG9kU0ACkQnuT4LnIMabLCDwIGd87vATq9RuURdEMfwqI01EXabSbXgZZ1+o/eKNXTsZ2HvNq+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975347; c=relaxed/simple;
	bh=xEG4osMbBnNB0foSfAyViImpjBxBo4SaU5VvBtfJ9Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TViH0ziYsaWleaXFglaIZr/NPCQlioboeEW2mtOriZ7R02Q3krouedQgL9erFfERmpBNFpfANCM5yx7v8JfmU5vr7mp/mc2i/o5rtvXoEf8AA41QJzDV08hNADDBkDF0U2Bej7Y3DZp3iwC7h0LePN+fR8POruQcctHzCKsopzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hooATR70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hooATR70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666D51F000E9;
	Mon, 17 Aug 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975346;
	bh=zYlPqBWI/7mMVfx1qcxq0QfdLFKk/fH6E5paD6QI/h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hooATR70pSAbK4YIL+NQvMvSQ2xUy9YNduKleyuKjPv3sFUIZl+eKw7r8FWXHgtQI
	 6AneApZl6hGfep7u13BtG5YfCtAumHTYIbaJxOy/Cx5R/6BmCNCd4Ws009pG3Lw5uU
	 uPHbZLZfzuVcEKbIdpy85z/qb1k4HXqEvv8pjx3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.18 240/250] fsverity: Fix bpf_get_fsverity_digest() dynptr assumptions
Date: Mon, 17 Aug 2026 15:33:21 +0200
Message-ID: <20260817132546.295915542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 3e8ec7c0387273329374f5c7bd61f5f38af71fe1 upstream.

The BPF verifier and the dynptr abstraction ensure that the memory space
referenced by a dynptr remains valid.  They do not, however, provide any
guarantee that the contents of the memory are stable.  kfuncs are
expected to remain memory-safe even if concurrent modifications occur.

bpf_get_fsverity_digest() didn't follow that: it could crash if
arg->digest_size was concurrently modified.

Fix that by using the known-good value hash_alg->digest_size instead.

Also widen 'dynptr_sz' and 'out_digest_sz' to u64 to match the return
type of __bpf_dynptr_size().  It doesn't appear that it can actually be
more than INT_MAX currently (since __bpf_dynptr_data_rw() excludes
file-based pointers), but the correct type might as well be used.

Fixes: 67814c00de31 ("bpf, fsverity: Add kfunc bpf_get_fsverity_digest")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803181232.14743-2-ebiggers@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/measure.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -122,11 +122,11 @@ __bpf_kfunc int bpf_get_fsverity_digest(
 {
 	struct bpf_dynptr_kern *digest_ptr = (struct bpf_dynptr_kern *)digest_p;
 	const struct inode *inode = file_inode(file);
-	u32 dynptr_sz = __bpf_dynptr_size(digest_ptr);
+	u64 dynptr_sz = __bpf_dynptr_size(digest_ptr);
 	struct fsverity_digest *arg;
 	const struct fsverity_info *vi;
 	const struct fsverity_hash_alg *hash_alg;
-	int out_digest_sz;
+	u64 out_digest_sz;
 
 	if (dynptr_sz < sizeof(struct fsverity_digest))
 		return -EINVAL;
@@ -150,11 +150,13 @@ __bpf_kfunc int bpf_get_fsverity_digest(
 	out_digest_sz = dynptr_sz - sizeof(struct fsverity_digest);
 
 	/* copy digest */
-	memcpy(arg->digest, vi->file_digest,  min_t(int, hash_alg->digest_size, out_digest_sz));
+	memcpy(arg->digest, vi->file_digest,
+	       min(hash_alg->digest_size, out_digest_sz));
 
 	/* fill the extra buffer with zeros */
 	if (out_digest_sz > hash_alg->digest_size)
-		memset(arg->digest + arg->digest_size, 0, out_digest_sz - hash_alg->digest_size);
+		memset(arg->digest + hash_alg->digest_size, 0,
+		       out_digest_sz - hash_alg->digest_size);
 
 	return 0;
 }


