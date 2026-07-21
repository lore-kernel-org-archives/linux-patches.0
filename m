Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7871546EF9C;
	Tue, 21 Jul 2026 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664605; cv=none; b=VtQvAXUJCY1FQUQchOWsK+UE3zV4SHitnzynPuKYXvZmqsZ4/evzR5UYvEQwk4UVUblHC+JQC41iGwJTTJGxwzmYa+s7Dy5X5ka5cnDleyQ4hlD2EbNDnUy8d2rDkEtdUSvBrK9rXdRlA7tddUOqyDM0VR/EpfsyO8wGL0S7ad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664605; c=relaxed/simple;
	bh=qRQqp+1BMPvDeitrmoZvcUTX8fCytmT7yIx1R33xWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/2lU+Khn0w5asPmqsQS+Mqm2tN+rgHvS0moxLNkW1mhtYIp+sLeuLrUIrjprcLQJI/1Fa/XUUfJB2dyPVfngUtHc4juI3wUCLl6j5hTNtTqDaP5wGlm3iW0GiSLQ5f1oI/C1jipjBOHXQan2dbPCHdmmY0wUjsuhEMnHHGTjG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li47cJZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li47cJZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA791F00A3A;
	Tue, 21 Jul 2026 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664604;
	bh=HTMkTUudPd3bKcI5Qd7GXidFKLBnl/BS4CLnsaUA0AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li47cJZ2+6fJGdNxhJk5xrdlIM1jN+BFiohqoOD0/F2bge3nB2yYVs+QioBcmI2pP
	 dPc0ymPwkeMfIEqW73qGMgmd7/BIh0j+AZ8xYuv9m6ofu8uD4bVKbKRZvyoORInhXd
	 QyXxBdsnR5qyigrLQSF6VoFEs0/AHNJeyONGvWLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	oxsignal <awo@kakao.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1246/1276] bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uninitialized
Date: Tue, 21 Jul 2026 17:28:09 +0200
Message-ID: <20260721152513.979249707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Matt Bobrowski <mattbobrowski@google.com>

commit a6f0643e4f63cfaa0d5d4a69de4f132eac4b8fe4 upstream.

When CONFIG_BPF_LSM=y is set, BPF inode storage maps
(BPF_MAP_TYPE_INODE_STORAGE) are compiled into the kernel. However,
if the BPF LSM is not explicitly enabled at boot time (e.g. omitted
from the "lsm=" boot parameter), lsm_prepare() is never executed for
the BPF LSM.

Consequently, the BPF inode security blob offset
(bpf_lsm_blob_sizes.lbs_inode) is never initialized and remains at
its default compiled size of 8 bytes instead of being updated to a
valid offset past the reserved struct rcu_head (typically 16 bytes
or more).

When a privileged user creates and updates a BPF_MAP_TYPE_INODE_STORAGE
map, bpf_inode() evaluates inode->i_security + 8. This erroneously
aliases the struct rcu_head.func callback pointer at the beginning
of the inode->i_security blob. During subsequent map element cleanup
or inode destruction, writing NULL to owner_storage clears the queued
RCU callback pointer. When rcu_do_batch() later executes the queued
callback, it attempts an instruction fetch at address 0x0, triggering
an immediate kernel panic.

Fix this by introducing a global bpf_lsm_initialized boolean flag
marked with __ro_after_init. Set this flag to true inside bpf_lsm_init()
when the LSM framework successfully registers the BPF LSM. Gate map
allocation in inode_storage_map_alloc() on this flag, returning
-EOPNOTSUPP if the BPF LSM is in turn uninitialized.

This fail-fast approach prevents userspace from allocating inode
storage maps when the supporting BPF LSM infrastructure is absent,
avoiding zombie map states.

Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
Reported-by: oxsignal <awo@kakao.com>
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/bpf/20260628201103.3624525-1-mattbobrowski@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_lsm.h        |    4 ++++
 kernel/bpf/bpf_inode_storage.c |    9 +++++++++
 security/bpf/hooks.c           |    3 +++
 3 files changed, 16 insertions(+)

--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -14,6 +14,8 @@
 
 #ifdef CONFIG_BPF_LSM
 
+extern bool bpf_lsm_initialized __ro_after_init;
+
 #define LSM_HOOK(RET, DEFAULT, NAME, ...) \
 	RET bpf_lsm_##NAME(__VA_ARGS__);
 #include <linux/lsm_hook_defs.h>
@@ -50,6 +52,8 @@ int bpf_lsm_get_retval_range(const struc
 			     struct bpf_retval_range *range);
 #else /* !CONFIG_BPF_LSM */
 
+#define bpf_lsm_initialized false
+
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
 {
 	return false;
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -182,6 +182,15 @@ static int notsupp_get_next_key(struct b
 
 static struct bpf_map *inode_storage_map_alloc(union bpf_attr *attr)
 {
+	/*
+	 * Do not allow allocation of BPF_MAP_TYPE_INODE_STORAGE if the BPF LSM
+	 * was not initialized by the LSM framework at boot. Without proper
+	 * initialization, the BPF inode security blob offset remains unprepared,
+	 * causing bpf_inode() to calculate an invalid memory offset and corrupt
+	 * inode->i_security.
+	 */
+	if (!bpf_lsm_initialized)
+		return ERR_PTR(-EOPNOTSUPP);
 	return bpf_local_storage_map_alloc(attr, &inode_cache, false);
 }
 
--- a/security/bpf/hooks.c
+++ b/security/bpf/hooks.c
@@ -7,6 +7,8 @@
 #include <linux/bpf_lsm.h>
 #include <uapi/linux/lsm.h>
 
+bool bpf_lsm_initialized __ro_after_init;
+
 static struct security_hook_list bpf_lsm_hooks[] __ro_after_init = {
 	#define LSM_HOOK(RET, DEFAULT, NAME, ...) \
 	LSM_HOOK_INIT(NAME, bpf_lsm_##NAME),
@@ -25,6 +27,7 @@ static int __init bpf_lsm_init(void)
 {
 	security_add_hooks(bpf_lsm_hooks, ARRAY_SIZE(bpf_lsm_hooks),
 			   &bpf_lsmid);
+	bpf_lsm_initialized = true;
 	pr_info("LSM support for eBPF active\n");
 	return 0;
 }


