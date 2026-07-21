Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE7471415;
	Tue, 21 Jul 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662905; cv=none; b=FGBLPU0zaRbEmw6aurXD893Pp2zCfGIiqZhmjK1m8ca9P/uXeWKjLjd48+zusQ8wfOWQHo/HNCKgCNnvhUMgKxDUwj7uMo1pu8lnEpv9KRtVGkKUvvpHeOgw4Yy9o3bPskeMv1RAkw9LOe0+tEhYmKfM0+quAZl0qfC2oHZwLGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662905; c=relaxed/simple;
	bh=f8jKMmtXyofdxmqF6e3kdRq9VwsZwDOzZQUAJCAopE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7FehqsR2pFeVyVcywjvYMzxFLN8zYRzhYQ24G5GqWqoIBZO4TmTqAuWSXn2vLG30dbsFS8AD/UpkjxRmQvb89THK8z0SQHx9rsv1zMDA4v+1sZrVSHAwcv0TxsUH9xFfEQRiHn+QFavpNA+i8nSWJH36UqK/N/C9kVq7rCAuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzw0ERRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzw0ERRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DA91F00A3F;
	Tue, 21 Jul 2026 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662904;
	bh=uKoNuoikzfoxlBka91QWt1MrCwJHLxqNfzediapELro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzw0ERRZGuMnLhnYeR+NboLQnQpPBkYMupFFC23pLeVDhN45v/8r+PdafIEGhvdM4
	 4wvi6kcSKoKOcJ3SGibXiBm8p+jZwpCobQyRfoLs7TjyVG/VbA7m0B4OoTQsIACnHC
	 ZjD8Oq2pzACTKiVx0IwbF+zlqB3ICmMzOtghiRFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0621/1276] bpf: Fix effective prog array index with BPF_F_PREORDER
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152500.004418798@linuxfoundation.org>
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

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit f08aaee3152d0dfc578b3f2586932d82062701dd ]

replace_effective_prog() and purge_effective_progs() located the slot in
the effective array by walking the program hlist and counting entries
linearly. That count does not match the array layout: compute_effective_
progs() places BPF_F_PREORDER programs at the front (ancestor cgroup
first, attach order within a cgroup) and the rest after them (descendant
cgroup first). So when a preorder program is present, the linear hlist
position no longer equals the program's index in the effective array.

For replace_effective_prog() (bpf_link_update()) this overwrote the
wrong slot, corrupting the effective order. For purge_effective_progs(),
it could dummy out a slot belonging to a different program and leave the
detached program in the array while bpf_prog_put() drops its reference,
i.e. a use-after-free.

Fix both by replaying compute_effective_progs()'s placement (including
the per-cgroup preorder reversal) in a shared effective_prog_pos()
helper. Identify the entry by its struct bpf_prog_list pointer rather
than by (prog, link) value, so the lookup resolves to exactly the
attachment the syscall selected even when the same bpf_prog is attached
to several cgroups in the hierarchy.

Fixes: 4b82b181a26c ("bpf: Allow pre-ordering for bpf cgroup progs")
Signed-off-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260619063520.2690547-2-ameryhung@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 108 +++++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 46 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 26ed09cdc85624..ad054a4c782ea9 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -769,19 +769,65 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
 	return ret;
 }
 
