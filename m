Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D9221D93;
	Thu, 12 Dec 2024 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025763; cv=none; b=NjZXe1bYRJi6VGPNmK/5Z0Poyj+CR+WVJflA81+fymCV4sCXyRE/NXSYZVD7cM3kxh7b5HB/ssJDAVusVlULInnV3xRt3OGIBryegIKvN9/CgMZH+fgD/eyHtymNFr1P1FeSD52xOVFK5zLRL74bYTJ1FA4dr0RsX/NQKEeLZjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025763; c=relaxed/simple;
	bh=DJOitZEV/tEAL2dlk3MsD/UFTDz158h1yQXg0SF/0Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx0MnUrieW+s4pJ1P/N41jCL2fIC8WQ98bkTOFfYftuA5gpk8EbdyF/o2Pbg3vTTa0j4uUlIUA54j7/KDElmN4Tq52EcNhG4Lv1M7sHNZY1Jdo61MycOoagugFsbZnRmbD/QPwUTxPa6OQ9xO/It8ah8g9pTm5e7LtPsf/Fchpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTcfTRQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTcfTRQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73452C4CECE;
	Thu, 12 Dec 2024 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025762;
	bh=DJOitZEV/tEAL2dlk3MsD/UFTDz158h1yQXg0SF/0Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTcfTRQAbRIUkq7lJeu0UG1gLMaUPlRKls13LETV9/GGOd+ttBwHECILTJOvF4eEX
	 b2E8+6efK0L5OF8EXFh465YwGRRV70bDqt12XoMXklu9GH4JOWnOGfisJNqWZGstXt
	 z/fc1ci6CaYjcqt5u6fE/a0keQpsdr/RvQXRZ4kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	SeongJae Park <sjpark@amazon.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/321] xenbus/backend: Protect xenbus callback with lock
Date: Thu, 12 Dec 2024 16:02:37 +0100
Message-ID: <20241212144239.417053092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit 060eabe8fbe726aca341b518366da4d79e338100 ]

A driver's 'reclaim_memory' callback can race with 'probe' or 'remove'
because it will be called whenever memory pressure is detected.  To
avoid such race, this commit embeds a spinlock in each 'xenbus_device'
and make 'xenbus' to hold the lock while the corresponded callbacks are
running.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Stable-dep-of: afc545da381b ("xen: Fix the issue of resource not being properly released in xenbus_dev_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c         |  8 +++++++-
 drivers/xen/xenbus/xenbus_probe_backend.c | 10 ++++++++--
 include/xen/xenbus.h                      |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 9215099caad61..1ad5bc9dd6cc4 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -240,7 +240,9 @@ int xenbus_dev_probe(struct device *_dev)
 		goto fail;
 	}
 
+	spin_lock(&dev->reclaim_lock);
 	err = drv->probe(dev, id);
+	spin_unlock(&dev->reclaim_lock);
 	if (err)
 		goto fail_put;
 
@@ -270,8 +272,11 @@ int xenbus_dev_remove(struct device *_dev)
 
 	free_otherend_watch(dev);
 
-	if (drv->remove)
+	if (drv->remove) {
+		spin_lock(&dev->reclaim_lock);
 		drv->remove(dev);
+		spin_unlock(&dev->reclaim_lock);
+	}
 
 	module_put(drv->driver.owner);
 
@@ -484,6 +489,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 		goto fail;
 
 	dev_set_name(&xendev->dev, "%s", devname);
+	spin_lock_init(&xendev->reclaim_lock);
 
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 386a1348694a7..54aefbbbbff9e 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -258,12 +258,18 @@ static int backend_probe_and_watch(struct notifier_block *notifier,
 static int backend_reclaim_memory(struct device *dev, void *data)
 {
 	const struct xenbus_driver *drv;
+	struct xenbus_device *xdev;
 
 	if (!dev->driver)
 		return 0;
 	drv = to_xenbus_driver(dev->driver);
-	if (drv && drv->reclaim_memory)
-		drv->reclaim_memory(to_xenbus_device(dev));
+	if (drv && drv->reclaim_memory) {
+		xdev = to_xenbus_device(dev);
+		if (!spin_trylock(&xdev->reclaim_lock))
+			return 0;
+		drv->reclaim_memory(xdev);
+		spin_unlock(&xdev->reclaim_lock);
+	}
 	return 0;
 }
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index cf37b2d93560f..0d166dfe48334 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -85,6 +85,7 @@ struct xenbus_device {
 	enum xenbus_state state;
 	struct completion down;
 	struct work_struct work;
+	spinlock_t reclaim_lock;
 };
 
 static inline struct xenbus_device *to_xenbus_device(struct device *dev)
-- 
2.43.0



