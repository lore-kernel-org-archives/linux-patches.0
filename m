Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2B963BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38A3C433D2;
	Mon, 20 Feb 2023 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901528;
	bh=azmU+k7UJ/E/AQqp94kZ+3zJYdz7y8e/T458A9QYbOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2U2y+z4+NyWOGp/RogJe7PYOIIFweVdGLpZ1GGQMX3q82/49olLZnciqZNAEWWqbb
	 p7vNGCIXobKCkpeQ55Y/Spq6IPL13KLDJwwZ7VfCK5BiWXQFNOcPGJp/u2Bsc+7Ud4
	 kfpzSu0ELLYJ6gLSIdwiGXORCd4ntNDIHMJpTScE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jfalempe@redhat.com,
	Jack Xiao <Jack.Xiao@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Evan Quan <evan.quan@amd.com>
Subject: [PATCH 6.1 051/118] drm/amd/amdgpu: fix warning during suspend
Date: Mon, 20 Feb 2023 14:36:07 +0100
Message-Id: <20230220133602.499529823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Xiao <Jack.Xiao@amd.com>

commit 8f32378986218812083b127da5ba42d48297d7c4 upstream.

Freeing memory was warned during suspend.
Move the self test out of suspend.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2151825
Cc: jfalempe@redhat.com
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-and-tested-by: Evan Quan <evan.quan@amd.com>
Tested-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +++
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4248,6 +4248,9 @@ int amdgpu_device_resume(struct drm_devi
 #endif
 	adev->in_suspend = false;
 
+	if (adev->enable_mes)
+		amdgpu_mes_self_test(adev);
+
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D0))
 		DRM_WARN("smart shift update failed\n");
 
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1339,7 +1339,7 @@ static int mes_v11_0_late_init(void *han
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
-	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix && !adev->in_suspend &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 


