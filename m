Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32D3168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5073EC433CB;
	Wed, 20 Sep 2023 12:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213874;
	bh=kbfMwPgGd5K4UtrK5x9DuuNLDwkQy1JdYdtaIsD8l3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZRiPqiOOYBILx+mKexy3NnivNvQN5ra//2l3XSGlzFNbUTX2TxSODUdxdevFwYug
	 LWSIeMn0NgZQx+dMM2bV/c5z6e+/Fi+q0S5+SE85DRathLDm/cuZlOlLboGhCoycxN
	 Ll1eibgKX85f47cQZ/n5wPntY8JQ5jlhvn6b6LDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/110] rcuscale: Move rcu_scale_writer() schedule_timeout_uninterruptible() to _idle()
Date: Wed, 20 Sep 2023 13:31:04 +0200
Message-ID: <20230920112830.621475399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit e60c122a1614b4f65b29a7bef9d83b9fd30e937a ]

The rcuscale.holdoff module parameter can be used to delay the start
of rcu_scale_writer() kthread.  However, the hung-task timeout will
trigger when the timeout specified by rcuscale.holdoff is greater than
hung_task_timeout_secs:

runqemu kvm nographic slirp qemuparams="-smp 4 -m 2048M"
bootparams="rcuscale.shutdown=0 rcuscale.holdoff=300"

[  247.071753] INFO: task rcu_scale_write:59 blocked for more than 122 seconds.
[  247.072529]       Not tainted 6.4.0-rc1-00134-gb9ed6de8d4ff #7
[  247.073400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.074331] task:rcu_scale_write state:D stack:30144 pid:59    ppid:2      flags:0x00004000
[  247.075346] Call Trace:
[  247.075660]  <TASK>
[  247.075965]  __schedule+0x635/0x1280
[  247.076448]  ? __pfx___schedule+0x10/0x10
[  247.076967]  ? schedule_timeout+0x2dc/0x4d0
[  247.077471]  ? __pfx_lock_release+0x10/0x10
[  247.078018]  ? enqueue_timer+0xe2/0x220
[  247.078522]  schedule+0x84/0x120
[  247.078957]  schedule_timeout+0x2e1/0x4d0
[  247.079447]  ? __pfx_schedule_timeout+0x10/0x10
[  247.080032]  ? __pfx_rcu_scale_writer+0x10/0x10
[  247.080591]  ? __pfx_process_timeout+0x10/0x10
[  247.081163]  ? __pfx_sched_set_fifo_low+0x10/0x10
[  247.081760]  ? __pfx_rcu_scale_writer+0x10/0x10
[  247.082287]  rcu_scale_writer+0x6b1/0x7f0
[  247.082773]  ? mark_held_locks+0x29/0xa0
[  247.083252]  ? __pfx_rcu_scale_writer+0x10/0x10
[  247.083865]  ? __pfx_rcu_scale_writer+0x10/0x10
[  247.084412]  kthread+0x179/0x1c0
[  247.084759]  ? __pfx_kthread+0x10/0x10
[  247.085098]  ret_from_fork+0x2c/0x50
[  247.085433]  </TASK>

This commit therefore replaces schedule_timeout_uninterruptible() with
schedule_timeout_idle().

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 57ec414710bbc..a83cb29d37607 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -402,7 +402,7 @@ rcu_scale_writer(void *arg)
 	sched_set_fifo_low(current);
 
 	if (holdoff)
-		schedule_timeout_uninterruptible(holdoff * HZ);
+		schedule_timeout_idle(holdoff * HZ);
 
 	/*
 	 * Wait until rcu_end_inkernel_boot() is called for normal GP tests
-- 
2.40.1



