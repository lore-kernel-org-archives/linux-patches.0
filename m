Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7501F7584;
	Tue,  3 Dec 2024 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240033; cv=none; b=MIvn39IIqcbSGRzIX+OC4MB+m08cALIhdSq4Ilar1YgM1hPqQ62Fy5PkVHc/K8Oy354xN1oinyvLpk8C42GRjxdjneqRli7nt1dDQyN/YvPKTfEIMsVBLv51RrZkoGoQKo+up2yGWuGcLY8nMjQDs3Gm5/Mk4rf2FEmjRy5BK8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240033; c=relaxed/simple;
	bh=dhzegJv0WPiQLmQ9u4deoinZJBThPnZG9bJ9zrvQsNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM3abXRTP7NmSaI6wVoiF2L/vcfqKa2BUVRmtMlsfNRJ5jOz0VzWXnshw03YcCB+ejyS/k+Uc4Sq7jMGuc0y5WrgCi7+baaoE8op02s+mF8sdlmH2fbpBlpOh/q0hagwWvMyawDF1SJnk0MXX/Vra0DNEqojkfe1ZLXNstoF9WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjQKRJiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjQKRJiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67560C4CECF;
	Tue,  3 Dec 2024 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240032;
	bh=dhzegJv0WPiQLmQ9u4deoinZJBThPnZG9bJ9zrvQsNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjQKRJiWhnFBqXvUbiPYrMCE8TXR80G6cUJYr1GUB+qLwI/L38NSBkfwmf8uCwsEj
	 DyX3wTMvpN/aZ7bwSkUKiaAqyjEP18eZDSMBxdNgdBGE9xO62nCTUm5ZHiy+GKa0nq
	 kJ57ExFNSCaeNtW6/FiZVHaJDaNwNF9Ndel1yK48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 787/817] nvme-fabrics: fix kernel crash while shutting down controller
Date: Tue,  3 Dec 2024 15:45:59 +0100
Message-ID: <20241203144026.732756232@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit e9869c85c81168a1275f909d5972a3fc435304be ]

The nvme keep-alive operation, which executes at a periodic interval,
could potentially sneak in while shutting down a fabric controller.
This may lead to a race between the fabric controller admin queue
destroy code path (invoked while shutting down controller) and hw/hctx
queue dispatcher called from the nvme keep-alive async request queuing
operation. This race could lead to the kernel crash shown below:

Call Trace:
    autoremove_wake_function+0x0/0xbc (unreliable)
    __blk_mq_sched_dispatch_requests+0x114/0x24c
    blk_mq_sched_dispatch_requests+0x44/0x84
    blk_mq_run_hw_queue+0x140/0x220
    nvme_keep_alive_work+0xc8/0x19c [nvme_core]
    process_one_work+0x200/0x4e0
    worker_thread+0x340/0x504
    kthread+0x138/0x140
    start_kernel_thread+0x14/0x18

While shutting down fabric controller, if nvme keep-alive request sneaks
in then it would be flushed off. The nvme_keep_alive_end_io function is
then invoked to handle the end of the keep-alive operation which
decrements the admin->q_usage_counter and assuming this is the last/only
request in the admin queue then the admin->q_usage_counter becomes zero.
If that happens then blk-mq destroy queue operation (blk_mq_destroy_
queue()) which could be potentially running simultaneously on another
cpu (as this is the controller shutdown code path) would forward
progress and deletes the admin queue. So, now from this point onward
we are not supposed to access the admin queue resources. However the
issue here's that the nvme keep-alive thread running hw/hctx queue
dispatch operation hasn't yet finished its work and so it could still
potentially access the admin queue resource while the admin queue had
been already deleted and that causes the above crash.

The above kernel crash is regression caused due to changes implemented
in commit a54a93d0e359 ("nvme: move stopping keep-alive into
nvme_uninit_ctrl()"). Ideally we should stop keep-alive before destroyin
g the admin queue and freeing the admin tagset so that it wouldn't sneak
in during the shutdown operation. However we removed the keep alive stop
operation from the beginning of the controller shutdown code path in commit
a54a93d0e359 ("nvme: move stopping keep-alive into nvme_uninit_ctrl()")
and added it under nvme_uninit_ctrl() which executes very late in the
shutdown code path after the admin queue is destroyed and its tagset is
removed. So this change created the possibility of keep-alive sneaking in
and interfering with the shutdown operation and causing observed kernel
crash.

To fix the observed crash, we decided to move nvme_stop_keep_alive() from
nvme_uninit_ctrl() to nvme_remove_admin_tag_set(). This change would ensure
that we don't forward progress and delete the admin queue until the keep-
alive operation is finished (if it's in-flight) or cancelled and that would
help contain the race condition explained above and hence avoid the crash.

Moving nvme_stop_keep_alive() to nvme_remove_admin_tag_set() instead of
adding nvme_stop_keep_alive() to the beginning of the controller shutdown
code path in nvme_stop_ctrl(), as was the case earlier before commit
a54a93d0e359 ("nvme: move stopping keep-alive into nvme_uninit_ctrl()"),
would help save one callsite of nvme_stop_keep_alive().

Fixes: a54a93d0e359 ("nvme: move stopping keep-alive into nvme_uninit_ctrl()")
Link: https://lore.kernel.org/all/1a21f37b-0f2a-4745-8c56-4dc8628d3983@linux.ibm.com/
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 128932c849a1a..f49431cbc8dfc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4551,6 +4551,11 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
+	/*
+	 * As we're about to destroy the queue and free tagset
+	 * we can not have keep-alive work running.
+	 */
+	nvme_stop_keep_alive(ctrl);
 	blk_mq_destroy_queue(ctrl->admin_q);
 	blk_put_queue(ctrl->admin_q);
 	if (ctrl->ops->flags & NVME_F_FABRICS) {
-- 
2.43.0



