Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60EF3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D782C433C0;
	Mon, 19 Jun 2023 10:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170919;
	bh=s9mrKwL6HcmwOo2sdypbeGAs4lUW4dfeHZAYUaQRDYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h77SK0rs+maGIqP39mSCeXer0BYD8qrB+JuKObDIeQerCV/Y1WLQCkN5r72UPYToM
	 2LVIjgkCv+7FrMkUl+7EOF7a/dQhRZ+DLoYCSi5LC+Ih9wnLztCAg+0TLIqOnlh09p
	 CFCBy6bXKjmEI8eesKYr1yuArsham1ROK8bHvIyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.3 083/187] drm/amd: Make sure image is written to trigger VBIOS image update flow
Date: Mon, 19 Jun 2023 12:28:21 +0200
Message-ID: <20230619102201.610617892@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3eb1a3a04056ba3df3205e169b8acc9da0c65a94 upstream.

The VBIOS image update flow requires userspace to:
1) Write the image to `psp_vbflash`
2) Read `psp_vbflash`
3) Poll `psp_vbflash_status` to check for completion

If userspace reads `psp_vbflash` before writing an image, it's
possible that it causes problems that can put the dGPU into an invalid
state.

Explicitly check that an image has been written before letting a read
succeed.

Cc: stable@vger.kernel.org
Fixes: 8424f2ccb3c0 ("drm/amdgpu/psp: Add vbflash sysfs interface support")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3538,6 +3538,9 @@ static ssize_t amdgpu_psp_vbflash_read(s
 	void *fw_pri_cpu_addr;
 	int ret;
 
+	if (adev->psp.vbflash_image_size == 0)
+		return -EINVAL;
+
 	dev_info(adev->dev, "VBIOS flash to PSP started");
 
 	ret = amdgpu_bo_create_kernel(adev, adev->psp.vbflash_image_size,


