Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BA81DEFC8;
	Tue,  8 Oct 2024 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392920; cv=none; b=sb1lieiUt9OGKIbQi9rM3jAWX1k9TOgjLqAdFqUXVer+JpHUwmTk1zNVDIYxUayllWVb3nmcavhHyFT1NhjNtFQSEtl4OO8FbRnIn0+2k9TNsQTplgTBFSilhpztapzZ6ZC0i6ChB1ur4kvYEvXG2GYRLXPZLuOoGJvaMCQfp2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392920; c=relaxed/simple;
	bh=szRt+te+Yh4MmRvABjXAsRYZPv0+EXokMZlv7HTRZ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcA2Xo/NUPPctZ3ozRDUmTUXrcqMKgxTDjAllf9b5GL0LoRcj+iUlxBpy4gZ0e7sl05ppe43QhT+buTRCtsM4pcDenBNY/ShF0XeASCy8x7SoRF9jTbaNiqofj8yMzJD4jTSTftVRb5wFQUyH2/PMZdOsU8vf4FckUVKoyk9F9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyaK8CAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyaK8CAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34219C4CEC7;
	Tue,  8 Oct 2024 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392920;
	bh=szRt+te+Yh4MmRvABjXAsRYZPv0+EXokMZlv7HTRZ4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyaK8CAjJuQWEV+XzLIGS4qVqzgy3QvJ8j9w/w4ePgBps91/o3lR4u6QXMXGoCrAo
	 2kwiXagJkNUk0vLaiU7n5ATNEGSJja4QvHz1Lkc08KwGT74y38NGaI3OH2MRAJxWZC
	 Y1hsg9xUEhncp04CdRFNR85GJCxWIpHSw+bwoKOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 546/558] drm/xe: Clean up VM / exec queue file lock usage.
Date: Tue,  8 Oct 2024 14:09:36 +0200
Message-ID: <20241008115723.720115011@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 9e3c85ddea7a473ed57b6cdfef2dfd468356fc91 ]

Both the VM / exec queue file lock protect the lookup and reference to
the object, nothing more. These locks are not intended anything else
underneath them. XA have their own locking too, so no need to take the
VM / exec queue file lock aside from when doing a lookup and reference
get.

Add some kernel doc to make this clear and cleanup a few typos too.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240921011712.2681510-1-matthew.brost@intel.com
(cherry picked from commit fe4f5d4b661666a45b48fe7f95443f8fefc09c8c)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 74231870cf49 ("drm/xe/vm: move xa_alloc to prevent UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c       |  2 --
 drivers/gpu/drm/xe/xe_device_types.h | 14 +++++++++++---
 drivers/gpu/drm/xe/xe_drm_client.c   |  9 ++++++++-
 drivers/gpu/drm/xe/xe_exec_queue.c   |  2 --
 drivers/gpu/drm/xe/xe_vm.c           |  4 ----
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 83f603a1ab122..8a44a2b6dcbb6 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -159,10 +159,8 @@ static void xe_file_close(struct drm_device *dev, struct drm_file *file)
 		xe_exec_queue_kill(q);
 		xe_exec_queue_put(q);
 	}
-	mutex_lock(&xef->vm.lock);
 	xa_for_each(&xef->vm.xa, idx, vm)
 		xe_vm_close_and_put(vm);
-	mutex_unlock(&xef->vm.lock);
 
 	xe_file_put(xef);
 
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index fbc05188263d9..a7c7812d57915 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -558,15 +558,23 @@ struct xe_file {
 	struct {
 		/** @vm.xe: xarray to store VMs */
 		struct xarray xa;
-		/** @vm.lock: protects file VM state */
+		/**
+		 * @vm.lock: Protects VM lookup + reference and removal a from
+		 * file xarray. Not an intended to be an outer lock which does
+		 * thing while being held.
+		 */
 		struct mutex lock;
 	} vm;
 
 	/** @exec_queue: Submission exec queue state for file */
 	struct {
-		/** @exec_queue.xe: xarray to store engines */
+		/** @exec_queue.xa: xarray to store exece queues */
 		struct xarray xa;
-		/** @exec_queue.lock: protects file engine state */
+		/**
+		 * @exec_queue.lock: Protects exec queue lookup + reference and
+		 * removal a frommfile xarray. Not an intended to be an outer
+		 * lock which does thing while being held.
+		 */
 		struct mutex lock;
 	} exec_queue;
 
diff --git a/drivers/gpu/drm/xe/xe_drm_client.c b/drivers/gpu/drm/xe/xe_drm_client.c
index 1af95b9b91715..c237ced421833 100644
--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -288,8 +288,15 @@ static void show_run_ticks(struct drm_printer *p, struct drm_file *file)
 
 	/* Accumulate all the exec queues from this client */
 	mutex_lock(&xef->exec_queue.lock);
-	xa_for_each(&xef->exec_queue.xa, i, q)
+	xa_for_each(&xef->exec_queue.xa, i, q) {
+		xe_exec_queue_get(q);
+		mutex_unlock(&xef->exec_queue.lock);
+
 		xe_exec_queue_update_run_ticks(q);
+
+		mutex_lock(&xef->exec_queue.lock);
+		xe_exec_queue_put(q);
+	}
 	mutex_unlock(&xef->exec_queue.lock);
 
 	/* Get the total GPU cycles */
diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index d0bbb1d9b1ac1..2179c65dc60ab 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -627,9 +627,7 @@ int xe_exec_queue_create_ioctl(struct drm_device *dev, void *data,
 		}
 	}
 
-	mutex_lock(&xef->exec_queue.lock);
 	err = xa_alloc(&xef->exec_queue.xa, &id, q, xa_limit_32b, GFP_KERNEL);
-	mutex_unlock(&xef->exec_queue.lock);
 	if (err)
 		goto kill_exec_queue;
 
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 743c8d79d79d2..8fb425ad9e4a4 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1905,9 +1905,7 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	if (IS_ERR(vm))
 		return PTR_ERR(vm);
 
-	mutex_lock(&xef->vm.lock);
 	err = xa_alloc(&xef->vm.xa, &id, vm, xa_limit_32b, GFP_KERNEL);
-	mutex_unlock(&xef->vm.lock);
 	if (err)
 		goto err_close_and_put;
 
@@ -1939,9 +1937,7 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	return 0;
 
 err_free_id:
-	mutex_lock(&xef->vm.lock);
 	xa_erase(&xef->vm.xa, id);
-	mutex_unlock(&xef->vm.lock);
 err_close_and_put:
 	xe_vm_close_and_put(vm);
 
-- 
2.43.0



