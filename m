Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241B015B0F0;
	Mon, 29 Jan 2024 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548204; cv=none; b=b3ZFmA8wWqBtTNJaoGT6Z572NIYiaQ4YUJs7m7pJG6GeAXXQRsaFDsUxxGoaem25lrRnx/FLNVO9zJqvFWj968dmGm1BWK0hm6I+tzPA67Cmq6FhBDHm8ji/EzCIxq+/SMyMMB9pS4Q9P+NzQOtAFtYrILJCp4brAFhs5dQkdLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548204; c=relaxed/simple;
	bh=3qmFEvpa0vptYomk7Mgf114p/bfPV3zU+Pb3+0l7Tqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk3mQwH2tHmVH1fcw0y1H7mxNAd1BLqNQqtAzoV5gkX/FNkscTpIlDDolKK+9jXc/JVw0U43dErnd/Ns6cZfGlqVBspWJ9cNoOtk061TUxZBEbIkAOoYARvJacKNMDPhMhRe13VI+oxOv2TZ5hI9j+q9xk8GGQGXg+mVN9yiB1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJK9XsgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJK9XsgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB26C43390;
	Mon, 29 Jan 2024 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548204;
	bh=3qmFEvpa0vptYomk7Mgf114p/bfPV3zU+Pb3+0l7Tqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJK9XsgGyxwNZdE6KqukKpUBQ+sQOtO9KpRwlWbelDZiQlFW+eSugf5qVQZiJ7kJJ
	 3NugZm2rhXOVfgpJNoYGrrbUb0fpyO/B95E6jSW/wPFiZNSspEfT71JnVWlE9T3kSG
	 yGQwsQ+CSFvyOw3LJp0ryes5w05kLniHAQIMX5E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 242/346] drm/amdgpu: Fix the null pointer when load rlc firmware
Date: Mon, 29 Jan 2024 09:04:33 -0800
Message-ID: <20240129170023.525824622@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

commit bc03c02cc1991a066b23e69bbcc0f66e8f1f7453 upstream.

If the RLC firmware is invalid because of wrong header size,
the pointer to the rlc firmware is released in function
amdgpu_ucode_request. There will be a null pointer error
in subsequent use. So skip validation to fix it.

Fixes: 3da9b71563cb ("drm/amd: Use `amdgpu_ucode_*` helpers for GFX10")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3996,16 +3996,13 @@ static int gfx_v10_0_init_microcode(stru
 
 	if (!amdgpu_sriov_vf(adev)) {
 		snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_rlc.bin", ucode_prefix);
-		err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw, fw_name);
-		/* don't check this.  There are apparently firmwares in the wild with
-		 * incorrect size in the header
-		 */
-		if (err == -ENODEV)
-			goto out;
+		err = request_firmware(&adev->gfx.rlc_fw, fw_name, adev->dev);
 		if (err)
-			dev_dbg(adev->dev,
-				"gfx10: amdgpu_ucode_request() failed \"%s\"\n",
-				fw_name);
+			goto out;
+
+		/* don't validate this firmware. There are apparently firmwares
+		 * in the wild with incorrect size in the header
+		 */
 		rlc_hdr = (const struct rlc_firmware_header_v2_0 *)adev->gfx.rlc_fw->data;
 		version_major = le16_to_cpu(rlc_hdr->header.header_version_major);
 		version_minor = le16_to_cpu(rlc_hdr->header.header_version_minor);


