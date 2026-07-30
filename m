Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D2E42F712;
	Thu, 30 Jul 2026 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424987; cv=none; b=Pu07v3RxUEd0G5oTwOjtNyC3w9rDw+M4uoOe34hZ2gMFg1550CH8YM6Ue94GxJEYhoHiPx4uN3DE2yEaJLy2Y3SBuQ8P7EyJkYiVUbwK/LJynOpAUolj8SyvafQ1g2jf8lI+fPBfy+3uoVuCp+UxXqw8ryI4RvamOM7Ee9pCR6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424987; c=relaxed/simple;
	bh=0LVYTosLTDUqmNgWj9kYrFsnHrC0HU6dOCIltHM+sD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTAUifd1lKhflLNkMknf765SFv/YKBqqig/+fZcP6ENmE70c/xMkfnizN8Uf/rVmYAunikSIrOgyLo6Dr6yx4HORNsVH3VwmFKW4OHMMC8Ma46hOQjxBJVxvpwAmlH4vqr6ZS1AF8qi+vn4tU7bYg+ojIo5pk+ZUuBeSn3C3Z2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrlkyWt0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrlkyWt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEDD1F000E9;
	Thu, 30 Jul 2026 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424985;
	bh=bXtYXRYCL+QeTjvVh18b2qYqCe2fYQ58HZxE+0K4oYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrlkyWt0eazmyEbpm7L/68FyRC4hIWkuIA2Zyq78qwUSHO/56U7cfrvQrwPgMe4Hh
	 q/5kY/IvRNBgEhSJA9pfgWcb0l1wHMwnBYmEh+NxDNc1z26fx8+6sZcyxYYF4cz7u/
	 lP2hCh+J4AnAZJO/PZAQz73dSQz2zXIAGnebtc+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 585/675] drm/amdgpu: fix division by zero with invalid uvd dimensions
Date: Thu, 30 Jul 2026 16:15:15 +0200
Message-ID: <20260730141457.555456695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit 0c01c811be47e6b146552dd59bfedbea8f09b8f4 upstream.

When width or height is less than 16, width_in_mb or height_in_mb
becomes 0, leading to fs_in_mb being 0. This causes a division by
zero when calculating num_dpb_buffer in H264 and H264 Perf decode
paths.

Add validation to reject frames with width < 16 or height < 16
before performing any calculations that depend on these values.

V2: Format change - move up all vaiable definitions.
V3: Use warn_once to avoid spam.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3e41d26c70b0a459d041cc19482a226c4b7423cb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -654,6 +654,14 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned int image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned int min_ctx_size = ~0;
 
+	/* Reject invalid dimensions to prevent division by zero */
+	if (width < 16 || height < 16) {
+		dev_WARN_ONCE(adev->dev, 1,
+			      "Invalid UVD decoding dimensions (%dx%d)!\n",
+			      width, height);
+		return -EINVAL;
+	}
+
 	image_size = width * height;
 	image_size += image_size / 2;
 	image_size = ALIGN(image_size, 1024);


