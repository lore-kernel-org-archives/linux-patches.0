Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4769175A6D;
	Thu, 30 Jul 2026 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423305; cv=none; b=jYBb/t4wfslBvPgM5RxlUNSQ7aTD7Dn5kdXWBUsZCxKtNINBjZPpudTtCnUXYWCrMzxchTGXjd6+uZ3/RgtUGB8Btr5uSQ/+z8bIOfvBkpmGbAkBi5PXl3D2qwaA2Jt0Ni0JMlAifcJm0hlUajUg9nbLkqCMRHHUK28a/Oa+vUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423305; c=relaxed/simple;
	bh=xUYHkb8O9JaX+pOmGdA9Qx96QW+cxaexjgpu36sfuUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMw8nCD/10S5fM6v7BxCBybYvIEjn8wS0MEKqt+FvFqoMeKni1Rr81HON06igwCZ7LB/G9cw4kX1mHjQS5bV1O/pIlsfqbX1PxUlmDsHYno4ggyNDz8EO5sw9QTSG8/N0P06I0LE5CFc3zEf6UvQ7usV0WUqvr4NYgplE9v+7YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaj6LJQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaj6LJQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D401F000E9;
	Thu, 30 Jul 2026 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423304;
	bh=4Q/mQuKpNLVG98+awc3nZRVeOa0c9aQb+AJZKVndrmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaj6LJQZXh16wRtLv1rKlf+WoYIOxGDGPypsGU/WwtKvAcSicMZeMsSXFGQFo+12d
	 89G3+/imtcmBZXQ1eAwUYNE4VD983LMGSQlRCLBMnzKJ6gElK0mlOXA/gVQcxJG6D+
	 icKjQoArB3PtWmrx4zLiLypme8rVzuHl/oXc8+es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 736/744] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Thu, 30 Jul 2026 16:16:49 +0200
Message-ID: <20260730141459.953185717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -909,6 +909,19 @@ void tb_unregister_service_driver(struct
 }
 EXPORT_SYMBOL_GPL(tb_unregister_service_driver);
 
+static int update_xdomain(struct device *dev, void *data)
+{
+	struct tb_xdomain *xd;
+
+	xd = tb_to_xdomain(dev);
+	if (xd) {
+		queue_delayed_work(xd->tb->wq, &xd->properties_changed_work,
+				   msecs_to_jiffies(50));
+	}
+
+	return 0;
+}
+
 static ssize_t key_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -2500,19 +2513,6 @@ bool tb_xdomain_handle_request(struct tb
 	return ret > 0;
 }
 
-static int update_xdomain(struct device *dev, void *data)
-{
-	struct tb_xdomain *xd;
-
-	xd = tb_to_xdomain(dev);
-	if (xd) {
-		queue_delayed_work(xd->tb->wq, &xd->properties_changed_work,
-				   msecs_to_jiffies(50));
-	}
-
-	return 0;
-}
-
 static void update_all_xdomains(void)
 {
 	bus_for_each_dev(&tb_bus_type, NULL, NULL, update_xdomain);


