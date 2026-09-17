Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2445A4F5DF8;
	Thu, 17 Sep 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666088; cv=none; b=kmNjwNG+TAY26b+rV7+LtuJbvJlmCkOM387IPiQGMJbRqiJeUneaJ9m3JWa1vXeV1Qj2cU5qPA4b0vB/mSI/AMPOM5o8eSSwLFfcbL+/HR0AypAZkftEdjOy2WqmmVKgB9vwXDYhBCNe22C5oXawcoqvmBH6fcT0cyQXYO1zWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666088; c=relaxed/simple;
	bh=cte1r8nWCK6/cibF0UajU/NbWi1ce35kaPjU176E+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4kC1+LTAP45n6UnNkUd1oQAvn+z8s1em5TEB9hYIhkvkaerR6YJXUNZjifEjrZlfSc7upFB4IBv1+1b6U0u8zNkS1/7gVPGdu6ZaCIAmowsmQpLZMQirenjrov7LZlK62RomTPlmIwzbp6rh2aesJmD60O63YmxDgdJA4ZynI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2/PdF7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2/PdF7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A38D1F000FF;
	Thu, 17 Sep 2026 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666087;
	bh=10UTKTgKx3vehfgq225Mzs/9DwqmkjF+TQeqPPyj4ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2/PdF7ossO49kkr7YD+0hjUIbQI0vJv46aY2yqcT7HC/Zror4l+1b48VgGF/DA1q
	 pfwn13hcmr+Qi9TgrOZutSVO3IH8FnmTTLQpkJGJ9en2PD8Y9a5To4WSvu4aKbsd3S
	 HXsPQpp/TFYdVWyU+dtx2ZRVSfynugpYg+ru+P6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0920/1250] sched/eevdf: Fix rb augmented with multi fields
Date: Thu, 17 Sep 2026 16:11:55 +0100
Message-ID: <20260917151616.942010723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 51b0e68cfa0ac69e3c3ea9d6753af7e15dfaab22 ]

The eevdf rb tree maintains 3 augmented fields but only one is currently
copied when balancing the tree.

Add a more generic define that can be used when there are several augmented
fields. In this case, we provide a function that takes care of copying all
fields.

Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260909150522.858312-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rbtree_augmented.h | 35 +++++++++++++++++++++++++-------
 kernel/sched/fair.c              | 12 +++++++++--
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index 6dbc5a1bf6a8c..d2fa1c41bfd2b 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -87,18 +87,18 @@ rb_add_augmented_cached(struct rb_node *node, struct rb_root_cached *tree,
 }
 
 /*
- * Template for declaring augmented rbtree callbacks (generic case)
+ * Template for declaring augmented rbtree callbacks (generic multi fields)
  *
  * RBSTATIC:    'static' or empty
  * RBNAME:      name of the rb_augment_callbacks structure
  * RBSTRUCT:    struct type of the tree nodes
  * RBFIELD:     name of struct rb_node field within RBSTRUCT
- * RBAUGMENTED: name of field within RBSTRUCT holding data for subtree
- * RBCOMPUTE:   name of function that recomputes the RBAUGMENTED data
+ * RBCOPY:	name of function that copies the RBAUGMENTED datas
+ * RBCOMPUTE:   name of function that recomputes the RBAUGMENTED datas
  */
 
-#define RB_DECLARE_CALLBACKS(RBSTATIC, RBNAME,				\
-			     RBSTRUCT, RBFIELD, RBAUGMENTED, RBCOMPUTE)	\
+#define RB_DECLARE_CALLBACKS_MULTI(RBSTATIC, RBNAME,			\
+			     RBSTRUCT, RBFIELD, RBCOPY, RBCOMPUTE)	\
 static inline void							\
 RBNAME ## _propagate(struct rb_node *rb, struct rb_node *stop)		\
 {									\
@@ -114,14 +114,14 @@ RBNAME ## _copy(struct rb_node *rb_old, struct rb_node *rb_new)		\
 {									\
 	RBSTRUCT *old = rb_entry(rb_old, RBSTRUCT, RBFIELD);		\
 	RBSTRUCT *new = rb_entry(rb_new, RBSTRUCT, RBFIELD);		\
-	new->RBAUGMENTED = old->RBAUGMENTED;				\
+	RBCOPY(new, old);						\
 }									\
 static void								\
 RBNAME ## _rotate(struct rb_node *rb_old, struct rb_node *rb_new)	\
 {									\
 	RBSTRUCT *old = rb_entry(rb_old, RBSTRUCT, RBFIELD);		\
 	RBSTRUCT *new = rb_entry(rb_new, RBSTRUCT, RBFIELD);		\
-	new->RBAUGMENTED = old->RBAUGMENTED;				\
+	RBCOPY(new, old);						\
 	RBCOMPUTE(old, false);						\
 }									\
 RBSTATIC const struct rb_augment_callbacks RBNAME = {			\
@@ -130,6 +130,27 @@ RBSTATIC const struct rb_augment_callbacks RBNAME = {			\
 	.rotate = RBNAME ## _rotate					\
 };
 
+/*
+ * Template for declaring augmented rbtree callbacks (generic single field)
+ *
+ * RBSTATIC:    'static' or empty
+ * RBNAME:      name of the rb_augment_callbacks structure
+ * RBSTRUCT:    struct type of the tree nodes
+ * RBFIELD:     name of struct rb_node field within RBSTRUCT
+ * RBAUGMENTED: name of field within RBSTRUCT holding data for subtree
+ * RBCOMPUTE:   name of function that recomputes the RBAUGMENTED data
+ */
+
+#define RB_DECLARE_CALLBACKS(RBSTATIC, RBNAME,				\
+			     RBSTRUCT, RBFIELD, RBAUGMENTED, RBCOMPUTE)	\
+static inline void							\
+RBNAME ## _copy_single(RBSTRUCT *new, RBSTRUCT *old)			\
+{									\
+	new->RBAUGMENTED = old->RBAUGMENTED;				\
+}									\
+RB_DECLARE_CALLBACKS_MULTI(RBSTATIC, RBNAME,				\
+		     RBSTRUCT, RBFIELD, RBNAME ## _copy_single, RBCOMPUTE)
+
 /*
  * Template for declaring augmented rbtree callbacks,
  * computing RBAUGMENTED scalar as max(RBCOMPUTE(node)) for all subtree nodes.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 92ef592d97b69..325aedbdb32a7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -883,6 +883,13 @@ static inline void __max_slice_update(struct sched_entity *se, struct rb_node *n
 	}
 }
 
+static inline void min_vruntime_copy(struct sched_entity *new, struct sched_entity *old)
+{
+	new->min_vruntime = old->min_vruntime;
+	new->min_slice = old->min_slice;
+	new->max_slice = old->max_slice;
+}
+
 /*
  * se->min_vruntime = min(se->vruntime, {left,right}->min_vruntime)
  */
@@ -910,8 +917,9 @@ static inline bool min_vruntime_update(struct sched_entity *se, bool exit)
 	       se->max_slice == old_max_slice;
 }
 
-RB_DECLARE_CALLBACKS(static, min_vruntime_cb, struct sched_entity,
-		     run_node, min_vruntime, min_vruntime_update);
+
+RB_DECLARE_CALLBACKS_MULTI(static, min_vruntime_cb, struct sched_entity,
+		     run_node, min_vruntime_copy, min_vruntime_update);
 
 /*
  * Enqueue an entity into the rb-tree:
-- 
2.53.0



