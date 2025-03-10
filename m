Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA622D799;
	Mon, 10 Mar 2025 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627642; cv=none; b=qBozOVprJQC4xm3xHS5thG/6sOF9NG+M48GPW7nJAv9+fhlI3IHYhEGTQwcxvZ/5eqdPm9glYejuAp2ghoy31+p+q/9n6wVevFtLaTajfkrS7XPT+DO3TQYXom9OM02PNFCTeBr4Q3i95KgDhxyhe2cZq4ek6xi2WW740kCfO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627642; c=relaxed/simple;
	bh=i1dWifN11q5b6u/jYRS51kCOT3TbxBJJ9VimInFXbvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnKHjafs+bFQvH7mal7Q+zyYKZyfLXYXpym+3PVNi0XQErKglXUglJs1zhxYD6sgQwjQAfm7ruZk6EYDhK45cxYpsf75pbqjddloX0fEoiekhtzQcUnLJjwrL2XSgVpibl5I15pU4G0mbqC/yiVJ736RaK1hU3KQqW0sUzEbdaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY9pEbsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY9pEbsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1973C4CEEC;
	Mon, 10 Mar 2025 17:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627642;
	bh=i1dWifN11q5b6u/jYRS51kCOT3TbxBJJ9VimInFXbvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY9pEbsUwcl/bekb2KH68qcHf5sxt9H2yFVVKOVCGVFfBi90xiOO1Xv8mtKb9Ll+X
	 2zfglQ2wVZllZpeKtXksvkA6JXQAqaWbU+GefJhJVrpUl7Rqn1tjJaMeNZLwl8/xmo
	 fv+gKj00d/DzW7Ux0FEfCLRiBhf2sCu0BTYEO3eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zecheng Li <zecheng@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.12 199/269] sched/fair: Fix potential memory corruption in child_cfs_rq_on_list
Date: Mon, 10 Mar 2025 18:05:52 +0100
Message-ID: <20250310170505.629635852@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zecheng Li <zecheng@google.com>

[ Upstream commit 3b4035ddbfc8e4521f85569998a7569668cccf51 ]

child_cfs_rq_on_list attempts to convert a 'prev' pointer to a cfs_rq.
This 'prev' pointer can originate from struct rq's leaf_cfs_rq_list,
making the conversion invalid and potentially leading to memory
corruption. Depending on the relative positions of leaf_cfs_rq_list and
the task group (tg) pointer within the struct, this can cause a memory
fault or access garbage data.

The issue arises in list_add_leaf_cfs_rq, where both
cfs_rq->leaf_cfs_rq_list and rq->leaf_cfs_rq_list are added to the same
leaf list. Also, rq->tmp_alone_branch can be set to rq->leaf_cfs_rq_list.

This adds a check `if (prev == &rq->leaf_cfs_rq_list)` after the main
conditional in child_cfs_rq_on_list. This ensures that the container_of
operation will convert a correct cfs_rq struct.

This check is sufficient because only cfs_rqs on the same CPU are added
to the list, so verifying the 'prev' pointer against the current rq's list
head is enough.

Fixes a potential memory corruption issue that due to current struct
layout might not be manifesting as a crash but could lead to unpredictable
behavior when the layout changes.

Fixes: fdaba61ef8a2 ("sched/fair: Ensure that the CFS parent is added after unthrottling")
Signed-off-by: Zecheng Li <zecheng@google.com>
Reviewed-and-tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20250304214031.2882646-1-zecheng@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ddc096d6b0c20..58ba14ed8fbcb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4155,15 +4155,17 @@ static inline bool child_cfs_rq_on_list(struct cfs_rq *cfs_rq)
 {
 	struct cfs_rq *prev_cfs_rq;
 	struct list_head *prev;
+	struct rq *rq = rq_of(cfs_rq);
 
 	if (cfs_rq->on_list) {
 		prev = cfs_rq->leaf_cfs_rq_list.prev;
 	} else {
-		struct rq *rq = rq_of(cfs_rq);
-
 		prev = rq->tmp_alone_branch;
 	}
 
+	if (prev == &rq->leaf_cfs_rq_list)
+		return false;
+
 	prev_cfs_rq = container_of(prev, struct cfs_rq, leaf_cfs_rq_list);
 
 	return (prev_cfs_rq->tg->parent == cfs_rq->tg);
-- 
2.39.5



