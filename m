Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994C32F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6625C433A0;
	Wed, 12 Apr 2023 08:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289179;
	bh=vCjQLRwvG9Fjkgjh9V2g/YplN8RULrAjuuFEEVOYUm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Om/utSRSHoCcmnG7bamw9oaHa1tREBM0RZRZmL6XKYIP5vHAH+dOjxproYi8dLwaz
	 yw93aaY6181R9nl43/pAR3eQQR6NveMCUMT3VAr9J6JZjulf+v/zzE+58kn01Qj31d
	 o7FqgjrOzj9DhvzC0NUesns7v21PBNG0+YN7L/8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 145/164] drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 reset
Date: Wed, 12 Apr 2023 10:34:27 +0200
Message-Id: <20230412082842.771554924@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit e11c775030c5585370fda43035204bb5fa23b139 upstream.

The psp suspend & resume should be skipped to avoid destroy
the TMR and reload FWs again for IMU enabled APU ASICs.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3040,6 +3040,18 @@ static int amdgpu_device_ip_suspend_phas
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
 			continue;
 
+		/* Once swPSP provides the IMU, RLC FW binaries to TOS during cold-boot.
+		 * These are in TMR, hence are expected to be reused by PSP-TOS to reload
+		 * from this location and RLC Autoload automatically also gets loaded
+		 * from here based on PMFW -> PSP message during re-init sequence.
+		 * Therefore, the psp suspend & resume should be skipped to avoid destroy
+		 * the TMR and reload FWs again for IMU enabled APU ASICs.
+		 */
+		if (amdgpu_in_reset(adev) &&
+		    (adev->flags & AMD_IS_APU) && adev->gfx.imu.funcs &&
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP)
+			continue;
+
 		/* XXX handle errors */
 		r = adev->ip_blocks[i].version->funcs->suspend(adev);
 		/* XXX handle errors */


