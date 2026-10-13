Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274414F93AD;
	Tue, 13 Oct 2026 12:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894179; cv=none; b=Kf170C3irOAbYPaw+QCgQjsKsf1+FOh+fZwHLX1acEQGIjDjbxX1fuST7erJnKoMhAylr4PA0eyF5hz8iJLpGDkLTSsr7HdY6kY5FIUzZvPFphuQA/Og6Iu8naNy9SIsGoWqFMTDY7HnC4VVqrKVT9Uy3wQ3fPGCU6V+MMWji1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894179; c=relaxed/simple;
	bh=N9JLyW7CXsmZeIgoB8dAL9BDUqW58cvA5je6S7Ka828=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7m55W6yS2iLq7Vl1fcyppivCMbrcdtGF36FCvmZqdqq7Nf6A3H+JSGEdmIGrfqglNUGO0TZbW8UuVRM+KhNel1goJqYoZgdyz/htyCdFD2pGYKLWmctqfvQU2xkTDzgwj11T8fGGl80+oeQaoYLF2IManY8yT9dCvOml7uVvbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb6/UnPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb6/UnPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCB11F000FF;
	Tue, 13 Oct 2026 12:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894178;
	bh=8aij0gRZ5hAnAr8B9uUZAIROiRA5miDJNxcVmMOcU7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jb6/UnPpp5ulWg8fPA87nTKJX694BmsHICmq3MRA74uIY/K1LVrWpej4Y0KuuUgnm
	 MNzbukH+BbA7iVohBj7StQjEdx+grQE/XJnlP5OYVF58VD9T1yCf8Yqr/iVknjX1Wv
	 DdM0vSJCm5vMTISKDXC62qcGKG8VhEz9P+DPLuvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Pu Lehui <pulehui@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 472/621] bpf: Fix WARNING in bpf_tracing_link_release
Date: Tue, 13 Oct 2026 13:37:47 +0200
Message-ID: <20261013112932.035323623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 61aaa8782bec59ecffd22e030f54ef9351bcabf9 ]

The trampoline could be corrupted by the blindly
'tr->flags = BPF_TRAMP_F_TAIL_CALL_CTX' in verifier.

1. A fexit attached to a tail_call_reachable prog. 'tr->flags' became
   'BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_TAIL_CALL_CTX'. And, the
   trampoline would poke the target prog's nop insn using jmp insn instead
   of call insn.
2. Another fexit loaded with the same tail_call_reachable prog target.
   'tr->flags' became 'BPF_TRAMP_F_TAIL_CALL_CTX'.
3. Close the first fexit link. Due to no BPF_TRAMP_F_CALL_ORIG in
   'tr->flags', the trampoline will fail to restore the prog's nop insn
   using call insn.

[    3.410719] WARNING: kernel/bpf/syscall.c:3551 at bpf_tracing_link_release+0x53/0x60, CPU#1: test_progs/98
...
[    3.428793]  bpf_link_free+0x58/0x130
[    3.429293]  bpf_link_release+0x23/0x30

Fix the warning by updating 'tr->flags' with '|=' and lock.

Fixes: 2b5dcb31a19a ("bpf, x64: Fix tailcall infinite loop")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20260722151909.69142-2-leon.hwang@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h     | 3 +++
 kernel/bpf/trampoline.c | 7 +++++++
 kernel/bpf/verifier.c   | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 862d6e0d5a287..774603d0a8bae 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1399,6 +1399,8 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
 
+void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags);
+
 /*
  * When the architecture supports STATIC_CALL replace the bpf_dispatcher_fn
  * indirection with a direct call to the bpf program. If the architecture does
@@ -1507,6 +1509,7 @@ static inline bool bpf_prog_has_trampoline(const struct bpf_prog *prog)
 {
 	return false;
 }
+static inline void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags) {}
 #endif
 
 struct bpf_func_info_aux {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 40f19147f227e..ccb943b7ac2c1 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -397,6 +397,13 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, int size)
 	return ERR_PTR(err);
 }
 
+void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags)
+{
+	mutex_lock(&tr->mutex);
+	tr->flags |= flags;
+	mutex_unlock(&tr->mutex);
+}
+
 static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex)
 {
 	struct bpf_tramp_image *im;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 73bebb1078972..c1e46c0cce981 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24601,7 +24601,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -ENOMEM;
 
 	if (tgt_prog && tgt_prog->aux->tail_call_reachable)
-		tr->flags = BPF_TRAMP_F_TAIL_CALL_CTX;
+		bpf_trampoline_set_flags(tr, BPF_TRAMP_F_TAIL_CALL_CTX);
 
 	prog->aux->dst_trampoline = tr;
 	return 0;
-- 
2.53.0



