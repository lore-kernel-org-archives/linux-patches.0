Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2183B6366;
	Thu, 30 Jul 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423226; cv=none; b=Yfo/juxbySIvU8DSW/LZsGtPx82xCIMFoeHEEwhwPR75fAFbLiAfIH699aNuhruhcNBmN0hruM+762621zKIHThx+Uw8+7UCPQtf49hymlk+kuJq2N2GW7g5hKQE5i3mymzrubjvV2KAXnd3pfvCmkuA1S18eJxO5ybDSMW8XNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423226; c=relaxed/simple;
	bh=4QJWl4vyuq9cADqI/e7isNG3dJUsR0M4YRVScjnsUoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJHqwc9OzahbCQHcgpjx1cRq3CNxBAQcbsGHJqQbFa86qdPC4iY4rVs9vs8uVhj/vjdiS1GQSxli5cCszeEngZzdJz44/YEPUVFrrmlZY+Vq7g5j4DuSZwPg6oWKOez3qthC67iBgfGOf6BOxA1b7DsIfvf4kZRTvGFR4S+SS7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A22KfQSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A22KfQSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6686D1F000E9;
	Thu, 30 Jul 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423224;
	bh=8pvGNBCA7nC00V14Cj+RhA9Bi8OwgohA4Kh9sanHGOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A22KfQSrOAW2AV2Ks8UnK0R0mBiqxkUH9cSZxM6GxH121O+p7OarQdMufu5oB3kFS
	 vWO+1hdQyorGUY8XmrxI6AgFUOxv01A+TTJBJ0hxDVwz7ZsLz33l/t0YCkr06HQxgx
	 lpdcV53UhapUnCMpptJIzUfK2d1ZSQcxvI5eRmCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 711/744] drm/amdgpu: fix division by zero with invalid uvd dimensions
Date: Thu, 30 Jul 2026 16:16:24 +0200
Message-ID: <20260730141459.391254525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -655,6 +655,14 @@ static int amdgpu_uvd_cs_msg_decode(stru
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


