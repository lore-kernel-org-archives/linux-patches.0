Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774579;
	b=M1/2Wi9vCwb0FK9xt2tGccyeDxoTA7onvKxl4WnqNlqA0YNl1jIzVqsD6lt9ef/hdMiF
	 gKpxRYQraBznjk3rFIZxz1I9onxmKrBv7tWPW6n/HRBAuAVMLGqmE/QhqjIK+suaGDf/0
	 uve0pjT82ZqZpI3p2Mg30KETep0kFn6/so44HcG2+R+nM8zrrGsOgOPMrgD1MODHFnkXq
	 OGx37Duc5nfEQdaDr5lt/rsS7AnAkJjI7SMrkObtXeIDcCbinboVkJaBS/IjIUsHETSu8
	 +7bhBKxygLyPmukPbA59Of6jhuK0+R3aOM9PdZ13vJXKWW+Mua93PbUnC8c1LhIYRWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=br7oGb0SpngKXGPMT8SBG2Set4mktU4kPPJM0e1sOPk=;
	b=B9jb1KI5kO42+myangy48l5vmFK9GsFSFrm1+ehUPcO+dLW3+/W64ElxaUiJaqmQWL+V
	 5Gt7kudDrjwhxDq42uuYVhXBrUvoQls9wsucgA9qV6djdq3ItsKeKflQQBZLd1Knjuba1
	 XMHL65iTiBVLLUIHzkWtDHjoHwfXRCHS4HZMUt2vs8U3wRpWCzgt1o/2McNGxllbXVT2f
	 0iVkMycWSyX0yDrqlLBIXozy17pgy0DbTxRAVXWMPtEuAxh4zw/cCCf0in0BIPbRgaRlv
	 iwKS8X99Ur73xgjd/8vk1VEp+zfG4eVmYAwsu3q3KtKUiKTJ3kSXtUrErwKnna9XO5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpQTBJ2e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C3C606A31B;
	Fri, 23 Oct 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpQTBJ2e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5691D1F01825;
	Fri, 23 Oct 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774578;
	bh=br7oGb0SpngKXGPMT8SBG2Set4mktU4kPPJM0e1sOPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpQTBJ2eWuN3YirVvmfAlP4mb22s1MP52FvYwRoD4pMLU0BUGFGbrPL9wivqyRBDc
	 CxJiR3tx0NjDh8ezhenWxXcLEYjx3hbzu0l00WGZOze1UfS482QfdC+/wr5NRVdj68
	 wYoctwgBTHY//6V1yUCbAHcNfm2+tTgDKG2BJEkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 050/242] scsi: target: Disable interrupts while holding delayed_cmd_lock
Date: Fri, 23 Oct 2026 18:38:12 +0200
Message-ID: <20261023163714.959504813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit 04a67a8b1a4460345d22fe75d93430cbf7e651d7 ]

target_do_delayed_work() takes dev->delayed_cmd_lock with a plain
spin_lock(). It runs from system_percpu_wq, so interrupts stay enabled
while the lock is held. Every other acquisition of that lock uses
spin_lock_irqsave(): target_handle_task_attr() and
transport_complete_ordered_sync() in target_core_transport.c, and
target_non_ordered_release() in target_core_device.c.

That was safe while every caller of transport_complete_task_attr() ran
in process context: target_complete_ok_work() from target_completion_wq,
transport_complete_qf() from dev->qf_work_queue, and
transport_generic_request_failure() from the submit and execute paths.

Since commit 06933066d88a ("scsi: target: Add support for completing
commands from backend context") that is no longer true. With
complete_type=1 on a fabric that sets direct_compl_supp,
target_complete() runs target_complete_ok_work() inline in the backend's
completion context, which target_complete_cmd_with_sense() documents as
"May be called from interrupt context". For iblock that is the bio
end_io.

target_complete_ok_work() starts with transport_complete_task_attr(),
which takes delayed_cmd_lock in two ways:

 - Every ORDERED command is put on dev->delayed_cmd_list by
   target_handle_task_attr() and dispatched from there by
   target_do_delayed_work(), which marks it SCF_TASK_ORDERED_SYNC.  Its
   completion therefore goes through transport_complete_ordered_sync().

 - A SIMPLE command that completes while an ORDERED command is pending
   drops the last reference to the killed dev->non_ordered, and
   percpu_ref_put() then runs target_non_ordered_release() in the
   completing context.

Both take the lock and, if commands are waiting, call
schedule_work(&dev->delayed_cmd_work), which queues on system_percpu_wq,
i.e. on the CPU that took the completion. Further completions for the
same queue are typically delivered there too, so one arriving while the
work holds the lock spins on it forever.

Reaching this needs complete_type=1, which is not the default
(vhost-scsi, the only fabric with direct_compl_supp, defaults to
TARGET_QUEUE_COMPL), a backend whose I/O completes from interrupt
context, and ORDERED commands from the initiator. Linux virtio_scsi
guests send only VIRTIO_SCSI_S_SIMPLE and never take the ordered path;
any guest that uses the ORDERED task attribute, which vhost-scsi
accepts, does.

target_do_delayed_work() is a work item and always runs in process
context, so spin_lock_irq() is sufficient.

Found by inspection; no runtime report. A single ORDERED command goes
through both acquisitions, so with CONFIG_PROVE_LOCKING the first one
completed through direct completion should produce an inconsistent lock
state report on delayed_cmd_lock (hardirq or softirq, depending on where
the backend completes).

Fixes: 06933066d88a ("scsi: target: Add support for completing commands from backend context")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260927091329.13482-1-yuz08559@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcfe945949167..67c046549192e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2359,7 +2359,7 @@ void target_do_delayed_work(struct work_struct *work)
 	struct se_device *dev = container_of(work, struct se_device,
 					     delayed_cmd_work);
 
-	spin_lock(&dev->delayed_cmd_lock);
+	spin_lock_irq(&dev->delayed_cmd_lock);
 	while (!dev->ordered_sync_in_progress) {
 		struct se_cmd *cmd;
 
@@ -2380,12 +2380,12 @@ void target_do_delayed_work(struct work_struct *work)
 		dev->ordered_sync_in_progress = true;
 
 		list_del(&cmd->se_delayed_node);
-		spin_unlock(&dev->delayed_cmd_lock);
+		spin_unlock_irq(&dev->delayed_cmd_lock);
 
 		__target_execute_cmd(cmd, true);
-		spin_lock(&dev->delayed_cmd_lock);
+		spin_lock_irq(&dev->delayed_cmd_lock);
 	}
-	spin_unlock(&dev->delayed_cmd_lock);
+	spin_unlock_irq(&dev->delayed_cmd_lock);
 }
 
 static void transport_complete_ordered_sync(struct se_cmd *cmd)
-- 
2.53.0



