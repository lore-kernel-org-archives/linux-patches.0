Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430C429802;
	Thu, 30 Jul 2026 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422432; cv=none; b=BYvdS3Rc7bBLGDLf6ui/AXrGVJmpVqwqhHMjOgu9Ywd6/MCNXlgqAfpfJJAZ3MmNutPXRkRA9PD9W85epnFhhiYI5FoeIf6PJtz0gKDOw22rE4KAi8Zu3lTUZL2Oz3gHlyfgFNN+YU+BQLT/SluxUnX9vYynrth/LdXOWPuz1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422432; c=relaxed/simple;
	bh=nfqkLGCM/HgeEsCrcCBv+OBhUU+h0R97adct+TO9Arg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIyfBSx/ghSO8+ieyMTuYr1/4CZZot7GTylJV+0TLqAp9Gk6Ftj0ZacND2O6eaWegFIoRHoLJZsaO6su+16o53em89fSxxtsAgkVJbVTDfSf/jPiIGMqRme3N00upey29T6tp3wQRYecr5u68raM2ffmTWBQnjeRWnbTWvUXmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzeSmsDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzeSmsDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF22F1F000E9;
	Thu, 30 Jul 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422431;
	bh=ExXeztRwynaRXPbb/kfBfYYRy7zsOEw8PPsUCPBDv6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzeSmsDPLTC/9gxeE/gdvF9vNHrtCXT52eHnwgd3QnZsPcqY7FC3ng5tfp9Yo8mnK
	 So0xrT3hyNZm3QBtljyJwSRIH2E7NTQqYx9UTs9giYNSsNsHIlJoSbRFBzGSxqkJPz
	 Za3nLbBWj8eWLHBMkQTnyq17NTbx/u/L6AvxwHGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 436/744] drm/amd/amdgpu: disable ASPM on VI if pcie dpm is disabled
Date: Thu, 30 Jul 2026 16:11:49 +0200
Message-ID: <20260730141453.564795906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

commit 18a7826aea6fd09f2d371c02cec70c7234fc4879 upstream.

Disable ASPM on VI if PCIE dpm is disabled.

Fixes: bb00bf17328d ("drm/amd/amdgpu: decouple ASPM with pcie dpm")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5370
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 873a8d6b3c0a386408c891e4ff1c684fa11783e1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1328,7 +1328,8 @@ static bool amdgpu_device_aspm_support_q
 	 * It's unclear if this is a platform-specific or GPU-specific issue.
 	 * Disable ASPM on SI for the time being.
 	 */
-	if (adev->family == AMDGPU_FAMILY_SI)
+	if (adev->family == AMDGPU_FAMILY_SI ||
+		(!(adev->pm.pp_feature & PP_PCIE_DPM_MASK) && adev->family == AMDGPU_FAMILY_VI))
 		return true;
 
 #if IS_ENABLED(CONFIG_X86)


