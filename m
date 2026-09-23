Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3985349B7;
	Wed, 23 Sep 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174131; cv=none; b=krrGZTx0rhWxAe2jPGXz6Ajb75LEb6Y+2Xrc8lqip5WrMGo7I2bfWuW52Q6AHwPu3i7uM0UAQ+La4R/Mt1sWooFmDHftOmuHmqzT8Wwe31orNlr/iXQdDkvfFF4v8WJ1A5W0JWgpJB6NXkY2HZf24z1adDGhKtrBq/glRCWKTvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174131; c=relaxed/simple;
	bh=kJdu2Ki24sRPxUmBVvfzm6mL+IIC4vti+UJWUmMiRCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF0EA9a2HY3PeiAdUpm3du3mGeNQENKlJFeuBkCF2P4+O4lNWBUzsgvXvxhqj5dLe/d3nluUpOl9RazEZxNHTgPlyuzoedU12Ta25YLfCtSAv2BHetAY5LpH5IKblE0HtRxs2bIbdOLcBH8e7nV/yF56cVYy/k5OIE4fa6ZBBuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+HvyKxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+HvyKxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6FC1F00898;
	Wed, 23 Sep 2026 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174130;
	bh=H1ynl+mmwIHpEPEfSBroj9PjNlOiSrIaLJTWe/zfiDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+HvyKxqy6V8SsUb6VBSllIqGjC5JM4PlRHVD3TEJrv9QNcPEYFGveghHd6s9p7gZ
	 zQMRaB63cacUGfbQIa11qxQgyjUFAdyCDGhrW6Oex5x76wIkOZ7DLSRyHOERrWpauQ
	 tbpP9hD+AJrLkHZzFFvVwXvaxJPU0dJnH/G5Sou8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gloveless@jqluv.com,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.2 437/438] drm/amdgpu: restrict BAR0 fallback read to SR-IOV VFs only
Date: Wed, 23 Sep 2026 16:07:38 +0200
Message-ID: <20260923140656.270934747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit bd1f08246b8a2564d8ac61df715b6bcd5f994729 upstream.

The BAR0 fallback read path was introduced as a workaround for SR-IOV VFs
where the VRAM aperture is not available during early init. Restrict this
workaround to only SR-IOV VFs where it's needed.

Reported-by: gloveless@jqluv.com
Fixes: cba4928cdffa ("drm/amdgpu: reduce early full GPU access during SR-IOV init")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20260826185102.2269511-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8a0affd207c813bd063fa2c27786f449eaf92b8)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -769,6 +769,9 @@ static int amdgpu_device_read_fb_via_bar
 	if (!buf || !size)
 		return -EINVAL;
 
+	if (!amdgpu_sriov_vf(adev))
+		return -EINVAL;
+
 	flags = pci_resource_flags(adev->pdev, 0);
 	if ((flags & IORESOURCE_UNSET) || !(flags & IORESOURCE_MEM))
 		return -EINVAL;


