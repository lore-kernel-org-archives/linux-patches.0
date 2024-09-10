Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB281917D6;
	Tue, 10 Sep 2024 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964830; cv=none; b=Jg1ibt0anuUsoZ2sPp0+rJTAl0YDZAEA0hgOa4eGjI3qDhSRk7D7mHZWLhxjdcAqaf6Jz2LBKcEJb66vIkARoQm2E7PcpvN8SUkvK5xpM+xHswrf7Y0y1SLDPFtUFBE3jD1n0vj4mBizbEiP3iRaZ0dibgiOi7NWWB0RQpfdDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964830; c=relaxed/simple;
	bh=9hSOHYyuw73T9IjCW2l3EpPwRtMjJLlIDIpWNbdYHNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD+ujcvttjJ986mjQMDQaEIlBpiLsQwZcmu7H7zx7NBHAKxH8qJoP/TAL+2+uX/RizmlqTluCOvOcIOI4dZ2J0qx5Log7unazNRhMXIEBWp4PJRa0uVaFk4UEHQ7Kj7X1CxnoDkuN/PvJlU6ZrEjudEvMF/h8OU2uZjTv02uYpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPplFKvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPplFKvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E58C4CEC6;
	Tue, 10 Sep 2024 10:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964830;
	bh=9hSOHYyuw73T9IjCW2l3EpPwRtMjJLlIDIpWNbdYHNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPplFKvwQod7G0wkOC+XlOnU/gySOm41qGMUYjKkGpEt7jfXf8BhBGMH0ShNCElnk
	 kbWqYS1G0s8sMkgI/jEv+p0f+fmkc5P6/ZhUF5d7XdXrQ9NDyB19SDu13bckoTxvVf
	 l78xq/DVZNgt1xpMxeRz5jCJwkwYqf2efkbr6kXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Tejun Heo <tj@kernel.org>,
	Connor OBrien <connor.obrien@crowdstrike.com>
Subject: [PATCH 5.10 046/186] bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092556.408438961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor O'Brien <connor.obrien@crowdstrike.com>

From: Daniel Borkmann <daniel@iogearbox.net>

commit 8520e224f547cd070c7c8f97b1fc6d58cff7ccaa upstream.

Fix cgroup v1 interference when non-root cgroup v2 BPF programs are used.
Back in the days, commit bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
embedded per-socket cgroup information into sock->sk_cgrp_data and in order
to save 8 bytes in struct sock made both mutually exclusive, that is, when
cgroup v1 socket tagging (e.g. net_cls/net_prio) is used, then cgroup v2
falls back to the root cgroup in sock_cgroup_ptr() (&cgrp_dfl_root.cgrp).

The assumption made was "there is no reason to mix the two and this is in line
with how legacy and v2 compatibility is handled" as stated in bd1060a1d671.
However, with Kubernetes more widely supporting cgroups v2 as well nowadays,
this assumption no longer holds, and the possibility of the v1/v2 mixed mode
with the v2 root fallback being hit becomes a real security issue.

Many of the cgroup v2 BPF programs are also used for policy enforcement, just
to pick _one_ example, that is, to programmatically deny socket related system
calls like connect(2) or bind(2). A v2 root fallback would implicitly cause
a policy bypass for the affected Pods.

In production environments, we have recently seen this case due to various
circumstances: i) a different 3rd party agent and/or ii) a container runtime
such as [0] in the user's environment configuring legacy cgroup v1 net_cls
tags, which triggered implicitly mentioned root fallback. Another case is
Kubernetes projects like kind [1] which create Kubernetes nodes in a container
and also add cgroup namespaces to the mix, meaning programs which are attached
to the cgroup v2 root of the cgroup namespace get attached to a non-root
cgroup v2 path from init namespace point of view. And the latter's root is
out of reach for agents on a kind Kubernetes node to configure. Meaning, any
entity on the node setting cgroup v1 net_cls tag will trigger the bypass
despite cgroup v2 BPF programs attached to the namespace root.

