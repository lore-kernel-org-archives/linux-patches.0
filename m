Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E7399CE9;
	Fri,  9 Oct 2026 14:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556751; cv=none; b=OuzMknRjbEiqoTP7HNmIWjSTdjje7Q/MbzSZT6+Fb+0Okw/X7zUDqVpunpOP0SYbCK7MEFn907hM3nEI4Jq5jNmxC0Xj9fmkHlEKvO6Sxq3zFy9F/CibjNEnQPxbLcUurzhFmrMm4fiJW/oRnJj4RIAt5hWGToHwXOaxQs3gU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556751; c=relaxed/simple;
	bh=lru9kTwJx1JT/dMvcc1ZtFTR4rir6cXndykFf6oUU5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGJi1wtazALfDUHo85ZNHyD8zcwp42vghlacTdjc24TnquOR3P2s+Zn3kHTI0/CjMUeUs/R4AxK5GtJADhbgFDXiyKxDAThE4f7jnGb8wHUHzy2Tz7INQEVrxDuAY/H1coriL+wLwH5alfDXkazs7o3k8YwzfW5/0eFUOqD6Bks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1J9Wm7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1J9Wm7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804961F000FF;
	Fri,  9 Oct 2026 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556750;
	bh=wlYhJzTSADwCsuBM/4MfZslx7YNGQzp7PTcM9spBg80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1J9Wm7y9pnsZn82Vyc69gw1tgcaSbfu6+m/0On5gQs6JfxF9MWdssWZrG2fpkZMo
	 UflKec8HIPKYmFj4fuhzv/eJySxYvCqTSFuIVIVgJNw9TLWzdVoOxrK6gCH6nSfpKM
	 SP7YGYBRxUPcT5ToOOjlElthJ2rw5oTrQI7yXrsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 287/403] thunderbolt: Fix KASAN reported use-after-free when request is canceled
Date: Fri,  9 Oct 2026 16:10:48 +0200
Message-ID: <20261009140958.910719997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit a02188ddc24b7872f0c5e0c5873f827318717803 upstream.

Alan reported that when doing stress testing sometimes KASAN notices
use-after-free during control channel operation (stripped down keeping
the relevant parts):

 BUG: KASAN: slab-use-after-free in tb_cfg_request_sync+0x240/0x250 [thunderbolt]
 Read of size 24 at addr ffff88811067f290 by task kworker/u40:2/1760
  <TASK>
  tb_cfg_request_sync+0x240/0x250 [thunderbolt]
  tb_cfg_read_raw+0x367/0x510 [thunderbolt]
  tb_cfg_read+0xec/0x240 [thunderbolt]
  tb_port_get_link_generation+0x258/0x420 [thunderbolt]
  tb_usb3_consumed_bandwidth+0x1c1/0x2c0 [thunderbolt]
  tb_tunnel_consumed_bandwidth+0xfd/0x910 [thunderbolt]
  tb_available_bandwidth+0x5f2/0xeb0 [thunderbolt]
  tb_recalc_estimated_bandwidth+0x2a0/0x1bc0 [thunderbolt]
  tb_handle_dp_bandwidth_request+0x1897/0x5e20 [thunderbolt]
  process_one_work+0x675/0x1230
  worker_thread+0x5e6/0xf70
  kthread+0x365/0x470
  ret_from_fork+0x54d/0x710
  ret_from_fork_asm+0x1a/0x30
  </TASK>

 Allocated by task 1760:
  __kmalloc_cache_noprof+0x1ee/0x550
  tb_cfg_read_raw+0x1d3/0x510 [thunderbolt]
  tb_cfg_read+0xec/0x240 [thunderbolt]
  tb_port_get_link_generation+0x258/0x420 [thunderbolt]
  tb_usb3_consumed_bandwidth+0x1c1/0x2c0 [thunderbolt]
  tb_tunnel_consumed_bandwidth+0xfd/0x910 [thunderbolt]
  tb_available_bandwidth+0x5f2/0xeb0 [thunderbolt]
  tb_recalc_estimated_bandwidth+0x2a0/0x1bc0 [thunderbolt]
  tb_handle_dp_bandwidth_request+0x1897/0x5e20 [thunderbolt]
  process_one_work+0x675/0x1230
  worker_thread+0x5e6/0xf70
  kthread+0x365/0x470
  ret_from_fork+0x54d/0x710
  ret_from_fork_asm+0x1a/0x30

 Freed by task 926:
  kfree+0x18f/0x4a0
  tb_cfg_request_put+0xb7/0xe0 [thunderbolt]
  tb_cfg_request_work+0x82/0x120 [thunderbolt]
  process_one_work+0x675/0x1230
  worker_thread+0x5e6/0xf70
  kthread+0x365/0x470
  ret_from_fork+0x54d/0x710
  ret_from_fork_asm+0x1a/0x30

 Second to last potentially related work creation:
  __queue_work+0x575/0xd00
  queue_work_on+0x77/0x80
  tb_cfg_request_cancel+0xc7/0x260 [thunderbolt]
  tb_cfg_request_sync+0x1f6/0x250 [thunderbolt]
  tb_cfg_read_raw+0x367/0x510 [thunderbolt]
  tb_cfg_read+0xec/0x240 [thunderbolt]
  tb_port_get_link_generation+0x258/0x420 [thunderbolt]
  tb_usb3_consumed_bandwidth+0x1c1/0x2c0 [thunderbolt]
  tb_tunnel_consumed_bandwidth+0xfd/0x910 [thunderbolt]
  tb_available_bandwidth+0x5f2/0xeb0 [thunderbolt]
  tb_recalc_estimated_bandwidth+0x2a0/0x1bc0 [thunderbolt]
  tb_handle_dp_bandwidth_request+0x1897/0x5e20 [thunderbolt]
  process_one_work+0x675/0x1230
  worker_thread+0x5e6/0xf70
  kthread+0x365/0x470
  ret_from_fork+0x54d/0x710
  ret_from_fork_asm+0x1a/0x30

