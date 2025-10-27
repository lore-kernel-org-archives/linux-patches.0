Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE5031B116;
	Mon, 27 Oct 2025 18:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590692; cv=none; b=ReQN6bgK+VaEOMvWP7gPwjtCoUrXN7OKde8JRJb1IH0BJSx96MmQskW2Ffv5nXgGSnFRfJ+PCmnLsLbO0qVWObEMdrFNdieh5FM7Itr7urFvUrvTHu5YZHDgNT/vgv8c8zLicsLD95X+o47gzOanwm+htOM8j6EBF+EhhJPjwJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590692; c=relaxed/simple;
	bh=66uluO/PChm2+87mQDih9StBc0yw81I9ze1Si9mZo2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sbswxeb7w9QOfiqWZMZbZrjGYACExbuPe/q8fDmlwx4l9LKimfP+9yAwTdfvZ0cm6v7iwuR2bfOZd4T4Vt0yfQq9SJPsioT8FYfU60ReRB7IhpMBCXm8K8HA+txAwhqCGjKiEVR8/cIo7hugTuQV65Mh1Ul7DO71OURfcoSBzPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFZXEXy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFZXEXy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551ABC4CEF1;
	Mon, 27 Oct 2025 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590692;
	bh=66uluO/PChm2+87mQDih9StBc0yw81I9ze1Si9mZo2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFZXEXy1Vv9gYIamM6y8KfDLOqBxH8bckUCgViqDiyfgrqLbLDf1VAEKIaxOQkn4H
	 hSidworIvkGFNDww5/xgKlnUxPaVl5Wd/+9NLMHLCoVuTaMQOPxEiNW/lBgPJ+vH2J
	 EIFQsjj75xFh+xbfOzcstblpTqQipuS5VlyjKmwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/224] dm: fix NULL pointer dereference in __dm_suspend()
Date: Mon, 27 Oct 2025 19:34:48 +0100
Message-ID: <20251027183512.772668041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 8d33a030c566e1f105cd5bf27f37940b6367f3be ]

There is a race condition between dm device suspend and table load that
can lead to null pointer dereference. The issue occurs when suspend is
invoked before table load completes:

BUG: kernel NULL pointer dereference, address: 0000000000000054
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 6 PID: 6798 Comm: dmsetup Not tainted 6.6.0-g7e52f5f0ca9b #62
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
RIP: 0010:blk_mq_wait_quiesce_done+0x0/0x50
Call Trace:
  <TASK>
  blk_mq_quiesce_queue+0x2c/0x50
  dm_stop_queue+0xd/0x20
  __dm_suspend+0x130/0x330
  dm_suspend+0x11a/0x180
  dev_suspend+0x27e/0x560
  ctl_ioctl+0x4cf/0x850
  dm_ctl_ioctl+0xd/0x20
  vfs_ioctl+0x1d/0x50
  __se_sys_ioctl+0x9b/0xc0
  __x64_sys_ioctl+0x19/0x30
  x64_sys_call+0x2c4a/0x4620
  do_syscall_64+0x9e/0x1b0

The issue can be triggered as below:

T1 						T2
dm_suspend					table_load
__dm_suspend					dm_setup_md_queue
						dm_mq_init_request_queue
						blk_mq_init_allocated_queue
						=> q->mq_ops = set->ops; (1)
dm_stop_queue / dm_wait_for_completion
=> q->tag_set NULL pointer!	(2)
						=> q->tag_set = set; (3)

Fix this by checking if a valid table (map) exists before performing
request-based suspend and waiting for target I/O. When map is NULL,
skip these table-dependent suspend steps.

Even when map is NULL, no I/O can reach any target because there is
no table loaded; I/O submitted in this state will fail early in the
DM layer. Skipping the table-dependent suspend logic in this case
is safe and avoids NULL pointer dereferences.

Fixes: c4576aed8d85 ("dm: fix request-based dm's use of dm_wait_for_completion")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ omitted DMF_QUEUE_STOPPED flag setting and braces absent in 5.15 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2595,7 +2595,7 @@ static int __dm_suspend(struct mapped_de
 {
 	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
 	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
-	int r;
+	int r = 0;
 
 	lockdep_assert_held(&md->suspend_lock);
 
@@ -2648,7 +2648,7 @@ static int __dm_suspend(struct mapped_de
 	 * Stop md->queue before flushing md->wq in case request-based
 	 * dm defers requests to md->wq from md->queue.
 	 */
-	if (dm_request_based(md))
+	if (map && dm_request_based(md))
 		dm_stop_queue(md->queue);
 
 	flush_workqueue(md->wq);
@@ -2658,7 +2658,8 @@ static int __dm_suspend(struct mapped_de
 	 * We call dm_wait_for_completion to wait for all existing requests
 	 * to finish.
 	 */
-	r = dm_wait_for_completion(md, task_state);
+	if (map)
+		r = dm_wait_for_completion(md, task_state);
 	if (!r)
 		set_bit(dmf_suspended_flag, &md->flags);
 


