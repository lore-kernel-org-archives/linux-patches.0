Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B37E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2255C433D6;
	Wed,  2 Nov 2022 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356899;
	bh=hHE9ViEJrYi4GNRrsd1OblH35/W9e2fE7CytOPY/KG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ak6C0NtmE/W+Mw9+dB6RMQgh73yG96eFC4mt+MJ3TnM2RwVQ/U4sOSNokUvXFYJNM
	 rx40txPtqLlMg7SsTUkLYR8Q/5hqcBIN+K5+oe1dk8KjHHrGi2hcQwlD1FaYEV6ElV
	 GJ6iRSaq95+Z9XaMLIfYpX8UQmpST2Y34jSSHqXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 061/240] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Date: Wed,  2 Nov 2022 03:30:36 +0100
Message-Id: <20221102022112.778610824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

commit d2c4c1569a7d7d5c8f75963bf2d62d7aeac30e2a upstream.

MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.

Since they are non-existing registers, read access will cause a
'Completer Abort' and gets reported when AER is enabled with the below patch.
Tagging with the patch so that this is backported along with it.

v2: squash in uninitialized warning fix (Nathan Chancellor)

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -32,8 +32,6 @@
 #include "gc/gc_10_1_0_offset.h"
 #include "soc15_common.h"
 
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
 
@@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_gra
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
 		def1 = data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
@@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_gra
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		if (def != data)
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
 		if (def1 != data1)
 			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
 		break;
@@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_gra
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
-		break;
+		/* There is no ATCL2 in MMHUB for 2.1.x */
+		return;
 	default:
 		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
 		break;
@@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_gra
 	else
 		data &= ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
 
-	if (def != data) {
-		switch (adev->ip_versions[MMHUB_HWIP][0]) {
-		case IP_VERSION(2, 1, 0):
-		case IP_VERSION(2, 1, 1):
-		case IP_VERSION(2, 1, 2):
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
-			break;
-		default:
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
-			break;
-		}
-	}
+	if (def != data)
+		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
 }
 
 static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
@@ -695,7 +680,10 @@ static void mmhub_v2_0_get_clockgating(s
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
+		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
+		 * based on DAGB
+		 */
+		data = MM_ATC_L2_MISC_CG__ENABLE_MASK;
 		data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:


