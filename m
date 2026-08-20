Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266004772A7;
	Thu, 20 Aug 2026 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248159; cv=none; b=N5j/0lvQF3DajZmiS9EKZ0aU9woL1r0cChP0bWhm2EPOngq/HQA4Nw60mIDI0ncRHhabXkFS0xshCbPj79kdhfDBisGKEEPDA7DHl+LLBiKK/I4awmprCDcRSOaTzDx1C9VaP13oi8ja4Yfb3bCP/8CXzu9T59QnTonNfAgkvXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248159; c=relaxed/simple;
	bh=fVmnbBLaxCVppSdKaBQ6hEvc7yBzkRzuFeAEvbw+ew8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y59wHfrk+QZYY3zp3H1pkq9RdXKhyoMSsDw/hAMVhQOQhB/js3Dm5C39sRoGP4TpgT6SItk/QlDAyDtHufm1EdV+jMUr7WSqRV+Y9Nl5sn8hGQHRtPMDasAX5j44pqxplXTncS1AWquF5welw9I3gqpVkA1EzJdb0qxY4TsfIF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJBJmbrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJBJmbrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D8D1F000E9;
	Thu, 20 Aug 2026 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248158;
	bh=VYgr82WwTuF2BtC1PETaQYRHIeJCai+T06IASBd4yGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJBJmbrQA8/ZMw5qafpqzz53OtY8X98uczkIAIvDklv+eaVV2nnPmmyRD3NjTXy0t
	 NnPCwC1CA7zIck8HjhacN9DDOaMRdPZHl27kWC5s6//Z46MKD1jhI+5piJghsVE40s
	 WpTN4mBhgEs7v8BRSCQQlKWTEIuPk1utuWNsZqLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/303] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145257.179727296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 2c5d2d3c3f70cde2565d7b279b544893a2035842 ]

tb_xdp_handle_request() runs on system_wq and queues
xd->state_work via queue_delayed_work() in three request handlers:
PROPERTIES_CHANGED_REQUEST, UUID_REQUEST (via start_handshake),
and LINK_STATE_CHANGE_REQUEST.  Similarly, update_xdomain() queues
xd->properties_changed_work when local properties change.

Concurrently, tb_xdomain_remove() calls stop_handshake() which does
cancel_delayed_work_sync() on both delayed works.  Later,
tb_xdomain_unregister() calls device_unregister() which eventually
frees the xdomain.  Since commit 559c1e1e0134 ("thunderbolt: Run
tb_xdp_handle_request() in system workqueue") moved the request
handler off tb->wq, the handler and the remove path are no longer
serialized.  If queue_delayed_work() executes after
cancel_delayed_work_sync() but before the xdomain is freed, the
delayed work fires on a freed object.

Add xd->removing that tb_xdomain_remove() sets under xd->lock
before calling stop_handshake().  Each external queue site holds
the same lock and checks removing before calling
queue_delayed_work().  This provides the mutual exclusion needed:
either the queue site acquires the lock first and queues work that
the subsequent cancel will see, or the remove path acquires the
lock first and the queue site observes removing == true and skips
the queue.

Fixes: 559c1e1e0134 ("thunderbolt: Run tb_xdp_handle_request() in system workqueue")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |   40 ++++++++++++++++++++++++++++++----------
 include/linux/thunderbolt.h   |    3 +++
 2 files changed, 33 insertions(+), 10 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -784,9 +784,13 @@ static void tb_xdp_handle_request(struct
 		 * the xdomain related to this connection as well in
 		 * case there is a change in services it offers.
 		 */
-		if (xd && device_is_registered(&xd->dev))
-			queue_delayed_work(tb->wq, &xd->state_work,
-					   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
+		if (xd) {
+			mutex_lock(&xd->lock);
+			if (!xd->removing && device_is_registered(&xd->dev))
+				queue_delayed_work(tb->wq, &xd->state_work,
+						   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
+			mutex_unlock(&xd->lock);
+		}
 		break;
 
 	case UUID_REQUEST_OLD:
@@ -799,8 +803,12 @@ static void tb_xdp_handle_request(struct
 		 * received UUID request from the remote host.
 		 */
 		if (!ret && xd && xd->state == XDOMAIN_STATE_ERROR) {
-			dev_dbg(&xd->dev, "restarting handshake\n");
-			start_handshake(xd);
+			mutex_lock(&xd->lock);
+			if (!xd->removing) {
+				dev_dbg(&xd->dev, "restarting handshake\n");
+				start_handshake(xd);
+			}
+			mutex_unlock(&xd->lock);
 		}
 		break;
 
@@ -828,9 +836,13 @@ static void tb_xdp_handle_request(struct
 
 			ret = tb_xdp_link_state_change_response(ctl, route,
 								sequence, 0);
-			xd->target_link_width = lsc->tlw;
-			queue_delayed_work(tb->wq, &xd->state_work,
-					   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
+			mutex_lock(&xd->lock);
+			if (!xd->removing) {
+				xd->target_link_width = lsc->tlw;
+				queue_delayed_work(tb->wq, &xd->state_work,
+						   msecs_to_jiffies(XDOMAIN_SHORT_TIMEOUT));
+			}
+			mutex_unlock(&xd->lock);
 		} else {
 			tb_xdp_error_response(ctl, route, sequence,
 					      ERROR_NOT_READY);
@@ -1978,6 +1990,10 @@ void tb_xdomain_remove(struct tb_xdomain
 {
 	tb_xdomain_debugfs_remove(xd);
 
+	mutex_lock(&xd->lock);
+	xd->removing = true;
+	mutex_unlock(&xd->lock);
+
 	stop_handshake(xd);
 
 	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
@@ -2364,8 +2380,12 @@ static int update_xdomain(struct device
 
 	xd = tb_to_xdomain(dev);
 	if (xd) {
-		queue_delayed_work(xd->tb->wq, &xd->properties_changed_work,
-				   msecs_to_jiffies(50));
+		mutex_lock(&xd->lock);
+		if (!xd->removing)
+			queue_delayed_work(xd->tb->wq,
+					   &xd->properties_changed_work,
+					   msecs_to_jiffies(50));
+		mutex_unlock(&xd->lock);
 	}
 
 	return 0;
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -189,6 +189,8 @@ void tb_unregister_property_dir(const ch
  * @link_width: Width of the link (1 or 2)
  * @link_usb4: Downstream link is USB4
  * @is_unplugged: The XDomain is unplugged
+ * @removing: Set by tb_xdomain_remove() under @lock to prevent
+ *	      concurrent delayed work queueing
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @service_ids: Used to generate IDs for the services
@@ -237,6 +239,7 @@ struct tb_xdomain {
 	unsigned int link_width;
 	bool link_usb4;
 	bool is_unplugged;
+	bool removing;
 	bool needs_uuid;
 	struct ida service_ids;
 	struct ida in_hopids;


