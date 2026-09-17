Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680F4FDA7C;
	Thu, 17 Sep 2026 17:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667296; cv=none; b=k5KywAIBnPZx+YW8ix/VEYyBhk20zcb/Zp37rkhYDF/dva9Zxln9q4AcCMb0LzY91NqbIKgiG4/E6gGyCVpYxlC2XUP0Y+TDfCxxR2W9AVXA6kosHCPzOxYUGtnoT2/FhsW+xhJRNjFY4GuFI6WG7qUpOb2FkHhe7UXZw4E+4eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667296; c=relaxed/simple;
	bh=FkXd6iFZuSnsKTw69BzErkrfPsWRAGTBnrZlnyjeKOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJpiFMOcqG+N8doRtroh0CnnY//CP1tlUZ9C37eu6IdAiPlopUfipJJXUZ3UEINtWtVEaaVH3UeP/OYCwI2vajjhsKi+pfslMnJgA6tD8KQkmXNMtEcQ9ipUYLmPOEceeFttjsAWw7hAnVuMHnln6sMFWH9crXvtiqRqYSvgbt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpuPsNPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpuPsNPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D91F000FF;
	Thu, 17 Sep 2026 17:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667295;
	bh=sIwlGrXhtyQajnoNabuO6mp+PZjhFO16tGNhTpGcOmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpuPsNPEJbsW8hJiUOZKhtn2abZbg5/G4stSxw5r34msHmo2zcvwjy9xICtu82CjA
	 yuL1IvYXjqh59B3homVe8jksXGyuNjKzelnvF6mN+WCap1XE261kgp21uKhGnX7Dnu
	 cbA0fHuu3A46RKlavKQ/pkt2KdCSuYkDnL8GoYZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0043/1102] drm/amdgpu: Prefer ROM BAR for default VGA device
Date: Thu, 17 Sep 2026 15:59:46 +0100
Message-ID: <20260917151540.528173973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 94e05c6b39d44..e665430898244 100644
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
@@ -476,7 +477,8 @@ static bool amdgpu_prefer_rom_resource(struct amdgpu_device *adev)
 {
 	struct resource *res = &adev->pdev->resource[PCI_ROM_RESOURCE];
 
-	return (res->flags & IORESOURCE_ROM_SHADOW);
+	return (res->flags & IORESOURCE_ROM_SHADOW) ||
+	       adev->pdev == vga_default_device();
 }
 
 static bool amdgpu_get_bios_dgpu(struct amdgpu_device *adev)
-- 
2.53.0



