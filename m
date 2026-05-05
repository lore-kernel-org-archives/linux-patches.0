Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A23A33AD8B;
	Tue,  5 May 2026 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974753; cv=none; b=vDdk27gGVOlq5tsjV8B0p8gpnGSZleFCdWSnyz5CWRtSmnz/3ODkZLzlqhbZ1erqtdXwxZdPGRn4P0Zr8OP+45pQPs4QOwX6ZnDDbnBlZUM+nmV+gKUN9xZUFqr2QJmYURmGi9LtOEsPSMIoLV6qDXxvwlXjuehrFk70yh1yJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974753; c=relaxed/simple;
	bh=C+ICdcLiCXANCpRxjkMaJZtez+92ukNWbnr4qkJgPUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F04J7QXzhHmDbeEoVbHoj+HIY1cD5gImL4jisNKuz+kSGivJVUT77zcNVkO8nCyMYuGITzXvlmttsFypsmg05HMkyj8K8rXAuTdbPqJ46d2MUidVF5dTQt+npcRRR/OkPyCj/ZhIOYW+h2ikgaa9LfT5rmjWEoAirT8MqCupJac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahHCuisR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahHCuisR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B7BC2BCC7;
	Tue,  5 May 2026 09:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974753;
	bh=C+ICdcLiCXANCpRxjkMaJZtez+92ukNWbnr4qkJgPUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahHCuisRp/lqniYf3hD0/RQqLxh86p7TVRI24pZfc6EV2RB76Omjy7o9Np6MyBBEE
	 Q1Twn3VkSjuvkPeHH957QwkEveK7m966RSW8Ih7ZNnEHWc0xgL+2DakmIQZ2EBMqpQ
	 Iw7Npo6DNwJbgtpQOFmu1Gkp96hSqERojUTFVEvlETJkGBoiDOIE4vrnkjSzifSW/z
	 XiivRcqytILd8GLOUiFPPPrwSmUQPcfnwuvkIsjytgfw6qFQjthFpMYnbEsKRhwFml
	 g27CkWT2et+3jWbC/AiDH97NmbSE0vvhN1edt68z3GRRFcvOVRxIay4x0jdNRGpAqQ
	 T8xR10te10twA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	boqun@kernel.org,
	urezki@gmail.com,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] rculist: add list_splice_rcu() for private lists
Date: Tue,  5 May 2026 05:51:29 -0400
Message-ID: <20260505095149.512052-13-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f902877b635551513729bdf9a8d1422c4aab7741 ]

This patch adds a helper function, list_splice_rcu(), to safely splice
a private (non-RCU-protected) list into an RCU-protected list.

The function ensures that only the pointer visible to RCU readers
(prev->next) is updated using rcu_assign_pointer(), while the rest of
the list manipulations are performed with regular assignments, as the
source list is private and not visible to concurrent RCU readers.

This is useful for moving elements from a private list into a global
RCU-protected list, ensuring safe publication for RCU readers.
Subsystems with some sort of batching mechanism from userspace can
benefit from this new function.

The function __list_splice_rcu() has been added for clarity and to
follow the same pattern as in the existing list_splice*() interfaces,
where there is a check to ensure that the list to splice is not
empty. Note that __list_splice_rcu() has no documentation for this
reason.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

Phase 1 Record: Subject subsystem is `rculist`; action verb is `add`;
claimed intent is adding `list_splice_rcu()` for splicing private lists
into RCU-protected lists. Tags verified: `Reviewed-by: Paul E.
McKenney`, `Signed-off-by: Pablo Neira Ayuso`. No `Fixes:`, `Reported-
by:`, `Tested-by:`, `Cc: stable`, or bug-report `Link:` in this commit.
The body describes an RCU publication helper, not a direct user-visible
failure. Hidden-fix assessment: as a standalone commit, it is an
internal helper; as verified from the series, it is required by the
following `nf_tables` RCU list fix.

Phase 2 Record: One file changed, `include/linux/rculist.h`, 29
insertions. New functions: `__list_splice_rcu()` and
`list_splice_rcu()`. Before: no helper for private-list-to-RCU-list
splice. After: list links are prepared with normal stores, then
`prev->next` is published with `rcu_assign_pointer()`. Bug category: RCU
synchronization/publication correctness, but the direct behavioral fix
is in the dependent `nf_tables` patch. Fix quality: small and clear;
regression risk low, because it is unused unless paired with callers.

Phase 3 Record: `git blame` showed neighboring RCU list helpers are
long-standing code; new lines have no prior blame. The dependent fix
targets `78d9f48f7f44` first contained by `v5.8-rc1` and `b9703ed44ffb`
first contained by `v6.4-rc1`. Local blame confirms the unsafe
`nf_tables` `list_splice()` sites came from those commits. Recent
history shows the helper is paired with `netfilter: nf_tables: join hook
list via splice_list_rcu() in commit phase`. Author context verified:
Pablo is listed as `NETFILTER` maintainer in `MAINTAINERS`.

Phase 4 Record: `b4 dig -c b93a4320874cf` found the original patch
discussion by patch-id, with the applied upstream helper as `[PATCH net
10/11]`. `b4 dig -a` found multiple revisions/submissions, including
v2/v3 and net pull submissions. `b4 dig -w` showed netfilter/netdev
maintainers and lists were included. Lore/Patchwork review verified Paul
requested documentation/order changes in early review, then gave
`Reviewed-by`; no NAK found for the helper. The cover letter explicitly
says this helper is required to fix unsafe splice into RCU-protected
hook lists. Stable lore search was blocked/ inconclusive.

