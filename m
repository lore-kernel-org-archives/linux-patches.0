Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6053A1B150B;
	Thu,  6 Jun 2024 14:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683393; cv=none; b=YVuPqWtQ+EoLkb1dBV7aqsSgzCBDa6yg1YMbW0peMEbIMD2ZPGkFycKtKUjWmaKhGSm27UJKlu5A4/6a8mtfeXDt5yoyP78Yd9cdegEiZ187PknpJPWKQii3epkFCp2GO1isIlsPm7JRCioQ4cZMuoE3GhlpSWuIX4VjAkx4+Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683393; c=relaxed/simple;
	bh=/J8DLDyJy5KxFYm5vVhxGP/V3VF9JOJnCwfUECusMHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB8ngi5WDcIzHX+JdNvYnPSBCiAQhmVmL+Nzsi0DX8A0fzwqQtmB5UIXkNo0cw3aKA0DwhJR48R6A4HPaan7BrMLDuyrAea8sU0XQfxcDny8Lbb5MNOJORyg0I0icLkFO3plmx5CN6Iw7Itq4aFtAwYVLk7AvZK0ibhILZq4G1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xT0wobfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xT0wobfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40856C2BD10;
	Thu,  6 Jun 2024 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683393;
	bh=/J8DLDyJy5KxFYm5vVhxGP/V3VF9JOJnCwfUECusMHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xT0wobfPYxMSOnaa7hBWYZf/mapkV9M7C4IvLUAL636F6AVoyrEG3a/05vij9RRW5
	 DE0x/YQnU/9MjxXh51chs8IGVKmMo1vevEgF7QEHBMIf2VwXfWuRsBA5kD1IoDlmM/
	 5q+EfGgO+7oEW0QYxVvXL++9gO8bmY3vXaH9+s5U=
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
Subject: [PATCH 6.1 277/473] sched/core: Fix incorrect initialization of the burst parameter in cpu_max_write()
Date: Thu,  6 Jun 2024 16:03:26 +0200
Message-ID: <20240606131709.067344715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 18a4f8f28a25f..d71234729edb4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11117,7 +11117,7 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 {
 	struct task_group *tg = css_tg(of_css(of));
 	u64 period = tg_get_cfs_period(tg);
-	u64 burst = tg_get_cfs_burst(tg);
+	u64 burst = tg->cfs_bandwidth.burst;
 	u64 quota;
 	int ret;
 
-- 
2.43.0



