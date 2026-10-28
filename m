Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208932;
	b=KyhTuCScez8pV+tYqZXFvowaqYToSccJK55nbs1xi/7eQSIStKyFHOZr9kt844gW7xuX
	 3Dt7Q4O3mMAfqEsvhD6kWYFk1whIx8TIuyrRBTsxCRAPcpu0eA57EFzebRZmt2hndhiaD
	 rEbIKJOXvfaUNug0hn1PT/ey2LwwsRiwIaGR9RSZYuDPrr/jRjtZ48RoXUNzd4bbO/ZRA
	 Av+OyqWcO10H5dmc2K1LyPEw2QCW9yrBaHxkYmqriCFxyuMCj2YMm//yU9ZD1XPoKx3cQ
	 9vNsToNL4+1WFC1KbhGpeWhCxqDyqVu2ktbEygY+C9hKWSlPwGsjTlSj9Ym2rFpt/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vkqy70+pToAecExa7jWNCt/ABBp24VCAjvHXMbS0m/8=;
	b=rh42brcnjSB5KDqvtJkvxadl5CzsVakz1pQ0DHSUV82uMMoK2oXkkxWNScHIbPNrMpPt
	 +UbSX4Jpyxl095Yo92XjAEp5jnPnCoh70rPpey/6KpQVaiHTQCoi5Mw/vdTlIL4Z18n4G
	 SqAFRaOKr3uF+vznRPv9aIQnnqGIJDdomETE43fQS/whHwoAD9RrptFRcbd4FA/hLJeXN
	 woO991qJWHYybogAMUszIGVpGJZEW1aeMW7SBbD5vP5ZqbLGHXaWvuEga6TI1FzJ5odyq
	 CplPxhq3IYuwiop/7zjNiEQoSTxiifAoZy6kZQT1jR+DtR+LZ+nFrEvHgW+uY46tiBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XUN/t1VW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D162A606A31C;
	Wed, 28 Oct 2026 17:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUN/t1VW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307C31F01825;
	Wed, 28 Oct 2026 17:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208931;
	bh=vkqy70+pToAecExa7jWNCt/ABBp24VCAjvHXMbS0m/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUN/t1VWx6ZdqfDF9eYPye0U/VNHTG5Ht1fqaZzjQozHCp4BR6mlapWxnKC8Dp7GH
	 96gNivSJ9yrUMtJPvVzv7sJ1WBmUJtaRaM5WXYUtn9RVjZkb2Y3b+Aw8bCKHctBz4r
	 kRWyvBovkpqGESj0C3xKeOqwEGvXmDfxy4L9dWLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/516] thunderbolt: Fix KASAN reported use-after-free when request is canceled
