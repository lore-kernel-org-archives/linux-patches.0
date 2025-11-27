Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1D9333759;
	Thu, 27 Nov 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255578; cv=none; b=hFh3KNs4/rzCtdjPAP3leW6ymQBIDLSafNjPbf589QI10nXkcqs/fM+1DO11fSB+rXmWjJlsPypmRkBCBYbUOOcxISiNYbzrwCEXhSVBFKKRJQCXIh8FcTiEJlswHm2WNmDANuxple7346TDBObmpCNfxZ+skNLsmw1oXYZfaZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255578; c=relaxed/simple;
	bh=d1b0NYcqfpfiF7PT8GZmwD4Ha62o1g+6Nz5MMSflnv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhNnohAO3d3yrDI4c77dYzs4jmhQz3KkQZNpp4JY7gv3Rbu1JfUkXEHAQXqvS2MeYHznHMmR+lfqYaiiAQt6v4+izbrHhhtFpd8u8qri/fGaBxHoK08OAqBAfk04sowKdaucg/fc88UBCsoDnUgUe65TLOYTQL/4dFwq6aQp1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTrYW+rJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTrYW+rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC433C4CEF8;
	Thu, 27 Nov 2025 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255578;
	bh=d1b0NYcqfpfiF7PT8GZmwD4Ha62o1g+6Nz5MMSflnv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTrYW+rJWPinw7nE6Iuxmq8yekrpTIIhlypPWXBbJFX1EUSk7hvdaxGkrbkmL/Kqj
	 nmaQCTZ4w42VVTjwNPq8cuLIKqlfisbRl++GreUTKQi3QiigpWV81MDB3xHSRDehxo
	 yVj853zLb5nziH6FO85yBgYUcEgHbPFqGukJRZgA=
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
Subject: [PATCH 6.17 042/175] nvme: nvme-fc: move tagset removal to nvme_fc_delete_ctrl()
Date: Thu, 27 Nov 2025 15:44:55 +0100
Message-ID: <20251127144044.499647417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2355,17 +2355,11 @@ nvme_fc_ctrl_free(struct kref *ref)
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
@@ -3261,11 +3255,18 @@ nvme_fc_delete_ctrl(struct nvme_ctrl *nc
 
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


