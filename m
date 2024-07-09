Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A21155389;
	Tue,  9 Jul 2024 11:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523634; cv=none; b=Pab6hkET+QuFmNN6TNVVWlbpHCt8xyVtZiA6kzM8vVMeRTwJqa3j/DfH6B6J6U+eVDupoTERX8Kzwnv+wVkQllhqhjnEfZmPd9GZ7KIYAOEjE5/m9kEQlSgP6jHOLCWrqIfYcUqqy2GVSDEY+2w33zwbeAoH0/gHPRq+YXghTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523634; c=relaxed/simple;
	bh=kw8bExwCuuFc79CKkIHFNybv1+PvYHTL2DmOSHlUjQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0H7Llo8YbQr5niY/zLf/4uqsXxW08kFCJvv1NJCFTlkkE1j1ug61tPx3f6f2Zq31B6QH3116VP/NWAhSRmvBHgRvyyYT6+WpEZ5lYgxlQs1dqICOjyRyWPuH+MVdgp3Ox2TFwdbkyRGQIqbbDKvmQ8Yk6GirW2SR/Ot4M7FPJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdnA2rCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdnA2rCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C60C3277B;
	Tue,  9 Jul 2024 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523634;
	bh=kw8bExwCuuFc79CKkIHFNybv1+PvYHTL2DmOSHlUjQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdnA2rCC+aZs730rBklHLyO1FGBb9HTZCvmDR9ZVKCJa1BXM382vIEvuG/7hrQJJc
	 tRO1X6rbBXdeTXi+3J8UIp6pYm9G59UV+zfZffpDXMH8pb/OUA7ZsNpHGyr732nw9A
	 bqLd/hArtyokOkCC1nvbIu3hCbBj/mQrfXCwHlfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/139] vhost: Release worker mutex during flushes
Date: Tue,  9 Jul 2024 13:09:19 +0200
Message-ID: <20240709110700.452554456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit ba704ff4e142fd3cfaf3379dd3b3b946754e06e3 ]

In the next patches where the worker can be killed while in use, we
need to be able to take the worker mutex and kill queued works for
new IO and flushes, and set some new flags to prevent new
__vhost_vq_attach_worker calls from swapping in/out killed workers.

If we are holding the worker mutex during a flush and the flush's work
is still in the queue, the worker code that will handle the SIGKILL
cleanup won't be able to take the mutex and perform it's cleanup. So
this patch has us drop the worker mutex while waiting for the flush
to complete.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20240316004707.45557-8-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 67bd947cc556d..069c8a23bff9e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -276,21 +276,36 @@ void vhost_vq_flush(struct vhost_virtqueue *vq)
 EXPORT_SYMBOL_GPL(vhost_vq_flush);
 
 /**
- * vhost_worker_flush - flush a worker
+ * __vhost_worker_flush - flush a worker
  * @worker: worker to flush
  *
- * This does not use RCU to protect the worker, so the device or worker
- * mutex must be held.
+ * The worker's flush_mutex must be held.
  */
-static void vhost_worker_flush(struct vhost_worker *worker)
+static void __vhost_worker_flush(struct vhost_worker *worker)
 {
 	struct vhost_flush_struct flush;
 
+	if (!worker->attachment_cnt)
+		return;
+
 	init_completion(&flush.wait_event);
 	vhost_work_init(&flush.work, vhost_flush_work);
 
 	vhost_worker_queue(worker, &flush.work);
+	/*
+	 * Drop mutex in case our worker is killed and it needs to take the
+	 * mutex to force cleanup.
+	 */
+	mutex_unlock(&worker->mutex);
 	wait_for_completion(&flush.wait_event);
+	mutex_lock(&worker->mutex);
+}
+
+static void vhost_worker_flush(struct vhost_worker *worker)
+{
+	mutex_lock(&worker->mutex);
+	__vhost_worker_flush(worker);
+	mutex_unlock(&worker->mutex);
 }
 
 void vhost_dev_flush(struct vhost_dev *dev)
@@ -298,15 +313,8 @@ void vhost_dev_flush(struct vhost_dev *dev)
 	struct vhost_worker *worker;
 	unsigned long i;
 
-	xa_for_each(&dev->worker_xa, i, worker) {
-		mutex_lock(&worker->mutex);
-		if (!worker->attachment_cnt) {
-			mutex_unlock(&worker->mutex);
-			continue;
-		}
+	xa_for_each(&dev->worker_xa, i, worker)
 		vhost_worker_flush(worker);
-		mutex_unlock(&worker->mutex);
-	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_flush);
 
@@ -685,7 +693,6 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	 * device wide flushes which doesn't use RCU for execution.
 	 */
 	mutex_lock(&old_worker->mutex);
-	old_worker->attachment_cnt--;
 	/*
 	 * We don't want to call synchronize_rcu for every vq during setup
 	 * because it will slow down VM startup. If we haven't done
@@ -696,6 +703,8 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	mutex_lock(&vq->mutex);
 	if (!vhost_vq_get_backend(vq) && !vq->kick) {
 		mutex_unlock(&vq->mutex);
+
+		old_worker->attachment_cnt--;
 		mutex_unlock(&old_worker->mutex);
 		/*
 		 * vsock can queue anytime after VHOST_VSOCK_SET_GUEST_CID.
@@ -711,7 +720,8 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	/* Make sure new vq queue/flush/poll calls see the new worker */
 	synchronize_rcu();
 	/* Make sure whatever was queued gets run */
-	vhost_worker_flush(old_worker);
+	__vhost_worker_flush(old_worker);
+	old_worker->attachment_cnt--;
 	mutex_unlock(&old_worker->mutex);
 }
 
@@ -764,6 +774,12 @@ static int vhost_free_worker(struct vhost_dev *dev,
 		mutex_unlock(&worker->mutex);
 		return -EBUSY;
 	}
+	/*
+	 * A flush might have raced and snuck in before attachment_cnt was set
+	 * to zero. Make sure flushes are flushed from the queue before
+	 * freeing.
+	 */
+	__vhost_worker_flush(worker);
 	mutex_unlock(&worker->mutex);
 
 	vhost_worker_destroy(dev, worker);
-- 
2.43.0



