Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E9D4BEE32;
	Sat, 12 Sep 2026 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211949; cv=none; b=czFUKPm8x7jJHXFOHcs30UmUyUbXgDVVQbO6jMpjzEQg/y87ZKCpdyEIcdgkhhS5j2BF9rGyRp6XMMPTMGLIGnqCVTAKY7xznkK29rTf/BUTamxY1WZ2FrnCgVAaK2bOjfHxc2Gz3hRJJm+pqs8KYIOafgLkhUhrNEL7Y55M8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211949; c=relaxed/simple;
	bh=08H3HI0tIPP7sxxqJTXlb8es86S/04xIKr6rBC+p4c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMHKIRI9xVgF3lEhI7uWtYcjFBEab40aGeZ2kCZaq4qZHRSUeknZuAs+NnYT3DS7sqeLZfUTMAbwX6zh5ncsAoYqXfGj2AsM2A4lg/t8zr1vodwRI0PsQG+gXqxlrX1TAVbDJyXLG35tUdFwsuNNCPbKgtoOInb60H5Wcr6BPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AELr2Cp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AELr2Cp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AE61F000FF;
	Sat, 12 Sep 2026 11:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211947;
	bh=o4awGU42knKFhvlRzfnw+4RInWxY3CouFF5o7lATZHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AELr2Cp6zD8A1JDQ84C00Ec4jDpenSTiFarsE/3alEFQWmLLiRtsK5LvzaQDkFkFF
	 UVV3Dm5D0HEqcK5/jRGYrZIFReb9aG6Vtl4XHiwzlwQwUK72qcquLdCw40h0EgOlFp
	 jZWbeM9LfJMgN5xowDB66nd3o3KLxVrMXFrRWP+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1293/1518] virtio: add virtio_device_shutdown() helper
Date: Sat, 12 Sep 2026 08:57:42 +0200
Message-ID: <20260912065652.765995316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 0d8aebe089b4ba887e792884cf041ce9f1040ff4 ]

The generic virtio bus .shutdown handler, virtio_dev_shutdown(), breaks
and resets a device once it has established that the driver has no
.shutdown of its own. A driver that does implement .shutdown, to quiesce
its own activity first, still needs the same break and reset afterwards
and would otherwise have to open code it.

Factor the break + synchronize_cbs + reset sequence out of
virtio_dev_shutdown() into an exported virtio_device_shutdown() helper so
such drivers can reuse it instead of duplicating the core logic.

No functional change.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-2-den@openvz.org>
Stable-dep-of: 7e17eef04600 ("virtio_balloon: quiesce balloon work before device shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 41 +++++++++++++++++++++++++++--------------
 include/linux/virtio.h  |  1 +
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 5bdc6b82b30b4..3b7bab73d8950 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -401,6 +401,32 @@ static const struct cpumask *virtio_irq_get_affinity(struct device *_d,
 	return dev->config->get_vq_affinity(dev, irq_vec);
 }
 
+/**
+ * virtio_device_shutdown - break and reset a device on shutdown
+ * @dev: the device
+ *
+ * Drivers with their own .shutdown method should quiesce their activity and
+ * then call this to stop the device the way the generic shutdown path does.
+ */
+void virtio_device_shutdown(struct virtio_device *dev)
+{
+	/*
+	 * Some devices get wedged if you kick them after they are
+	 * reset. Mark all vqs as broken to make sure we don't.
+	 */
+	virtio_break_device(dev);
+	/*
+	 * Guarantee that any callback will see vq->broken as true.
+	 */
+	virtio_synchronize_cbs(dev);
+	/*
+	 * As IOMMUs are reset on shutdown, this will block device access to memory.
+	 * Some devices get wedged if this happens, so reset to make sure it does not.
+	 */
+	dev->config->reset(dev);
+}
+EXPORT_SYMBOL_GPL(virtio_device_shutdown);
+
 static void virtio_dev_shutdown(struct device *_d)
 {
 	struct virtio_device *dev = dev_to_virtio(_d);
@@ -419,20 +445,7 @@ static void virtio_dev_shutdown(struct device *_d)
 		return;
 	}
 
-	/*
-	 * Some devices get wedged if you kick them after they are
-	 * reset. Mark all vqs as broken to make sure we don't.
-	 */
-	virtio_break_device(dev);
-	/*
-	 * Guarantee that any callback will see vq->broken as true.
-	 */
-	virtio_synchronize_cbs(dev);
-	/*
-	 * As IOMMUs are reset on shutdown, this will block device access to memory.
-	 * Some devices get wedged if this happens, so reset to make sure it does not.
-	 */
-	dev->config->reset(dev);
+	virtio_device_shutdown(dev);
 }
 
 static const struct bus_type virtio_bus = {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index d3f723b875a78..9918538f59ca8 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -204,6 +204,7 @@ int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);
 #endif
 void virtio_reset_device(struct virtio_device *dev);
+void virtio_device_shutdown(struct virtio_device *dev);
 int virtio_device_reset_prepare(struct virtio_device *dev);
 int virtio_device_reset_done(struct virtio_device *dev);
 
-- 
2.53.0



