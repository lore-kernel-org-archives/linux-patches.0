Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C38361FDF;
	Mon, 27 May 2024 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838697; cv=none; b=Ftg53I0CJGYT9Fq1toBQyF4gl9A0B43RQp2rz964i/JtaQ0RATUYfbhnToyheKis1xxRXFPKoxL6ci2RxB3rygfbjf5H7WgB9prM2mWV7afF141DV7IUxViL5xKg6Lv0Cn6pG4AQFKnZGC/rm3rBUvS7Gch11Zw/yjr/DGShDRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838697; c=relaxed/simple;
	bh=Lsv/31KQ61hrPqcqWHBAF8CwCscSS1XczKLapxFxJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHMh8RjhifyVLWkPGLmA7F/RHZt9xF++gRBpfX6xkGe3604OZz/9cDG5pkNwuRMdhCLmf++VVAlB8Qb9+qVqrNkkbUsTrgbGv7H70bvp5M9nP4n3tRfQaNV5yCDpCH2xWDv3hETz8uVzM+tObzV1cvd0jgQ3nSBP9kmtQmi9kaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PA1nbuyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PA1nbuyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E50C2BBFC;
	Mon, 27 May 2024 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838697;
	bh=Lsv/31KQ61hrPqcqWHBAF8CwCscSS1XczKLapxFxJcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PA1nbuyjENLRlbAjoaM4dkiIn+b9ZdnjC20W6+YQ8k6mc4AEWFbrXsUlj0xa/f0bV
	 VlXpvt4yDY06x/VhFt/0IM2/K9yiZ+ElH+BT6nh9tucCdxeile91fgK/V3WBmfTL0c
	 Buq0G0r+m+9zBGWIIHPFoENMM+9NjJMB8HW6SfU4=
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
Subject: [PATCH 6.8 483/493] sched/core: Fix incorrect initialization of the burst parameter in cpu_max_write()
Date: Mon, 27 May 2024 20:58:05 +0200
Message-ID: <20240527185645.937066376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9116bcc903467..d3aef6283931e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11381,7 +11381,7 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 {
 	struct task_group *tg = css_tg(of_css(of));
 	u64 period = tg_get_cfs_period(tg);
-	u64 burst = tg_get_cfs_burst(tg);
+	u64 burst = tg->cfs_bandwidth.burst;
 	u64 quota;
 	int ret;
 
-- 
2.43.0



