Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7499934F279;
	Tue, 21 Jul 2026 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656876; cv=none; b=haTRcRLeD0/czk7hVLihMio1FS+5WzGq/0hHqygC2dywNqeehXODffejv65ZhWuNigChpqZ5U0EDwphpHekyNrIbcOaxkPdtEv83NRfkZgLihfp8Me/Y3Bq8bbXJR96Q/6PSqdYxxZNgBWrzbxqVeuLcHnPqyZzphJL/9a+x+EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656876; c=relaxed/simple;
	bh=LsvgQ0QMa5EEtM0G/zw0SoZYSx4JCOE3pzeZ5cFw7hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUJ3tCoVBgUgMq1MmTthFGucRzFEgtatN4y/V5wGSmbR9hAyk5i4ckDxQRh8lulcz/TmJG68ub0xCSfKSavlhm1s+kN2+47CDQXIjpP579lN4bO8ev3AUfCxGosGdpMiesJCvIuLF0rplXQ3LWtYzuBOVNr2BGF/vKvACp6ckXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJ+TO6O8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJ+TO6O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65241F00A3D;
	Tue, 21 Jul 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656875;
	bh=QbgyKMDnjvzkUnrPpUTBnnNeDBUOGsduQgwbmS/x3Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJ+TO6O8ChDvJt7ztYfHkZ2zrXJNp7Ui/I/Eh2aiKV8NJCYCjnK/iHGJoAFrifVj9
	 HZtUgd8DR/Z+Rfk+1JsIeHHU61NtzYhBNOVezj0VBYs7Vyi+fhpqJlJukCju/ee5V8
	 B5N9br/Wa+GrUB5ng2gPXaQOgHDsGhiri47qKZb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0515/1611] bpf: Fix setting retval to -EPERM for cgroup hooks not returning errno
Date: Tue, 21 Jul 2026 17:10:31 +0200
Message-ID: <20260721152526.930296467@linuxfoundation.org>
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

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 4c71303c837449158815c521fcee4ec3b8721dbd ]

When a cgroup BPF program exits with 0, bpf_prog_run_array_cg() sets
the hook return value to -EPERM if it is not a valid errno. This is
correct for errno-based hooks, which return 0 on success and negative
errno on failure, but wrong for boolean and void LSM hooks. Boolean
LSM hooks should only return true or false, and void LSM hooks have
no return value at all.

Fix it by skipping setting -EPERM for hooks not returning errno.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20260610201724.733943-2-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_lsm.h |  6 ++++++
 kernel/bpf/bpf_lsm.c    | 20 ++++++++++++++++++
 kernel/bpf/cgroup.c     | 47 +++++++++++++++++++++++++++++------------
 3 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 643809cc78c33e..143775a27a2a0b 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -52,6 +52,7 @@ int bpf_set_dentry_xattr_locked(struct dentry *dentry, const char *name__str,
 				const struct bpf_dynptr *value_p, int flags);
 int bpf_remove_dentry_xattr_locked(struct dentry *dentry, const char *name__str);
 bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog);
+bool bpf_lsm_hook_returns_errno(u32 btf_id);
 
 #else /* !CONFIG_BPF_LSM */
 
@@ -104,6 +105,11 @@ static inline bool bpf_lsm_has_d_inode_locked(const struct bpf_prog *prog)
 {
 	return false;
 }
+
+static inline bool bpf_lsm_hook_returns_errno(u32 btf_id)
+{
+	return true;
+}
 #endif /* CONFIG_BPF_LSM */
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 2eead789b898ba..554985ce9025ac 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -421,6 +421,26 @@ BTF_ID(func, bpf_lsm_audit_rule_known)
 BTF_ID(func, bpf_lsm_inode_xattr_skipcap)
 BTF_SET_END(bool_lsm_hooks)
 
