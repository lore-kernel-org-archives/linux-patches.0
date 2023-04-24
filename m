Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DD52108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD7AC433D2;
	Mon, 24 Apr 2023 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343296;
	bh=yST70huNKn2hy4ZF4XI5MUjPDyBiYb+t1gY0elZlGUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLCu+SAPOJW/ncLT7h4JNuEqzvjDI3XECHpDNqOgTWJD3BVDq2OTdC/ceuFZISwLi
	 gzDgINMMGDkWsqbdAtVYRquJm07yrdQMlfy4A2+blzvNEZbCJJgUqLDenRom4Uzg4g
	 v1YI3ZcPuCx0i9r1eKK64G4MN4XDyHtKIsmJrdQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qais Yousef <qais.yousef@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 5.10 40/68] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date: Mon, 24 Apr 2023 15:18:11 +0200
Message-Id: <20230424131129.200675071@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qais Yousef <qais.yousef@arm.com>

commit c56ab1b3506ba0e7a872509964b100912bde165d upstream.

So that it is now uclamp aware.

This fixes a major problem of busy tasks capped with UCLAMP_MAX keeping
the system in overutilized state which disables EAS and leads to wasting
energy in the long run.

Without this patch running a busy background activity like JIT
compilation on Pixel 6 causes the system to be in overutilized state
74.5% of the time.

With this patch this goes down to  9.79%.

It also fixes another problem when long running tasks that have their
UCLAMP_MIN changed while running such that they need to upmigrate to
honour the new UCLAMP_MIN value. The upmigration doesn't get triggered
because overutilized state never gets set in this state, hence misfit
migration never happens at tick in this case until the task wakes up
again.

Fixes: af24bde8df202 ("sched/uclamp: Add uclamp support to energy_compute()")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-7-qais.yousef@arm.com
(cherry picked from commit c56ab1b3506ba0e7a872509964b100912bde165d)
[Conflict in kernel/sched/fair.c: use cpu_util() instead of
cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5657,7 +5657,10 @@ static inline unsigned long cpu_util(int
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)


