Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4E23C1F5E;
	Tue, 16 Jun 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623740; cv=none; b=lzojdoYwVFfs8fMf3QT4b4VwRlkcft0RSSEHeJ4ekd48Gxuhpz/glPDuL/0rb7W6aEUmYRe5kufCfcluJ2B+jbp2GdQHcfx2bFCb4v9ne90OSAca7RcHnQeshc5b0KZ0EFYq1/STBF3n3iBqhiBeQP/QX3ayY7X3Ld071k0Yp7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623740; c=relaxed/simple;
	bh=wJ0bSyLm/XG2Xe+faHAU1IKxbyWZWjicCZmU5U9G39s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmmtqPVfns875jBCiX5Nbt1/4dKhBswmgYTUjKnuavJUd6e50q+da/dWPUGcM+cyjV2aFQWo9bQ3KIh7XUXCCwSvlu0PU6WGydvXqwrZDHrRRW8YaZMKZ9bVTmNAl5zq5S3EPyfog3cB9h1+zspJvDCVqF9WO4XQTQBum3nrwr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPT1GCjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPT1GCjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFAE1F000E9;
	Tue, 16 Jun 2026 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623738;
	bh=U9STe6k1W322fmvQTTZxWpHvjTQCn8i09SlFLfY/qzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPT1GCjRr2p8k8LBdC6OWJIgZrLFezXVXGEH6vs4nF23Rz8BnWNm4DkVrzuQzuubD
	 lwncLGMCruGYTgKsFu7gffsse4a8scrfZj8PkfSioQpsYIaIM1NGGSNzAB6rwWY3TX
	 ExFBc5fHVBk/UUZHkUKc3DAPU+Xzc1ej6zfUAQPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.0 177/378] accel/ivpu: Add bounds check for firmware runtime memory
Date: Tue, 16 Jun 2026 20:26:48 +0530
Message-ID: <20260616145119.695172835@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit 1d0b597facdd3c0239c88e8797c1014e1ea0ef15 upstream.

Validate that the firmware runtime memory specified in the image
header is properly aligned and sized to hold the firmware image.
This prevents errors during memory allocation and image transfer.

Fixes: 2007e210b6a1 ("accel/ivpu: Split FW runtime and global memory buffers")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260529120853.135876-1-andrzej.kacprowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_fw.c b/drivers/accel/ivpu/ivpu_fw.c
index 107f8ad31050..33c50779c06b 100644
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -259,6 +259,22 @@ static int ivpu_fw_parse(struct ivpu_device *vdev)
 		return -EINVAL;
 	}
 
+	if (!PAGE_ALIGNED(runtime_addr)) {
+		ivpu_err(vdev, "Runtime address 0x%llx not page aligned\n", runtime_addr);
+		return -EINVAL;
+	}
+
+	if (!PAGE_ALIGNED(runtime_size)) {
+		ivpu_err(vdev, "Runtime size %llu not page aligned\n", runtime_size);
+		return -EINVAL;
+	}
+
+	if (runtime_size < image_size) {
+		ivpu_err(vdev, "Runtime size too small: %llu, image size: %llu\n",
+			 runtime_size, image_size);
+		return -EINVAL;
+	}
+
 	if (!ivpu_is_within_range(image_load_addr, image_size, &vdev->hw->ranges.runtime)) {
 		ivpu_err(vdev, "Invalid firmware load address: 0x%llx and size %llu\n",
 			 image_load_addr, image_size);
-- 
2.54.0



