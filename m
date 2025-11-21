Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6734D92B;
	Fri, 21 Nov 2025 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732244; cv=none; b=dVwDRuAotnvdkx/dXdmM1aIIdzjxmgS47XRo7Pt7xTGMERc8s3NXLY+JBysWrKH1bBctDrt3IQPGjmSFdbSmdHD4MS6eMH7epgVyOnFWJDu9vRrqNdv7YSTbA0CRniz+cCU1Ya8NM6kU8yjhkGNb68aQK7qvj/SWsuXfTuA6fiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732244; c=relaxed/simple;
	bh=BzBRfG9dRhn7kJrHSZUg8JCRFH3F51W5ga0ScgNPKZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6qlf5rWgCMGNBHOoAeSbmH75atczkoXelpgXivlUagR8cDspcCxZh/o0abVBA/Pgsw4YfJ4m9pWrpWtDGpRRVUKOtorxQtn14W7YEFIlubRvZOBQ0imi5eKjuJUY2AC1beVbmkRyObsXO+zchgEdSsLJ8ej11sGgDnxHaLYFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgjIS5lp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgjIS5lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C272C4CEFB;
	Fri, 21 Nov 2025 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732244;
	bh=BzBRfG9dRhn7kJrHSZUg8JCRFH3F51W5ga0ScgNPKZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgjIS5lplZcFm41WnsPL+Ca88JxxH2SmGLqLIME5m5QI21RH0vlR1XiKTJzh5+XhH
	 FfXIASAt4Fsq7pqp2DChsmlQTKKXhsOrUwaHrm/bsnzdJ0cvLXTf3NzvVeWcSdHQve
	 9YwUroPudGqFVfMJgOVRbgB+WYob+UF1CJDiEFws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.6 052/529] sched/fair: Use all little CPUs for CPU-bound workloads
Date: Fri, 21 Nov 2025 14:05:51 +0100
Message-ID: <20251121130232.863450294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Pierre Gondois <pierre.gondois@arm.com>

commit 3af7524b14198f5159a86692d57a9f28ec9375ce upstream.

Running N CPU-bound tasks on an N CPUs platform:

- with asymmetric CPU capacity

- not being a DynamIq system (i.e. having a PKG level sched domain
  without the SD_SHARE_PKG_RESOURCES flag set)

.. might result in a task placement where two tasks run on a big CPU
and none on a little CPU. This placement could be more optimal by
using all CPUs.

Testing platform:

  Juno-r2:
    - 2 big CPUs (1-2), maximum capacity of 1024
    - 4 little CPUs (0,3-5), maximum capacity of 383

Testing workload ([1]):

  Spawn 6 CPU-bound tasks. During the first 100ms (step 1), each tasks
  is affine to a CPU, except for:

    - one little CPU which is left idle.
    - one big CPU which has 2 tasks affine.

  After the 100ms (step 2), remove the cpumask affinity.

Behavior before the patch:

  During step 2, the load balancer running from the idle CPU tags sched
  domains as:

  - little CPUs: 'group_has_spare'. Cf. group_has_capacity() and
    group_is_overloaded(), 3 CPU-bound tasks run on a 4 CPUs
    sched-domain, and the idle CPU provides enough spare capacity
    regarding the imbalance_pct

  - big CPUs: 'group_overloaded'. Indeed, 3 tasks run on a 2 CPUs
    sched-domain, so the following path is used:

      group_is_overloaded()
      \-if (sgs->sum_nr_running <= sgs->group_weight) return true;

    The following path which would change the migration type to
    'migrate_task' is not taken:

      calculate_imbalance()
      \-if (env->idle != CPU_NOT_IDLE && env->imbalance == 0)

    as the local group has some spare capacity, so the imbalance
    is not 0.

  The migration type requested is 'migrate_util' and the busiest
  runqueue is the big CPU's runqueue having 2 tasks (each having a
  utilization of 512). The idle little CPU cannot pull one of these
  task as its capacity is too small for the task. The following path
  is used:

   detach_tasks()
   \-case migrate_util:
     \-if (util > env->imbalance) goto next;

After the patch:

As the number of failed balancing attempts grows (with
'nr_balance_failed'), progressively make it easier to migrate
a big task to the idling little CPU. A similar mechanism is
used for the 'migrate_load' migration type.

Improvement:

Running the testing workload [1] with the step 2 representing
a ~10s load for a big CPU:

  Before patch: ~19.3s
  After patch:  ~18s (-6.7%)

Similar issue reported at:

  https://lore.kernel.org/lkml/20230716014125.139577-1-qyousef@layalina.io/

Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Acked-by: Qais Yousef <qyousef@layalina.io>
Link: https://lore.kernel.org/r/20231206090043.634697-1-pierre.gondois@arm.com
Cc: John Stultz <jstultz@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9165,7 +9165,7 @@ static int detach_tasks(struct lb_env *e
 		case migrate_util:
 			util = task_util_est(p);
 
-			if (util > env->imbalance)
+			if (shr_bound(util, env->sd->nr_balance_failed) > env->imbalance)
 				goto next;
 
 			env->imbalance -= util;


