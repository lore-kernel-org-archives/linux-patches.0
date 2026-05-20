Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48303F39C9;
	Wed, 20 May 2026 17:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299601; cv=none; b=bNPigFZeb0eL21/yNPWVFl/Qcr6y0Ajfz9gIHvdY+DSSm9VhQPLDp4QA+t3D41Be7WBBRJUlG1yUqzc0P/4jJg45nrVhBetA8tN2S5bhv2W4qVexwvAsjT+uhp9rEhcV6y4K9MVGu0MCTwrk3yEAzLfRFefb4LnI7g6jDKPP1xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299601; c=relaxed/simple;
	bh=NKfRuvMpYOswN1eAD9Mq9Q6VwO/Vxc8JviPV+Y8boBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln/opCuoMGxg8f3aGk2xd7MJqUFG4R9KGiHS3hz1oJ89x3sLkZ9/IN5NNRxE1bhJHsB9IzkjL2HhRDXD7y6FE8861M7WbewuEvczLPmqCmwfKT//1lTGI9OR96eANYHUm8SX/IHQ03VHT39ZiZWwyjXRdrLvqFSuUTgwQUo2tDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnEUGmjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnEUGmjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC961F000E9;
	Wed, 20 May 2026 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299600;
	bh=XxQrsrcvd2Gq4HmPnYDK4zHp2mkV1mx2HguddvbwyBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnEUGmjL7HhRTDNkhCb0wi5Bm8TtUYRzpmJgyH7/pGEUH6WG3IzwnpAhnyhxlkUuN
	 PMgEXJeHokSSa3oE5/ts+FoD0EnGrUNNbErOy1FIGlTWOYfQKXbLARBSlxMp1fJGH7
	 i7Rd/F9jrwZhGdvO2mmaccZt3eHZgNLz5jZTBI9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 833/957] drm/xe: Fix error cleanup in xe_exec_queue_create_ioctl()
Date: Wed, 20 May 2026 18:21:56 +0200
Message-ID: <20260520162152.631070211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit f3cc22d4df3ed58439ea7e21daa54c3608e03b78 ]

Two error handling issues exist in xe_exec_queue_create_ioctl():

1. When xe_hw_engine_group_add_exec_queue() fails, the error path jumps
   to put_exec_queue which skips xe_exec_queue_kill(). If the VM is in
   preempt fence mode, xe_vm_add_compute_exec_queue() has already added
   the queue to the VM's compute exec queue list. Skipping the kill
   leaves the queue on that list, leading to a dangling pointer after
   the queue is freed.

2. When xa_alloc() fails after xe_hw_engine_group_add_exec_queue() has
   succeeded, the error path does not call
   xe_hw_engine_group_del_exec_queue() to remove the queue from the hw
   engine group list. The queue is then freed while still linked into
   the hw engine group, causing a use-after-free.

Fix both by:
- Changing the xe_hw_engine_group_add_exec_queue() failure path to jump
  to kill_exec_queue so that xe_exec_queue_kill() properly removes the
  queue from the VM's compute list.
- Adding a del_hw_engine_group label before kill_exec_queue for the
  xa_alloc() failure path, which removes the queue from the hw engine
  group before proceeding with the rest of the cleanup.

Fixes: 7970cb36966c ("'drm/xe/hw_engine_group: Register hw engine group's exec queues")
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408020647.3397933-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 37c831f401746a45d510b312b0ed7a77b1e06ec8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 231d1fbe5eefa..0df11f054cfba 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -789,7 +789,7 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 		if (q->vm && q->hwe->hw_engine_group) {
 			err = xe_hw_engine_group_add_exec_queue(q->hwe->hw_engine_group, q);
 			if (err)
-				goto put_exec_queue;
+				goto kill_exec_queue;
 		}
 	}
 
@@ -798,12 +798,15 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 	/* user id alloc must always be last in ioctl to prevent UAF */
 	err = xa_alloc(&xef->exec_queue.xa, &id, q, xa_limit_32b, GFP_KERNEL);
 	if (err)
-		goto kill_exec_queue;
+		goto del_hw_engine_group;
 
 	args->exec_queue_id = id;
 
 	return 0;
 
+del_hw_engine_group:
+	if (q->vm && q->hwe && q->hwe->hw_engine_group)
+		xe_hw_engine_group_del_exec_queue(q->hwe->hw_engine_group, q);
 kill_exec_queue:
 	xe_exec_queue_kill(q);
 put_exec_queue:
-- 
2.53.0



