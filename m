Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E6132E757;
	Sat, 12 Sep 2026 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231587; cv=none; b=VZkdRhf2QLposKQKs3dAW2nfyXas0fESLpE/agk6AI/gDVb/W1MVrFc9LuwFAY+EeE+Ee0I8mAqHP7aMLOCjgloIGFvEeMCFwkBqCtmW6bK2MFxYfgbEI0AsL//Nii79Sjhm0TpjemE7jzAMpRvzcwnrtS6UhFQWXQRtiuxnTqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231587; c=relaxed/simple;
	bh=VD22ngh2mU/YnKudjxN6qeIKmu22eFZTQijjZeJt+8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgN931StPeWD57ysHwAxSZNsqiLU/CbXClyCx8uz9dH+D+DTbYgiNymlXk0sjd5yIyAYO7KJE8YW1QD/z63QZAWg2/Y1Q9BEnzUgDLklFC1h96QjpP2mq9twTS69BFhjFhP7tkavGSBr7cwjpREmrIhqoKsbrXHVaqh8rn1s/P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duUe3Y9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duUe3Y9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818491F000FF;
	Sat, 12 Sep 2026 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231585;
	bh=6IrdVAAuknYEKpw1hu2/VFlH78i+wy6wL9E7c340rEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duUe3Y9UaOXI3oMbNE2lGiTPcqi2Om+QQ7mph8/JAwwUxGqLvqiJqr3aCfpaVUTuq
	 Id+yHzb6FUJ31JxtQAaFcQ+zSqiVC7xJPPq2sXQTCJQ5Aw2r5jpIXcm2AlqxfONtPx
	 b52YSuAfkyaXx7wTxc7TV+/YlDrHYZLfZoxGLaoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Zizhi Wo <wozizhi@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1030/1191] null_blk: reject per-device queue resize for shared tag set
Date: Sat, 12 Sep 2026 09:02:38 +0200
Message-ID: <20260912065611.318615720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 1cdfe2fa62b48728a9b436fbbd3dbe4c11593e24 ]

When shared_tags is enabled, null_setup_tagset() makes the device use the
global tag_set, whose driver_data stays NULL. null_map_queues() therefore
falls back to the module-wide g_submit_queues/g_poll_queues instead of any
per-device value.

Resizing submit_queues or poll_queues via configfs on such a device calls
blk_mq_update_nr_hw_queues() on the shared set, shrinking
set->nr_hw_queues.  __blk_mq_realloc_hw_ctxs() only grows the
q->queue_hw_ctx[] allocation, so on shrink it merely exits and NULLs the
now-excess hctx slots. null_map_queues(), however, keeps mapping CPUs with
the unchanged g_submit_queues/g_poll_queues, so mq_map[] ends up pointing
at those NULLed hctx slots. blk_mq_map_swqueue() then dereferences the NULL
hctx (hctx->cpumask), crashing the kernel:

[  460.218374] KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
[  460.219003] CPU: 24 UID: 0 PID: 1492 Comm: sh Not tainted 7.2.0-rc2+ #67 PREEMPT(full)
[  460.219792] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
[  460.220452] RIP: 0010:blk_mq_map_swqueue+0x4db/0x1430
......
[  460.228977] Call Trace:
[  460.229175]  <TASK>
[  460.229354]  blk_mq_update_nr_hw_queues+0xd49/0x11c0
[  460.229779]  ? __pfx_blk_mq_update_nr_hw_queues+0x10/0x10
[  460.230200]  nullb_update_nr_hw_queues+0x1a9/0x370 [null_blk]
[  460.230694]  nullb_device_submit_queues_store+0xd9/0x170 [null_blk]
[  460.231190]  ? __pfx_nullb_device_submit_queues_store+0x10/0x10 [null_blk]
[  460.231776]  ? configfs_write_iter+0x35c/0x4e0
[  460.232122]  configfs_write_iter+0x286/0x4e0
[  460.232460]  vfs_write+0x52d/0xd00
[  460.232779]  ? __x64_sys_openat+0x108/0x1d0
[  460.233106]  ? __pfx_vfs_write+0x10/0x10
[  460.233413]  ? fdget_pos+0x1cf/0x4c0
[  460.233745]  ? fput_close+0x133/0x190
[  460.234038]  ? __pfx_expand_files+0x10/0x10
[  460.234368]  ksys_write+0xfc/0x1d0

Reproducer:
modprobe null_blk shared_tags=1 submit_queues=64 poll_queues=1
mkdir /sys/kernel/config/nullb/dev
echo 1 > /sys/kernel/config/nullb/dev/power
echo 1 > /sys/kernel/config/nullb/dev/submit_queues

A per-device resize of a shared tag set is meaningless anyway, so reject it
with -EINVAL in nullb_update_nr_hw_queues() when the device is bound to the
global tag_set.

Fixes: 45919fbfe1c4 ("null_blk: Enable modifying 'submit_queues' after an instance has been configured")
Suggested-by: Nilay Shroff <nilay@linux.ibm.com>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260725022509.714271-8-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 7383a54af2c4d..be95f3a15c4ea 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -353,6 +353,15 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 	if (!dev->nullb)
 		return 0;
 
+	/*
+	 * A shared tag_set is mapped via the module-wide queue counts, so a
+	 * per-device resize is meaningless. On shrink it would also leave
+	 * mq_map[] pointing at NULLed hctx slots, causing a NULL deref in
+	 * blk_mq_map_swqueue(). Reject it.
+	 */
+	if (dev->shared_tags)
+		return -EINVAL;
+
 	/*
 	 * Make sure at least one submit queue exists.
 	 */
-- 
2.53.0



