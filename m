Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1D344AB8D;
	Thu, 30 Jul 2026 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425151; cv=none; b=NpaGco++hf5ujEIP7kVL67tNpgaHqiKHzprgb4zk6qYmX5cOV7b1y9App7mxFIGbB6K7Zy2t9j/KVF9Wlanx4MpnkIx1f7QEeTC7jGxNaKhRrGusi1F5Ft2AoT4OeuhNDUZltQ2Bsqo9FDcfC6RZM5hYSzcxfNDP01YaNe+q/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425151; c=relaxed/simple;
	bh=huLPUH2WZHWb3E+skH96nrAlDzOeRkKzg38REDAdVE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYO33jcy46RNcXm/qjEJEazxH66Seb+iCZWEINKKTS/3ElSf0iRH8Z82qMrDciYSxMkjpuINkceOnlS3/vB4xY5zsn9VNAGMYo6LISlHk+qiF1U+zFwWd2fI1iot+imrOUNpseF0CPsnhTyxMOkq2J31wvYehAMwYztHPc2TXlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U66ySGXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U66ySGXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85771F00A3D;
	Thu, 30 Jul 2026 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425150;
	bh=JQybpkaX8k9pO5GupigCTVNrlQvQiqG0nn19GoKmKsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U66ySGXDvO5H3hhGyGd1yRdqVJ0q/Y3E6vKz4No6Y5jvYs/7hgq5syJLOfXsmLuAl
	 rYPqfby2sDK8BnUKAavW3IKLIl0GKFRa/sGHeHNw7tWQYNQB6biZulaSFGt2glQ2cG
	 mEm4ht5nN/6kNGP8QUxJcvuYgIIc7ialhzlCuIY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 640/675] thunderbolt: Prevent XDomain delayed work use-after-free on disconnect
Date: Thu, 30 Jul 2026 16:16:10 +0200
Message-ID: <20260730141458.732239799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