Generally, this mutual exclusiveness does not hold anymore in today's user
environments and makes cgroup v2 usage from BPF side fragile and unreliable.
This fix adds proper struct cgroup pointer for the cgroup v2 case to struct
sock_cgroup_data in order to address these issues; this implicitly also fixes
the tradeoffs being made back then with regards to races and refcount leaks
as stated in bd1060a1d671, and removes the fallback, so that cgroup v2 BPF
programs always operate as expected.

  [0] https://github.com/nestybox/sysbox/
  [1] https://kind.sigs.k8s.io/

Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/bpf/20210913230759.2313-1-daniel@iogearbox.net
[resolve trivial conflicts]
Signed-off-by: Connor O'Brien <connor.obrien@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h  |  107 ++++++++++---------------------------------
 include/linux/cgroup.h       |   22 --------
 kernel/cgroup/cgroup.c       |   50 ++++----------------
 net/core/netclassid_cgroup.c |    7 --
 net/core/netprio_cgroup.c    |   10 ----
 5 files changed, 41 insertions(+), 155 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -764,107 +764,54 @@ static inline void cgroup_threadgroup_ch
  * sock_cgroup_data is embedded at sock->sk_cgrp_data and contains
  * per-socket cgroup information except for memcg association.
  *
- * On legacy hierarchies, net_prio and net_cls controllers directly set
- * attributes on each sock which can then be tested by the network layer.
- * On the default hierarchy, each sock is associated with the cgroup it was
- * created in and the networking layer can match the cgroup directly.
- *
- * To avoid carrying all three cgroup related fields separately in sock,
- * sock_cgroup_data overloads (prioidx, classid) and the cgroup pointer.
- * On boot, sock_cgroup_data records the cgroup that the sock was created
- * in so that cgroup2 matches can be made; however, once either net_prio or
- * net_cls starts being used, the area is overriden to carry prioidx and/or
- * classid.  The two modes are distinguished by whether the lowest bit is
- * set.  Clear bit indicates cgroup pointer while set bit prioidx and
- * classid.
- *
- * While userland may start using net_prio or net_cls at any time, once
- * either is used, cgroup2 matching no longer works.  There is no reason to
- * mix the two and this is in line with how legacy and v2 compatibility is
- * handled.  On mode switch, cgroup references which are already being
- * pointed to by socks may be leaked.  While this can be remedied by adding
- * synchronization around sock_cgroup_data, given that the number of leaked
- * cgroups is bound and highly unlikely to be high, this seems to be the
- * better trade-off.
+ * On legacy hierarchies, net_prio and net_cls controllers directly
+ * set attributes on each sock which can then be tested by the network
+ * layer. On the default hierarchy, each sock is associated with the
+ * cgroup it was created in and the networking layer can match the
+ * cgroup directly.
  */
 struct sock_cgroup_data {
-	union {
-#ifdef __LITTLE_ENDIAN
-		struct {
-			u8	is_data : 1;
-			u8	no_refcnt : 1;
-			u8	unused : 6;
-			u8	padding;
-			u16	prioidx;
-			u32	classid;
-		} __packed;
-#else
-		struct {
-			u32	classid;
-			u16	prioidx;
-			u8	padding;
-			u8	unused : 6;
-			u8	no_refcnt : 1;
-			u8	is_data : 1;
-		} __packed;
+	struct cgroup	*cgroup; /* v2 */
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	u32		classid; /* v1 */
+#endif
+#ifdef CONFIG_CGROUP_NET_PRIO
+	u16		prioidx; /* v1 */
 #endif
-		u64		val;
-	};
 };
 
