Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5015B970;
	Mon, 29 Jan 2024 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548609; cv=none; b=E/gSlgoO1t2Jz3C2qn9cffwhlE7/yJzKh09eqDHfZCuLXw3LPQkDyeBYat/0ZxzKt59jRYnoSD4gzUJokD9J7mBtjGZMUdXyHJifNChPJNRK3uQpQO+FRCKXoGCBXdPM5+lWVpQqD8ll44SmuHvENDJoKRGoO/kS1y69do07boU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548609; c=relaxed/simple;
	bh=/LJhbeep0+ODPDl2d3t+m8GOLjUNiCvRaqd18JWskjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qylh325lX06GW7aEc55xDAO5EsoD532OogzXepptj/r2YWi0b3njovK132N+xjJqnd0dZ9h1R8T+9Br68SW8ISzFbaNZKejga0q+h9wMP/iVwwhvxmpf+8YEdQqw3yqNJDHxm32gwgteQQykkstEd+n3yjJE9OyCau+oOi2QpOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS+qW9li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS+qW9li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D908BC433F1;
	Mon, 29 Jan 2024 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548608;
	bh=/LJhbeep0+ODPDl2d3t+m8GOLjUNiCvRaqd18JWskjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS+qW9lirAzXtVH2a0LtFifJ6pw0IsFF/Rx8qBnMlMx+USzGm9Jon7M2B26+LDf4D
	 s4+Ws39SDQQR162t/vtiUtFJZVswVI7qFs3Et51wrs+iSe5kMCvRe824GBTZ+/i1r5
	 FORnATgafTWfhqfcGdlav/xTu6B8DVqvvY++kZiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 250/331] drm/amdgpu: Fix the null pointer when load rlc firmware
Date: Mon, 29 Jan 2024 09:05:14 -0800
Message-ID: <20240129170022.199564740@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3989,16 +3989,13 @@ static int gfx_v10_0_init_microcode(stru
 
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


