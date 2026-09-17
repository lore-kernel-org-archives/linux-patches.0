Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9D74B44A9;
	Thu, 17 Sep 2026 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660034; cv=none; b=c/WYDYCCUu1dWC+C/f6jPSe+q0m7l62CI27pqx+EnIB7JGe1phn9u4z7AXVsFuGRGa/Js+vHCtITKKs89nTPIG5ccUX9sz+jLie8AxyGjNnAcTFiKM4vd/UgJMh55k03SRX9blVbf0ffQnb+JHcYSU2SXu2kZApeVt4a5mSZLkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660034; c=relaxed/simple;
	bh=WGOyR9vweQg0CqlmBjoHRN1HY6oIAobhsuQBp3skPgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRFcFNQfSYp+w4Cuk5NuRI+kGZz89O+Bm84NdiKrOnvc84St+nqSVCHF9h/ML48A4ar8+FX6tm2wDHr6CnBczBLN70Zpex4s3unc4pyFZrA+EeU13D7Pe4rVyCUbezH3X6s13bWXMkCdbDHqpSTwKKwQcFWqhinvfOUVm17P4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePvZNILn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePvZNILn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220EA1F00898;
	Thu, 17 Sep 2026 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660029;
	bh=Qlg1t7E7UA3o13du3CsXl4Lmev1uo3shntF44Pj/PKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePvZNILniZ+17ysBv7mG0xr+KdDN2t5LuwW2lT9Jfn/TG6pHkLb8RtVquFv+2qfcw
	 Rigb/zKVqynp6aDtfrNcg1p9BTZO+m06DPA0N/Hv9/QU7OkyaHZIJS0tFZ0+gLklA5
	 QtxF3XENll4NyHw+JvrF95+g8D2GEiLCcBf6H3OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 417/733] sched/eevdf: Fix rb augmented with multi fields
Date: Thu, 17 Sep 2026 16:12:05 +0100
Message-ID: <20260917151402.185319459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 83fe5319e2ccd..a30d539a3f054 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1004,6 +1004,13 @@ static inline void __max_slice_update(struct sched_entity *se, struct rb_node *n
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
@@ -1031,8 +1038,9 @@ static inline bool min_vruntime_update(struct sched_entity *se, bool exit)
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



