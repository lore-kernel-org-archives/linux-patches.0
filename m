Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B99844AB84;
	Thu, 30 Jul 2026 16:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427938; cv=none; b=IgpLZ3UAZdXy4N/cifvE9zS9Byz5nSwYyIoFhR9hAb7ks/rvJ85LGY9tX4S8jCfMGRKxc2gChUGaBI5+pTPP2UfrciFaTWbpHiKrL8M324kM40Ecjkz7TJDiOlE28nOqPblW2hGq9STVM9po254QK9ztXxfuPRXLwxDTld+S67M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427938; c=relaxed/simple;
	bh=zLTJvzvzFIMrY8Q5QTYIDeJCmvDcPi8RM/EncCrCAQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2EqzprZ+zCEov2vUCrWKTfCTQxJJcEM3zu85sAi8AK2MCQBBr2CAa3xiZUcS+j0+Don10mqCzJa891ibcESWH2sVrrI4yv/LcAzbqyYS+2eRdYeDxJoOD9gSSIZB7D0qxmZtcVyEOyPRHbxTWRPqoi0at1FldLbgRTgDk6RrYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdqPxXVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdqPxXVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71231F000E9;
	Thu, 30 Jul 2026 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427937;
	bh=z4t9kaBi6+7kP0meiohL5hi1j5dclhxHoftnxbmoqJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdqPxXVF8w0jVPu5658tXYdWK+vjiqR1AwKYErPTajXQ9m9Tr/G4mEKdi1+dltByg
	 boKHJGnhX+ZmPEIYcH/ZAnw23onMBn3DYrlddjvzWbAzPiPpWmnAluiFyWrYA18tF2
	 Xy4uaAIQX9jEtqAfY+t5k0Aed8FHLs9qmwhLT/g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 346/484] drm/amdgpu: fix division by zero with invalid uvd dimensions
Date: Thu, 30 Jul 2026 16:14:03 +0200
Message-ID: <20260730141430.998932847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -647,6 +647,14 @@ static int amdgpu_uvd_cs_msg_decode(stru
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


