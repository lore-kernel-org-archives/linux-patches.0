Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA61CF28B;
	Wed,  2 Oct 2024 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875649; cv=none; b=szF0In270MoZz63MocNDpCVy1PPweI/WaTpunFKQZohfjTFw/HnWkaYJKORuVhMAICjmeHTawI9kI/N63C+F+tsrG3q8QenqwxfLj02CD0fmzwjQWvO4SbnK1jDDu+DdzZdippaXdAp0aWV3HBthx0qBcC6oyH2X1JD2NWgIn2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875649; c=relaxed/simple;
	bh=s/cBXKqtDKuA36yCe/dB8yyKKPc/W1p7K7g7rxlZ/jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzbNJ3AKNPO4rb380riXoaGT0urRluwHQGTO1Mg71RxOumGTfR5RsTLpkahf3rsawtnFCONjWHHJ4oUMTJ6nR7kwLM+xENasNC8KgYzsCwxy2WMn/R1S0g7Plaw3y1fwBhporkUM0uKSENUzQJMtLjOj0XTnm0NbIbfS050YBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9lBVAhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9lBVAhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A51BC4CEC5;
	Wed,  2 Oct 2024 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875649;
	bh=s/cBXKqtDKuA36yCe/dB8yyKKPc/W1p7K7g7rxlZ/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9lBVAhhIEWaODI2GOCqcbTWD/G+7FkH5LfklwBEx3nb6CcMOo88dlc5sb3rUKT2j
	 dzFscHrkLYMbKLzzmxQSMLUZLnY04g4LmkkEwk/c+qz6X2Q6DlkNZHb0xvZwqa9HrO
	 82li8c8VMs9Ie1V0I16deSchzq2zty03uXMNDWCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 173/695] cgroup/pids: Avoid spurious event notification
Date: Wed,  2 Oct 2024 14:52:51 +0200
Message-ID: <20241002125829.376897713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit d72a00a8485d1cb11ac1a57bf89b02cbd3a405bf ]

Currently when a process in a group forks and fails due to it's
parent's max restriction, all the cgroups from 'pids_forking' to root
will generate event notifications but only the cgroups from
'pids_over_limit' to root will increase the counter of PIDCG_MAX.

Consider this scenario: there are 4 groups A, B, C,and D, the
relationships are as follows, and user is watching on C.pids.events.

root->A->B->C->D

When a process in D forks and fails due to B.max restriction, the
user will get a spurious event notification because when he wakes up
and reads C.pids.events, he will find that the content has not changed.

To address this issue, only the cgroups from 'pids_over_limit' to root
will have their PIDCG_MAX counters increased and event notifications
generated.

Fixes: 385a635cacfe ("cgroup/pids: Make event counters hierarchical")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/pids.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index f5cb0ec45b9dd..34aa63d7c9c65 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -244,7 +244,6 @@ static void pids_event(struct pids_cgroup *pids_forking,
 		       struct pids_cgroup *pids_over_limit)
 {
 	struct pids_cgroup *p = pids_forking;
-	bool limit = false;
 
 	/* Only log the first time limit is hit. */
 	if (atomic64_inc_return(&p->events_local[PIDCG_FORKFAIL]) == 1) {
@@ -252,20 +251,17 @@ static void pids_event(struct pids_cgroup *pids_forking,
 		pr_cont_cgroup_path(p->css.cgroup);
 		pr_cont("\n");
 	}
-	cgroup_file_notify(&p->events_local_file);
 	if (!cgroup_subsys_on_dfl(pids_cgrp_subsys) ||
-	    cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS)
+	    cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS) {
+		cgroup_file_notify(&p->events_local_file);
 		return;
+	}
 
-	for (; parent_pids(p); p = parent_pids(p)) {
-		if (p == pids_over_limit) {
-			limit = true;
-			atomic64_inc(&p->events_local[PIDCG_MAX]);
-			cgroup_file_notify(&p->events_local_file);
-		}
-		if (limit)
-			atomic64_inc(&p->events[PIDCG_MAX]);
+	atomic64_inc(&pids_over_limit->events_local[PIDCG_MAX]);
+	cgroup_file_notify(&pids_over_limit->events_local_file);
 
+	for (p = pids_over_limit; parent_pids(p); p = parent_pids(p)) {
+		atomic64_inc(&p->events[PIDCG_MAX]);
 		cgroup_file_notify(&p->events_file);
 	}
 }
-- 
2.43.0



