Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF1168C4;
	Mon, 27 May 2024 19:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837385; cv=none; b=t474LeMU3AFnooSKSA+bXzYKptaJuS5LpkDStuEx8V3Jxk2xQaECGFWhfzTcm7i53+WxuCl2QTI9P0P4B+havsNOgqEmXqaS5ok3z257Ki8HzD/VfZISJ6p5xb/FX0k9kRDAe4Elc4HYlxZJXk8kdK6O+5xNCyhCtE+wrL74Cdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837385; c=relaxed/simple;
	bh=4rbyc3hAFglCVosixIW69Zx66pu7vJoLvG0XIg5wvTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCYkYUuNGRdZHbiIMeku32l61udIsb00fCCk037a1mNczhhg32Z12JK9mz5JzXeM+9tRXhtjNF5k/Jx7CkTS6ecB9bthQJ4VWLeMgNfELHplUz3VVZlr+IEDKfVvRJFW+toxSwoxx+ZrJWUwmHj/pbwfww4Wry0cgHrhKC/bvpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edfBbOAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edfBbOAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095C0C2BBFC;
	Mon, 27 May 2024 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837385;
	bh=4rbyc3hAFglCVosixIW69Zx66pu7vJoLvG0XIg5wvTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edfBbOAuCNVDCsmjPOjTNJfpCwyuW7hyFw4UTRha5icnD0bYg7aVEOis3s+RKFFXa
	 WNY1l7dn9QB+EzTYG/x70khS3I0zzxBYTsTtYqh4zs4IB6Cazv8Nzvswe+oD2m2Z/0
	 dOgRRQNovqdDgTg4Oz90SKCgTZWzf10m1j6J2/Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qixin Liao <liaoqixin@huawei.com>,
	Cheng Yu <serein.chengyu@huawei.com>,
	Zhang Qiao <zhangqiao22@huawei.com>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 421/427] sched/core: Fix incorrect initialization of the burst parameter in cpu_max_write()
Date: Mon, 27 May 2024 20:57:48 +0200
Message-ID: <20240527185635.733745107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yu <serein.chengyu@huawei.com>

[ Upstream commit 49217ea147df7647cb89161b805c797487783fc0 ]

In the cgroup v2 CPU subsystem, assuming we have a
cgroup named 'test', and we set cpu.max and cpu.max.burst:

    # echo 1000000 > /sys/fs/cgroup/test/cpu.max
    # echo 1000000 > /sys/fs/cgroup/test/cpu.max.burst

then we check cpu.max and cpu.max.burst:

    # cat /sys/fs/cgroup/test/cpu.max
    1000000 100000
    # cat /sys/fs/cgroup/test/cpu.max.burst
    1000000

Next we set cpu.max again and check cpu.max and
cpu.max.burst:

    # echo 2000000 > /sys/fs/cgroup/test/cpu.max
    # cat /sys/fs/cgroup/test/cpu.max
    2000000 100000

    # cat /sys/fs/cgroup/test/cpu.max.burst
    1000

... we find that the cpu.max.burst value changed unexpectedly.

In cpu_max_write(), the unit of the burst value returned
by tg_get_cfs_burst() is microseconds, while in cpu_max_write(),
the burst unit used for calculation should be nanoseconds,
which leads to the bug.

To fix it, get the burst value directly from tg->cfs_bandwidth.burst.

Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")
Reported-by: Qixin Liao <liaoqixin@huawei.com>
Signed-off-by: Cheng Yu <serein.chengyu@huawei.com>
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20240424132438.514720-1-serein.chengyu@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7019a40457a6d..d211d40a2edc9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11402,7 +11402,7 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 {
 	struct task_group *tg = css_tg(of_css(of));
 	u64 period = tg_get_cfs_period(tg);
-	u64 burst = tg_get_cfs_burst(tg);
+	u64 burst = tg->cfs_bandwidth.burst;
 	u64 quota;
 	int ret;
 
-- 
2.43.0



