Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF6334723;
	Tue, 26 Aug 2025 11:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207719; cv=none; b=UXtw9ZrK8MtXBFl+Kd0Bqh5LZoQ1DLchPooocAQi6U7C/aBMkeFZIw5yo3d/jtRNQSi2VlLIw41XzWMzKLK+7X+JoeEEb9/kr2RyNA5SyZBjnTKvHRzN3gwR4gvg/28xnkWtkgRbJJWs+Rtj8ia17VGLMxyzO/OMxyMwP4kNJ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207719; c=relaxed/simple;
	bh=kceQT1zJyEdIEDn93f/lm+j9DhLUaCUauU7+NFgBCOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPc/uq5uH6A6rHayDgF7D9QEVriEtat2tdlk1271YpmEdWEP0LzFiuAV87RqomljW2Shlt/JzNn2jPN4hAVvw1NMs01PjGgR5ExuSKrRmx/OFywimZyf4GLMOfOv/8BJg8yHvatwI6fp6OEW0Pl63gkIFZJIhXyMnGLpsrTW9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bVZ+3AN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bVZ+3AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9A3C4CEF1;
	Tue, 26 Aug 2025 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207719;
	bh=kceQT1zJyEdIEDn93f/lm+j9DhLUaCUauU7+NFgBCOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bVZ+3ANti4qs0xV+pe9R+R3/tNWnsU6em+YkgOlRgDomEyd+QCF5LCN2uebH35QH
	 T0MluOycx79BBUVpe0Pi06lTLk50hwJK+knKgh4yz/5jRMPqD5qif3ug0FDNN1WkKQ
	 yayiVFLrOppD+2ZeXBjDMDGFPntp4merFUcI1OGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 292/457] drm/amd: Restore cached manual clock settings during resume
Date: Tue, 26 Aug 2025 13:09:36 +0200
Message-ID: <20250826110944.599325230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 796ff8a7e01bd18738d3bb4111f9d6f963145d29 ]

If the SCLK limits have been set before S3 they will not
be restored. The limits are however cached in the driver and so
they can be restored by running a commit sequence during resume.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250725031222.3015095-3-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4e9526924d09057a9ba854305e17eded900ced82)
Cc: stable@vger.kernel.org
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -76,6 +76,9 @@ static void smu_power_profile_mode_get(s
 				       enum PP_SMC_POWER_PROFILE profile_mode);
 static void smu_power_profile_mode_put(struct smu_context *smu,
 				       enum PP_SMC_POWER_PROFILE profile_mode);
+static int smu_od_edit_dpm_table(void *handle,
+				 enum PP_OD_DPM_TABLE_COMMAND type,
+				 long *input, uint32_t size);
 
 static int smu_sys_get_pp_feature_mask(void *handle,
 				       char *buf)
@@ -2144,6 +2147,7 @@ static int smu_resume(struct amdgpu_ip_b
 	int ret;
 	struct amdgpu_device *adev = ip_block->adev;
 	struct smu_context *smu = adev->powerplay.pp_handle;
+	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 
 	if (amdgpu_sriov_multi_vf_mode(adev))
 		return 0;
@@ -2181,6 +2185,12 @@ static int smu_resume(struct amdgpu_ip_b
 			return ret;
 	}
 
+	if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL) {
+		ret = smu_od_edit_dpm_table(smu, PP_OD_COMMIT_DPM_TABLE, NULL, 0);
+		if (ret)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


