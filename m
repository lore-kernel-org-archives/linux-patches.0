Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC0FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE1EC433EF;
	Mon, 15 May 2023 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170573;
	bh=TifXGaWGBWlm68FOaLPEkkCtywDrgJcuZ+MEP8HwFis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adBr0zBD3mouMAWXVz3p2CCOyFGD40FQQ+gV1mSS54M8VBzYCcZGa7itQ5rw8GZfN
	 tzgzUa6x0tPeJRtLCT5kOAHlriuc3QpUPm5UgT6J91dYUYRNb2RfDFUHZhcqFTY8Xl
	 Lr/pu9hIM5HTPK6NjQYzJlPdIZWzo6QsQ9m6ve1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 173/239] drm/amd/pm: parse pp_handle under appropriate conditions
Date: Mon, 15 May 2023 18:27:16 +0200
Message-Id: <20230515161726.859529769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

commit 58d9b9a14b47c2a3da6effcbb01607ad7edc0275 upstream.

amdgpu_dpm_is_overdrive_supported is a common API across all
asics, so we should cast pp_handle into correct structure
under different power frameworks.

v2: using return directly to simplify code
v3: SI asic does not carry od_enabled member in pp_handle, and update Fixes tag

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2541
Fixes: eb4900aa4c49 ("drm/amdgpu: Fix kernel NULL pointer dereference in dpm functions")
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1414,15 +1414,21 @@ int amdgpu_dpm_get_smu_prv_buf_details(s
 
 int amdgpu_dpm_is_overdrive_supported(struct amdgpu_device *adev)
 {
-	struct pp_hwmgr *hwmgr = adev->powerplay.pp_handle;
-	struct smu_context *smu = adev->powerplay.pp_handle;
+	if (is_support_sw_smu(adev)) {
+		struct smu_context *smu = adev->powerplay.pp_handle;
 
-	if ((is_support_sw_smu(adev) && smu->od_enabled) ||
-	    (is_support_sw_smu(adev) && smu->is_apu) ||
-		(!is_support_sw_smu(adev) && hwmgr->od_enabled))
-		return true;
+		return (smu->od_enabled || smu->is_apu);
+	} else {
+		struct pp_hwmgr *hwmgr;
 
-	return false;
+		/* SI asic does not carry od_enabled */
+		if (adev->family == AMDGPU_FAMILY_SI)
+			return false;
+
+		hwmgr = (struct pp_hwmgr *)adev->powerplay.pp_handle;
+
+		return hwmgr->od_enabled;
+	}
 }
 
 int amdgpu_dpm_set_pp_table(struct amdgpu_device *adev,


