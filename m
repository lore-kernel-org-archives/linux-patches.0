Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF418035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3UZ0KwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD67CC433C8;
	Mon,  9 Oct 2023 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858880;
	bh=4el1q7CcPw10LMoZJ4/kkjgBIqK+QBnSXeU5TTQMqSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3UZ0KwSLY5TBgjG0ixnFLC9Y0NyBiSf2U7r8/4zFS0gCqfPHFmdhv8aMbwuUSQbU
	 gis+IXb0haVFUS5/lU/Ht0egR1lPQj6wbdxbxUmfCwZonCaG2n4GaIil/QFp+v5YTo
	 gbj8zhHoeqIxJuJEXi1DRpTXNyf4zhFj5LYCtZng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minye Zhu <zhuminye@bytedance.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/226] sched/cpuacct: Fix charge percpu cpuusage
Date: Mon,  9 Oct 2023 15:01:31 +0200
Message-ID: <20231009130130.163242270@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Chengming Zhou <zhouchengming@bytedance.com>

commit 248cc9993d1cc12b8e9ed716cc3fc09f6c3517dd upstream.

The cpuacct_account_field() is always called by the current task
itself, so it's ok to use __this_cpu_add() to charge the tick time.

But cpuacct_charge() maybe called by update_curr() in load_balance()
on a random CPU, different from the CPU on which the task is running.
So __this_cpu_add() will charge that cputime to a random incorrect CPU.

Fixes: 73e6aafd9ea8 ("sched/cpuacct: Simplify the cpuacct code")
Reported-by: Minye Zhu <zhuminye@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220220051426.5274-1-zhouchengming@bytedance.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpuacct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 8a260115a137b..3c59c541dd314 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -328,12 +328,13 @@ static struct cftype files[] = {
  */
 void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
+	unsigned int cpu = task_cpu(tsk);
 	struct cpuacct *ca;
 
 	rcu_read_lock();
 
 	for (ca = task_ca(tsk); ca; ca = parent_ca(ca))
-		__this_cpu_add(*ca->cpuusage, cputime);
+		*per_cpu_ptr(ca->cpuusage, cpu) += cputime;
 
 	rcu_read_unlock();
 }
-- 
2.40.1