+/* hooks returning void */
+#define LSM_HOOK_void(DEFAULT, NAME, ...) BTF_ID(func, bpf_lsm_##NAME)
+#define LSM_HOOK_int(DEFAULT, NAME, ...)  /* nothing */
+#define LSM_HOOK(RET, DEFAULT, NAME, ...) LSM_HOOK_##RET(DEFAULT, NAME, __VA_ARGS__)
+BTF_SET_START(void_lsm_hooks)
+#include <linux/lsm_hook_defs.h>
+#undef LSM_HOOK
+#undef LSM_HOOK_void
+#undef LSM_HOOK_int
+BTF_SET_END(void_lsm_hooks)
+
+bool bpf_lsm_hook_returns_errno(u32 btf_id)
+{
+	if (btf_id_set_contains(&bool_lsm_hooks, btf_id))
+		return false;
+	if (btf_id_set_contains(&void_lsm_hooks, btf_id))
+		return false;
+	return true;
+}
+
 int bpf_lsm_get_retval_range(const struct bpf_prog *prog,
 			     struct bpf_retval_range *retval_range)
 {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 008b3a9be0c418..c00e440fb36b64 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -55,6 +55,28 @@ void __init cgroup_bpf_lifetime_notifier_init(void)
 						&cgroup_bpf_lifetime_nb));
 }
 
+#ifdef CONFIG_BPF_LSM
+struct cgroup_lsm_atype {
+	u32 attach_btf_id;
+	int refcnt;
+	bool returns_errno;
+};
+
+static struct cgroup_lsm_atype cgroup_lsm_atype[CGROUP_LSM_NUM];
+
+static bool cgroup_bpf_hook_returns_errno(enum cgroup_bpf_attach_type atype)
+{
+	if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
+		return READ_ONCE(cgroup_lsm_atype[atype - CGROUP_LSM_START].returns_errno);
+	return true;
+}
+#else
+static bool cgroup_bpf_hook_returns_errno(enum cgroup_bpf_attach_type atype)
+{
+	return true;
+}
+#endif
+
 /* __always_inline is necessary to prevent indirect call through run_prog
  * function pointer.
  */
@@ -83,7 +105,8 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 			*(ret_flags) |= (func_ret >> 1);
 			func_ret &= 1;
 		}
-		if (!func_ret && !IS_ERR_VALUE((long)run_ctx.retval))
+		if (!func_ret && cgroup_bpf_hook_returns_errno(atype) &&
+		    !IS_ERR_VALUE((long)run_ctx.retval))
 			run_ctx.retval = -EPERM;
 		item++;
 	}
@@ -156,13 +179,6 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
 }
 
 #ifdef CONFIG_BPF_LSM
-struct cgroup_lsm_atype {
-	u32 attach_btf_id;
-	int refcnt;
-};
-
-static struct cgroup_lsm_atype cgroup_lsm_atype[CGROUP_LSM_NUM];
-
 static enum cgroup_bpf_attach_type
 bpf_cgroup_atype_find(enum bpf_attach_type attach_type, u32 attach_btf_id)
 {
@@ -191,10 +207,13 @@ void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	WARN_ON_ONCE(cgroup_lsm_atype[i].attach_btf_id &&
-		     cgroup_lsm_atype[i].attach_btf_id != attach_btf_id);
-
-	cgroup_lsm_atype[i].attach_btf_id = attach_btf_id;
+	if (!cgroup_lsm_atype[i].attach_btf_id) {
+		cgroup_lsm_atype[i].attach_btf_id = attach_btf_id;
+		WRITE_ONCE(cgroup_lsm_atype[i].returns_errno,
+			   bpf_lsm_hook_returns_errno(attach_btf_id));
+	} else {
+		WARN_ON_ONCE(cgroup_lsm_atype[i].attach_btf_id != attach_btf_id);
+	}
 	cgroup_lsm_atype[i].refcnt++;
 }
 
@@ -203,8 +222,10 @@ void bpf_cgroup_atype_put(int cgroup_atype)
 	int i = cgroup_atype - CGROUP_LSM_START;
 
 	cgroup_lock();
-	if (--cgroup_lsm_atype[i].refcnt <= 0)
+	if (--cgroup_lsm_atype[i].refcnt <= 0) {
+		WRITE_ONCE(cgroup_lsm_atype[i].returns_errno, true);
 		cgroup_lsm_atype[i].attach_btf_id = 0;
+	}
 	WARN_ON_ONCE(cgroup_lsm_atype[i].refcnt < 0);
 	cgroup_unlock();
 }
-- 
2.53.0



