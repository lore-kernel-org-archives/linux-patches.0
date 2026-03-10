Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519383876CE;
	Tue, 10 Mar 2026 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141654; cv=none; b=UH9UKWuRo8Qzf4Dk9ev8vDGS/MM+h4XkRtbjeOwXRsq8ymz6/hbCrGVmYoGYRWP4TK7Xc1LgQlYZvVgsbHMKDBhRIMLPTA9mg2nKcJ86/rz2ZzmytL5w49hJze+0YaijxyOWBSB71jJxaEMXXfd8cmohIAqGWGKfbbTz7p21xxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141654; c=relaxed/simple;
	bh=1PDJLzPvQh4MTELw1O0ls5Gy9t3/lTuozUgcp1RQft0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToUiWCuSpPVbCxn7b9NUfJ3GRJ81ZnlZRIWu3x14lkg4TmF/2doAGeLGprNFRLkdYZuXVN1nHkHNjNw2bd9J2QPrKA3YfGEo9zDySxdSMlSLtI1nEXDRcsOZ08WljA0e89/CeIUO9J/FaKMczlsSS9MseFaN3CA0Ar2D56NJWMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8Q22Qrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8Q22Qrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA64C2BC86;
	Tue, 10 Mar 2026 11:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141654;
	bh=1PDJLzPvQh4MTELw1O0ls5Gy9t3/lTuozUgcp1RQft0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8Q22QrzTzijNro9ZDZJCp+fgUURVNKXU2iBNIHMsc5CRnMOiN4Lbz6v7APsdGtw3
	 CpfNmUYUIFYNX43B4Eyg8RiP3l8ifuSjRlZAZo4i5IcJZGh8jXz7lKL+a52qvN5Maz
	 0X+Mqbs1yO2cutaPqHcU13+nXRovFVo7oWmd+yR3SwOMN2eY1TjA158OO29j8ANe8t
	 El+6SRSf/S09lwANli3JjMushB32KCfloiVU3fGpUuPsRTSH41cnG/7/6jnWeHFqVN
	 kYNSQH+xu2y/npXNuauaZhEtUFW4SoFZeJ+FPq3DUEQMpVSU/k0bIuGAKVfTtBY0YC
	 aicMd7rv1GXmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/314] sched/fair: Introduce and use the vruntime_cmp() and vruntime_op() wrappers for wrapped-signed aritmetics
Date: Tue, 10 Mar 2026 07:14:40 -0400
Message-ID: <6d6950c6f54a1a9056d88f1fcffce1c39229f11f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 5758e48eefaf111d7764d8f1c8b666140fe5fa27 ]

We have to be careful with vruntime comparisons and subtraction,
due to the possibility of wrapping, so we have macros like:

   #define vruntime_gt(field, lse, rse) ({ (s64)((lse)->field - (rse)->field) > 0; })

Which is used like this:

		if (vruntime_gt(min_vruntime, se, rse))
			se->min_vruntime = rse->min_vruntime;

Replace this with an easier to read pattern that uses the regular
arithmetics operators:

		if (vruntime_cmp(se->min_vruntime, ">", rse->min_vruntime))
			se->min_vruntime = rse->min_vruntime;

Also replace vruntime subtractions with vruntime_op():

	-       delta = (s64)(sea->vruntime - seb->vruntime) +
	-               (s64)(cfs_rqb->zero_vruntime_fi - cfs_rqa->zero_vruntime_fi);
	+       delta = vruntime_op(sea->vruntime, "-", seb->vruntime) +
	+               vruntime_op(cfs_rqb->zero_vruntime_fi, "-", cfs_rqa->zero_vruntime_fi);

In the vruntime_cmp() and vruntime_op() macros use Use __builtin_strcmp(),
because of __HAVE_ARCH_STRCMP might turn off the compiler optimizations
we rely on here to catch usage bugs.

