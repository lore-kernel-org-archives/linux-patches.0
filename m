Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D63FA5CC;
	Mon, 17 Aug 2026 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979715; cv=none; b=YZTBiBe3kckDzaiPah14q6/5lrQfDPBis6kWpvLd2FqDnIPBqre7WpRCFeFvfMIz0B+8SbfTPc0qIWIupqMCiWwZiyYkl1GDiHjFAS/7ANOZV80VEy4wslwYynj+Jtm+pgQ7zJXMEjO7mjdNYm/UHabp/7PZuGtndjROyFy363Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979715; c=relaxed/simple;
	bh=UrwH5QyChKh1xbZMsm++KT0f5d5XIDjdnq8v94471u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW0tlcJpgVxgVvXHkOc9pR4sKVGJuw+a7ABDQtic9D336ATw/2oVE+Tp6asIzKjC0qKplRCfSdTHjOI7YZH/vFhyI3FAeZs3xXv8GZUDGGJ4U519pkBoR2sViM/5F44mA/byetdBuXBPuHFwIuYHyQie8E67CYCBA5yzURhlmOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL24+H0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL24+H0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB11F00A3A;
	Mon, 17 Aug 2026 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979713;
	bh=yNp6Sf3yktpPYKDeqNNLqVu5ZDIpcUdv5TLA/uDUkgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL24+H0+RjIo62mXnS460E3T2y0hu2mQvogtewRV8DZcoQ4fgw42gFuuA70YlVrq8
	 lKelo7CP5hk3zcMVBh4x43vNjWKz6sOYqlzOD7Ga08pzW0R651MSNPFx74HnG93rFa
	 QJx+gf/SjAssp/wVn7v1+VoITjZ8w2RsvRmFYITI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 284/609] drm/amdgpu: fix division by zero with invalid uvd dimensions
Date: Mon, 17 Aug 2026 15:29:40 +0200
Message-ID: <20260817132553.682741084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -630,6 +630,14 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned min_ctx_size = ~0;
 
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


