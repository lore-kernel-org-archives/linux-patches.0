Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E2625A35A;
	Tue,  2 Sep 2025 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756814932; cv=none; b=Hgijq0J3aZ/6Pb7WzLXUE4nQ1dktMtwo9yR5RzzSU97FcXpYWv3mKcw0gf9DTPwbhiUMxwHyAy9+SbhtLeo86Lv6Fg28qcG5f1mZ5tgYLM8SZgZEULhDy0Xy3qj5+Mpm/P/MCvIRwdhvjcVRyJ8l9XgNvvM13ZoXICXnl0UvaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756814932; c=relaxed/simple;
	bh=MTBISx2TrbKUTCQBuWxqITvtEHWCV2NbgkZHlrVnnVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRlY1LETwUa5svIreXSThRgiMrgDUOZxWvqAuLQAuuKw38cs/ITWziQjVtCssbsnfZ6jR2tG5WRFbznefcRXbejQj5kfCtaEW4srkQJbVaIfv8yo+ObFb7PLMh7kzh2CKubAoy+/nRE4cXYiAombRSVnPI9apyyKqiy7XtCyMwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkxySClu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkxySClu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F1FC4CEF7;
	Tue,  2 Sep 2025 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756814930;
	bh=MTBISx2TrbKUTCQBuWxqITvtEHWCV2NbgkZHlrVnnVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkxySCluMeUSHekIrGg/646Cuq46H1DfEXe8m5E8e8slYxwwLDbftTxlgs6LAiEFU
	 eSIZRzaMCz8u5SVNjT4HPvywyoZbZMCmiGvKorI8EOWVqOeUv/3VX74iU3yfVgc3FJ
	 sthevmkdIWVaxM6jExKimC0yKpo23ptO5h/6yFEVbQivJG+wUbsVsLMHzV2owWspUe
	 yINC9qtE6LrHYMY8zJbLgojrhRjPqFSVUZixX2XA/cGHO5iA4VfB5WaLInUlJj4HM3
	 mJLT0335hmmrvRv/eGZpwEbn4XctcXpwrPt7K7GYaMTQdlWYKWeLblNNWNLXUojvDh
	 BunzN9OFWnQ/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ying Gao <ying01.gao@samsung.com>,
	Ying Xu <ying123.xu@samsung.com>,
	Junnan Wu <junnan01.wu@samsung.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kraxel@redhat.com,
	jasowang@redhat.com,
	virtualization@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16-6.1] virtio_input: Improve freeze handling
Date: Tue,  2 Sep 2025 08:08:21 -0400
Message-ID: <20250902120833.1342615-10-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250902120833.1342615-1-sashal@kernel.org>
References: <20250902120833.1342615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.4
Content-Transfer-Encoding: 8bit

From: Ying Gao <ying01.gao@samsung.com>

[ Upstream commit 528d92bfc0937a6a1ec837dbbcb3612a8545cd37 ]

When executing suspend to ram, if lacking the operations
to reset device and free unused buffers before deleting
a vq, resource leaks and inconsistent device status will
appear.

According to chapter "3.3.1 Driver Requirements: Device Cleanup:"
of virtio-specification:
  Driver MUST ensure a virtqueue isn’t live
  (by device reset) before removing exposed
  buffers.

Therefore, modify the virtinput_freeze function to reset the
device and delete the unused buffers before deleting the
virtqueue, just like virtinput_remove does.

Co-developed-by: Ying Xu <ying123.xu@samsung.com>
Signed-off-by: Ying Xu <ying123.xu@samsung.com>
Co-developed-by: Junnan Wu <junnan01.wu@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
Signed-off-by: Ying Gao <ying01.gao@samsung.com>
Message-Id: <20250812095118.3622717-1-ying01.gao@samsung.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

## Extensive Analysis

This commit should be backported to stable kernel trees. Here's my
detailed analysis based on the code changes and commit context:

### 1. **Bug Fix Nature**
The commit fixes a clear resource leak bug in the virtio_input driver's
suspend-to-RAM path. Looking at the code changes in
`/home/sasha/linux/drivers/virtio/virtio_input.c:359-373`, the
`virtinput_freeze()` function was missing critical cleanup steps that
are present in `virtinput_remove()` (lines 340-356).

### 2. **Resource Leak Details**
The specific issue involves:
- **Memory leak**: The status queue (`vi->sts`) can contain allocated
  buffers (line 94 shows `virtqueue_add_outbuf` adds dynamically
  allocated `stsbuf` buffers via `kzalloc`). Without calling
  `virtqueue_detach_unused_buf()`, these buffers remain allocated but
  inaccessible after `del_vqs()`, causing memory leaks.
- **Device state inconsistency**: Not calling `virtio_reset_device()`
  before deleting virtqueues violates the virtio specification
  requirement quoted in the commit message.

### 3. **Minimal and Contained Fix**
The fix adds only 4 lines of code:
```c
+       void *buf;
+       virtio_reset_device(vdev);
+       while ((buf = virtqueue_detach_unused_buf(vi->sts)) != NULL)
+               kfree(buf);
```
This is a minimal change that mirrors what `virtinput_remove()` already
does (lines 351-353), making it a low-risk fix.

### 4. **Real User Impact**
This bug affects users who:
- Use virtio input devices (keyboards, mice, tablets in VMs)
- Perform suspend-to-RAM operations
- Would experience cumulative memory leaks on each suspend/resume cycle

### 5. **Follows Established Pattern**
Looking at commit `df4198b1e0c4a` from 2015, a similar fix was applied
to the remove path to add device reset and buffer cleanup. This current
commit extends that same pattern to the freeze path, showing consistency
with previous fixes.

### 6. **Compliance with Virtio Specification**
The commit explicitly addresses virtio specification compliance (chapter
3.3.1), which states that drivers MUST ensure virtqueues aren't live
before removing exposed buffers. This is a correctness issue beyond just
the memory leak.

### 7. **Similar Fixes in Other Drivers**
Examining other virtio drivers like `virtio_balloon.c` (lines checked
earlier), they properly reset the device in their freeze/remove paths,
confirming this is the correct pattern.

### 8. **No Architectural Changes**
The fix doesn't introduce:
- New features
- API changes
- Complex logic modifications
- Dependencies on other subsystems

It simply ensures proper cleanup during suspend, making it ideal for
stable backporting.

### 9. **Low Regression Risk**
The added code only runs during suspend-to-RAM, a well-defined path, and
mirrors existing, tested code from the remove function. The risk of
introducing new bugs is minimal.

This commit meets all criteria for stable backporting: it fixes a real
bug with user impact (memory leaks and spec violation), the fix is small
and contained, and it follows established patterns without introducing
architectural changes.

 drivers/virtio/virtio_input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index a5d63269f20b9..d0728285b6ce9 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -360,11 +360,15 @@ static int virtinput_freeze(struct virtio_device *vdev)
 {
 	struct virtio_input *vi = vdev->priv;
 	unsigned long flags;
+	void *buf;
 
 	spin_lock_irqsave(&vi->lock, flags);
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
 
+	virtio_reset_device(vdev);
+	while ((buf = virtqueue_detach_unused_buf(vi->sts)) != NULL)
+		kfree(buf);
 	vdev->config->del_vqs(vdev);
 	return 0;
 }
-- 
2.50.1

