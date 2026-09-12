Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF8373BF3;
	Sat, 12 Sep 2026 07:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199259; cv=none; b=Jq2CfIWn5wRjWNvAZl9SFs6C224cbZZdZA2RJwYaplfmRbwqBYNnp81+WCDPXUdvZjGWlgC6vQ5T/XopwCjhIg2gVV8soSKdt0cUTFojwU+nBTJZbSpieHCEQUVXvA2V0rGzqJLWRI8rYyntDG+XhVkbatkrm01MR/4S5afnZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199259; c=relaxed/simple;
	bh=lLyHZpPQ5jx3Rq9HAHay/BhhUMGlGXf/YA5QCjX+SxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clB+C38S7v3R15TjQLpUPUvvwbLgzPLXPWdATdcY73CKA5B60DkcjxMK3AvaYRDPiSOGbnN/GFjhg0+PPapMeJDTQyE5UEzsOdIteiiSQVUDF733wA9TFdvnXRVmeYYJbiQGRCnr3/jk1UgUdgawO3HhV4iOTCnQRw4qoaPSTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0oFq2MM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0oFq2MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F4D1F000FF;
	Sat, 12 Sep 2026 07:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199258;
	bh=VjIinJp1v/JrefkQcYjvxLxtgjs1ghwLX3eM+xy0iBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0oFq2MMYjzxgJ0NlMi9elSjZpt3Qz1mWXPuVFRU0rDoNzj6J6JXZyrS8pkZ6FWKF
	 2V6+ojKO7N/s1pjnnf8xOoXweMIbuRcFmYoOVNxH/c9icQDnauTDZIYbAYrqCJM3mi
	 PWGHOvAUTElp7sSqvoedjO9i8lan5c168IDQ7yx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0506/1815] vfio: selftests: Avoid VLAs
Date: Sat, 12 Sep 2026 08:37:36 +0200
Message-ID: <20260912065700.769453545@linuxfoundation.org>
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

From: Alex Mastro <amastro@fb.com>

[ Upstream commit 6bc73befe1b4143ebe6a991b2ab133e9f3087128 ]

Allocate VFIO ioctl requests dynamically instead of using VLAs. GCC 11.5.0
rejects initialized VLAs with:

  error: variable-sized object may not be initialized

The replaced stack u8 arrays also do not guarantee native struct alignment
for the aliased pointers.

Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
Fixes: 20face8c75ff ("vfio: selftests: Add helper to set/override a vf_token")
Assisted-by: Codex:gpt-5.5-high
Reviewed-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Alex Mastro <amastro@fb.com>
Link: https://lore.kernel.org/r/20260617-scratch-amastro-vfio-selftests-avoid-vlas-v4-2-b9f52f1e2c5a@fb.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/vfio/lib/vfio_pci_device.c      | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 94dc5fcecbeb6..3db65084a4351 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -30,13 +30,11 @@
 static void vfio_pci_irq_set(struct vfio_pci_device *device,
 			     u32 index, u32 vector, u32 count, int *fds)
 {
-	u8 buf[sizeof(struct vfio_irq_set) + sizeof(int) * count];
-	struct vfio_irq_set *irq = (void *)&buf;
-	int *irq_fds = (void *)&irq->data;
+	size_t argsz = sizeof(struct vfio_irq_set) + sizeof(int) * count;
+	struct vfio_irq_set *irq;
 
-	memset(buf, 0, sizeof(buf));
-
-	irq->argsz = sizeof(buf);
+	irq = calloc_assert(1, argsz);
+	irq->argsz = argsz;
 	irq->flags = VFIO_IRQ_SET_ACTION_TRIGGER;
 	irq->index = index;
 	irq->start = vector;
@@ -44,12 +42,13 @@ static void vfio_pci_irq_set(struct vfio_pci_device *device,
 
 	if (count) {
 		irq->flags |= VFIO_IRQ_SET_DATA_EVENTFD;
-		memcpy(irq_fds, fds, sizeof(int) * count);
+		memcpy(irq->data, fds, sizeof(int) * count);
 	} else {
 		irq->flags |= VFIO_IRQ_SET_DATA_NONE;
 	}
 
 	ioctl_assert(device->fd, VFIO_DEVICE_SET_IRQS, irq);
+	free(irq);
 }
 
 void vfio_pci_irq_trigger(struct vfio_pci_device *device, u32 index, u32 vector)
@@ -118,15 +117,20 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 static int vfio_device_feature_ioctl(int fd, u32 flags, void *data,
 				     size_t data_size)
 {
-	u8 buffer[sizeof(struct vfio_device_feature) + data_size] = {};
-	struct vfio_device_feature *feature = (void *)buffer;
+	size_t argsz = sizeof(struct vfio_device_feature) + data_size;
+	struct vfio_device_feature *feature;
+	int ret;
 
+	feature = calloc_assert(1, argsz);
 	memcpy(feature->data, data, data_size);
 
-	feature->argsz = sizeof(buffer);
+	feature->argsz = argsz;
 	feature->flags = flags;
 
-	return ioctl(fd, VFIO_DEVICE_FEATURE, feature);
+	ret = ioctl(fd, VFIO_DEVICE_FEATURE, feature);
+	free(feature);
+
+	return ret;
 }
 
 static void vfio_device_feature_set(int fd, u16 feature, void *data, size_t data_size)
-- 
2.53.0



