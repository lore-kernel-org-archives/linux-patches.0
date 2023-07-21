Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342F20F9D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E350C433C8;
	Fri, 21 Jul 2023 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967178;
	bh=BixtcL6TFBoy08m+p0ROADkjm3qjQJUK65MIl1WjP+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZncMknmjFN6Ogx16PLeVM/lORptn8uF3sh+6O1lnie29JBTmfHLSIJY3dE4nRgCOv
	 ldZpNpAgz59a7inIuAvlpHE2oHvUH6MPzKU1X8K6cT1Nopv7QzCigUYclZ3u2oH3IL
	 jO54Yn14YCY3yqnqmkF1X4Mday/zihO/RMxGm3jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 071/223] drm/amd/pm: revise the ASPM settings for thunderbolt attached scenario
Date: Fri, 21 Jul 2023 18:05:24 +0200
Message-ID: <20230721160523.891940720@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit fd21987274463a439c074b8f3c93d3b132e4c031 upstream.

Also, correct the comment for NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT
as 0x0000000E stands for 400ms instead of 4ms.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -346,7 +346,7 @@ static void nbio_v2_3_init_registers(str
 
 #define NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT		0x00000000 // off by default, no gains over L1
 #define NAVI10_PCIE__LC_L1_INACTIVITY_DEFAULT		0x00000009 // 1=1us, 9=1ms
-#define NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT	0x0000000E // 4ms
+#define NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT	0x0000000E // 400ms
 
 static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
 				  bool enable)
@@ -479,9 +479,12 @@ static void nbio_v2_3_program_aspm(struc
 		WREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP5, data);
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
-	data &= ~PCIE_LC_CNTL__LC_L0S_INACTIVITY_MASK;
-	data |= 0x9 << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
-	data |= 0x1 << PCIE_LC_CNTL__LC_PMI_TO_L1_DIS__SHIFT;
+	data |= NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L0S_INACTIVITY__SHIFT;
+	if (pci_is_thunderbolt_attached(adev->pdev))
+		data |= NAVI10_PCIE__LC_L1_INACTIVITY_TBT_DEFAULT  << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
+	else
+		data |= NAVI10_PCIE__LC_L1_INACTIVITY_DEFAULT << PCIE_LC_CNTL__LC_L1_INACTIVITY__SHIFT;
+	data &= ~PCIE_LC_CNTL__LC_PMI_TO_L1_DIS_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 


