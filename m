Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B8272E53;
	Thu, 20 Aug 2026 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243546; cv=none; b=FX01LSPtUfDOPcayAxiitqMtcF1lUkkAtAHuRI9jRTFrXEAMiawgJWZRh9VgoJ4f8yfc48SI1JEDOdlXNkjoHDrn5+McSc+8GxEeUQF0WoeZH49tveIJjx5x77VBePpB/CaD1wRn+H73qsExFcdjU6ah11+LWzEa8elZk5/XXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243546; c=relaxed/simple;
	bh=SPUDX20Xc2aikRrzxAlKMfO/BpnzddglYQ0WJNyjems=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRSD6u3fWEyu80f+guGZFCQttkeMMLZdCfm54xj829adDqIvFAbyefCisUv8kU0VDYCQ/X2v0PMsVbz7ZxGq49ScXSgQ5A+9Ni6DjyvK8MmlXxRAJ3KkNXZdX5jTQfG6aqOQCfA2bIRhJdY7aAMg35aExz7pdVFa/bAZxi2ViLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZL9o9cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZL9o9cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB2D1F000E9;
	Thu, 20 Aug 2026 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243544;
	bh=KXZdBgVfTB6XqRiQs8kaIaWGhdrK0y26H0DRt7klZXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZL9o9cc+3xqqfYfeoLz/XiCpa1nWO4CIY5kPUdwP6ktpCFHQXYXrQXcEkkw/oaf3
	 3nSd8xaFyESdqxqC2RQ/5aIOBOZOG1mXiz5T3rBqx/JkHJ4UTAbDc85rf/k9ETHNG7
	 aQHOpTYXlDPr787pDhG7Xv8MWbEy6LiI7t9gSCLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/272] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Thu, 20 Aug 2026 16:55:16 +0200
Message-ID: <20260820145235.221015005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/thunderbolt/xdomain.c |   22 +++++++++++++++++-----
 include/linux/thunderbolt.h   |    3 +++
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -630,9 +630,13 @@ static void tb_xdp_handle_request(struct
 		 * the xdomain related to this connection as well in
 		 * case there is a change in services it offers.
 		 */
-		if (xd && device_is_registered(&xd->dev)) {
-			queue_delayed_work(tb->wq, &xd->get_properties_work,
-					   msecs_to_jiffies(50));
+		if (xd) {
+			mutex_lock(&xd->lock);
+			if (!xd->removing && device_is_registered(&xd->dev))
+				queue_delayed_work(tb->wq,
+						   &xd->get_properties_work,
+						   msecs_to_jiffies(50));
+			mutex_unlock(&xd->lock);
 		}
 		break;
 
@@ -1486,6 +1490,10 @@ static int unregister_service(struct dev
  */
 void tb_xdomain_remove(struct tb_xdomain *xd)
 {
+	mutex_lock(&xd->lock);
+	xd->removing = true;
+	mutex_unlock(&xd->lock);
+
 	stop_handshake(xd);
 
 	if (!device_is_registered(&xd->dev)) {
@@ -1885,8 +1893,12 @@ static int update_xdomain(struct device
 
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
@@ -188,6 +188,8 @@ void tb_unregister_property_dir(const ch
  * @link_speed: Speed of the link in Gb/s
  * @link_width: Width of the link (1 or 2)
  * @is_unplugged: The XDomain is unplugged
+ * @removing: Set by tb_xdomain_remove() under @lock to prevent
+ *	      concurrent delayed work queueing
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @service_ids: Used to generate IDs for the services
@@ -235,6 +237,7 @@ struct tb_xdomain {
 	unsigned int link_speed;
 	unsigned int link_width;
 	bool is_unplugged;
+	bool removing;
 	bool needs_uuid;
 	struct ida service_ids;
 	struct ida in_hopids;


