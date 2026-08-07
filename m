Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF2339387;
	Fri,  7 Aug 2026 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116589; cv=none; b=QNy+yTha2KGlDWjvh0aUkXV6Z2nIkLPej2Lv9NeakS3kI3sftmwTqRIyrnMJTn24rKroE806wCW+wkCuQgrHM5yc5yUPxKNf34iwX9rs8EBB7yqU0ul4xsGGmL9m5+39PUar9XFrGF02E7rfVTlAB1VDG1vr8cMN4NAvxN7+HJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116589; c=relaxed/simple;
	bh=obQo3FINaixm/ezt8g3pm+dbcnS5PKrMzEMh6ea0ui4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeyeC3JjYvNJJ8AwTxfs3iSR3sXrBBX2mu7wnttnZ5u1K7NR1IH1Ygkh68k0yDGzWC7mJ8Ktwqdr5dpI/CPIrBmUh4j+knR36w9lJYUeL9H62osr+N9igxMvw4TW5qR+DY5pUwoj2r7UuxLnLmMbUIUONWIGj+u5cb3c/a9YHqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bpK84xW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bpK84xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06761F000E9;
	Fri,  7 Aug 2026 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116588;
	bh=Ubk7B9bLTUZuHIpNGs9C0/y/FxXzFW0BsO4mvqkaibo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bpK84xWqFdMQiLSRZId6tv51AgvALuYYyHye5JnSpbPQf0jx94I6B+lrCuwlf4pP
	 Os1qejQWI8INSb9Xtx7fZ/csKCKMtZzdFXhxktVDDj93U+0en/pEwP8qZplA8EQUnL
	 0HF3fGWmXsO9+CsYuFhoN5Bwn2E4gpATTRzTG4Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 006/438] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Fri,  7 Aug 2026 16:33:22 +0200
Message-ID: <20260807143428.147155723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fd1cf4295a2a..55f91ead8f13b 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -785,9 +785,13 @@ static void tb_xdp_handle_request(struct work_struct *work)
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
@@ -800,8 +804,12 @@ static void tb_xdp_handle_request(struct work_struct *work)
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
 
@@ -829,9 +837,13 @@ static void tb_xdp_handle_request(struct work_struct *work)
 
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
@@ -2074,6 +2086,10 @@ void tb_xdomain_remove(struct tb_xdomain *xd)
 {
 	tb_xdomain_debugfs_remove(xd);
 
+	mutex_lock(&xd->lock);
+	xd->removing = true;
+	mutex_unlock(&xd->lock);
+
 	stop_handshake(xd);
 
 	device_for_each_child_reverse(&xd->dev, xd, unregister_service);
@@ -2484,8 +2500,12 @@ static int update_xdomain(struct device *dev, void *data)
 
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
index 0ba112175bb39..7204586c10c3e 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -209,6 +209,8 @@ enum tb_link_width {
  * @link_width: Width of the downstream facing link
  * @link_usb4: Downstream link is USB4
  * @is_unplugged: The XDomain is unplugged
+ * @removing: Set by tb_xdomain_remove() under @lock to prevent
+ *	      concurrent delayed work queueing
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @service_ids: Used to generate IDs for the services
@@ -257,6 +259,7 @@ struct tb_xdomain {
 	enum tb_link_width link_width;
 	bool link_usb4;
 	bool is_unplugged;
+	bool removing;
 	bool needs_uuid;
 	struct ida service_ids;
 	struct ida in_hopids;
-- 
2.53.0



