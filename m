Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C83CAA3A;
	Sat, 17 Oct 2026 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255367; cv=none; b=neZuuSHK3kNjhNANxK5i8N5A1+33dp8HPMWK1Jr5G1mnIfQ1dHDXrFUBbPOoQOmnG4h6vGxTnF8IHWdz0H8/M/EfK+LYOgSpyaK9uLg2fYeN6zkQ6AKMLNkCGW1gX6qiVcXWZgVLwMbhSOe2ma9LPtb9TWkzdPqs6BgIFChcLL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255367; c=relaxed/simple;
	bh=qeDRzyl7nm7cs1gJ1A1GQOaDfF8i/atm6ScnGz9OrbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N01YQRZKbocoYGZ2nq2/6Ya0lJa4kOUQQYhn9BhZJwYQCiiXoI0u8E/T77EDHmEZjYTrSN3mVTp2k+eRO5/+8hqcVJ26TAUZLHusAlZ09kIo5zxSZw1EIh2a5bW0VYHEA6iyxdyBBu9oV8O63SfztZfqILbm2A9RF4sXZHsWSUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hpy9d77d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hpy9d77d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895DA1F000C4;
	Sat, 17 Oct 2026 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255366;
	bh=3+xd6Z0cG84HG6Kheqds3mRVqQsgVtbQLSN9pswvJ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hpy9d77dYZZ3NK74mhA2XbMQ7SHZ/pSt5urTQgqMmxj42zTFB5uCHYxf/6cfNYqpU
	 Mc1Z9UtnX/yQGOE35L0gcKSYFzwr8CKgjU7LeqlzLytpzOFDxwPfmTnV0UMIgdpJK8
	 4U2Byhv47OHyzB/QtR7SDqSsmuKjFC/EGpw0j8/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 709/869] bpf: Reject writes through untrusted BTF pointers
Date: Sat, 17 Oct 2026 17:59:10 +0200
Message-ID: <20261017160055.138710670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit ac65c710cc643cbc52b899627577357867249530 ]

check_ptr_to_btf_access() lets program-type btf_struct_access callbacks
validate writes before the default BTF access path rejects non-read
accesses. That bypasses the read-only policy for untrusted BTF pointers
created by helpers such as bpf_rdonly_cast().

Reject non-read accesses through PTR_UNTRUSTED BTF pointers at the
common entry point, before the callback branch to handle all cases.

Fixes: 282de143ead9 ("bpf: Introduce allocated objects support")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7c814248e842c..ba665811c7fe6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6907,6 +6907,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
+	if (atype != BPF_READ && (type_flag(reg->type) & PTR_UNTRUSTED)) {
+		verbose(env, "only read is supported\n");
+		return -EACCES;
+	}
+
 	if (env->ops->btf_struct_access && !type_is_alloc(reg->type) && atype == BPF_WRITE) {
 		if (!btf_is_kernel(reg->btf)) {
 			verbose(env, "verifier internal error: reg->btf must be kernel btf\n");
@@ -6915,8 +6920,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		ret = env->ops->btf_struct_access(&env->log, reg, off, size);
 	} else {
 		/* Writes are permitted with default btf_struct_access for
-		 * program allocated objects (which always have ref_obj_id > 0),
-		 * but not for untrusted PTR_TO_BTF_ID | MEM_ALLOC.
+		 * program allocated objects (which always have ref_obj_id > 0).
 		 */
 		if (atype != BPF_READ && !type_is_ptr_alloc_obj(reg->type)) {
 			verbose(env, "only read is supported\n");
-- 
2.53.0



