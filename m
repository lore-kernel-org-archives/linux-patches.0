Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92927FD4C;
	Tue, 27 May 2025 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366673; cv=none; b=IN5++T9waNkYNmsX/giIU2qGULtxQmy06MC4+k8qkdJWoxGveXFuZNztf/fUmS+7qvPcIFCAidL6BUGMGxzXTV5x/7GLUHElcOcRn8Hiyg4TvIBzLidIry6uT5lhSlr0JhkJ9curLcLggxXy9fpaeeZjBDregkRiW449rYFQwiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366673; c=relaxed/simple;
	bh=hYcCvCG/nkc69KRWWr6k6rgwividhSGisBWR8KzkZF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbpMbCFU7IBMJNwqES61/WMMf3bcmdyPx+yNTuL9s5vZL+xI0d62itpSnAdfSbcyaaiY3f/uTRUVJ62LfDxrHoDm3A1gPbjiwyb/SuXVS4lCg7YvZMxyh2Y21QmDVKHMV0IougOBsbocrGuNb5wJm8h568JDXMOKMd1vQfJtyAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fR44xyk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fR44xyk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E28BC4CEE9;
	Tue, 27 May 2025 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366671;
	bh=hYcCvCG/nkc69KRWWr6k6rgwividhSGisBWR8KzkZF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR44xyk2EEJAt1RjcAXVOL5vutGwiqqFR1uizQVEw2aMDJUeTDn5zaUQwsOI1D/DV
	 Kwp0Y22Ug4Vf0uWl+ceBoLe4MecYfXaINs6CWCoqMpDGt4jjRMQuzkAp/4P5voUd00
	 sfDGf7PyeZ76hAjGpOvRPsGEUPUZcOt2CenpVJNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 143/783] drm/amdgpu: dont free conflicting apertures for non-display devices
Date: Tue, 27 May 2025 18:19:00 +0200
Message-ID: <20250527162518.979417977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9deacd6c55f1b31e5ab20db79df2e14ac480203c ]

PCI_CLASS_ACCELERATOR_PROCESSING devices won't ever be
the sysfb, so there is no need to free conflicting
apertures.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ea50f82b547d9..28190b0ac5fca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4370,10 +4370,17 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	if (r)
 		return r;
 
-	/* Get rid of things like offb */
-	r = aperture_remove_conflicting_pci_devices(adev->pdev, amdgpu_kms_driver.name);
-	if (r)
-		return r;
+	/*
+	 * No need to remove conflicting FBs for non-display class devices.
+	 * This prevents the sysfb from being freed accidently.
+	 */
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA ||
+	    (pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER) {
+		/* Get rid of things like offb */
+		r = aperture_remove_conflicting_pci_devices(adev->pdev, amdgpu_kms_driver.name);
+		if (r)
+			return r;
+	}
 
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
-- 
2.39.5