The last stack trace is helpful because it shows that we are cancelling
a request and looking at tb_cfg_request_cancel() what might happen is
that tb_cfg_request_work() completes right before tb_cfg_request_cancel()
starts and because of this it will call schedule_work() queueing the
same work to run again. However, it is already removed from the
request_queue and reference count is dropped so when
tb_cfg_request_work() triggers again it will access memory that is
already released.

Fix this so that we first make sure a cancelled request is not handed
away from tb_cfg_request_find() or scheduled to run. Then instead of
relying on the worker to clean up the request we will do it in
tb_cfg_request_cancel() after the work is canceled from running. Make
tb_cfg_request_dequeue() release the request only if it was actually
removed from the queue.

Reported-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Fixes: d7f781bfdbf4 ("thunderbolt: Rework control channel to be more reliable")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/ctl.c |   63 ++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -73,7 +73,6 @@ struct tb_ctl {
 #define tb_ctl_dbg_once(ctl, format, arg...) \
 	dev_dbg_once(&(ctl)->nhi->pdev->dev, format, ## arg)
 
-static DECLARE_WAIT_QUEUE_HEAD(tb_cfg_request_cancel_queue);
 /* Serializes access to request kref_get/put */
 static DEFINE_MUTEX(tb_cfg_request_lock);
 
@@ -133,41 +132,42 @@ void tb_cfg_request_put(struct tb_cfg_re
 static int tb_cfg_request_enqueue(struct tb_ctl *ctl,
 				  struct tb_cfg_request *req)
 {
+	tb_cfg_request_get(req);
+
 	WARN_ON(test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags));
 	WARN_ON(req->ctl);
 
-	mutex_lock(&ctl->request_queue_lock);
+	guard(mutex)(&ctl->request_queue_lock);
 	if (!ctl->running) {
-		mutex_unlock(&ctl->request_queue_lock);
+		tb_cfg_request_put(req);
 		return -ENOTCONN;
 	}
 	req->ctl = ctl;
 	list_add_tail(&req->list, &ctl->request_queue);
 	set_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
-	mutex_unlock(&ctl->request_queue_lock);
 	return 0;
 }
 
-static void tb_cfg_request_dequeue(struct tb_cfg_request *req)
+static bool tb_cfg_request_is_active(struct tb_cfg_request *req)
 {
-	struct tb_ctl *ctl = req->ctl;
-
-	mutex_lock(&ctl->request_queue_lock);
-	if (!test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags)) {
-		mutex_unlock(&ctl->request_queue_lock);
-		return;
-	}
+	return test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
+}
 
-	list_del(&req->list);
-	clear_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
-	if (test_bit(TB_CFG_REQUEST_CANCELED, &req->flags))
-		wake_up(&tb_cfg_request_cancel_queue);
-	mutex_unlock(&ctl->request_queue_lock);
+static bool tb_cfg_request_is_canceled(struct tb_cfg_request *req)
+{
+	return test_bit(TB_CFG_REQUEST_CANCELED, &req->flags);
 }
 
-static bool tb_cfg_request_is_active(struct tb_cfg_request *req)
+static void tb_cfg_request_dequeue(struct tb_cfg_request *req)
 {
-	return test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
+	struct tb_ctl *ctl = req->ctl;
+
+	guard(mutex)(&ctl->request_queue_lock);
+	if (tb_cfg_request_is_active(req)) {
+		list_del(&req->list);
+		clear_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
+		tb_cfg_request_put(req);
+	}
 }
 
 static struct tb_cfg_request *
@@ -178,7 +178,7 @@ tb_cfg_request_find(struct tb_ctl *ctl,
 	mutex_lock(&pkg->ctl->request_queue_lock);
 	list_for_each_entry(iter, &pkg->ctl->request_queue, list) {
 		tb_cfg_request_get(iter);
-		if (iter->match(iter, pkg)) {
+		if (!tb_cfg_request_is_canceled(iter) && iter->match(iter, pkg)) {
 			req = iter;
 			break;
 		}
@@ -512,8 +512,11 @@ static void tb_ctl_rx_callback(struct tb
 	trace_tb_rx(pkg->ctl->index, frame->eof, pkg->buffer, frame->size, !req);
 
 	if (req) {
-		if (req->copy(req, pkg))
-			schedule_work(&req->work);
+		scoped_guard(mutex, &pkg->ctl->request_queue_lock) {
+			if (!tb_cfg_request_is_canceled(req) &&
+			    req->copy(req, pkg))
+				schedule_work(&req->work);
+		}
 		tb_cfg_request_put(req);
 	}
 
@@ -525,11 +528,10 @@ static void tb_cfg_request_work(struct w
 {
 	struct tb_cfg_request *req = container_of(work, typeof(*req), work);
 
-	if (!test_bit(TB_CFG_REQUEST_CANCELED, &req->flags))
+	if (!tb_cfg_request_is_canceled(req))
 		req->callback(req->callback_data);
 
 	tb_cfg_request_dequeue(req);
-	tb_cfg_request_put(req);
 }
 
 /**
@@ -555,10 +557,9 @@ int tb_cfg_request(struct tb_ctl *ctl, s
 	INIT_WORK(&req->work, tb_cfg_request_work);
 	INIT_LIST_HEAD(&req->list);
 
-	tb_cfg_request_get(req);
 	ret = tb_cfg_request_enqueue(ctl, req);
 	if (ret)
-		goto err_put;
+		return ret;
 
 	ret = tb_ctl_tx(ctl, req->request, req->request_size,
 			req->request_type);
@@ -572,9 +573,6 @@ int tb_cfg_request(struct tb_ctl *ctl, s
 
 err_dequeue:
 	tb_cfg_request_dequeue(req);
-err_put:
-	tb_cfg_request_put(req);
-
 	return ret;
 }
 
@@ -588,9 +586,10 @@ err_put:
  */
 void tb_cfg_request_cancel(struct tb_cfg_request *req, int err)
 {
-	set_bit(TB_CFG_REQUEST_CANCELED, &req->flags);
-	schedule_work(&req->work);
-	wait_event(tb_cfg_request_cancel_queue, !tb_cfg_request_is_active(req));
+	scoped_guard(mutex, &req->ctl->request_queue_lock)
+		set_bit(TB_CFG_REQUEST_CANCELED, &req->flags);
+	cancel_work_sync(&req->work);
+	tb_cfg_request_dequeue(req);
 	req->result.err = err;
 }
 


