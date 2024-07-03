Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9A013E024;
	Wed,  3 Jul 2024 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005656; cv=none; b=mwxcDrXgrbdWfmoZ+pZJtXi+4yenYfXANyXZQkzkATznngdsyOU71qLRKnCMBYuDd9EBBNqLLt9O9RnmEj5nvwFvSzu1PBVqWffks7KFEftxunwB7THkdt2XqLGVvnqx12O6IFqdtmjap57nvRg5qR2KLObIjlA8n6sd6lB9PsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005656; c=relaxed/simple;
	bh=TK76AAZ4q6YmKVG8dAr995hacdE8gGU6380W2PRBQ7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQo7CsDjpPmTpUWTERGy4rMvYpXS4nImzyyvpYWbSr9wfpPj6f4ZiYtq6mBlXtQrtULsQLXJ9Of25ZL5SHXErUnHADYLmBWMy/FdtodegXmySwIFZug6/J6OHUbpj48IaTwY0iPl5Y/oqQt7uu6CuMK+Q4WDbsWapPXUeuHe/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RmfIBMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RmfIBMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B681CC2BD10;
	Wed,  3 Jul 2024 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005656;
	bh=TK76AAZ4q6YmKVG8dAr995hacdE8gGU6380W2PRBQ7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RmfIBMTsy+HDU9q4L7I9jQiSgOj6iZ6yp8NfpoMh3DCtKXDtlKce3n/AP7cIABj5
	 RN9YwcyKypabUPKh4zyzt6QQRju1+GtWuLdU/rxPMpl0TB/eSIvy/4cqgbwmglgc4B
	 OlFMyOYwTvcQ/JwKiw0FzpTUyw/B16sZrEqPSe18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/356] rcutorture: Make stall-tasks directly exit when rcutorture tests end
Date: Wed,  3 Jul 2024 12:38:09 +0200
Message-ID: <20240703102918.891631297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

[ Upstream commit 431315a563015f259b28e34c5842f6166439e969 ]

When the rcutorture tests start to exit, the rcu_torture_cleanup() is
invoked to stop kthreads and release resources, if the stall-task
kthreads exist, cpu-stall has started and the rcutorture.stall_cpu
is set to a larger value, the rcu_torture_cleanup() will be blocked
for a long time and the hung-task may occur, this commit therefore
add kthread_should_stop() to the loop of cpu-stall operation, when
rcutorture tests ends, no need to wait for cpu-stall to end, exit
directly.

Use the following command to test:

insmod rcutorture.ko torture_type=srcu fwd_progress=0 stat_interval=4
stall_cpu_block=1 stall_cpu=200 stall_cpu_holdoff=10 read_exit_burst=0
object_debug=1
rmmod rcutorture

[15361.918610] INFO: task rmmod:878 blocked for more than 122 seconds.
[15361.918613]       Tainted: G        W
6.8.0-rc2-yoctodev-standard+ #25
[15361.918615] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[15361.918616] task:rmmod           state:D stack:0     pid:878
tgid:878   ppid:773    flags:0x00004002
[15361.918621] Call Trace:
[15361.918623]  <TASK>
[15361.918626]  __schedule+0xc0d/0x28f0
[15361.918631]  ? __pfx___schedule+0x10/0x10
[15361.918635]  ? rcu_is_watching+0x19/0xb0
[15361.918638]  ? schedule+0x1f6/0x290
[15361.918642]  ? __pfx_lock_release+0x10/0x10
[15361.918645]  ? schedule+0xc9/0x290
[15361.918648]  ? schedule+0xc9/0x290
[15361.918653]  ? trace_preempt_off+0x54/0x100
[15361.918657]  ? schedule+0xc9/0x290
[15361.918661]  schedule+0xd0/0x290
[15361.918665]  schedule_timeout+0x56d/0x7d0
[15361.918669]  ? debug_smp_processor_id+0x1b/0x30
[15361.918672]  ? rcu_is_watching+0x19/0xb0
[15361.918676]  ? __pfx_schedule_timeout+0x10/0x10
[15361.918679]  ? debug_smp_processor_id+0x1b/0x30
[15361.918683]  ? rcu_is_watching+0x19/0xb0
[15361.918686]  ? wait_for_completion+0x179/0x4c0
[15361.918690]  ? __pfx_lock_release+0x10/0x10
[15361.918693]  ? __kasan_check_write+0x18/0x20
[15361.918696]  ? wait_for_completion+0x9d/0x4c0
[15361.918700]  ? _raw_spin_unlock_irq+0x36/0x50
[15361.918703]  ? wait_for_completion+0x179/0x4c0
[15361.918707]  ? _raw_spin_unlock_irq+0x36/0x50
[15361.918710]  ? wait_for_completion+0x179/0x4c0
[15361.918714]  ? trace_preempt_on+0x54/0x100
[15361.918718]  ? wait_for_completion+0x179/0x4c0
[15361.918723]  wait_for_completion+0x181/0x4c0
[15361.918728]  ? __pfx_wait_for_completion+0x10/0x10
[15361.918738]  kthread_stop+0x152/0x470
[15361.918742]  _torture_stop_kthread+0x44/0xc0 [torture
7af7f9cbba28271a10503b653f9e05d518fbc8c3]
[15361.918752]  rcu_torture_cleanup+0x2ac/0xe90 [rcutorture
f2cb1f556ee7956270927183c4c2c7749a336529]
[15361.918766]  ? __pfx_rcu_torture_cleanup+0x10/0x10 [rcutorture
f2cb1f556ee7956270927183c4c2c7749a336529]
[15361.918777]  ? __kasan_check_write+0x18/0x20
[15361.918781]  ? __mutex_unlock_slowpath+0x17c/0x670
[15361.918789]  ? __might_fault+0xcd/0x180
[15361.918793]  ? find_module_all+0x104/0x1d0
[15361.918799]  __x64_sys_delete_module+0x2a4/0x3f0
[15361.918803]  ? __pfx___x64_sys_delete_module+0x10/0x10
[15361.918807]  ? syscall_exit_to_user_mode+0x149/0x280

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 82c6046db8a42..e9323cc5da73b 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2061,8 +2061,8 @@ static int rcu_torture_stall(void *args)
 			preempt_disable();
 		pr_alert("%s start on CPU %d.\n",
 			  __func__, raw_smp_processor_id());
-		while (ULONG_CMP_LT((unsigned long)ktime_get_seconds(),
-				    stop_at))
+		while (ULONG_CMP_LT((unsigned long)ktime_get_seconds(), stop_at) &&
+		       !kthread_should_stop())
 			if (stall_cpu_block) {
 #ifdef CONFIG_PREEMPTION
 				preempt_schedule();
-- 
2.43.0



