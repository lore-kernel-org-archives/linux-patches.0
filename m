Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA832BDC0E;
	Sat, 12 Sep 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204479; cv=none; b=OgDEIb2tu+dX5T3xBhgTHgQCThSZKW1EGkqCeDSs6rdwj4jh+kuT/X51SRe6oV1FmxhBgYos5IWXs30tc1VzICpZSXXbKx8yjKgQT4uvLQh9ZhVkoKWF3EZgLq/OWKOu8WVNFFzchogncS3hRLRq3Bbqq9t4rHbgesR2QHHSaYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204479; c=relaxed/simple;
	bh=51Ns/AwUjECa4l9i9TOkwK/5JkiePmJvNQjG/1OMFEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpBOn9VYaqQVh/bR2easdwzGYdxrSwr76Q7ygP9cKqKuQ1BmTTibFvgAVig7Dcp3bC4zr9WCW4M0YBwcFuypjvDL4PILGH199XiuR2EeKeNuHJVaRDC3AL5tewY0+F1Qtx/rKa/65jNwGx63+FxTeh7Yhnt4U9jLDtyBdV8FguQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEhMXpeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEhMXpeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38021F000FF;
	Sat, 12 Sep 2026 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204477;
	bh=8icFN5vcUuTwCd5x0j/jOxdlZWoXRa1Yml7Q+vPzwr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEhMXpeSXcKhlUPNpZbWgbAapQkwOXyex8eWYLDZHgJFyqiydtReg5rOhU/pWIvbA
	 D25z1x/5WUZvJ/fl+DuaV044ArpBzQqp9Ast1D3uh60jjc06MLXikMT0PqumF0T95U
	 65KY8VI4870pljITsIN0Kqz2rt+RHGZJVADuKEok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1621/1815] virtio: add virtio_device_shutdown() helper
Date: Sat, 12 Sep 2026 08:56:11 +0200
Message-ID: <20260912065727.044415307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 299fa83be1d5f..75bb4ffe3b877 100644
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
 
 static int virtio_dev_num_vf(struct device *dev)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 93e573c565635..f923e42cfd011 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -213,6 +213,7 @@ int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);
 #endif
 void virtio_reset_device(struct virtio_device *dev);
+void virtio_device_shutdown(struct virtio_device *dev);
 int virtio_device_reset_prepare(struct virtio_device *dev);
 int virtio_device_reset_done(struct virtio_device *dev);
 
-- 
2.53.0



