Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEFC246BCD;
	Sat, 12 Sep 2026 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207356; cv=none; b=juVgU0kI7UD8ef2rybnS4fybgZsU5kTPuEF/gKRa8yWM5MQZpJrqzRrq6JRg3M9IzkBMZyf4vRNxAx/cY90qD0FkUtxKFqirSgLQPsWofYiSRfhG/Sf2RakStuamXgWDkPYneDUEcoo9prMOdCzHMeT0f8Jejf+sFFSnybetz9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207356; c=relaxed/simple;
	bh=qLifwwBmaLu1wyNzqgGKoj0ywieHk4sEQsOn6qzNH0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMxQPwwfRB6Nh50HC7UDj3yrr/qNh03R6X7UDdmoHsfd0oQwUAqd9+dbUVzc7vNbcg/QGY+/rvz6RdiaGkcyuh+sYU92Km0GoaSoOwSzgoXSvZqg3Nh2IBl/EnyF9YojmHk5UbhYG2WP6I6Lm/0UxkNDGxUYKGKEj+yaBzI09zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUmVfrrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUmVfrrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B631F000FF;
	Sat, 12 Sep 2026 10:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207355;
	bh=O7wu/l8JDnFOfObCG6DFD2fglhrifyj540XxN6vZKn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUmVfrrhY2WYyZ30jcxHxy/DOQU8ykqj5JdjyVwSAMSKYdt6QVk7/TYUOZdWjk8iL
	 F2hr3ky0a3i5Cjv+2ocVDwJlZmAI1CHo3LZX5nOCZQv1AbfGb6x2wZlS+Af1jXv+wZ
	 JlsNClb4DgXVqnNqia1i9nHaRrQdmNQMGtsiz82s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0369/1518] iommufd: Simplify iommufd_device_remove_vdev()
Date: Sat, 12 Sep 2026 08:42:18 +0200
Message-ID: <20260912065631.817013127@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8062148046e1a6417d44e2ed86c04e66c2f4f2a1 ]

Peiyang reports that this function indirectly includes a fault injection
point through iommufd_get_object() that was intended to cover the uAPI use
of object IDs, not in places like this that cannot fail.

On deeper inspection this can be written using a dedicated helper to
obtain a users refcount relying entirely on the xa locking instead of
going through the whole get/put scheme. The new helper doesn't need the
fault injection point.

Fixes: 850f14f5b919 ("iommufd: Destroy vdevice on idevice destroy")
Link: https://patch.msgid.link/r/0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com
Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/r/870BB9ADBBEDDD1A+37c5bfab-ad32-4fc5-a302-57c81a8432b5@smail.nju.edu.cn
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/device.c          | 13 +++----------
 drivers/iommu/iommufd/iommufd_private.h |  9 +--------
 drivers/iommu/iommufd/main.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index c40515bf5017b..3216deab98e39 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -148,29 +148,22 @@ static void iommufd_device_remove_vdev(struct iommufd_device *idev)
 	if (!idev->vdev)
 		goto out_unlock;
 
-	vdev = iommufd_get_vdevice(idev->ictx, idev->vdev->obj.id);
+	vdev = idev->vdev;
+
 	/*
 	 * An ongoing vdev destroy ioctl has removed the vdev from the object
 	 * xarray, but has not finished iommufd_vdevice_destroy() yet as it
 	 * needs the same mutex. We exit the locking then wait on wait_cnt
 	 * reference for the vdev destruction.
 	 */
-	if (IS_ERR(vdev))
-		goto out_unlock;
-
-	/* Should never happen */
-	if (WARN_ON(vdev != idev->vdev)) {
-		iommufd_put_object(idev->ictx, &vdev->obj);
+	if (iommufd_try_inc_users(idev->ictx, &vdev->obj))
 		goto out_unlock;
-	}
 
 	/*
 	 * vdev is still alive. Hold a users refcount to prevent racing with
 	 * userspace destruction, then use iommufd_object_tombstone_user() to
 	 * destroy it and leave a tombstone.
 	 */
-	refcount_inc(&vdev->obj.users);
-	iommufd_put_object(idev->ictx, &vdev->obj);
 	mutex_unlock(&idev->igroup->lock);
 	iommufd_object_tombstone_user(idev->ictx, &vdev->obj);
 	return;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 53d37e77c4b98..c208563eb367f 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -181,6 +181,7 @@ static inline bool iommufd_lock_obj(struct iommufd_object *obj)
 	return true;
 }
 
+int iommufd_try_inc_users(struct iommufd_ctx *ictx, struct iommufd_object *obj);
 struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 					  enum iommufd_object_type type);
 static inline void iommufd_put_object(struct iommufd_ctx *ictx,
@@ -695,14 +696,6 @@ void iommufd_vdevice_abort(struct iommufd_object *obj);
 int iommufd_hw_queue_alloc_ioctl(struct iommufd_ucmd *ucmd);
 void iommufd_hw_queue_destroy(struct iommufd_object *obj);
 
-static inline struct iommufd_vdevice *
-iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 id)
-{
-	return container_of(iommufd_get_object(ictx, id,
-					       IOMMUFD_OBJ_VDEVICE),
-			    struct iommufd_vdevice, obj);
-}
-
 #ifdef CONFIG_IOMMUFD_TEST
 int iommufd_test(struct iommufd_ucmd *ucmd);
 void iommufd_selftest_destroy(struct iommufd_object *obj);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ce775fbbae94e..02d06a02d5e67 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -180,6 +180,26 @@ struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 	return obj;
 }
 
+/*
+ * Increment the users count of an object outside the context of an ioctl that
+ * has already locked it. The users refcount cannot be increased on an already
+ * created object unless the object is installed in the xarray, otherwise things
+ * are racing with a parallel destruction.
+ */
+int iommufd_try_inc_users(struct iommufd_ctx *ictx, struct iommufd_object *obj)
+{
+	struct iommufd_object *cur;
+
+	xa_lock(&ictx->objects);
+	cur = xa_load(&ictx->objects, obj->id);
+	if (cur == obj)
+		refcount_inc(&obj->users);
+	xa_unlock(&ictx->objects);
+	if (cur != obj)
+		return -EBUSY;
+	return 0;
+}
+
 static int iommufd_object_dec_wait(struct iommufd_ctx *ictx,
 				   struct iommufd_object *to_destroy)
 {
-- 
2.53.0



