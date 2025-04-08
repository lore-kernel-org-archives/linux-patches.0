Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B3268FEB;
	Tue,  8 Apr 2025 12:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113770; cv=none; b=L80das9dtVfH6hKn2CdT+r96Y252IoCJcDhAf1Hsj54o0PYjnzYgztjre2UuBlSw+hHVaSb34DxTJUxujeVb6KMMnS0973Tz7hvyL8Cf76A3MehwQcYfOve0uJUjd74qHrLDtvtHbQpjdVhgUYfjIp41Ets+GT+RjRxq0STGhzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113770; c=relaxed/simple;
	bh=y8qIPJ5i0iNtyg6CgE86vbYp4U+0YkVw2PBZlKSl8wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCCF25suoUbIiqHEuQij8jmQ/mM+hJSt/YZrYadrFWOQLic0PEUuY6ab9Tr4YkCv7dbnmnGq7C74aFyaHevxV7CdTfEqggEmambeuQtWXmowZA8cUYUdP4rpmZ3CUqWrVMUc2lyxP82J8VvXmgMf0xCxDr6gk1OnRgiz1vvLhLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTJuR8s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTJuR8s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20296C4CEE5;
	Tue,  8 Apr 2025 12:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113769;
	bh=y8qIPJ5i0iNtyg6CgE86vbYp4U+0YkVw2PBZlKSl8wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTJuR8s3ay98RblDBUZ0MTJNO0AJEITR3TcBh8xTQEVhOJLh3lQN4nvJjEBuJ0Dio
	 oAuu2OM6QU5ELLQ95tk6Y/nHVXmR6xGQ5Lu9pM4w2VLfxNxSMByS8ESJVM9HQUz/NA
	 wdUPrbBJ7D6ME3oR2bF/yI6pN9+6sQQbPdynKHJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dbueso@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/154] drivers/hv: Replace binary semaphore with mutex
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104815.744556485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 8aea7f82153d6f292add3eb4bd7ba8edcae5c7f7 ]

At a slight footprint cost (24 vs 32 bytes), mutexes are more optimal
than semaphores; it's also a nicer interface for mutual exclusion,
which is why they are encouraged over binary semaphores, when possible.

Replace the hyperv_mmio_lock, its semantics implies traditional lock
ownership; that is, the lock owner is the same for both lock/unlock
operations. Therefore it is safe to convert.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Stable-dep-of: 73fe9073c0cc ("Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 01a2eeb2ec961..488ea7810ad99 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -107,7 +107,7 @@ static struct notifier_block hyperv_panic_block = {
 static const char *fb_mmio_name = "fb_range";
 static struct resource *fb_mmio;
 static struct resource *hyperv_mmio;
-static DEFINE_SEMAPHORE(hyperv_mmio_lock);
+static DEFINE_MUTEX(hyperv_mmio_lock);
 
 static int vmbus_exists(void)
 {
@@ -2082,7 +2082,7 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 	int retval;
 
 	retval = -ENXIO;
-	down(&hyperv_mmio_lock);
+	mutex_lock(&hyperv_mmio_lock);
 
 	/*
 	 * If overlaps with frame buffers are allowed, then first attempt to
@@ -2137,7 +2137,7 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 	}
 
 exit:
-	up(&hyperv_mmio_lock);
+	mutex_unlock(&hyperv_mmio_lock);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(vmbus_allocate_mmio);
@@ -2154,7 +2154,7 @@ void vmbus_free_mmio(resource_size_t start, resource_size_t size)
 {
 	struct resource *iter;
 
-	down(&hyperv_mmio_lock);
+	mutex_lock(&hyperv_mmio_lock);
 	for (iter = hyperv_mmio; iter; iter = iter->sibling) {
 		if ((iter->start >= start + size) || (iter->end <= start))
 			continue;
@@ -2162,7 +2162,7 @@ void vmbus_free_mmio(resource_size_t start, resource_size_t size)
 		__release_region(iter, start, size);
 	}
 	release_mem_region(start, size);
-	up(&hyperv_mmio_lock);
+	mutex_unlock(&hyperv_mmio_lock);
 
 }
 EXPORT_SYMBOL_GPL(vmbus_free_mmio);
-- 
2.39.5



