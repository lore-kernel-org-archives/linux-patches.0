Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27793161A1;
	Sat, 12 Sep 2026 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220966; cv=none; b=RsJE50gJ6iZzIXw7RUATF8e5tu2mkc/Rce9vTyI+X0RIWMZxmjs+hCRdzoeLRefpaWVjdUgQh3NUcjwNeMLGvsMUWsfrP94crtMPPa3Yj/p/BgpNZzFB/J9wxovZ/WFY5Xb26p9NGu5y8bwI+ugOT1hNuxbg8aKdNBSorg9m5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220966; c=relaxed/simple;
	bh=fyVuwcAVTKt4rNIMllYKGEk9Xn3Hl4aQCfdt4dz1abU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKD4TVCnv/IqfBWQFUxxYtcQl6eoVYkLMzWixz0amSRko2gHVi+nX0xm8zW0HXoeqHga1UVmgmgXn8QYRp+z7YPiWe8GjNkUunsrtVujgG+z3UMaWfAqGumyfQYqtyj/eKA7iFrleey2MeqJw772FWNEJ/neM8u1wlYLkg7tjXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOck3XVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOck3XVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02121F000FF;
	Sat, 12 Sep 2026 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220964;
	bh=SQp9lWQ2Eu5UgYE3hFQxtwujEseKhY3RZN/9KH2R5lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOck3XVaHlta8kiTYRtmge1t5dQgSQ9Eqzj4doxZrv5IXOtW7NXEIqQxZkenz1RNo
	 B/SG9ksL19HbfoYFyDdiBeLlFYXYGHJEVwyy45EsNBV4ms44xTCNbhlQabVfqnWLcr
	 6lWY+XF06iF9yCQ8S/d4vwOfEGd1KXNCE7KYUbDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0285/1424] cgroup/cpuset: Fix misplaced DL migration reset
Date: Sat, 12 Sep 2026 08:45:17 +0200
Message-ID: <20260912065613.664284461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

Mainline commit 4a39eda5fdd8 ("cgroup/cpuset: Reset DL migration state
on can_attach() failure") puts the common error cleanup in
cpuset_can_attach().  The 6.6.y backport instead placed that hunk at
cpuset_can_fork()'s similarly named out_unlock label, while removing
cpuset_can_attach()'s two existing targeted resets.

If cpuset_can_attach() fails after accounting a SCHED_DEADLINE task,
cgroup_migrate_execute() does not call cpuset_cancel_attach() for the
failing subsystem.  The temporary migration fields remain set, and a
later successful migration can consume the stale state and corrupt
deadline-task and pending-bandwidth accounting.

Move the reset to cpuset_can_attach()'s common error exit.  It is not
needed in cpuset_can_fork(), which never accumulates migration DL state.

Fixes: 14897ef9341c ("cgroup/cpuset: Reset DL migration state on can_attach() failure")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f9c7178f51ada..bb413045d1744 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2630,6 +2630,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 */
 	cs->attach_in_progress++;
 out_unlock:
+	if (ret)
+		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
@@ -3462,8 +3464,6 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
 	cs->attach_in_progress++;
 
 out_unlock:
-	if (ret)
-		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
-- 
2.53.0



