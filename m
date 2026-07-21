Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4946D2D5;
	Tue, 21 Jul 2026 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659653; cv=none; b=fFRJYYvjvRp4BJW/iIyAnwPAzYQCh0HJwqPzoSP9VWNpxLbFRnrDJP9VnFD1y7k+AdCBftp0celc+PGsCd8iSQtJUWPl5Nwm15WRafmRAargS6ZVfrlhHNbgbHHsrsEBaNY0A0bOENuKFuxUcrMCYxdZkZkbIpWm8rwf8YFCVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659653; c=relaxed/simple;
	bh=jZYdqOEzf7eZ/tc0DOnVj+7iQb9M5kKuNuWvySeSE3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRbM3nI5dsyptwpDNa543GJoJqdtKRuMk4iDaL1JFQLD9NCW90kBavCrYthSRyPa9eBcSWNnjHMD87SbtxTAHNwA+CPp9Z6BokUewgiEobEDLRxpI57+IrddJNkJC+J6+dyX583jJpUhFOC3ZfG4RigcibS//TtYW9k3jIPXKKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpHw6SDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpHw6SDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E551F000E9;
	Tue, 21 Jul 2026 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659651;
	bh=Iw/yx13ixDklXES9HUI4OzoRSZVoxGWl4/jA7djAuIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpHw6SDDyGlHBY8TmM42EDoKBiJY1P62yTjlNMIKWLUCjm9fEYkAUqZ7xprtv7DDI
	 5eNccRVdbeWH8g/UhArZGLw2whg3MikSpujYccXzlqqZ1N9cFmUso+G6dOI5FmBMDF
	 KheOhh9MmYhI2Z0Pz/P0B8d0AOFPuzhha5X0OFhc=
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
Subject: [PATCH 6.18 1601/1611] bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uninitialized
Date: Tue, 21 Jul 2026 17:28:37 +0200
Message-ID: <20260721152551.487375329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit a6f0643e4f63cfaa0d5d4a69de4f132eac4b8fe4 ]

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
@@ -56,6 +58,8 @@ bool bpf_lsm_hook_returns_errno(u32 btf_
 
 #else /* !CONFIG_BPF_LSM */
 
+#define bpf_lsm_initialized false
+
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
 {
 	return false;
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -181,6 +181,15 @@ static int notsupp_get_next_key(struct b
 
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
@@ -24,6 +26,7 @@ static int __init bpf_lsm_init(void)
 {
 	security_add_hooks(bpf_lsm_hooks, ARRAY_SIZE(bpf_lsm_hooks),
 			   &bpf_lsmid);
+	bpf_lsm_initialized = true;
 	pr_info("LSM support for eBPF active\n");
 	return 0;
 }


