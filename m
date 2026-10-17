Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F14277026;
	Sat, 17 Oct 2026 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256096; cv=none; b=YuMPqA7I8AA+Tg5gR5SlQBmGUwobH11XmphMEHZA5dT7FctWrWzHx5y0pAcXzbaslSMEh65+taimVoqYz341y1LAD4lqb5VEJKklgJMdd/2ReyuEBTAQYUsXCzvMPJf0qMLCwQ01/A9F3v83ZdWjNLNC/Em94xsuCD5Omhb2Juw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256096; c=relaxed/simple;
	bh=6UjqatVnm7yrpaxwPD+6I3QZ5rhn1YJd4iOcrPLBFj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9CfMqOLrZ+jHkTzfJjsntM93ePmK/8NKHafZIC9IG38E/M8D8qblYpTJ4W2YH4FALs58dbl+uShYsJJqjVdHALb9hTR4PFU+B89eIOCCvvz5WyiZbhovKsDDim5MB42w9YIY23s8ttXMCT6u+VnmC2lQL8GE+zwZLgleTiNOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WP1aHeXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WP1aHeXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A44B1F000C4;
	Sat, 17 Oct 2026 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256095;
	bh=hvljujTSz4YyLxRHw9pYfS2lu9av/jirhhvnJocTljM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WP1aHeXC7kkh70YnhlaQyWubcmZ6s3FALm/y0qfhF+3Wuu9divcW9EG0SSdacRDxm
	 Zaj1xamCxxY5COwXQ3e9mp9qxJUkPjpinc+FNigxyetUuQpOJVk94UYX1aexlmeZdv
	 pptb6vezcvppeSAF+9kZNu5JUmqYZglNEyvTB75E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0124/1674] drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()
Date: Sat, 17 Oct 2026 17:39:56 +0200
Message-ID: <20261017160434.337596886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a997baa61179b450bd55c4810c7ccfed3b753a54 ]

amdgpu_acpi_enumerate_xcc() looks up each XCC ACPI device with
acpi_dev_get_first_match_dev(), which takes a reference to the device.
The reference is dropped with acpi_dev_put() after the XCC info is
initialized, but if the kzalloc_obj() allocation of the XCC info fails
the function returns -ENOMEM without releasing the reference, leaking
the last reference to the ACPI device.

Drop the ACPI device reference on the allocation failure path before
returning.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9211ef48b31ec66999cf55e04d0cbc60cd855fd5)
Cc: stable@vger.kernel.org
[ adapted the hunk to the existing kzalloc() failure block with braces and DRM_ERROR() logging. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 7730e56444934..45cea079d6c82 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1110,6 +1110,7 @@ static int amdgpu_acpi_enumerate_xcc(void)
 				   GFP_KERNEL);
 		if (!xcc_info) {
 			DRM_ERROR("Failed to allocate memory for xcc info\n");
+			acpi_dev_put(acpi_dev);
 			return -ENOMEM;
 		}
 
-- 
2.53.0



