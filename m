Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693547DD71;
	Thu, 20 Aug 2026 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244255; cv=none; b=kevpR3R1174fVlW3SzxgNOYzLC02osV/JnA6wYyppLrOXONJjGSvoYp+lvYOHHuK6MRypy/xF1N1U5EVQllwl+73ahs2QL4Rt+PUYHsXkCqLkf/Kgcvnygn4vjleO/vTFomsg+jLKOMGlHedzXG6UhypV4BOwTovJVpC8k6BYdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244255; c=relaxed/simple;
	bh=GFGGpO1ecpeZHC09mF3h9WrMZzC8m3Xy+vVMTCL/5VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKeRf3WkhuDoi5hTu4XwmYhN7GHMreWflYB8klRWVUaurGnp4YUb1kDTB5TE8z6B0FgcHPO4DpQ7M+TwJrKTTWgDMf7iNx3nPBPaK8ckJ0mAsFJPElgD7GMJW2um5RX3Mo/F/WLKu+3WdEEfswCio65k9n8QFavcaaGalYj4p/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbkn/UYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbkn/UYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F3F1F000E9;
	Thu, 20 Aug 2026 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244254;
	bh=48Vyj6KE13wrNr3+RlbJM27YrrkJd02GWlUqIYGuorU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lbkn/UYhxyI0A/eOrwcppJFOsKuK9rUNBW7Ebe5rGJGNNXW1/xMp118Q3X6yUf3qW
	 7bozyNVbmdRp6aCd/Ckl2gZtbVrhtYQiTHfITkaKID2dJUay7ok6AKPwgfeFKR1BQX
	 IfSMaIndvMbl7+hOHudM1hoezxPUGswkp280RQBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/235] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Thu, 20 Aug 2026 16:55:42 +0200
Message-ID: <20260820145219.667412673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/thunderbolt/xdomain.c |   20 ++++++++++++++++----
 include/linux/thunderbolt.h   |    3 +++
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -604,8 +604,12 @@ static void tb_xdp_handle_request(struct
 		 */
 		xd = tb_xdomain_find_by_uuid_locked(tb, &xchg->src_uuid);
 		if (xd) {
-			queue_delayed_work(tb->wq, &xd->get_properties_work,
-					   msecs_to_jiffies(50));
+			mutex_lock(&xd->lock);
+			if (!xd->removing)
+				queue_delayed_work(tb->wq,
+						   &xd->get_properties_work,
+						   msecs_to_jiffies(50));
+			mutex_unlock(&xd->lock);
 			tb_xdomain_put(xd);
 		}
 
@@ -1369,6 +1373,10 @@ static int unregister_service(struct dev
  */
 void tb_xdomain_remove(struct tb_xdomain *xd)
 {
+	mutex_lock(&xd->lock);
+	xd->removing = true;
+	mutex_unlock(&xd->lock);
+
 	stop_handshake(xd);
 
 	if (!device_is_registered(&xd->dev)) {
@@ -1646,8 +1654,12 @@ static int update_xdomain(struct device
 
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
@@ -181,6 +181,8 @@ void tb_unregister_property_dir(const ch
  * @device_name: Name of the device (or %NULL if not known)
  * @is_unplugged: The XDomain is unplugged
  * @resume: The XDomain is being resumed
+ * @removing: Set by tb_xdomain_remove() under @lock to prevent
+ *	      concurrent delayed work queueing
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @transmit_path: HopID which the remote end expects us to transmit
@@ -225,6 +227,7 @@ struct tb_xdomain {
 	const char *device_name;
 	bool is_unplugged;
 	bool resume;
+	bool removing;
 	bool needs_uuid;
 	u16 transmit_path;
 	u16 transmit_ring;


