Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B802FB08C;
	Wed, 25 Feb 2026 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002752; cv=none; b=UXsZLVEPhVyZlb/tHt1aMs20dpsnilCbNAm72J4TEJIiZdmxXMzl6zxgtaAdkyWyPGXLXEogR0Y+3kbH9ucQGY6KL3e5NIU/uOTOq3NUIwrBx/r1ZYvp7Ig6voBCGGrVAvlhi78GuLXF3WLPb1+I0+vZRd5kpmoelafYhG6urq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002752; c=relaxed/simple;
	bh=PwnsdSg5dsA1CQ/82WRkgLeG0hSnnkxyXsYlUvRX8e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQNA59m1AkAlGjoqa04caMlm96F0gXGOgtt95VBAe+SydXIR0fkLYPWC9sb7iVoW8gunu1cuqMVxn0w8UpzQWWScA78bEDICVGZT7rzLG4icW4ILLNrpoNahCLaDQ0qmAPd0p/2IVCsvsHxnWgYn227sCnLDgOHMd3KrHTxW4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyTVBlgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyTVBlgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C149C4AF0B;
	Wed, 25 Feb 2026 06:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002752;
	bh=PwnsdSg5dsA1CQ/82WRkgLeG0hSnnkxyXsYlUvRX8e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyTVBlgz+MoDBN1usJr/FX9BvoLcZbsfYa0N8RPU9FsJQUr4fgOZDUUjM9W/FpSxn
	 zmELctxWG6OkYcKYWXp/VXaM07O9cj3encoVygNtjBIpudSyFNBBzqIOCFzq5xbSji
	 Ny11Uw4IN/4rrEO4kXIetN9MBRhvnBNqUTjhdYjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 578/641] drm/amdgpu: Fix memory leak in amdgpu_acpi_enumerate_xcc()
Date: Tue, 24 Feb 2026 17:25:04 -0800
Message-ID: <20260225012402.519718599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c9be63d565789b56ca7b0197e2cb78a3671f95a8 ]

In amdgpu_acpi_enumerate_xcc(), if amdgpu_acpi_dev_init() returns -ENOMEM,
the function returns directly without releasing the allocated xcc_info,
resulting in a memory leak.

Fix this by ensuring that xcc_info is properly freed in the error paths.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 6c62e27b98002..67db986eda3f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1136,8 +1136,10 @@ static int amdgpu_acpi_enumerate_xcc(void)
 		if (!dev_info)
 			ret = amdgpu_acpi_dev_init(&dev_info, xcc_info, sbdf);
 
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM) {
+			kfree(xcc_info);
 			return ret;
+		}
 
 		if (!dev_info) {
 			kfree(xcc_info);
-- 
2.51.0



