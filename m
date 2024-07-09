Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A1227713;
	Tue,  9 Jul 2024 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524421; cv=none; b=ni7O/XjOB0k71lXEuqkUdFbT5yY73yStaudhAPO6Y948j01583i9Zgd2htYRbeh1hX+DkfYA9jcSljZ5vLHfoJk5zfCL5sGpBrmNlWOMq7fLaRhpWTLKVwx6SaibLX5oalsoTzODVAeQmFHnC1fl6y6/yWoxQrc7ZDPt+9G5TjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524421; c=relaxed/simple;
	bh=m/aCcnA8yR1AB0NBOx07JYCJp/M9kE1pC16BrGrEg8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkFfsjmDKa+JEk0ZSgiV2elIeHo2MzFAnKfZ3PMvRZ1WNgtITQDsCoZNVKRw9GJX2XR0LxcBKzMGvodIFtSwKb4BMAY8jw7puRxTQbWweJYBzkOxMoMmsbvjxpEPGs8H6NJGLNjWwFt+ya7s2n2v7b/v+Xs5AVIui0juNcocuXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbtSBkhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbtSBkhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2164CC3277B;
	Tue,  9 Jul 2024 11:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524421;
	bh=m/aCcnA8yR1AB0NBOx07JYCJp/M9kE1pC16BrGrEg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbtSBkhGqOqIZKN5S5fbMnSZna/DjG5T9pbiDuKEmsaFIx2J6YcK6BrtboxlJSt6z
	 I1uFB6DIq4He4sgQlGvbAk6tu8omGnSiTZv7GmbWMs41I3g20GRMufiJCFxPcMSEOO
	 u9LzBVf7/oQfW2HYr5KCHdheMH6E+aP/MywBtIXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 177/197] vhost-scsi: Handle vhost_vq_work_queue failures for events
Date: Tue,  9 Jul 2024 13:10:31 +0200
Message-ID: <20240709110715.795418015@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit b1b2ce58ed23c5d56e0ab299a5271ac01f95b75c ]

Currently, we can try to queue an event's work before the vhost_task is
created. When this happens we just drop it in vhost_scsi_do_plug before
even calling vhost_vq_work_queue. During a device shutdown we do the
same thing after vhost_scsi_clear_endpoint has cleared the backends.

In the next patches we will be able to kill the vhost_task before we
have cleared the endpoint. In that case, vhost_vq_work_queue can fail
and we will leak the event's memory. This has handle the failure by
just freeing the event. This is safe to do, because
vhost_vq_work_queue will only return failure for us when the vhost_task
is killed and so userspace will not be able to handle events if we
sent them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20240316004707.45557-2-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 282aac45c6909..f34f9895b8984 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -497,10 +497,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
 
-static void vhost_scsi_evt_work(struct vhost_work *work)
+static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 {
-	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
-					vs_event_work);
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct vhost_scsi_evt *evt, *t;
 	struct llist_node *llnode;
@@ -508,12 +506,20 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	mutex_lock(&vq->mutex);
 	llnode = llist_del_all(&vs->vs_event_list);
 	llist_for_each_entry_safe(evt, t, llnode, list) {
-		vhost_scsi_do_evt_work(vs, evt);
+		if (!drop)
+			vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
 	}
 	mutex_unlock(&vq->mutex);
 }
 
+static void vhost_scsi_evt_work(struct vhost_work *work)
+{
+	struct vhost_scsi *vs = container_of(work, struct vhost_scsi,
+					     vs_event_work);
+	vhost_scsi_complete_events(vs, false);
+}
+
 static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
 {
 	struct iov_iter *iter = &cmd->saved_iter;
@@ -1509,7 +1515,8 @@ vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	}
 
 	llist_add(&evt->list, &vs->vs_event_list);
-	vhost_vq_work_queue(vq, &vs->vs_event_work);
+	if (!vhost_vq_work_queue(vq, &vs->vs_event_work))
+		vhost_scsi_complete_events(vs, true);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
-- 
2.43.0



