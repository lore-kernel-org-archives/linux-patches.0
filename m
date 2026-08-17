Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A489441625;
	Mon, 17 Aug 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974611; cv=none; b=Pe8D26ltkgJEmmPUwq2Qwd6UD68aQ808YYer4vDnA2r66VTvQ8h7ECS0wS6JVvJ1e2HsUoB/BCX1HTw8codMIvklqpku27y8rY/e/q9QfSjcrXCLQ/hZ9cpR6GkyAgTOb97rw+uvhrq3owpuaIV2dKNij/rY/YraXYh+0cvzMNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974611; c=relaxed/simple;
	bh=uMzoVgjsNADTePFgi1Rsjojb44emKUgtS/PaKfzKysA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBEH1YQNqzRKxU8PQ/vR57sMSSiwCkayGA7/PYO5EoL4Czd1fAPQYCwaaCtTuNaMcIsdfTEm8N1w1DYl3jE44ej243BMqhkCpnOc3OWLkuhP5N6+KyHO9csStse4dyxN++k3o9qFOC7NWBy9X2TNhwxIZxxZlyFDoMkyxxu3uWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDUqKKs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDUqKKs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECC1F00A3A;
	Mon, 17 Aug 2026 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974605;
	bh=fYVQJq/vgyqTN6xvUM8OhBYGG/kbZ6LM0LrxEWo++ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDUqKKs/xBfalxILO89ssAXoY9ma/zXQq2ZLB2LSDa/jdLH07iao5rDGtyXCcIwT+
	 pG/MdaFjuL7jcfinin0vpMS3gOIk/RvhjGgJ3yG3irb6jcXwENLKqB+BbgUB5SCAiv
	 81oKfugsLCdmaExFxlUWubw4rsu7IEUdQX9gsbvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 7.1 264/271] fsverity: Fix silent truncation in bpf_get_fsverity_digest()
Date: Mon, 17 Aug 2026 15:33:09 +0200
Message-ID: <20260817132547.583024452@linuxfoundation.org>
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
@@ -144,14 +144,15 @@ __bpf_kfunc int bpf_get_fsverity_digest(
 
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


