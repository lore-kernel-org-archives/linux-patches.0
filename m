Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9260376BCD;
	Sat, 12 Sep 2026 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219432; cv=none; b=HPqH1FCE/ggHbVp8lGdhC5ynhKa0u/Pf6tW4lf87Mh/CNFPRbXmKlmMWbwmhTz8M3v6j0A1bwAZ9f4yyhvS9n0Tk67kpA4cO3J8UEEcFDf5gUvEEueDyWAEGBSoQ8B4NVYSKyZxRORH0ZVTLAV+RzEJC9OMpTIOioTgCTY4q1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219432; c=relaxed/simple;
	bh=n+kixdauVlyJqGyoT/pYUO5l/yUC/ZDqvSoQg5IqW5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aTzOgHo7vsuLfn1+rgwQTASVO3bUOQf+IVwX7KdURAVlNTcelyoj9cGbH9YX72/r3WGnoL2aExAcE11OpOVAe38vArrSqwiQvAPbMkQldaT1C9TnaHLiTyh8WflvcIw3YRDBqCZRwILWfQPNlApKFX5qm2HR/z9Ny/fTLm/Qzvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzaVUo+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzaVUo+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BEB1F000FF;
	Sat, 12 Sep 2026 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219430;
	bh=MfAT3VTYkrBTEAUg3kLB4H6gyiMP+B+8YbJ/spY5QQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzaVUo+ZMENtOb1ynue/R4EYe0VlCfmWa5qKnR8/utxESI7l+WlDVbRo8gjD8W3eA
	 McfvBbFREd8oGv5A3e6gTjzeIlkel58c8Sf7LkRN6MmDKGjxA6/lm+emuWYSJP3pvl
	 K9kGJovmBprszT5dZcEiQEd7/2JejQte5ae76bnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1350/1376] bpf: fix BPF_PROG_QUERY OOB write and cgroup backward compat
Date: Sat, 12 Sep 2026 09:02:56 +0200
Message-ID: <20260912065637.620183665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 21c4b99b27f3f85b89256e81b3e997dec0a460d0 ]

BPF_PROG_QUERY writes back the 'query.revision' field unconditionally to
userspace. If userspace passes a smaller 'bpf_attr' structure (e.g. 40
bytes, which was the layout before the addition of 'query.revision'),
the kernel performs an out-of-bounds write.

Fix this by propagating the user-provided attribute size 'uattr_size'
down to the cgroup query handlers, and conditionally skipping writing
the revision field to userspace when the provided buffer size is
insufficient.

query.revision in bpf_mprog_query is structurally identical to the
cgroup case: a late tail field, written unconditionally.

But the backward-compat hazard is not the same.

The min-historical-size test is per command, and bpf_mprog_query only
serves attach types that were born with revision in the struct:

- tcx_prog_query -> BPF_TCX_INGRESS/EGRESS
- netkit_prog_query -> BPF_NETKIT_PRIMARY/PEER

tcx, netkit, the revision field, and bpf_mprog_query itself all landed in
the same v6.6 merge window (053c8e1f235d added the mprog query API +
revision; tcx in e420bed02507, netkit in 35dfaad7188c). There has never
been a tcx/netkit BPF_PROG_QUERY userspace that doesn't know about
revision. So for these commands the minimum legitimate struct already
covers offset 56-64 — no old binary can be broken here.

Contrast with cgroup: BPF_PROG_QUERY on cgroup attach types shipped in
2017; revision write-back was bolted on years later (120933984460). That
path has a real population of pre-revision callers.

Fixes: 120933984460 ("bpf: Implement mprog API on top of existing cgroup progs")
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Link: https://lore.kernel.org/r/20260531075600.4058207-2-yuyanghuang@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h |  5 +++--
 kernel/bpf/cgroup.c        | 13 +++++++------
 kernel/bpf/syscall.c       |  6 +++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 26ee360c345fa..a0b5104558124 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -420,7 +420,7 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype);
 int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 int cgroup_bpf_prog_query(const union bpf_attr *attr,
-			  union bpf_attr __user *uattr);
+			  union bpf_attr __user *uattr, u32 uattr_size);
 
 const struct bpf_func_proto *
 cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
@@ -451,7 +451,8 @@ static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
 }
 
 static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
-					union bpf_attr __user *uattr)
+					union bpf_attr __user *uattr,
+					u32 uattr_size)
 {
 	return -EINVAL;
 }
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index fa2b9f033d84e..b30ea11d93dba 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1216,7 +1216,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 
 /* Must be called with cgroup_mutex held to avoid races. */
 static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-			      union bpf_attr __user *uattr)
+			      union bpf_attr __user *uattr, u32 uattr_size)
 {
 	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
 	bool effective_query = attr->query.query_flags & BPF_F_QUERY_EFFECTIVE;
@@ -1267,7 +1267,8 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		return -EFAULT;
 	if (!effective_query && from_atype == to_atype)
 		revision = cgrp->bpf.revisions[from_atype];
-	if (copy_to_user(&uattr->query.revision, &revision, sizeof(revision)))
+	if (uattr_size >= offsetofend(union bpf_attr, query.revision) &&
+	    copy_to_user(&uattr->query.revision, &revision, sizeof(revision)))
 		return -EFAULT;
 	if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
 		/* return early if user requested only program count + flags */
@@ -1320,12 +1321,12 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 }
 
 static int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-			    union bpf_attr __user *uattr)
+			    union bpf_attr __user *uattr, u32 uattr_size)
 {
 	int ret;
 
 	cgroup_lock();
-	ret = __cgroup_bpf_query(cgrp, attr, uattr);
+	ret = __cgroup_bpf_query(cgrp, attr, uattr, uattr_size);
 	cgroup_unlock();
 	return ret;
 }
@@ -1529,7 +1530,7 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 }
 
 int cgroup_bpf_prog_query(const union bpf_attr *attr,
-			  union bpf_attr __user *uattr)
+			  union bpf_attr __user *uattr, u32 uattr_size)
 {
 	struct cgroup *cgrp;
 	int ret;
@@ -1538,7 +1539,7 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
 	if (IS_ERR(cgrp))
 		return PTR_ERR(cgrp);
 
-	ret = cgroup_bpf_query(cgrp, attr, uattr);
+	ret = cgroup_bpf_query(cgrp, attr, uattr, uattr_size);
 
 	cgroup_put(cgrp);
 	return ret;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ac5500541c7d2..954b299f241b6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4227,7 +4227,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 #define BPF_PROG_QUERY_LAST_FIELD query.revision
 
 static int bpf_prog_query(const union bpf_attr *attr,
-			  union bpf_attr __user *uattr)
+			  union bpf_attr __user *uattr, u32 uattr_size)
 {
 	if (!bpf_net_capable())
 		return -EPERM;
@@ -4266,7 +4266,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 	case BPF_LSM_CGROUP:
-		return cgroup_bpf_prog_query(attr, uattr);
+		return cgroup_bpf_prog_query(attr, uattr, uattr_size);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
@@ -5720,7 +5720,7 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size)
 		err = bpf_prog_detach(&attr);
 		break;
 	case BPF_PROG_QUERY:
-		err = bpf_prog_query(&attr, uattr.user);
+		err = bpf_prog_query(&attr, uattr.user, size);
 		break;
 	case BPF_PROG_TEST_RUN:
 		err = bpf_prog_test_run(&attr, uattr.user);
-- 
2.53.0