-/*
- * There's a theoretical window where the following accessors race with
- * updaters and return part of the previous pointer as the prioidx or
- * classid.  Such races are short-lived and the result isn't critical.
- */
 static inline u16 sock_cgroup_prioidx(const struct sock_cgroup_data *skcd)
 {
-	/* fallback to 1 which is always the ID of the root cgroup */
-	return (skcd->is_data & 1) ? skcd->prioidx : 1;
+#ifdef CONFIG_CGROUP_NET_PRIO
+	return READ_ONCE(skcd->prioidx);
+#else
+	return 1;
+#endif
 }
 
 static inline u32 sock_cgroup_classid(const struct sock_cgroup_data *skcd)
 {
-	/* fallback to 0 which is the unconfigured default classid */
-	return (skcd->is_data & 1) ? skcd->classid : 0;
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	return READ_ONCE(skcd->classid);
+#else
+	return 0;
+#endif
 }
 
-/*
- * If invoked concurrently, the updaters may clobber each other.  The
- * caller is responsible for synchronization.
- */
 static inline void sock_cgroup_set_prioidx(struct sock_cgroup_data *skcd,
 					   u16 prioidx)
 {
-	struct sock_cgroup_data skcd_buf = {{ .val = READ_ONCE(skcd->val) }};
-
-	if (sock_cgroup_prioidx(&skcd_buf) == prioidx)
-		return;
-
-	if (!(skcd_buf.is_data & 1)) {
-		skcd_buf.val = 0;
-		skcd_buf.is_data = 1;
-	}
-
-	skcd_buf.prioidx = prioidx;
-	WRITE_ONCE(skcd->val, skcd_buf.val);	/* see sock_cgroup_ptr() */
+#ifdef CONFIG_CGROUP_NET_PRIO
+	WRITE_ONCE(skcd->prioidx, prioidx);
+#endif
 }
 
 static inline void sock_cgroup_set_classid(struct sock_cgroup_data *skcd,
 					   u32 classid)
 {
-	struct sock_cgroup_data skcd_buf = {{ .val = READ_ONCE(skcd->val) }};
-
-	if (sock_cgroup_classid(&skcd_buf) == classid)
-		return;
-
-	if (!(skcd_buf.is_data & 1)) {
-		skcd_buf.val = 0;
-		skcd_buf.is_data = 1;
-	}
-
-	skcd_buf.classid = classid;
-	WRITE_ONCE(skcd->val, skcd_buf.val);	/* see sock_cgroup_ptr() */
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	WRITE_ONCE(skcd->classid, classid);
+#endif
 }
 
 #else	/* CONFIG_SOCK_CGROUP_DATA */
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -816,33 +816,13 @@ static inline void cgroup_account_cputim
  */
 #ifdef CONFIG_SOCK_CGROUP_DATA
 
