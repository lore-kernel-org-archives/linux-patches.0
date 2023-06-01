Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA5FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920CDC433D2;
	Thu,  1 Jun 2023 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626112;
	bh=cBQUmH0D1KS8ymXupEOV/hGItm+UFsBcZh/fnlYOMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqqKIA5eoNELDtZ6AY8Sh0zKlC3L40uTbqdAyo2vzZQaoawDKAOyYj2qSi2Zs9b9R
	 sOlb8eybClgAqQy/bTiu/YOOSHVDazh20zULMjPzT8eTYebs0zppa0v1tzO4zUHhPC
	 fKJbNqRzkoITRFaO62H/L6IB8AIBMhMrwDm+K0cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Deucher <Alexander.Deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 35/42] drm/amd: Dont allow s0ix on APUs older than Raven
Date: Thu,  1 Jun 2023 14:21:44 +0100
Message-Id: <20230601131940.612437728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
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

commit ca47518663973083c513cd6b2801dcda0bfaaa99 upstream.

APUs before Raven didn't support s0ix.  As we just relieved some
of the safety checks for s0ix to improve power consumption on
APUs that support it but that are missing BIOS support a new
blind spot was introduced that a user could "try" to run s0ix.

Plug this hole so that if users try to run s0ix on anything older
than Raven it will just skip suspend of the GPU.

Fixes: cf488dcd0ab7 ("drm/amd: Allow s0ix without BIOS support")
Suggested-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c  |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1083,6 +1083,9 @@ bool amdgpu_acpi_is_s0ix_active(struct a
 	    (pm_suspend_target_state != PM_SUSPEND_TO_IDLE))
 		return false;
 
+	if (adev->asic_type < CHIP_RAVEN)
+		return false;
+
 	/*
 	 * If ACPI_FADT_LOW_POWER_S0 is not set in the FADT, it is generally
 	 * risky to do any special firmware-related preparations for entering
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2402,8 +2402,10 @@ static int amdgpu_pmops_suspend(struct d
 
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
-	else
+	else if (amdgpu_acpi_is_s3_active(adev))
 		adev->in_s3 = true;
+	if (!adev->in_s0ix && !adev->in_s3)
+		return 0;
 	return amdgpu_device_suspend(drm_dev, true);
 }
 
@@ -2424,6 +2426,9 @@ static int amdgpu_pmops_resume(struct de
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 	int r;
 
+	if (!adev->in_s0ix && !adev->in_s3)
+		return 0;
+
 	/* Avoids registers access if device is physically gone */
 	if (!pci_device_is_present(adev->pdev))
 		adev->no_hw_access = true;


