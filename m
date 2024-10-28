Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FC618E05D;
	Mon, 28 Oct 2024 06:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098075; cv=none; b=iEzlnPjO8Y3cxqgYcYtXZ9+0TtqbiL1BXSeS1fpNqF/LtBCgJ/BgKnxjjRdk2ckNerY7qBchrhiHWUaNoD+SBfizEQoTUl1Gylhs8kZXMP84hYd2TpJ7G0fbLwc51dhUZO2sS4BqwUS7vx1g8E/N4/h+czCDCB0rbf9RF7zmGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098075; c=relaxed/simple;
	bh=PJI16U6Gt0ZHdLo/QWJ901ezQec7yQlVH1hPzmPkpVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td3UqOqEjbpizVn8Hnh3g2snihoH11I60sp1DEZYwWUUxFy+UObzHmSQNThuZqn7wKXiC/IK5iJMF6Q66S3Zn+xVVFw+ZiS7pbJ2R4VQFQdNe6FqK5zbzDo/fJDL6FmvkCTShYYKr1FSAhspkxdFuEnVeRSofUTYVXSkH+T0p6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uln6mjq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uln6mjq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB2EC4CEC3;
	Mon, 28 Oct 2024 06:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098074;
	bh=PJI16U6Gt0ZHdLo/QWJ901ezQec7yQlVH1hPzmPkpVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uln6mjq96nDz2bZ9V0cHQWizGgXSOAVCtbKTpEZ1FaLuefWpgJObEvW2P9lKag11A
	 vEd9IOAr3UEGYAUSClMUDgKWZsoTnTDBs3TmB6jTdPzFu4YjjHnl9q5t9DEecYiZN+
	 3oJ0tMJJzOsIf+b1Xzoc9MOr4Vy/6IoiMkrYPg/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d383dc9579a76f56c251@syzkaller.appspotmail.com,
	syzbot+c596faae21a68bf7afd0@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 066/261] netdevsim: use cond_resched() in nsim_dev_trap_report_work()
Date: Mon, 28 Oct 2024 07:23:28 +0100
Message-ID: <20241028062313.687214789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a1494d532e28598bde7a5544892ef9c7dbfafa93 ]

I am still seeing many syzbot reports hinting that syzbot
might fool nsim_dev_trap_report_work() with hundreds of ports [1]

Lets use cond_resched(), and system_unbound_wq
instead of implicit system_wq.

[1]
INFO: task syz-executor:20633 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc2-syzkaller-00205-g1d227fcc7222 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:25856 pid:20633 tgid:20633 ppid:1      flags:0x00004006
...
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 16760 Comm: kworker/1:0 Not tainted 6.12.0-rc2-syzkaller-00205-g1d227fcc7222 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events nsim_dev_trap_report_work
 RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x70 kernel/kcov.c:210
Code: 89 fb e8 23 00 00 00 48 8b 3d 04 fb 9c 0c 48 89 de 5b e9 c3 c7 5d 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 8b 04 24 65 48 8b 0c 25 c0 d7 03 00 65 8b 15 60 f0
RSP: 0018:ffffc90000a187e8 EFLAGS: 00000246
RAX: 0000000000000100 RBX: ffffc90000a188e0 RCX: ffff888027d3bc00
RDX: ffff888027d3bc00 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88804a2e6000 R08: ffffffff8a4bc495 R09: ffffffff89da3577
R10: 0000000000000004 R11: ffffffff8a4bc2b0 R12: dffffc0000000000
R13: ffff88806573b503 R14: dffffc0000000000 R15: ffff8880663cca00
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc90a747f98 CR3: 000000000e734000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 000000000000002b DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
  __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:382
  spin_unlock_bh include/linux/spinlock.h:396 [inline]
  nsim_dev_trap_report drivers/net/netdevsim/dev.c:820 [inline]
  nsim_dev_trap_report_work+0x75d/0xaa0 drivers/net/netdevsim/dev.c:850
  process_one_work kernel/workqueue.c:3229 [inline]
  process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
  worker_thread+0x870/0xd30 kernel/workqueue.c:3391
  kthread+0x2f0/0x390 kernel/kthread.c:389
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Fixes: ba5e1272142d ("netdevsim: avoid potential loop in nsim_dev_trap_report_work()")
Reported-by: syzbot+d383dc9579a76f56c251@syzkaller.appspotmail.com
Reported-by: syzbot+c596faae21a68bf7afd0@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20241012094230.3893510-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 92a7a36b93ac0..3e0b61202f0c9 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -836,7 +836,8 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 	nsim_dev = nsim_trap_data->nsim_dev;
 
 	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
-		schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw, 1);
+		queue_delayed_work(system_unbound_wq,
+				   &nsim_dev->trap_data->trap_report_dw, 1);
 		return;
 	}
 
@@ -848,11 +849,12 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
 			continue;
 
 		nsim_dev_trap_report(nsim_dev_port);
+		cond_resched();
 	}
 	devl_unlock(priv_to_devlink(nsim_dev));
-
-	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
-			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+	queue_delayed_work(system_unbound_wq,
+			   &nsim_dev->trap_data->trap_report_dw,
+			   msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
 }
 
 static int nsim_dev_traps_init(struct devlink *devlink)
@@ -907,8 +909,9 @@ static int nsim_dev_traps_init(struct devlink *devlink)
 
 	INIT_DELAYED_WORK(&nsim_dev->trap_data->trap_report_dw,
 			  nsim_dev_trap_report_work);
-	schedule_delayed_work(&nsim_dev->trap_data->trap_report_dw,
-			      msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
+	queue_delayed_work(system_unbound_wq,
+			   &nsim_dev->trap_data->trap_report_dw,
+			   msecs_to_jiffies(NSIM_TRAP_REPORT_INTERVAL_MS));
 
 	return 0;
 
-- 
2.43.0



