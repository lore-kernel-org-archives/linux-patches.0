Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A559D27466A;
	Fri,  7 Aug 2026 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115850; cv=none; b=CuTsP6AwMYe7PC8ceQZs3dSVBXSaeW5VzomFrv5wLRLhjZSsJjHQX1TWC65FEfE2klzoS9W2e+5TsYllLYW/92dn9AJNc4VS+4u2G0uLwpEgN64e/k5ZXev2lYp4HnCPv0RCbxQLjyDpJgKrOTNO3vWpO8XqiOqx0YVsso39EcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115850; c=relaxed/simple;
	bh=NcYgsDgtJyPbLV80puQHSH6H0CuVLednrX/aCozPhxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZecCa/1wAcnuhkchO+t5+SFmzAZ63QrNFZ7Kky/ly8+C+ihoBsCbw9hMwDILkfR6kjRlboSiQfEOw5TWuOnfBVO5/xUDBsLBoj6fC+hLkrrwCmrniRcqSq+mkm9iy0SRtlBGMFnYas2+8YOba+bfBkV2t/f3hRvr8Dc8BM049rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HM4mFveC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HM4mFveC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBB61F00A3A;
	Fri,  7 Aug 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115849;
	bh=6ReZRDj9TJ9opXbLSZ1zOFYSshLDWvJMhxrhhNwzxMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HM4mFveCWpu35j812dMX9ZjlnlgRCw7qBNgT5HR2hUpi/9KutT5mSq+pvSWFi+BzU
	 u/5NJV3npQDauXdqfzWLf5AeClL9VRvbd8HhKLc6nqiHOTYT+t5T7gtbK03TbwVV2L
	 AQdQs59sWUR8d3iCCbkQ2zilI7pzqGWEvQagx/Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/261] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Fri,  7 Aug 2026 16:36:06 +0200
Message-ID: <20260807143415.566156785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/thunderbolt/xdomain.c | 40 ++++++++++++++++++++++++++---------
 include/linux/thunderbolt.h   |  3 +++
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index a5ec70327d81a..87fbced665b91 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -783,9 +783,13 @@ static void tb_xdp_handle_request(struct work_struct *work)
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
@@ -798,8 +802,12 @@ static void tb_xdp_handle_request(struct work_struct *work)
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
 
@@ -827,9 +835,13 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
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
@@ -2018,6 +2030,10 @@ void tb_xdomain_remove(struct tb_xdomain *xd)
 {
 	tb_xdomain_debugfs_remove(xd);
 
+	mutex_lock(&xd->lock);
+	xd->removing = true;
+	mutex_unlock(&xd->lock);
+
 	stop_handshake(xd);
 
 	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
@@ -2412,8 +2428,12 @@ static int update_xdomain(struct device *dev, void *data)
 
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
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 02333f47c9941..d95e69c1ac63b 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -203,6 +203,8 @@ enum tb_link_width {
  * @link_width: Width of the downstream facing link
  * @link_usb4: Downstream link is USB4
  * @is_unplugged: The XDomain is unplugged
+ * @removing: Set by tb_xdomain_remove() under @lock to prevent
+ *	      concurrent delayed work queueing
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @service_ids: Used to generate IDs for the services
@@ -251,6 +253,7 @@ struct tb_xdomain {
 	enum tb_link_width link_width;
 	bool link_usb4;
 	bool is_unplugged;
+	bool removing;
 	bool needs_uuid;
 	struct ida service_ids;
 	struct ida in_hopids;
-- 
2.53.0



