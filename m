Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FF61DDCE;
	Tue, 16 Jul 2024 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145696; cv=none; b=BtQBtq0+9PTYEKnEYuh8ouaRYpXGtv0G7SCvRzUZPwvBDH/Lt4AEVodHOpKHMZPOWPXlirHd1oQ5pNSypGHClhypgW+qYIiLeraOINgyDX8UxVpWCXRzzrsSh+QYFwt+n0pZhG1EAV19RzwqSu6tJOTbr7Nk53d1S7ghg7kAmc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145696; c=relaxed/simple;
	bh=p7n0YZUXawntrAWYgqm+xjwUJeu2NfOP43IBDKV6oxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqLoLoDj17cSvzr9WlXGXt7scvkTed6/m8Ud0g3cx2Eqmq36hiEuR0/XexE+JoAH5XqajRbYJoQuSbOpML4ura28DVAPIAT4o2tLbwSe2iAi7/hi2mNny5f8/Nm43t/86TVBnYx2l+di9PRKE0VQ16jsV4h/OEi1tfiJi3LVFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0dpA6Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0dpA6Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BCAC116B1;
	Tue, 16 Jul 2024 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145696;
	bh=p7n0YZUXawntrAWYgqm+xjwUJeu2NfOP43IBDKV6oxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0dpA6LvP8kbxvFPX0CBHdv6admFa2n0YIhcOk2xNUpqd1MSfJKp/e+imR4wUz6nB
	 Qjnuo9UY40XVkSzta1+4izcEDm0wGDkJ9Vq4oliy2Zxtaw2yYvOi1EuEpf9V8kjyuc
	 jcZQ1N8/YsYJfP0vmucwcbFJWLpSfS4G0Tp+6m/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Don <joshdon@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 6.6 052/121] Revert "sched/fair: Make sure to try to detach at least one movable task"
Date: Tue, 16 Jul 2024 17:31:54 +0200
Message-ID: <20240716152753.324089708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Josh Don <joshdon@google.com>

commit 2feab2492deb2f14f9675dd6388e9e2bf669c27a upstream.

This reverts commit b0defa7ae03ecf91b8bfd10ede430cff12fcbd06.

b0defa7ae03ec changed the load balancing logic to ignore env.max_loop if
all tasks examined to that point were pinned. The goal of the patch was
to make it more likely to be able to detach a task buried in a long list
of pinned tasks. However, this has the unfortunate side effect of
creating an O(n) iteration in detach_tasks(), as we now must fully
iterate every task on a cpu if all or most are pinned. Since this load
balance code is done with rq lock held, and often in softirq context, it
is very easy to trigger hard lockups. We observed such hard lockups with
a user who affined O(10k) threads to a single cpu.

When I discussed this with Vincent he initially suggested that we keep
the limit on the number of tasks to detach, but increase the number of
tasks we can search. However, after some back and forth on the mailing
list, he recommended we instead revert the original patch, as it seems
likely no one was actually getting hit by the original issue.

Fixes: b0defa7ae03e ("sched/fair: Make sure to try to detach at least one movable task")
Signed-off-by: Josh Don <joshdon@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20240620214450.316280-1-joshdon@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8977,12 +8977,8 @@ static int detach_tasks(struct lb_env *e
 			break;
 
 		env->loop++;
-		/*
-		 * We've more or less seen every task there is, call it quits
-		 * unless we haven't found any movable task yet.
-		 */
-		if (env->loop > env->loop_max &&
-		    !(env->flags & LBF_ALL_PINNED))
+		/* We've more or less seen every task there is, call it quits */
+		if (env->loop > env->loop_max)
 			break;
 
 		/* take a breather every nr_migrate tasks */
@@ -11259,9 +11255,7 @@ more_balance:
 
 		if (env.flags & LBF_NEED_BREAK) {
 			env.flags &= ~LBF_NEED_BREAK;
-			/* Stop if we tried all running tasks */
-			if (env.loop < busiest->nr_running)
-				goto more_balance;
+			goto more_balance;
 		}
 
 		/*


