Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72B2AD16;
	Tue,  8 Jul 2025 00:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932965; cv=none; b=lYkkPeKk8Zqd3o3ndNndYcSvPykjIUlmFs/kI5zjczfxJ4j1gXiyG2a7VcuDZazC92mXKk2YfYjvFtHjyOokJ8dBzIozkz2joJVPCoCZP86od8Kt/JMzTKtP8AJlrOzdw0qWC8h4zTpiVYH4L+Ww1ZP9OiBACU6DRa39ho3mz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932965; c=relaxed/simple;
	bh=5NgoAFqm+T9LCk+9loFlldkh/Tg26UH3q61evtLs1K8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NZvtDxoGbKNfxBWc+k/dcA79Cp+brbsVA04By6Z6W3ENDXFNIfAoEjPvfLYam6q2lfgydHn8hSvKDAp6IXSaN0JmkuCeE4PRGwM3RiLKd/ZQLgnXpSkIN53WNSVW/KiHjtHzJBU+SXPqw274T+xpg69LIQoLQk95rou64oBiqj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYCMuDAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYCMuDAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AE3C4CEF1;
	Tue,  8 Jul 2025 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932965;
	bh=5NgoAFqm+T9LCk+9loFlldkh/Tg26UH3q61evtLs1K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYCMuDAKNe4GQIa5EBy0MNX79NqAr6qol1EMtOb8rCLiI3RruLvPQui3oUM4L/07h
	 UtMGWQnBzbRaAB7nks92Sk/xlxTzh62DyoUM11UmCYbIk2FPbd4QEBDWzmbYvif0Kw
	 +p12YU7iVVwLJk95zBsUg6reDf0ITjI8XUs/zK2XIEuhJiUi7dsCQR3c+0/kklqH+Q
	 SBpgSw6VYkz4ipPdalCPnwpRkZ1PQZqoPdgBrJuTwA2mXtyos/wtyFjG78DYUbAECt
	 oo54xPtoIWrZsMU8iWH0IXU9Ut3+ZkmLwawjdUVWgSAfF2ZmwZEP2IbpeD23XLXKS6
	 ZuurHWtX0GrUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	xuanzhuo@linux.alibaba.com,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 6.6 2/4] virtio_ring: Fix error reporting in virtqueue_resize
Date: Mon,  7 Jul 2025 20:02:39 -0400
Message-Id: <20250708000241.793498-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000241.793498-1-sashal@kernel.org>
References: <20250708000241.793498-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.96
Content-Transfer-Encoding: 8bit

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 45ebc7e6c125ce93d2ddf82cd5bea20121bb0258 ]

The virtqueue_resize() function was not correctly propagating error codes
from its internal resize helper functions, specifically
virtqueue_resize_packet() and virtqueue_resize_split(). If these helpers
returned an error, but the subsequent call to virtqueue_enable_after_reset()
succeeded, the original error from the resize operation would be masked.
Consequently, virtqueue_resize() could incorrectly report success to its
caller despite an underlying resize failure.

This change restores the original code behavior:

       if (vdev->config->enable_vq_after_reset(_vq))
               return -EBUSY;

       return err;

Fix: commit ad48d53b5b3f ("virtio_ring: separate the logic of reset/enable from virtqueue_resize")
Cc: xuanzhuo@linux.alibaba.com
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250521092236.661410-2-lvivier@redhat.com
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## Analysis Summary

**YES**, this commit should be backported to stable kernel trees.

Here's my extensive analysis:

### 1. **This is a clear bug fix for incorrect error reporting**

The commit fixes a critical error handling bug in `virtqueue_resize()`
where error codes from the resize operation (`virtqueue_resize_packed()`
or `virtqueue_resize_split()`) were being masked if
`virtqueue_enable_after_reset()` succeeded.

The specific bug pattern:
```c
// Before fix (buggy code):
err = virtqueue_resize_packed/_split(_vq, num);  // May return error
return virtqueue_enable_after_reset(_vq);        // Returns 0 on
success, masking 'err'

// After fix (correct code):
err = virtqueue_resize_packed/_split(_vq, num);
err_reset = virtqueue_enable_after_reset(_vq);
if (err_reset)
    return err_reset;
return err;  // Correctly returns the resize error
```

### 2. **The bug affects users and can cause silent failures**

According to the function documentation at lines 2787-2788, when
`-ENOMEM` is returned from resize, "vq can still work normally" with the
original ring size. However, with the bug, the caller would receive
success (0) instead of `-ENOMEM`, leading them to incorrectly believe
the resize succeeded when it actually failed. This could cause:
- Incorrect assumptions about queue capacity
- Performance issues if the application expected a different queue size
- Potential resource allocation mismatches

### 3. **The fix is small, contained, and low-risk**

The change is minimal - only 6 lines of code:
- Introduces a new local variable `err_reset`
- Properly preserves and returns the original error code
- No architectural changes or new features
- Only affects error propagation logic

### 4. **The bug exists in stable kernels**

- Bug introduced in v6.6-rc1 (commit ad48d53b5b3f)
- The feature (virtqueue_resize) exists since v6.0-rc1
- Therefore, stable kernels 6.6.x and later contain this bug

### 5. **Clear regression from refactoring**

The commit message explicitly states this "restores the original code
behavior" and includes a "Fix:" tag pointing to the commit that
introduced the regression. The original correct pattern was:
```c
if (vdev->config->enable_vq_after_reset(_vq))
    return -EBUSY;
return err;
```

### 6. **Meets stable kernel criteria**

Per stable kernel rules, this fix:
- Fixes a real bug that affects users (incorrect error reporting)
- Is already in Linus' tree (merged by Paolo Abeni)
- Is small and easily reviewable
- Has been tested (Tested-by: Lei Yang)
- Has multiple maintainer acks (Jason Wang, Michael S. Tsirkin)
- Does not add new features or make risky changes

### 7. **Similar commits context**

While the similar commits shown are feature additions (introducing
virtqueue_resize functionality), this commit is fundamentally different
- it's a bug fix for error handling, not a feature addition.

The fix ensures that callers of `virtqueue_resize()` receive accurate
error information, which is critical for proper error handling and
recovery in virtio drivers that use queue resizing functionality.

 drivers/virtio/virtio_ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c5f04234d9511..db4582687b958 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2739,7 +2739,7 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 		     void (*recycle)(struct virtqueue *vq, void *buf))
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	int err;
+	int err, err_reset;
 
 	if (num > vq->vq.num_max)
 		return -E2BIG;
@@ -2759,7 +2759,11 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 	else
 		err = virtqueue_resize_split(_vq, num);
 
-	return virtqueue_enable_after_reset(_vq);
+	err_reset = virtqueue_enable_after_reset(_vq);
+	if (err_reset)
+		return err_reset;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
-- 
2.39.5

