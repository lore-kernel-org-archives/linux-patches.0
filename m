Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEA44E77F2;
	Thu, 17 Sep 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661046; cv=none; b=Rtp9N7kz4i/5L81bPaUQDgpuInN1Jua9Ax8bcM+x22D/UpsGVdZxEguHC/do+e4uC9VEUAwik6vchiq/NyL/sOaPFarvA3szGPHjLe3Wbs8fxWrxgMAdt4NCPGc0TIy0MaDqq0WzSbE4rvy9l8XLlp3NY1lGWZD6Xx1V/n/VARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661046; c=relaxed/simple;
	bh=1+DI2TPoJWzOcjlhnuTGkfswoJoL/Kc23zmcDpmNXHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyF+PuFjBm23fOOvi5/4D2pypbsFq/YHNy7J+STdyp8krcpV51WMfGpo1WsFwHG8z27w8csDYb4POF4YPhCgJuLXRnPn7U40qIj+anFsAjTYzSgld3Q3Elo9Qfmo69fOInUEe1+8BZVzuzoS6LkIvqDxcJsgqM276LpAsglvQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfKG4Kgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfKG4Kgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9742B1F000FF;
	Thu, 17 Sep 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661045;
	bh=1F2BJVmbYX0vAVOqxBvo0S1a7iVHJFPhooBd5JtwxtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfKG4Kgd91A96dntq5Vt26MLh6+mC6PJVTOMKCDqgHBmqiLWevqaq6ckKHQMgRRpk
	 D8Q9F/JyiT0KYF4W6ldNPSzMiawyy9NdNs/W/aIC8ldvcFXHbuXyZuZQYFYgysXI+d
	 /xMEyByzLjDdPj+FfWw/lm6dp3LZWOSCa7lK8o00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0063/1250] drm/amdgpu: Prefer ROM BAR for default VGA device
Date: Thu, 17 Sep 2026 15:57:38 +0100
Message-ID: <20260917151553.650343325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 9e32d17592950478baffaecdbda8e2e60935fd3d ]

Fetching from platform ROM doesn't work with hybrid ROM images. For
default VGA devices also prefer ROM BAR.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 4e60753e16e90..dec312b0f3b0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/vgaarb.h>
 /*
  * BIOS.
  */
@@ -491,7 +492,8 @@ static bool amdgpu_prefer_rom_resource(struct amdgpu_device *adev)
 {
 	struct resource *res = &adev->pdev->resource[PCI_ROM_RESOURCE];
 
-	return (res->flags & IORESOURCE_ROM_SHADOW);
+	return (res->flags & IORESOURCE_ROM_SHADOW) ||
+	       adev->pdev == vga_default_device();
 }
 
 static bool amdgpu_get_bios_dgpu(struct amdgpu_device *adev)
-- 
2.53.0