Date: Wed, 28 Oct 2026 17:57:26 +0100
Message-ID: <20261028170010.457023248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit a02188ddc24b7872f0c5e0c5873f827318717803 ]

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
[ sashal: replaced scoped mutex guards with explicit mutex_lock()/mutex_unlock() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/ctl.c | 47 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 85a6b093a097e..4318a0c8c01a0 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -53,7 +53,6 @@ struct tb_ctl {
 #define tb_ctl_dbg(ctl, format, arg...) \
 	dev_dbg(&(ctl)->nhi->pdev->dev, format, ## arg)
 
-static DECLARE_WAIT_QUEUE_HEAD(tb_cfg_request_cancel_queue);
 /* Serializes access to request kref_get/put */
 static DEFINE_MUTEX(tb_cfg_request_lock);
 
@@ -111,11 +110,14 @@ void tb_cfg_request_put(struct tb_cfg_request *req)
 static int tb_cfg_request_enqueue(struct tb_ctl *ctl,
 				  struct tb_cfg_request *req)
 {
+	tb_cfg_request_get(req);
+
 	WARN_ON(test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags));
 	WARN_ON(req->ctl);
 
 	mutex_lock(&ctl->request_queue_lock);
 	if (!ctl->running) {
+		tb_cfg_request_put(req);
 		mutex_unlock(&ctl->request_queue_lock);
 		return -ENOTCONN;
 	}
@@ -126,28 +128,24 @@ static int tb_cfg_request_enqueue(struct tb_ctl *ctl,
 	return 0;
 }
 
+static bool tb_cfg_request_is_active(struct tb_cfg_request *req)
+{
+	return test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
+}
+
 static void tb_cfg_request_dequeue(struct tb_cfg_request *req)
 {
 	struct tb_ctl *ctl = req->ctl;
 
 	mutex_lock(&ctl->request_queue_lock);
-	if (!test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags)) {
-		mutex_unlock(&ctl->request_queue_lock);
-		return;
+	if (tb_cfg_request_is_active(req)) {
+		list_del(&req->list);
+		clear_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
+		tb_cfg_request_put(req);
 	}
-
-	list_del(&req->list);
-	clear_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
-	if (test_bit(TB_CFG_REQUEST_CANCELED, &req->flags))
-		wake_up(&tb_cfg_request_cancel_queue);
 	mutex_unlock(&ctl->request_queue_lock);
 }
 
-static bool tb_cfg_request_is_active(struct tb_cfg_request *req)
-{
-	return test_bit(TB_CFG_REQUEST_ACTIVE, &req->flags);
-}
-
 static struct tb_cfg_request *
 tb_cfg_request_find(struct tb_ctl *ctl, struct ctl_pkg *pkg)
 {
@@ -157,7 +155,8 @@ tb_cfg_request_find(struct tb_ctl *ctl, struct ctl_pkg *pkg)
 	mutex_lock(&pkg->ctl->request_queue_lock);
 	list_for_each_entry(req, &pkg->ctl->request_queue, list) {
 		tb_cfg_request_get(req);
-		if (req->match(req, pkg)) {
+		if (!test_bit(TB_CFG_REQUEST_CANCELED, &req->flags) &&
+		    req->match(req, pkg)) {
 			found = true;
 			break;
 		}
@@ -484,8 +483,11 @@ static void tb_ctl_rx_callback(struct tb_ring *ring, struct ring_frame *frame,
 	 */
 	req = tb_cfg_request_find(pkg->ctl, pkg);
 	if (req) {
-		if (req->copy(req, pkg))
+		mutex_lock(&pkg->ctl->request_queue_lock);
+		if (!test_bit(TB_CFG_REQUEST_CANCELED, &req->flags) &&
+		    req->copy(req, pkg))
 			schedule_work(&req->work);
+		mutex_unlock(&pkg->ctl->request_queue_lock);
 		tb_cfg_request_put(req);
 	}
 
@@ -501,7 +503,6 @@ static void tb_cfg_request_work(struct work_struct *work)
 		req->callback(req->callback_data);
 
 	tb_cfg_request_dequeue(req);
-	tb_cfg_request_put(req);
 }
 
 /**
@@ -525,10 +526,9 @@ int tb_cfg_request(struct tb_ctl *ctl, struct tb_cfg_request *req,
 	INIT_WORK(&req->work, tb_cfg_request_work);
 	INIT_LIST_HEAD(&req->list);
 
-	tb_cfg_request_get(req);
 	ret = tb_cfg_request_enqueue(ctl, req);
 	if (ret)
-		goto err_put;
+		return ret;
 
 	ret = tb_ctl_tx(ctl, req->request, req->request_size,
 			req->request_type);
@@ -542,9 +542,6 @@ int tb_cfg_request(struct tb_ctl *ctl, struct tb_cfg_request *req,
 
 err_dequeue:
 	tb_cfg_request_dequeue(req);
-err_put:
-	tb_cfg_request_put(req);
-
 	return ret;
 }
 
@@ -558,9 +555,11 @@ int tb_cfg_request(struct tb_ctl *ctl, struct tb_cfg_request *req,
  */
 void tb_cfg_request_cancel(struct tb_cfg_request *req, int err)
 {
+	mutex_lock(&req->ctl->request_queue_lock);
 	set_bit(TB_CFG_REQUEST_CANCELED, &req->flags);
-	schedule_work(&req->work);
-	wait_event(tb_cfg_request_cancel_queue, !tb_cfg_request_is_active(req));
+	mutex_unlock(&req->ctl->request_queue_lock);
+	cancel_work_sync(&req->work);
+	tb_cfg_request_dequeue(req);
 	req->result.err = err;
 }
 
-- 
2.53.0



