Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18B524D1;
	Mon, 11 Dec 2023 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzZYi3J1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE7CC433C8;
	Mon, 11 Dec 2023 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319560;
	bh=XCXNP4xRu65TsGJluZhzmt9e/SneuWlVWh64iLAc5O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzZYi3J1rDyHna5kz1a0d1PwGsBQAc1MtQUWKNaDOgI6FK4cRg9q4sYdoFm21SIie
	 7vV0hWxSvU0KGPcAy3v/bP9CFFCs0yGPnOtJ+aAmsX1nBaP0IlJdzpA431jS8fOOqf
	 eLChvGERB7SQVyjd46ags5U0SO8fgRxUAQmeOVgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Mark Hasemeyer <markhas@chromium.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 151/244] cgroup_freezer: cgroup_freezing: Check if not frozen
Date: Mon, 11 Dec 2023 19:20:44 +0100
Message-ID: <20231211182052.589573124@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Van Patten <timvp@google.com>

commit cff5f49d433fcd0063c8be7dd08fa5bf190c6c37 upstream.

__thaw_task() was recently updated to warn if the task being thawed was
part of a freezer cgroup that is still currently freezing:

	void __thaw_task(struct task_struct *p)
	{
	...
		if (WARN_ON_ONCE(freezing(p)))
			goto unlock;

This has exposed a bug in cgroup1 freezing where when CGROUP_FROZEN is
asserted, the CGROUP_FREEZING bits are not also cleared at the same
time. Meaning, when a cgroup is marked FROZEN it continues to be marked
FREEZING as well. This causes the WARNING to trigger, because
cgroup_freezing() thinks the cgroup is still freezing.

There are two ways to fix this:

1. Whenever FROZEN is set, clear FREEZING for the cgroup and all
children cgroups.
2. Update cgroup_freezing() to also verify that FROZEN is not set.

This patch implements option (2), since it's smaller and more
straightforward.

Signed-off-by: Tim Van Patten <timvp@google.com>
Tested-by: Mark Hasemeyer <markhas@chromium.org>
Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/legacy_freezer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -66,9 +66,15 @@ static struct freezer *parent_freezer(st
 bool cgroup_freezing(struct task_struct *task)
 {
 	bool ret;
+	unsigned int state;
 
 	rcu_read_lock();
-	ret = task_freezer(task)->state & CGROUP_FREEZING;
+	/* Check if the cgroup is still FREEZING, but not FROZEN. The extra
+	 * !FROZEN check is required, because the FREEZING bit is not cleared
+	 * when the state FROZEN is reached.
+	 */
+	state = task_freezer(task)->state;
+	ret = (state & CGROUP_FREEZING) && !(state & CGROUP_FROZEN);
 	rcu_read_unlock();
 
 	return ret;