-#if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
-extern spinlock_t cgroup_sk_update_lock;
-#endif
-
-void cgroup_sk_alloc_disable(void);
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
 void cgroup_sk_clone(struct sock_cgroup_data *skcd);
 void cgroup_sk_free(struct sock_cgroup_data *skcd);
 
 static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 {
-#if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
-	unsigned long v;
-
-	/*
-	 * @skcd->val is 64bit but the following is safe on 32bit too as we
-	 * just need the lower ulong to be written and read atomically.
-	 */
-	v = READ_ONCE(skcd->val);
-
-	if (v & 3)
-		return &cgrp_dfl_root.cgrp;
-
-	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
-#else
-	return (struct cgroup *)(unsigned long)skcd->val;
-#endif
+	return skcd->cgroup;
 }
 
 #else	/* CONFIG_CGROUP_DATA */
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6557,74 +6557,44 @@ int cgroup_parse_float(const char *input
  */
 #ifdef CONFIG_SOCK_CGROUP_DATA
 
-#if defined(CONFIG_CGROUP_NET_PRIO) || defined(CONFIG_CGROUP_NET_CLASSID)
-
-DEFINE_SPINLOCK(cgroup_sk_update_lock);
-static bool cgroup_sk_alloc_disabled __read_mostly;
-
-void cgroup_sk_alloc_disable(void)
-{
-	if (cgroup_sk_alloc_disabled)
-		return;
-	pr_info("cgroup: disabling cgroup2 socket matching due to net_prio or net_cls activation\n");
-	cgroup_sk_alloc_disabled = true;
-}
-
-#else
-
-#define cgroup_sk_alloc_disabled	false
-
-#endif
-
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 {
-	if (cgroup_sk_alloc_disabled) {
-		skcd->no_refcnt = 1;
-		return;
-	}
-
 	/* Don't associate the sock with unrelated interrupted task's cgroup. */
 	if (in_interrupt())
 		return;
 
 	rcu_read_lock();
-
 	while (true) {
 		struct css_set *cset;
 
 		cset = task_css_set(current);
 		if (likely(cgroup_tryget(cset->dfl_cgrp))) {
-			skcd->val = (unsigned long)cset->dfl_cgrp;
+			skcd->cgroup = cset->dfl_cgrp;
 			cgroup_bpf_get(cset->dfl_cgrp);
 			break;
 		}
 		cpu_relax();
 	}
-
 	rcu_read_unlock();
 }
 
 void cgroup_sk_clone(struct sock_cgroup_data *skcd)
 {
-	if (skcd->val) {
-		if (skcd->no_refcnt)
-			return;
-		/*
-		 * We might be cloning a socket which is left in an empty
-		 * cgroup and the cgroup might have already been rmdir'd.
-		 * Don't use cgroup_get_live().
-		 */
-		cgroup_get(sock_cgroup_ptr(skcd));
-		cgroup_bpf_get(sock_cgroup_ptr(skcd));
-	}
+	struct cgroup *cgrp = sock_cgroup_ptr(skcd);
+
+	/*
+	 * We might be cloning a socket which is left in an empty
+	 * cgroup and the cgroup might have already been rmdir'd.
+	 * Don't use cgroup_get_live().
+	 */
+	cgroup_get(cgrp);
+	cgroup_bpf_get(cgrp);
 }
 
 void cgroup_sk_free(struct sock_cgroup_data *skcd)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(skcd);
 
-	if (skcd->no_refcnt)
-		return;
 	cgroup_bpf_put(cgrp);
 	cgroup_put(cgrp);
 }
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -72,11 +72,8 @@ static int update_classid_sock(const voi
 	struct update_classid_context *ctx = (void *)v;
 	struct socket *sock = sock_from_file(file, &err);
 
-	if (sock) {
-		spin_lock(&cgroup_sk_update_lock);
+	if (sock)
 		sock_cgroup_set_classid(&sock->sk->sk_cgrp_data, ctx->classid);
-		spin_unlock(&cgroup_sk_update_lock);
-	}
 	if (--ctx->batch == 0) {
 		ctx->batch = UPDATE_CLASSID_BATCH;
 		return n + 1;
@@ -122,8 +119,6 @@ static int write_classid(struct cgroup_s
 	struct css_task_iter it;
 	struct task_struct *p;
 
-	cgroup_sk_alloc_disable();
-
 	cs->classid = (u32)value;
 
 	css_task_iter_start(css, 0, &it);
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -207,8 +207,6 @@ static ssize_t write_priomap(struct kern
 	if (!dev)
 		return -ENODEV;
 
-	cgroup_sk_alloc_disable();
-
 	rtnl_lock();
 
 	ret = netprio_set_prio(of_css(of), dev, prio);
@@ -222,12 +220,10 @@ static int update_netprio(const void *v,
 {
 	int err;
 	struct socket *sock = sock_from_file(file, &err);
-	if (sock) {
-		spin_lock(&cgroup_sk_update_lock);
+
+	if (sock)
 		sock_cgroup_set_prioidx(&sock->sk->sk_cgrp_data,
 					(unsigned long)v);
-		spin_unlock(&cgroup_sk_update_lock);
-	}
 	return 0;
 }
 
@@ -236,8 +232,6 @@ static void net_prio_attach(struct cgrou
 	struct task_struct *p;
 	struct cgroup_subsys_state *css;
 
-	cgroup_sk_alloc_disable();
-
 	cgroup_taskset_for_each(p, css, tset) {
 		void *v = (void *)(unsigned long)css->id;
 


