Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5419FA90;
	Thu, 15 Aug 2024 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732305; cv=none; b=iodKHC6aZbee7PtgMw0kQbezxKK3HHwinsYCGIa/aocPYgKBmZhLueMcmMEazdNhQtZevyDkH/eyBtW9PmaBDYVpdEoxUKA66tsRkw8v2D53dXjzvEJqszSVTZRoP0awKdWscnVJuirW+hO1TsJshgsBYWTwFeE8Rn1gvUOUv9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732305; c=relaxed/simple;
	bh=DbKSWjjUi+fIRFWlIspEk7DQb7pgNuCSrl9wJX2X6mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnm3UWMbPkFutG+Ur1GEofGoWRxhS5FBXMgU/YQ5QSxa7j2K8Dxc8Sbk+33s5eM0oq+/PteDGvhcSynrTqYhohUu04NEIusihcB3ByqYdPWllfeDjtuykfh7kf9mi8WzLHBY/zWHEJrDSt+Jw5287rslM3OLUCR4h9et3hq8Kw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyYnpI3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyYnpI3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74BFC32786;
	Thu, 15 Aug 2024 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732305;
	bh=DbKSWjjUi+fIRFWlIspEk7DQb7pgNuCSrl9wJX2X6mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyYnpI3+EzzLW1hBoJiHpfz/7V1dA+RuT+q93o/GMfzjexEEksgG2BP8u/CdMNeFK
	 rIYv3dbubJjTZVvd/QuJFNXV0tzWT25+eLJK3nBqdEB7t3dY8S+VXRG2UoBPvH88FF
	 qC5t9y8HlyV8WfRnbVq5abJ9OGSRPfuJ6pxDk2Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 5.10 138/352] sched/fair: Use all little CPUs for CPU-bound workloads
Date: Thu, 15 Aug 2024 15:23:24 +0200
Message-ID: <20240815131924.591190020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7950,7 +7950,7 @@ static int detach_tasks(struct lb_env *e
 		case migrate_util:
 			util = task_util_est(p);
 
-			if (util > env->imbalance)
+			if (shr_bound(util, env->sd->nr_balance_failed) > env->imbalance)
 				goto next;
 
 			env->imbalance -= util;