Phase 5 Record: Key functions are `list_splice_rcu()` and
`__list_splice_rcu()`. Verified call sites on the candidate branch are
only the two `nf_tables_commit()` updates from the dependent patch.
`nf_tables_commit()` is the `nfnetlink` batch commit callback;
`NFT_MSG_NEWCHAIN` and `NFT_MSG_NEWFLOWTABLE` are batch netlink
operations, while `GETCHAIN`/`GETFLOWTABLE` callbacks are RCU readers.
`nfnetlink_rcv()` requires `CAP_NET_ADMIN`, so this is reachable from
privileged userspace netlink operations, not verified as unprivileged.

Phase 6 Record: The helper itself is not present in checked-out
`v7.0.3`. The unsafe `list_splice()` patterns exist in active stable-
family branches checked: `5.10`, `5.15`, `6.1`, `6.6`, `6.12`, and
`6.19`, with chain-specific sites appearing from `6.6` onward and
flowtable sites in older branches. `git apply --check` verified both the
helper patch and dependent `nf_tables` patch apply cleanly to the
current checkout. Backport difficulty for this helper is low; older
branches may need only the relevant dependent fix subset.

Phase 7 Record: Subsystem is core RCU list infrastructure plus netfilter
usage context. Criticality: `include/linux/rculist.h` is core
infrastructure, but runtime impact here is limited to future callers;
the verified caller is `nf_tables`, an important networking subsystem.
Subsystem activity is active, with many recent `nf_tables` fixes in
history.

Phase 8 Record: Affected users are systems using nftables netdev
chain/flowtable hook updates and concurrent netlink dumps. Trigger is
privileged nftables batch update plus concurrent RCU dump traversal.
Verified severity is RCU list publication correctness; no concrete crash
report was found for this exact helper/dependent patch, so I do not rate
it as proven crash/security. Benefit is high when paired with the
dependent `nf_tables` fix; standalone benefit is none. Risk is low: 29
lines, internal static inline helper, no userspace API.

Phase 9 Record: Evidence for backporting: small helper, reviewed,
required by an actual `nf_tables` RCU correctness fix, clean apply
verified, bug-introducing commits exist in stable lines. Evidence
against: standalone commit does not fix runtime behavior and adds a new
internal helper API. Stable rules: obviously correct yes; tested only by
review/apply-check here, no runtime test verified; fixes a real bug only
as dependency; important issue is RCU list safety but no concrete crash
report verified; small/contained yes; no userspace API yes; applies
cleanly to current stable checkout yes. Exception category:
dependency/helper for a small bug fix, not a device ID/quirk/build/doc
exception.

## Verification

- Phase 1: Parsed `git show`/provided commit message; verified tags and
  absence of bug tags.
- Phase 2: Inspected diff; verified 29 insertions in
  `include/linux/rculist.h`.
- Phase 3: Ran `git blame` on `rculist.h` and `nf_tables_api.c`;
  verified introducers and `git describe --contains` versions for
  dependent fix targets.
- Phase 4: Ran `b4 dig -c`, `-a`, and `-w`; fetched lore/Patchwork
  mirrors; verified series context, review, and dependency statement.
- Phase 5: Used `git grep`, `rg`, and file reads; verified helper call
  sites, netlink callback paths, RCU dump traversal, and `CAP_NET_ADMIN`
  gate.
- Phase 6: Checked stable branches with `git grep`; verified helper
  absence and unsafe splice presence; ran `git apply --check` for helper
  and dependent fix.
- Phase 7: Verified maintainer entry in `MAINTAINERS` and recent
  netfilter history.
- Phase 8: Verified trigger path from nfnetlink batch operations; no
  concrete crash report was found.
- Unverified: Runtime testing was not performed; stable-specific lore
  discussion could not be fetched due bot protection.

This should be backported only together with the dependent `nf_tables`
fix. As that dependency, it is small, reviewed, cleanly applicable, and
enables a real RCU list publication fix without userspace-visible API
changes.

**YES**

 include/linux/rculist.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 2abba7552605c..e3bc442256922 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -261,6 +261,35 @@ static inline void list_replace_rcu(struct list_head *old,
 	old->prev = LIST_POISON2;
 }
 
+static inline void __list_splice_rcu(struct list_head *list,
+				     struct list_head *prev,
+				     struct list_head *next)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+
+	last->next = next;
+	first->prev = prev;
+	next->prev = last;
+	rcu_assign_pointer(list_next_rcu(prev), first);
+}
+
+/**
+ * list_splice_rcu - splice a non-RCU list into an RCU-protected list,
+ *                   designed for stacks.
+ * @list:	the non RCU-protected list to splice
+ * @head:	the place in the existing RCU-protected list to splice
+ *
+ * The list pointed to by @head can be RCU-read traversed concurrently with
+ * this function.
+ */
+static inline void list_splice_rcu(struct list_head *list,
+				   struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_rcu(list, head, head->next);
+}
+
 /**
  * __list_splice_init_rcu - join an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
2.53.0

