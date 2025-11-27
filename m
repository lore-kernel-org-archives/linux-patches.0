Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADADA29BD89;
	Thu, 27 Nov 2025 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255258; cv=none; b=AdZf6Bnkl5e+0uoQlyos7/fakVxKhljNNoOjtT742vNgegbacN9rEytFRltUGsd4yQiCRbOYUiX8jsFVW+ssoUGxgIJEekkoy+D3mRdzCj3gmB+bXd0f1nUwtCCN7Gix7R0M59Kxr5R3hbIp3axQPFdqfp2q9BUlsDlzChmq9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255258; c=relaxed/simple;
	bh=D44YWuh660q1AMxvTPrWL8zdbw8pGjwvc0wcJMZE/n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq1zPg8tFqked5El/5yZRa3F3jSgl+pipEYnhDkdbUdNdHVMKHYBtpKlzAYF0ZuyrCQ6OhUOzs4y3W6+BlOhVQpK++Vk3fcXw3cydL9yWr+CIFfmb4dfy33LlV6sdHaFxNET5/HDlqKa1UXSnsRb8vdeZPMErMJBsAmhedFxYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BogAU9GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BogAU9GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B35C4CEF8;
	Thu, 27 Nov 2025 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255258;
	bh=D44YWuh660q1AMxvTPrWL8zdbw8pGjwvc0wcJMZE/n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BogAU9GQMoN+4rDDBjJJtcxgbEcv13PugMwM5sNaU7BGoG3mHtWWBPYakuwl0rsQf
	 EyBSOlovesARQ3I9xTMJdfp1UHS/355C6Zf8OjziSZfW4k0XNx9sxPvN54r3pEJTtD
	 z3MvKQRadqA7SBpRHTDpW/GH+HBhG+WV3kuU0rV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>,
	James Smart <james.smart@broadcom.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Ming Lei <ming.lei@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 029/112] nvme: nvme-fc: move tagset removal to nvme_fc_delete_ctrl()
Date: Thu, 27 Nov 2025 15:45:31 +0100
Message-ID: <20251127144033.906316580@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

commit ea3442efabd0aa3930c5bab73c3901ef38ef6ac3 upstream.

Now target is removed from nvme_fc_ctrl_free() which is the ctrl->ref
release handler. And even admin queue is unquiesced there, this way
is definitely wrong because the ctr->ref is grabbed when submitting
command.

And Marco observed that nvme_fc_ctrl_free() can be called from request
completion code path, and trigger kernel warning since request completes
from softirq context.

Fix the issue by moveing target removal into nvme_fc_delete_ctrl(),
which is also aligned with nvme-tcp and nvme-rdma.

Patch originally proposed by Ming Lei, then modified to move the tagset
removal down to after nvme_fc_delete_association() after further testing.

Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Ewan Milne <emilne@redhat.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Cc: stable@vger.kernel.org
Tested-by: Marco Patalano <mpatalan@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2349,17 +2349,11 @@ nvme_fc_ctrl_free(struct kref *ref)
 		container_of(ref, struct nvme_fc_ctrl, ref);
 	unsigned long flags;
 
-	if (ctrl->ctrl.tagset)
-		nvme_remove_io_tag_set(&ctrl->ctrl);
-
 	/* remove from rport list */
 	spin_lock_irqsave(&ctrl->rport->lock, flags);
 	list_del(&ctrl->ctrl_list);
 	spin_unlock_irqrestore(&ctrl->rport->lock, flags);
 
-	nvme_unquiesce_admin_queue(&ctrl->ctrl);
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
-
 	kfree(ctrl->queues);
 
 	put_device(ctrl->dev);
@@ -3255,11 +3249,18 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nc
 
 	cancel_work_sync(&ctrl->ioerr_work);
 	cancel_delayed_work_sync(&ctrl->connect_work);
+
 	/*
 	 * kill the association on the link side.  this will block
 	 * waiting for io to terminate
 	 */
 	nvme_fc_delete_association(ctrl);
+
+	if (ctrl->ctrl.tagset)
+		nvme_remove_io_tag_set(&ctrl->ctrl);
+
+	nvme_unquiesce_admin_queue(&ctrl->ctrl);
+	nvme_remove_admin_tag_set(&ctrl->ctrl);
 }
 
 static void