+static int effective_prog_pos(struct cgroup *cgrp,
+			      enum cgroup_bpf_attach_type atype,
+			      struct bpf_prog_list *target_pl)
+{
+	int cnt = 0, preorder_cnt = 0, fstart, bstart, init_bstart, pos = -1;
+	struct bpf_prog_list *pl;
+	struct cgroup *p = cgrp;
+
+	/* count effective programs to find where the preorder region ends */
+	do {
+		if (cnt == 0 || (p->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
+			cnt += prog_list_length(&p->bpf.progs[atype], &preorder_cnt);
+		p = cgroup_parent(p);
+	} while (p);
+
+	/* replay compute_effective_progs() placement and record target's slot */
+	cnt = 0;
+	p = cgrp;
+	fstart = preorder_cnt;
+	bstart = preorder_cnt - 1;
+	do {
+		if (cnt > 0 && !(p->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
+			continue;
+
+		init_bstart = bstart;
+		hlist_for_each_entry(pl, &p->bpf.progs[atype], node) {
+			if (!prog_list_prog(pl))
+				continue;
+
+			if (pl->flags & BPF_F_PREORDER) {
+				if (pl == target_pl)
+					pos = bstart;
+				bstart--;
+			} else {
+				if (pl == target_pl)
+					pos = fstart;
+				fstart++;
+			}
+			cnt++;
+		}
+
+		/* reverse pre-ordering progs at this cgroup level */
+		if (pos >= bstart + 1 && pos <= init_bstart)
+			pos = bstart + 1 + init_bstart - pos;
+	} while ((p = cgroup_parent(p)));
+
+	return pos;
+}
+
 /* Swap updated BPF program for given link in effective program arrays across
  * all descendant cgroups. This function is guaranteed to succeed.
  */
 static void replace_effective_prog(struct cgroup *cgrp,
 				   enum cgroup_bpf_attach_type atype,
-				   struct bpf_cgroup_link *link)
+				   struct bpf_prog_list *pl)
 {
 	struct bpf_prog_array_item *item;
 	struct cgroup_subsys_state *css;
 	struct bpf_prog_array *progs;
-	struct bpf_prog_list *pl;
-	struct hlist_head *head;
-	struct cgroup *cg;
 	int pos;
 
 	css_for_each_descendant_pre(css, &cgrp->self) {
@@ -790,27 +836,15 @@ static void replace_effective_prog(struct cgroup *cgrp,
 		if (percpu_ref_is_zero(&desc->bpf.refcnt))
 			continue;
 
-		/* find position of link in effective progs array */
-		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
-			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
-				continue;
+		pos = effective_prog_pos(desc, atype, pl);
+		if (WARN_ON_ONCE(pos < 0))
+			continue;
 
-			head = &cg->bpf.progs[atype];
-			hlist_for_each_entry(pl, head, node) {
-				if (!prog_list_prog(pl))
-					continue;
-				if (pl->link == link)
-					goto found;
-				pos++;
-			}
-		}
-found:
-		BUG_ON(!cg);
 		progs = rcu_dereference_protected(
 				desc->bpf.effective[atype],
 				lockdep_is_held(&cgroup_mutex));
 		item = &progs->items[pos];
-		WRITE_ONCE(item->prog, link->link.prog);
+		WRITE_ONCE(item->prog, pl->link->link.prog);
 	}
 }
 
@@ -853,7 +887,7 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 		return -ENOENT;
 
 	old_prog = xchg(&link->link.prog, new_prog);
-	replace_effective_prog(cgrp, atype, link);
+	replace_effective_prog(cgrp, atype, pl);
 	bpf_prog_put(old_prog);
 	return 0;
 }
@@ -920,19 +954,14 @@ static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
  *                           recomputing the array in place.
  *
  * @cgrp: The cgroup which descendants to travers
- * @prog: A program to detach or NULL
- * @link: A link to detach or NULL
+ * @pl: The prog_list entry being detached
  * @atype: Type of detach operation
  */
-static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
-				  struct bpf_cgroup_link *link,
+static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog_list *pl,
 				  enum cgroup_bpf_attach_type atype)
 {
 	struct cgroup_subsys_state *css;
 	struct bpf_prog_array *progs;
-	struct bpf_prog_list *pl;
-	struct hlist_head *head;
-	struct cgroup *cg;
 	int pos;
 
 	/* recompute effective prog array in place */
@@ -942,24 +971,11 @@ static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
 		if (percpu_ref_is_zero(&desc->bpf.refcnt))
 			continue;
 
-		/* find position of link or prog in effective progs array */
-		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
-			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
-				continue;
-
-			head = &cg->bpf.progs[atype];
-			hlist_for_each_entry(pl, head, node) {
-				if (!prog_list_prog(pl))
-					continue;
-				if (pl->prog == prog && pl->link == link)
-					goto found;
-				pos++;
-			}
-		}
-
+		pos = effective_prog_pos(desc, atype, pl);
 		/* no link or prog match, skip the cgroup of this layer */
-		continue;
-found:
+		if (pos < 0)
+			continue;
+
 		progs = rcu_dereference_protected(
 				desc->bpf.effective[atype],
 				lockdep_is_held(&cgroup_mutex));
@@ -1020,7 +1036,7 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		/* if update effective array failed replace the prog with a dummy prog*/
 		pl->prog = old_prog;
 		pl->link = link;
-		purge_effective_progs(cgrp, old_prog, link, atype);
+		purge_effective_progs(cgrp, pl, atype);
 	}
 
 	/* now can actually delete it from this cgroup list */
-- 
2.53.0



