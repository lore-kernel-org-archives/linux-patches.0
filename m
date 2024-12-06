Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE1146A87;
	Fri,  6 Dec 2024 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496394; cv=none; b=FuIgd+1DZ/PmXnxhmJEkg7FPZohG0rOgoK4dpIOy7xsUx2J6AM/3FEOuob1OWHb4VZoAZLZ/UP8yy2BJPklYXYDxp3QWILvF7yxTHh15TTX52WPyGs5qRHF4i00lkMepm6p4wTvtzMnmwJkxtnNIDpPVxFb1er1m2unZYWTI5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496394; c=relaxed/simple;
	bh=uPvBau7xs9YX2O7ydekYW8QFTA549vxj7OduHYMmvvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brSeVwwTrTaJjn5pb6AQU+Xnh8qiQqnPxFV9W0IjejnnJF3E4pSdpjRjXf3ZkbLLg+oJQvkyWSP6QqxYjBanv/p8BoX21a0cmH/5LiL2w3n4x5LPBc5QOuZup2Yq5OAQAO88gBoGL8J7Nx5zrYaVwUX+i1bBrxiquFR+2CmXsLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEsDhveu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEsDhveu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7590CC4CED1;
	Fri,  6 Dec 2024 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496393;
	bh=uPvBau7xs9YX2O7ydekYW8QFTA549vxj7OduHYMmvvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEsDhveuNqPK5gEfu6ssejPWypPzXRcarqLwX4/uUyY7Bti/RJzkNllgYp620WVl8
	 BI2BxZhb7vQf/UzHw+7R9YuvgbotnBdnUNC6TRsBjrDIuO8x/+xsph6HN7t1vo8OeP
	 M9RTu06G51b+Vd+vI0wAM699WZFBRnYT9cl0JjeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 139/146] drm/amd: Fix initialization mistake for NBIO 7.11 devices
Date: Fri,  6 Dec 2024 15:37:50 +0100
Message-ID: <20241206143533.005940142@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 349af06a3abd0bb3787ee2daf3ac508412fe8dcc upstream.

There is a strapping issue on NBIO 7.11.x that can lead to spurious PME
events while in the D0 state.

Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20241118174611.10700-2-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
@@ -275,6 +275,15 @@ static void nbio_v7_11_init_registers(st
 	if (def != data)
 		WREG32_SOC15(NBIO, 0, regBIF_BIF256_CI256_RC3X4_USB4_PCIE_MST_CTRL_3, data);
 
+	switch (adev->ip_versions[NBIO_HWIP][0]) {
+	case IP_VERSION(7, 11, 0):
+	case IP_VERSION(7, 11, 1):
+	case IP_VERSION(7, 11, 2):
+	case IP_VERSION(7, 11, 3):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4) & ~BIT(23);
+		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF5_STRAP4, data);
+		break;
+	}
 }
 
 static void nbio_v7_11_update_medium_grain_clock_gating(struct amdgpu_device *adev,


