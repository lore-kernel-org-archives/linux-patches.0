Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4433CFD;
	Fri, 24 Nov 2023 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNJmy0T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15430C433C7;
	Fri, 24 Nov 2023 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850286;
	bh=5Tr6kKqok24oE0sp2mGLgiglh1YjCxmc/uqOljNmthg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNJmy0T4+k8saCV89ACqu06pPoPcCMcB0sfXnDeVTgr2zaJwTQWW3jYPQKRMPLhKL
	 Dj9W3Mjobl36aHXTy2ndWjTSdbLgf91lMbOPHG2SXo38LUlUYN0TP7/9ChGJLHRHlm
	 Jq4PF/3i+XH83SyNFHhMOHdxQas7zBsVfjN1ZHL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 520/530] drm/amdgpu: dont use ATRM for external devices
Date: Fri, 24 Nov 2023 17:51:26 +0000
Message-ID: <20231124172044.008288335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 432e664e7c98c243fab4c3c95bd463bea3aeed28 upstream.

The ATRM ACPI method is for fetching the dGPU vbios rom
image on laptops and all-in-one systems.  It should not be
used for external add in cards.  If the dGPU is thunderbolt
connected, don't try ATRM.

v2: pci_is_thunderbolt_attached only works for Intel.  Use
    pdev->external_facing instead.
v3: dev_is_removable() seems to be what we want

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2925
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -29,6 +29,7 @@
 #include "amdgpu.h"
 #include "atom.h"
 
+#include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
@@ -287,6 +288,10 @@ static bool amdgpu_atrm_get_bios(struct
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
+	/* ATRM is for on-platform devices only */
+	if (dev_is_removable(&adev->pdev->dev))
+		return false;
+
 	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev)) != NULL) {
 		dhandle = ACPI_HANDLE(&pdev->dev);
 		if (!dhandle)


