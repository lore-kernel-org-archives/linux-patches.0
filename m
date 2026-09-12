Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F0368D5A;
	Sat, 12 Sep 2026 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199742; cv=none; b=fXJ4jVTiDygBcCrJqDN43adUWUvICy/F1WjcHvvURy9wVr8G3VBT9e3ImEptAv5WdbCwH/UsOVvv7wslD/dJLX7mSMCgya5Y/VmnLJbKwMAXRhZzIhyRGWvhW29+05GxncZJY3Ad/1JQjf5BDOLOQi+8o5ns+BNmuSmz+uPIoc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199742; c=relaxed/simple;
	bh=OtnRbOaY0hzsTNWqZlo5Ns3E36fgahZ9E1QIYrhfarg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNqyoPS9XqFE7ZIXeKWFUbl4eJZujAkjhXpdDmpN7X8jcmJ9WKQq90D6et+Ev2+GWh0eLb7cw5jlXZSK65ynAQrXcb4R2pwfELAW933ybiNVPe8+4DO87waGSRiCzLlUc6Nbz6ZpAXumVUv9LDwf2BfV83H61lZQkUco7b0hpoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0wA13/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0wA13/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13FA1F000FF;
	Sat, 12 Sep 2026 07:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199741;
	bh=l4Udm6oZGLi5OANCRy613WHp7nXBSu+lxQIz/FgNONE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0wA13/eojcJE17h+RRNxWnkLXUYStkU3j9umFyyoI0vqwggRA2rDHj9ez0+eq6Ud
	 OHPfoz9yc+jPETn3ghzlgDXzWTYvWjcmWTUZXrzTU3gBOSM4U38kjp2VXQFhTwZS3r
	 Qpz9KZlwk6sz/ToTblqxphQUvbp64H77oX5z45e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Pu Lehui <pulehui@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0648/1815] bpf: Fix WARNING in bpf_tracing_link_release
Date: Sat, 12 Sep 2026 08:39:58 +0200
Message-ID: <20260912065704.092285604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 31c1fef6b59b1..52eedb71d6eb7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1524,6 +1524,7 @@ int bpf_trampoline_multi_attach(struct bpf_prog *prog, u32 *ids,
 				struct bpf_tracing_multi_link *link);
 int bpf_trampoline_multi_detach(struct bpf_prog *prog,
 				struct bpf_tracing_multi_link *link);
+void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags);
 
 /*
  * When the architecture supports STATIC_CALL replace the bpf_dispatcher_fn
@@ -1647,6 +1648,7 @@ static inline int bpf_trampoline_multi_detach(struct bpf_prog *prog,
 {
 	return -ENOTSUPP;
 }
+static inline void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags) {}
 #endif
 
 struct bpf_func_info_aux {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6eadf64f7ec90..129d07db117ec 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -670,6 +670,13 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, int size)
 	return ERR_PTR(err);
 }
 
+void bpf_trampoline_set_flags(struct bpf_trampoline *tr, u32 flags)
+{
+	trampoline_lock(tr);
+	tr->flags |= flags;
+	trampoline_unlock(tr);
+}
+
 static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex,
 				 const struct bpf_trampoline_ops *ops, void *data)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 22a122403a2e3..072275c7d4be6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19444,7 +19444,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -ENOMEM;
 
 	if (tgt_prog && tgt_prog->aux->tail_call_reachable)
-		tr->flags = BPF_TRAMP_F_TAIL_CALL_CTX;
+		bpf_trampoline_set_flags(tr, BPF_TRAMP_F_TAIL_CALL_CTX);
 
 	prog->aux->dst_trampoline = tr;
 	return 0;
-- 
2.53.0



