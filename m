Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E3223C4D;
	Thu, 12 Dec 2024 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025669; cv=none; b=ZGioxi0gxRDgowAxBmr/DcQnbvrgZ6+dLqaBZoQXqs6HjETFmU8y+Hvkx0C4pMarniPv6ar5qTVzde5CFLdtUIHoMQuCLq3lPiaXAtCd+SmrScce8dMuidy+7yGToG9ZQx/eGSLj/ZI57qAeFYxemiwvwojhRehfLJ6IDFwFHA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025669; c=relaxed/simple;
	bh=ccsrU6aOFM8Mmbh+DwLeDKBrZW3XWbipT639feZbyuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQCB6/oU5UGvuMOoizDKdUJJFBgGIP4L1IRNPSkx1KlxxrG1yPuSJLV6ts6Uv+3k2goO207LdxUiqCzVUKe6jdgFp4hcdT8n9MI9egJrjGhYX9AGi/cpWOUaqpfucaSTTLXdZYbH+5vq0h7i25ZsEYhyHa+ub0v6Wb/Yr+gzmzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzJewWcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzJewWcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC93CC4CECE;
	Thu, 12 Dec 2024 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025669;
	bh=ccsrU6aOFM8Mmbh+DwLeDKBrZW3XWbipT639feZbyuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzJewWcfWIMNH7Eb3xiQ4SYU3SFlGtV41ZUCg/FFI/wQLyfHjilplOfYRBMxu9tyz
	 EQ3prEij29wU1fjZtuKZSIT6uxjVnQlfgvrN7fmJpkIKRcLHUHbLhejO0wCXNo2prk
	 pD/xzToOko8PxBxTvQOrCPC8isbMACkm5B9vst/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/321] xen/xenbus: fix locking
Date: Thu, 12 Dec 2024 16:02:38 +0100
Message-ID: <20241212144239.455888436@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 2f69a110e7bba3ec6bc089a2f736ca0941d887ed ]

Commit 060eabe8fbe726 ("xenbus/backend: Protect xenbus callback with
lock") introduced a bug by holding a lock while calling a function
which might schedule.

Fix that by using a semaphore instead.

Fixes: 060eabe8fbe726 ("xenbus/backend: Protect xenbus callback with lock")
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20200305100323.16736-1-jgross@suse.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Stable-dep-of: afc545da381b ("xen: Fix the issue of resource not being properly released in xenbus_dev_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c         | 10 +++++-----
 drivers/xen/xenbus/xenbus_probe_backend.c |  5 +++--
 include/xen/xenbus.h                      |  3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 1ad5bc9dd6cc4..b88512d92ef52 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -240,9 +240,9 @@ int xenbus_dev_probe(struct device *_dev)
 		goto fail;
 	}
 
-	spin_lock(&dev->reclaim_lock);
+	down(&dev->reclaim_sem);
 	err = drv->probe(dev, id);
-	spin_unlock(&dev->reclaim_lock);
+	up(&dev->reclaim_sem);
 	if (err)
 		goto fail_put;
 
@@ -273,9 +273,9 @@ int xenbus_dev_remove(struct device *_dev)
 	free_otherend_watch(dev);
 
 	if (drv->remove) {
-		spin_lock(&dev->reclaim_lock);
+		down(&dev->reclaim_sem);
 		drv->remove(dev);
-		spin_unlock(&dev->reclaim_lock);
+		up(&dev->reclaim_sem);
 	}
 
 	module_put(drv->driver.owner);
@@ -489,7 +489,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 		goto fail;
 
 	dev_set_name(&xendev->dev, "%s", devname);
-	spin_lock_init(&xendev->reclaim_lock);
+	sema_init(&xendev->reclaim_sem, 1);
 
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 54aefbbbbff9e..8c76b94f0512d 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -45,6 +45,7 @@
 #include <linux/mm.h>
 #include <linux/notifier.h>
 #include <linux/export.h>
+#include <linux/semaphore.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -265,10 +266,10 @@ static int backend_reclaim_memory(struct device *dev, void *data)
 	drv = to_xenbus_driver(dev->driver);
 	if (drv && drv->reclaim_memory) {
 		xdev = to_xenbus_device(dev);
-		if (!spin_trylock(&xdev->reclaim_lock))
+		if (down_trylock(&xdev->reclaim_sem))
 			return 0;
 		drv->reclaim_memory(xdev);
-		spin_unlock(&xdev->reclaim_lock);
+		up(&xdev->reclaim_sem);
 	}
 	return 0;
 }
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 0d166dfe48334..372c7c69cdf6e 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -42,6 +42,7 @@
 #include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/semaphore.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/xenbus.h>
@@ -85,7 +86,7 @@ struct xenbus_device {
 	enum xenbus_state state;
 	struct completion down;
 	struct work_struct work;
-	spinlock_t reclaim_lock;
+	struct semaphore reclaim_sem;
 };
 
 static inline struct xenbus_device *to_xenbus_device(struct device *dev)
-- 
2.43.0



