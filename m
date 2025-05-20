Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701F1922ED;
	Tue, 20 May 2025 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749346; cv=none; b=M+BgzA3uWoc+R0G84izYWQGn+IR5SAuYJIXkyXf1Bc8hlNcLpLm08e9+WHzTwYJ0oVCeL9f13Rb4O/MnCmToVIOX0aVvtJKHpVOSkPczpc182VuOEhzMs3ES1sTC0f0wKPUzolMUcPbbLjh3IQMtmhpCiZLC1tquSDDWZfmcAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749346; c=relaxed/simple;
	bh=e2LMfSL+U4U5c3cVkMl0UWEPXecejg80udRS74ik03U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly7TloImr4ZRY7K4Cnxs2DXYdG7D46K5RIUBdDL49rtQoneH73YtEQozLmNe7ISKuWUOdmQRZ7xtckciTnybsbCOyBRvgj0gyeBV3DBB0vhwFgIJBW9PlX+rRsfiztrKMaFlVGO50AkVxPZehnEgfCDS1RqV1u6hSCV+eEV2AgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiy/3D2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiy/3D2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACBAC4CEE9;
	Tue, 20 May 2025 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749346;
	bh=e2LMfSL+U4U5c3cVkMl0UWEPXecejg80udRS74ik03U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiy/3D2sX1oAuRLVuGjJhuXQkrEpricSXfExgX9SuEZN+Oh055rT0/N8tXODfpNme
	 wlGiTGGybAUSElbvDhx/vzRBE1Kj8tfMSn1fUKPyuZB8ypGEjXAemxNW9v81uRDtvJ
	 SlFXVkk5TkRyQYlFJZQaaK+viXsTKOL/AL0eBrBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/97] drm/amdgpu: Fix the runtime resume failure issue
Date: Tue, 20 May 2025 15:49:40 +0200
Message-ID: <20250520125801.261050730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit bbfaf2aea7164db59739728d62d9cc91d64ff856 ]

Don't set power state flag when system enter runtime suspend,
or it may cause runtime resume failure issue.

Fixes: 3a9626c816db ("drm/amd: Stop evicting resources on APUs in suspend")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Stable-dep-of: d0ce1aaa8531 ("Revert "drm/amd: Stop evicting resources on APUs in suspend"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 70d761f79770d..46916680f044b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1127,6 +1127,9 @@ bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
  */
 void amdgpu_choose_low_power_state(struct amdgpu_device *adev)
 {
+	if (adev->in_runpm)
+		return;
+
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
 	else if (amdgpu_acpi_is_s3_active(adev))
-- 
2.39.5



