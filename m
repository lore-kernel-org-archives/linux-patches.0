Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74C0BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D56C433D2;
	Tue,  7 Mar 2023 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214610;
	bh=UfHIndz2cS4jkv2lRnJmh+Q7YlgidVpoB6juTD78jg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8Cxe7FzVdvLTMCF7XV3rk7ArRS4+CnZYpGo4VM9LgoZIExyqHGMLsXxZpHN8z0BY
	 4rRdJ+6QygOiL7NGTdexiYv5UbJ99LIsnkeAWSdHh6ryV3yksek1ZsnLRS0bc71RXC
	 fKsAlZSW2P+NJWj9mTen2MTxqcvM2e9f1IBiEOjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 878/885] drm/amd: Fix initialization for nbio 7.5.1
Date: Tue,  7 Mar 2023 18:03:32 +0100
Message-Id: <20230307170039.930248221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit 65a24000808f70ac69bd2a96381fa0c7341f20c0 upstream.

A mistake has been made in the BIOS for some ASICs with NBIO 7.5.1
where some NBIO registers aren't properly setup.

Ensure that they're set during initialization.

Tested-by: Richard Gong <richard.gong@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
index 31776b12e4c4..4b0d563c6522 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
@@ -382,6 +382,11 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 		if (def != data)
 			WREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regBIF1_PCIE_MST_CTRL_3), data);
 		break;
+	case IP_VERSION(7, 5, 1):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2);
+		data &= ~RCC_DEV2_EPF0_STRAP2__STRAP_NO_SOFT_RESET_DEV2_F0_MASK;
+		WREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2, data);
+		fallthrough;
 	default:
 		def = data = RREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regPCIE_CONFIG_CNTL));
 		data = REG_SET_FIELD(data, PCIE_CONFIG_CNTL,
-- 
2.39.2



