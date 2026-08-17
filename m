Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792AD439F7F;
	Mon, 17 Aug 2026 13:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974610; cv=none; b=N6SaIIwMFmeOKvoqCccn2XOzcGB6JpU6ueTLVZ5qzlfhk4TNv3L5y/3EnA3SjHm7F6uYqQniLCmj1mU95Cuiw8VVW4QazAukvQyjLubhLGNcVma6yUoud17SQwfDKGc4SM+cD4OJ3GMZQ98vSPT49aGZmIiAb0N6ESAIu+K1dG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974610; c=relaxed/simple;
	bh=G0qLG/yQ4Y0WFMsXpM1XRe118Kqd+eF5Jjw0zfnKuLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLkmA9S/WZSqE8E37kp4rCGBOjNC/wBVtRTDS0SrnQmSZPcgpR8FQ6zhA9MuaZYwf22eNLI+4GpvgIJi34tfuXM+who2+DIwjqs7Svky4ZpkedaNchJCzr8jZwK2VUbM/D8I/k9eQo8UybusDweK86snITL0Nc0DizsNKbq4+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6RSzDvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6RSzDvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704C71F000E9;
	Mon, 17 Aug 2026 13:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974603;
	bh=u+A3/g0Vvwu3jzFPMyyNU1qO7at2QqF/YW+Bi4ma/H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6RSzDvFU3+emcejT9I1T2BNTiSCqlcbvH7RSvBvoltKtDS3213NBiwJXYEiQQ21F
	 7SR5x4wKg5kyMP400r+6KijY8SwyhliXbVVMYkASB/RA4vu5zqaxdtlwi47OolKPDK
	 2yEliKJRnOLZ4vNV1j3GfJx6tg0QaCP1fSDQIYaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 7.1 263/271] fsverity: Fix bpf_get_fsverity_digest() dynptr assumptions
Date: Mon, 17 Aug 2026 15:33:08 +0200
Message-ID: <20260817132547.544441787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


