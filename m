Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A9A3806BD;
	Thu, 30 Jul 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426520; cv=none; b=DLZhuc2V5NPlpNkGuzJisjD2Qu21cPopLM2TxeALkvHFYoH/uORoKEdzHF8uRjBOIKBoyvcSYvAnsRllq+cr7DHyQiG42i1R5gjERty/pTLcl7XTQiigiJPdQ4CF9TpzoEdvWxeygle/Z1CPSwPo5xvLRaV6ffwia1FB/cDRFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426520; c=relaxed/simple;
	bh=8TX/W6VF/24jYw6SnXXScDRcXMoj3VgLKAJRMl1E5YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APViWG7yedrWAbu3CGBozX8VXJgi8rQfX1Ko78vVu8VV9DqZtIAKn6hOTEiz/15jIFJHkd+/YsRCcIZrdSmUSiMeXEepTqa6ZOioLL7uHOAf85FB6HIbQg9QBwEYCRCfev9acJG7ab+vFWj1biNuNUp/gypIjtTxDdUr2YXy+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmkE6A4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmkE6A4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8401C1F000E9;
	Thu, 30 Jul 2026 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426519;
	bh=ejvxwalWu5Cx+4M/k6xByWi5IaGBntst3d5wNHf/sNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmkE6A4SPdzf1zQnI5Y9JtECdksOhYj6A3vloC3c5XTjxtv2LYsSqXoiTIKlhz07j
	 JRUQZgVnW1CuxBAFoGEJ2GT+EMo58M8juR/igsoNlnxa0OskE/+afvbC2xSEidIJnS
	 OKpzWWolwoSmx0is3/zSr/k4sOCgPL/ST3ebV8vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 448/602] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Thu, 30 Jul 2026 16:14:00 +0200
Message-ID: <20260730141445.374423987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

commit 28c9b3c5dc35cc790d11e26ca3fc6e068be63998 upstream.

Call pm_genpd_remove() to unregister from global list prior to releasing
acp_genpd memory, and clear the pointer after free.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd8650d7a91ee8b768e202354672553faa5cc1f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -559,7 +559,9 @@ static int acp_hw_fini(void *handle)
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return 0;


