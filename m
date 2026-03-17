Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5898729D26C;
	Tue, 17 Mar 2026 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766883; cv=none; b=WpkpEJmAPtTK8lasSdwXhNPWo08l5oLnS0Ie8Vx9t1qTupjwyF+OCfa7tbj2/L9XC0/tYZxvhY7l7VXK290Hsiraw3eL5Jbw0cp6YqWi5dEJuBR8iAP5b30RH6IdeXH5i25R5x7zd8R3Hp46QfQ0gOU3rr/1DYuscSKwTnQrUlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766883; c=relaxed/simple;
	bh=soLDvchqM3qNU/guem7YlJ63HsTz238G/oso9bYCKtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsomu85CvbO7rX/DtchI9IEyhEO0MNeAq9Cc3Yu/5WpzSXvac00FAQEe9LjMgL91JZFHKFfyhb+/2ztXC2cLVvk00GVkz478tYoSP0B3RRaZmbyZiKXMddtBaSqtePjV9K4XmkVRlEiyHLSNEExb9Sd5tIMVbfTIEbOs/YNeBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMCUeKP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMCUeKP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C7EC4CEF7;
	Tue, 17 Mar 2026 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766883;
	bh=soLDvchqM3qNU/guem7YlJ63HsTz238G/oso9bYCKtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMCUeKP5nmVPxX1JwzqnWTy/W+frItFR45pU0vRnjFynhMbLGyqYVHHzRduGEVYCL
	 NtfevKN0KJsTPklmEKV6MfFsoinAheKZ9dw+cEW1fK3H5W38z6R4s+bYhqFpqEyWL1
	 emni/Jg79rUVwtjvub7LJBFXsnlZdROAXs+J0xpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.19 309/378] drm/amd: Fix a few more NULL pointer dereference in device cleanup
Date: Tue, 17 Mar 2026 17:34:26 +0100
Message-ID: <20260317163018.368163440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 72ecb1dae72775fa9fea0159d8445d620a0a2295 upstream.

I found a few more paths that cleanup fails due to a NULL version pointer
on unsupported hardware.

Add NULL checks as applicable.

Fixes: 39fc2bc4da00 ("drm/amdgpu: Protect GPU register accesses in powergated state in some paths")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5a05f8414fc10f307eb965f303580c7778f8dd2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3654,6 +3654,8 @@ static int amdgpu_device_ip_fini_early(s
 	int i, r;
 
 	for (i = 0; i < adev->num_ip_blocks; i++) {
+		if (!adev->ip_blocks[i].version)
+			continue;
 		if (!adev->ip_blocks[i].version->funcs->early_fini)
 			continue;
 
@@ -3730,6 +3732,8 @@ static int amdgpu_device_ip_fini(struct
 		if (!adev->ip_blocks[i].status.sw)
 			continue;
 
+		if (!adev->ip_blocks[i].version)
+			continue;
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC) {
 			amdgpu_ucode_free_bo(adev);
 			amdgpu_free_static_csa(&adev->virt.csa_obj);
@@ -3756,6 +3760,8 @@ static int amdgpu_device_ip_fini(struct
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.late_initialized)
 			continue;
+		if (!adev->ip_blocks[i].version)
+			continue;
 		if (adev->ip_blocks[i].version->funcs->late_fini)
 			adev->ip_blocks[i].version->funcs->late_fini(&adev->ip_blocks[i]);
 		adev->ip_blocks[i].status.late_initialized = false;


