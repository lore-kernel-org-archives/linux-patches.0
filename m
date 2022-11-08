Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793AE15CB3
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C288EC433C1;
	Tue,  8 Nov 2022 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916978;
	bh=P/6WlaGvkIeJbrdeqXJRfGQ73dOtRH/GBt3yzBJBpZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSSy2SMRTnPp4mR8vChXfWAz8JbGDF3UxW7KDVMibvCllLM0sUA2syZIo+KxN2Kc6
	 PLKEK5D7fIvQJ2bSJSmZBkhu94ixbBAFkci09DlN7gJqnlfiRKD7g2bue9sAfpEor+
	 sMs0fb9GNk6w7+hxcv+yJx33J7NXgSV7DrSXh5oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Graham Sider <Graham.Sider@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Subject: [PATCH 6.0 192/197] drm/amdgpu: disable GFXOFF during compute for GFX11
Date: Tue,  8 Nov 2022 14:40:30 +0100
Message-Id: <20221108133403.580396388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Graham Sider <Graham.Sider@amd.com>

commit a3e5ce56f3d260f2ec8e5242c33f57e60ae9eba7 upstream.

Temporary workaround to fix issues observed in some compute applications
when GFXOFF is enabled on GFX11.

Signed-off-by: Graham Sider <Graham.Sider@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -703,6 +703,13 @@ err:
 
 void amdgpu_amdkfd_set_compute_idle(struct amdgpu_device *adev, bool idle)
 {
+	/* Temporary workaround to fix issues observed in some
+	 * compute applications when GFXOFF is enabled on GFX11.
+	 */
+	if (IP_VERSION_MAJ(adev->ip_versions[GC_HWIP][0]) == 11) {
+		pr_debug("GFXOFF is %s\n", idle ? "enabled" : "disabled");
+		amdgpu_gfx_off_ctrl(adev, idle);
+	}
 	amdgpu_dpm_switch_power_profile(adev,
 					PP_SMC_POWER_PROFILE_COMPUTE,
 					!idle);