No change in functionality.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: b3d99f43c72b ("sched/fair: Fix zero_vruntime tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 66 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a5f698ed15032..f669c84c7c0e9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -524,10 +524,48 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
  * Scheduling class tree data structure manipulation methods:
  */
 
+extern void __BUILD_BUG_vruntime_cmp(void);
+
+/* Use __builtin_strcmp() because of __HAVE_ARCH_STRCMP: */
+
+#define vruntime_cmp(A, CMP_STR, B) ({				\
+	int __res = 0;						\
+								\
+	if (!__builtin_strcmp(CMP_STR, "<")) {			\
+		__res = ((s64)((A)-(B)) < 0);			\
+	} else if (!__builtin_strcmp(CMP_STR, "<=")) {		\
+		__res = ((s64)((A)-(B)) <= 0);			\
+	} else if (!__builtin_strcmp(CMP_STR, ">")) {		\
+		__res = ((s64)((A)-(B)) > 0);			\
+	} else if (!__builtin_strcmp(CMP_STR, ">=")) {		\
+		__res = ((s64)((A)-(B)) >= 0);			\
+	} else {						\
+		/* Unknown operator throws linker error: */	\
+		__BUILD_BUG_vruntime_cmp();			\
+	}							\
+								\
+	__res;							\
+})
+
+extern void __BUILD_BUG_vruntime_op(void);
+
+#define vruntime_op(A, OP_STR, B) ({				\
+	s64 __res = 0;						\
+								\
+	if (!__builtin_strcmp(OP_STR, "-")) {			\
+		__res = (s64)((A)-(B));				\
+	} else {						\
+		/* Unknown operator throws linker error: */	\
+		__BUILD_BUG_vruntime_op();			\
+	}							\
+								\
+	__res;						\
+})
+
+
 static inline __maybe_unused u64 max_vruntime(u64 max_vruntime, u64 vruntime)
 {
-	s64 delta = (s64)(vruntime - max_vruntime);
-	if (delta > 0)
+	if (vruntime_cmp(vruntime, ">", max_vruntime))
 		max_vruntime = vruntime;
 
 	return max_vruntime;
@@ -535,8 +573,7 @@ static inline __maybe_unused u64 max_vruntime(u64 max_vruntime, u64 vruntime)
 
 static inline __maybe_unused u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 {
-	s64 delta = (s64)(vruntime - min_vruntime);
-	if (delta < 0)
+	if (vruntime_cmp(vruntime, "<", min_vruntime))
 		min_vruntime = vruntime;
 
 	return min_vruntime;
@@ -549,12 +586,12 @@ static inline bool entity_before(const struct sched_entity *a,
 	 * Tiebreak on vruntime seems unnecessary since it can
 	 * hardly happen.
 	 */
-	return (s64)(a->deadline - b->deadline) < 0;
+	return vruntime_cmp(a->deadline, "<", b->deadline);
 }
 
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return (s64)(se->vruntime - cfs_rq->zero_vruntime);
+	return vruntime_op(se->vruntime, "-", cfs_rq->zero_vruntime);
 }
 
 #define __node_2_se(node) \
@@ -732,7 +769,7 @@ static int vruntime_eligible(struct cfs_rq *cfs_rq, u64 vruntime)
 		load += weight;
 	}
 
-	return avg >= (s64)(vruntime - cfs_rq->zero_vruntime) * load;
+	return avg >= vruntime_op(vruntime, "-", cfs_rq->zero_vruntime) * load;
 }
 
 int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -743,7 +780,7 @@ int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void update_zero_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = avg_vruntime(cfs_rq);
-	s64 delta = (s64)(vruntime - cfs_rq->zero_vruntime);
+	s64 delta = vruntime_op(vruntime, "-", cfs_rq->zero_vruntime);
 
 	sum_w_vruntime_update(cfs_rq, delta);
 
@@ -770,13 +807,12 @@ static inline bool __entity_less(struct rb_node *a, const struct rb_node *b)
 	return entity_before(__node_2_se(a), __node_2_se(b));
 }
 
-#define vruntime_gt(field, lse, rse) ({ (s64)((lse)->field - (rse)->field) > 0; })
-
 static inline void __min_vruntime_update(struct sched_entity *se, struct rb_node *node)
 {
 	if (node) {
 		struct sched_entity *rse = __node_2_se(node);
-		if (vruntime_gt(min_vruntime, se, rse))
+
+		if (vruntime_cmp(se->min_vruntime, ">", rse->min_vruntime))
 			se->min_vruntime = rse->min_vruntime;
 	}
 }
@@ -887,7 +923,7 @@ static inline void update_protect_slice(struct cfs_rq *cfs_rq, struct sched_enti
 
 static inline bool protect_slice(struct sched_entity *se)
 {
-	return ((s64)(se->vprot - se->vruntime) > 0);
+	return vruntime_cmp(se->vruntime, "<", se->vprot);
 }
 
 static inline void cancel_protect_slice(struct sched_entity *se)
@@ -1014,7 +1050,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se);
  */
 static bool update_deadline(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if ((s64)(se->vruntime - se->deadline) < 0)
+	if (vruntime_cmp(se->vruntime, "<", se->deadline))
 		return false;
 
 	/*
@@ -13238,8 +13274,8 @@ bool cfs_prio_less(const struct task_struct *a, const struct task_struct *b,
 	 * zero_vruntime_fi, which would have been updated in prior calls
 	 * to se_fi_update().
 	 */
-	delta = (s64)(sea->vruntime - seb->vruntime) +
-		(s64)(cfs_rqb->zero_vruntime_fi - cfs_rqa->zero_vruntime_fi);
+	delta = vruntime_op(sea->vruntime, "-", seb->vruntime) +
+		vruntime_op(cfs_rqb->zero_vruntime_fi, "-", cfs_rqa->zero_vruntime_fi);
 
 	return delta > 0;
 }
-- 
2.51.0

