Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BB11EBFE0;
	Tue, 12 Aug 2025 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023031; cv=none; b=aGE6gwi9QKekE1GL9GLtQdba/r00J9Vwm5+NJzDunq4ZxYjjMNIxC84MbOmlLnIcOPvGfd0X58eHSUYTBm0p0ZlPluVq1aZF93gsuJpqh6SGmsXnUfFCqNi3708awWIFQXaTdqTXtVuFFh0C/GLGwPNCAmb+5mkkomQpJcujND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023031; c=relaxed/simple;
	bh=5er8bQlFs2g5P3oNk1TbLTWjkWPkNo02hsO+/IGbn8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpMQmqfIcEvGqzWiF6d24hMp/EhzWC4UaxgeKfRQfc0WYYkJ06KlQjB32rqn6GwnL6MH3R82D0jrAqOPNPYIB/MkHFP1TwBIjB6QrcUARZ9sA5OzwioUY7V0H2metBMscxEayJ6z7/HUKPzBmGYT5HT+JBHidUywZgyQ7YMmZok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XotSHSiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XotSHSiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75EFC4CEF7;
	Tue, 12 Aug 2025 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023031;
	bh=5er8bQlFs2g5P3oNk1TbLTWjkWPkNo02hsO+/IGbn8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XotSHSiPLs04Pz420Gddk7/V5jg5vwgYPGBSHQX7iez9VbAM23IN87kbdcCS9YoL9
	 HLvsmt1deS25OL7cqTBfyAsRwsVkYVaNOBN8Z1mT/+zV92WVf3XQ53Plb1VsNhTLyq
	 Maek+zJI1I0/uPPLD3WNw+VLtOF4sHWshX55Yr5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.12 330/369] accel/ivpu: Fix reset_engine debugfs file logic
Date: Tue, 12 Aug 2025 19:30:27 +0200
Message-ID: <20250812173029.124708926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>

commit 541a137254c71822e7a3ebdf8309c5a37b7de465 upstream.

The current reset_engine implementation unconditionally resets
all engines. Improve implementation to reset only the engine
requested by the user space to allow more granular testing.
Also use DEFINE_DEBUGFS_ATTRIBUTE() to simplify implementation.

Same changes applied to resume_engine debugfs file for consistency.

Signed-off-by: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-22-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c |   42 +++++++-------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -346,49 +346,23 @@ static const struct file_operations ivpu
 	.write = ivpu_force_recovery_fn,
 };
 
-static ssize_t
-ivpu_reset_engine_fn(struct file *file, const char __user *user_buf, size_t size, loff_t *pos)
+static int ivpu_reset_engine_fn(void *data, u64 val)
 {
-	struct ivpu_device *vdev = file->private_data;
+	struct ivpu_device *vdev = (struct ivpu_device *)data;
 
-	if (!size)
-		return -EINVAL;
-
-	if (ivpu_jsm_reset_engine(vdev, DRM_IVPU_ENGINE_COMPUTE))
-		return -ENODEV;
-	if (ivpu_jsm_reset_engine(vdev, DRM_IVPU_ENGINE_COPY))
-		return -ENODEV;
-
-	return size;
+	return ivpu_jsm_reset_engine(vdev, (u32)val);
 }
 
-static const struct file_operations ivpu_reset_engine_fops = {
-	.owner = THIS_MODULE,
-	.open = simple_open,
-	.write = ivpu_reset_engine_fn,
-};
+DEFINE_DEBUGFS_ATTRIBUTE(ivpu_reset_engine_fops, NULL, ivpu_reset_engine_fn, "0x%02llx\n");
 
-static ssize_t
-ivpu_resume_engine_fn(struct file *file, const char __user *user_buf, size_t size, loff_t *pos)
+static int ivpu_resume_engine_fn(void *data, u64 val)
 {
-	struct ivpu_device *vdev = file->private_data;
+	struct ivpu_device *vdev = (struct ivpu_device *)data;
 
-	if (!size)
-		return -EINVAL;
-
-	if (ivpu_jsm_hws_resume_engine(vdev, DRM_IVPU_ENGINE_COMPUTE))
-		return -ENODEV;
-	if (ivpu_jsm_hws_resume_engine(vdev, DRM_IVPU_ENGINE_COPY))
-		return -ENODEV;
-
-	return size;
+	return ivpu_jsm_hws_resume_engine(vdev, (u32)val);
 }
 
-static const struct file_operations ivpu_resume_engine_fops = {
-	.owner = THIS_MODULE,
-	.open = simple_open,
-	.write = ivpu_resume_engine_fn,
-};
+DEFINE_DEBUGFS_ATTRIBUTE(ivpu_resume_engine_fops, NULL, ivpu_resume_engine_fn, "0x%02llx\n");
 
 static int dct_active_get(void *data, u64 *active_percent)
 {


