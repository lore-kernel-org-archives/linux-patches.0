Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307B23A59BC;
	Sat, 17 Oct 2026 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260206; cv=none; b=lqW1Xx/k18Nr2okqtgLqQ5hMclh5Uvb/+n11XcwKySHZbtnooP/51JwcBMtfkUlE9NvyY/lWd46Gekgqjy/VGXnOGB6S4EXCeipROg5dz8U65tKEc/KDi3keht1Rgelh/xctDL+nf8t1XLdEbl+v+CA1tnc+X2fdykq9EjU9ppA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260206; c=relaxed/simple;
	bh=tmkqWH/oREp6IPA3fs3NtCkBV8Lsvq2ilVDeNbLcHzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tThIN6LTOeJWetyoZ3l40Oe4DgJII05NQVl/od/wdfMf9mioIW8QTJXblEpZcLxagxTbORpSnR5ayW1ADvVuhcWXaR1HO847e6mJUpdiRSbpx3amDYzcbGq1dy2fhKwNTClN24qh2x6AahZViuhhmQsg+R99Yz6MgB3rg9B7wso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMrc5lHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMrc5lHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E061F000C4;
	Sat, 17 Oct 2026 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260205;
	bh=eH1I/2ASHcHJ4uKN8jnh8Rd32haEe6kbY62UVLmRx/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMrc5lHfSUiEEshikag2i2uMddqskAfIRRGlKWYFKuEaRlZKgYNXjtBEGnft+JbD5
	 200j4HwD4mkzNOa20XSXrVRZx1G/45pF1KMFfFku6QDsJapB4OrRG3uNyJEv6OlhA0
	 ZVdJk2UKdBHGjE1eeavxydl32ccGmLjIRkgco39Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Pu Lehui <pulehui@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1469/1674] bpf: Fix WARNING in bpf_tracing_link_release
Date: Sat, 17 Oct 2026 18:02:21 +0200
Message-ID: <20261017160508.875408407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/bpf.h     | 2 ++
 kernel/bpf/trampoline.c | 7 +++++++
 kernel/bpf/verifier.c   | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 12a2d3efdad1f..98f9792960cdd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1267,6 +1267,7 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags);
 int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
 
 /*
@@ -1361,6 +1362,7 @@ static inline struct bpf_trampoline *bpf_trampoline_get(u64 key,
 	return NULL;
 }
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
+static inline void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags) {}
 #define DEFINE_BPF_DISPATCHER(name)
 #define DECLARE_BPF_DISPATCHER(name)
 #define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nop_func
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index a75c3bdaa35ae..4eebb9e22d26e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -392,6 +392,13 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key)
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
index c3fd1a2148e9e..ac801a81f1967 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20652,7 +20652,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -ENOMEM;
 
 	if (tgt_prog && tgt_prog->aux->tail_call_reachable)
-		tr->flags = BPF_TRAMP_F_TAIL_CALL_CTX;
+		bpf_trampoline_set_flags(tr, BPF_TRAMP_F_TAIL_CALL_CTX);
 
 	prog->aux->dst_trampoline = tr;
 	return 0;
-- 
2.53.0



