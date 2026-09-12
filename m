Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B476357D18;
	Sat, 12 Sep 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227678; cv=none; b=o5l15NP+r4oyhvgyEOzRqYdwvvb0xInClY6t5R3t35vOLomk2y8l7lOasVTclYHv4J8jYZQ+v6QuV11H4/ZFURBFyQpL31JbRViJvf9262tu50R487RWAK1eg01zW4tqB8SjVRiyp2fHGfgv+4EIWZkmbQV8LGzH1yfITH3QrkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227678; c=relaxed/simple;
	bh=UHNyD/0uzgNq4xh4fPPbLpT06lAOYpN/OVbLN4XGGc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKCyUL/LXWfriOf3sx2P6R2WvB0IzFNtnsUzj96J2XHrLjtAaj8S1DRZoFCFDwtSEnk4W22TxM5FXx8be5KeI3cSoS6KFsaROBnlqYiZkAyEQznV4GZ5u1HHJLLoa6nRfY9478Q6UecULzUOrJAWf764Ra/mfjC2MZzlAaSO43c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqQ1QyvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqQ1QyvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498061F000FF;
	Sat, 12 Sep 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227677;
	bh=8IVp997ZxRL+bwA0OnA+Gou/kouq+9B5dLfOHb/4vvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqQ1QyvY71V74Up4HmPDEpkDNS73MYFtt+tz6oEW1D6NctqtUm4wL04mIvxQ2C2Ox
	 3bCih8fNHUscC89eJcY5I1jCdn3jRKFJXtJBs7utGBYArGti/NStcEubr6eJWt2hDN
	 CsgeL0nFYHRAxeACEQGEgDlHhulByx6iyfwe/jdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0229/1191] cgroup/cpuset: Fix misplaced DL migration reset
Date: Sat, 12 Sep 2026 08:49:17 +0200
Message-ID: <20260912065553.352678413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
on can_attach() failure") puts the common error cleanup in
cpuset_can_attach().  The 6.1.y backport instead placed that hunk at
cpuset_can_fork()'s similarly named out_unlock label, while removing
cpuset_can_attach()'s two existing targeted resets.

If cpuset_can_attach() fails after accounting a SCHED_DEADLINE task,
cgroup_migrate_execute() does not call cpuset_cancel_attach() for the
failing subsystem.  The temporary migration fields remain set, and a
later successful migration can consume the stale state and corrupt
deadline-task and pending-bandwidth accounting.

Move the reset to cpuset_can_attach()'s common error exit.  It is not
needed in cpuset_can_fork(), which never accumulates migration DL state.

Fixes: f8a8358832f3 ("cgroup/cpuset: Reset DL migration state on can_attach() failure")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 681b52f6aae5b..7123bb020a242 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2600,6 +2600,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 */
 	cs->attach_in_progress++;
 out_unlock:
+	if (ret)
+		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
@@ -3405,8 +3407,6 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
 	cs->attach_in_progress++;
 
 out_unlock:
-	if (ret)
-		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
-- 
2.53.0



