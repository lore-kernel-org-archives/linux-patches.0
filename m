Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351F81F6691;
	Tue,  3 Dec 2024 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238321; cv=none; b=Is5r6pRsNy14lXGlGEMZe2SiQsvkQJsco8UyMAn0iC8WyyNOPUNBRzl/c3db4k1buJNGlchZbADpsRi2iA5yG7VmSy+CWnrB44JXM4muuDvyJeR2A3f1pw2Vxnz9eSOcwne0FqetVqYLD8Rz5Tb3og9SEjGNdT9AONR/YzqCjSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238321; c=relaxed/simple;
	bh=nFEcWgDyY23pK26br1PvUCaGn5gBQAYJXWooi8nLU2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBNnNb2ijqy2Dz+sgTmKyX2crnhac2Kx6tNwgJvfI4BzvIclZOf9FLbVmBi5GGmjMeLsvK6rOGakz97/Ag9okXLEHSpWQot+gXcnBy6d/arskz9YZL4X/n3INJFahCcmM9LaBGCSN/C9Wd/NT4hsz/M5BBmlyW3VLrEEv/dOzO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3leXTVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3leXTVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC45DC4CECF;
	Tue,  3 Dec 2024 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238321;
	bh=nFEcWgDyY23pK26br1PvUCaGn5gBQAYJXWooi8nLU2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3leXTVqCfRAnOeGVr9RQiYIrZnFBORcDE7YU9OwcnECRIgaSbdwXSfFkQ5DVc3tf
	 KPAqh3AMkO+COcYJyvFOW6l3KYGdfvvzfawgQIDK50wUEULUOtlOVfcNoU8PZgBhxu
	 l9Js65hayQRbfKrJ5++g3wJhokrLaVK0qGKAqgQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 208/817] media: venus: sync with threaded IRQ during inst destruction
Date: Tue,  3 Dec 2024 15:36:20 +0100
Message-ID: <20241203144003.866327765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 45b1a1b348ec178a599323f1ce7d7932aea8c6d4 ]

When destroying an inst we should make sure that we don't race
against threaded IRQ (or pending IRQ), otherwise we can concurrently
kfree() inst context and inst itself.

BUG: KASAN: slab-use-after-free in vb2_queue_error+0x80/0x90
Call trace:
dump_backtrace+0x1c4/0x1f8
show_stack+0x38/0x60
dump_stack_lvl+0x168/0x1f0
print_report+0x170/0x4c8
kasan_report+0x94/0xd0
__asan_report_load2_noabort+0x20/0x30
vb2_queue_error+0x80/0x90
venus_helper_vb2_queue_error+0x54/0x78
venc_event_notify+0xec/0x158
hfi_event_notify+0x878/0xd20
hfi_process_msg_packet+0x27c/0x4e0
venus_isr_thread+0x258/0x6e8
hfi_isr_thread+0x70/0x90
venus_isr_thread+0x34/0x50
irq_thread_fn+0x88/0x130
irq_thread+0x160/0x2c0
kthread+0x294/0x328
ret_from_fork+0x10/0x20

Allocated by task 20291:
kasan_set_track+0x4c/0x80
kasan_save_alloc_info+0x28/0x38
__kasan_kmalloc+0x84/0xa0
kmalloc_trace+0x7c/0x98
v4l2_m2m_ctx_init+0x74/0x280
venc_open+0x444/0x6d0
v4l2_open+0x19c/0x2a0
chrdev_open+0x374/0x3f0
do_dentry_open+0x710/0x10a8
vfs_open+0x88/0xa8
path_openat+0x1e6c/0x2700
do_filp_open+0x1a4/0x2e0
do_sys_openat2+0xe8/0x508
do_sys_open+0x15c/0x1a0
__arm64_sys_openat+0xa8/0xc8
invoke_syscall+0xdc/0x270
el0_svc_common+0x1ec/0x250
do_el0_svc+0x54/0x70
el0_svc+0x50/0xe8
el0t_64_sync_handler+0x48/0x120
el0t_64_sync+0x1a8/0x1b0

Freed by task 20291:
 kasan_set_track+0x4c/0x80
 kasan_save_free_info+0x3c/0x60
 ____kasan_slab_free+0x124/0x1a0
 __kasan_slab_free+0x18/0x28
 __kmem_cache_free+0x134/0x300
 kfree+0xc8/0x1a8
 v4l2_m2m_ctx_release+0x44/0x60
 venc_close+0x78/0x130 [venus_enc]
 v4l2_release+0x20c/0x2f8
 __fput+0x328/0x7f0
 ____fput+0x2c/0x48
 task_work_run+0x1e0/0x280
 get_signal+0xfb8/0x1190
 do_notify_resume+0x34c/0x16a8
 el0_svc+0x9c/0xe8
 el0t_64_sync_handler+0x48/0x120
 el0t_64_sync+0x1a8/0x1b0

Rearrange inst destruction.  First remove the inst from the
core->instances list, second synchronize IRQ/IRQ-thread to
make sure that nothing else would see the inst while we take
it down.

Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 12 +++++++++++-
 drivers/media/platform/qcom/venus/venc.c | 12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 4af268e756883..b446046546403 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1748,10 +1748,20 @@ static int vdec_close(struct file *file)
 	vdec_pm_get(inst);
 
 	cancel_work_sync(&inst->delayed_process_work);
+	/*
+	 * First, remove the inst from the ->instances list, so that
+	 * to_instance() will return NULL.
+	 */
+	hfi_session_destroy(inst);
+	/*
+	 * Second, make sure we don't have IRQ/IRQ-thread currently running
+	 * or pending execution, which would race with the inst destruction.
+	 */
+	synchronize_irq(inst->core->irq);
+
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	ida_destroy(&inst->dpb_ids);
-	hfi_session_destroy(inst);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 	vdec_ctrl_deinit(inst);
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 56777d3d630a5..b83f03abbf0aa 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1515,9 +1515,19 @@ static int venc_close(struct file *file)
 
 	venc_pm_get(inst);
 
+	/*
+	 * First, remove the inst from the ->instances list, so that
+	 * to_instance() will return NULL.
+	 */
+	hfi_session_destroy(inst);
+	/*
+	 * Second, make sure we don't have IRQ/IRQ-thread currently running
+	 * or pending execution, which would race with the inst destruction.
+	 */
+	synchronize_irq(inst->core->irq);
+
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
-	hfi_session_destroy(inst);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 	venc_ctrl_deinit(inst);
-- 
2.43.0



