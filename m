Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E628A35BDAA;
	Thu, 30 Jul 2026 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422427; cv=none; b=cB23mwsYccs/ZiOsOSKbELLW0Dgr+nXFi74hQFvShTBC4MhVKSHmRnmMuCKc+qsbZAN1QOMwruDNMF4b4Qifv3Zeq9B6oEgl1SlI4eulR8SD0FrKFUak6fTTlm44obqqThabDoqJ2QR1Z9+ul11vWOYKN/a1E895Psa2YFkWtRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422427; c=relaxed/simple;
	bh=ID4Q3NOWM/PZX/UbIbBglg17yHS8YQI4Q81QRo8Jy6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhAFuaTCJFNXRUirwdHlsMnB4uNVq/GJHZmx/41hQJlW3NEQKqgLnDExxrj3SDVherQFCrVcuuu646hE7ohG1Y5qm1j3sM/5fikYRFjG5cAefVkoj+vIJJo4Q+dNd68GGH67i7aSSidsidnns+vjGEom+9Ps0bowV2PKBsV0kTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlkJXuv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlkJXuv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D141F000E9;
	Thu, 30 Jul 2026 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422425;
	bh=X30VkxDEaUYTl2jCJfdTbMaizbEQHv1L47Eqw72BltI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlkJXuv7ht/izlbhATTvKOU0uSutXkEnv3K6PII4tPanGAbS4eqRq7PRhNXOYXVtI
	 Asaz2fCd83LAcfy7qr5U9M5XzuZYUXlKzON1sjoFvI6ZCr9V6w4OsTM3HHSNAihW5D
	 sO3IWCFJK3in+IYuMBo8uCEKRRUKJwJXVU+lx4wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Linke <jakob@linke.cx>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 434/744] drm/amdgpu/soc24: reset dGPU if suspend got aborted
Date: Thu, 30 Jul 2026 16:11:47 +0200
Message-ID: <20260730141453.522271710@linuxfoundation.org>
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

From: Jakob Linke <jakob@linke.cx>

commit aff079bdce65f6d085e4b0091fdf87fffa95b0d9 upstream.

For SOC24 ASICs (RDNA4 / Navi 4x dGPUs) re-enabling PM features fails if an
S3 suspend got aborted, the same issue already handled for SOC21 and SOC15:

  commit df3c7dc5c58b ("drm/amdgpu: Reset dGPU if suspend got aborted")
  commit 38e8ca3e4b6d ("amdgpu/soc15: enable asic reset for dGPU in case of suspend abort")

The aborted resume fails with:

  amdgpu: SMU: No response msg_reg: 6 resp_reg: 0
  amdgpu: Failed to enable requested dpm features!
  amdgpu: resume of IP block <smu> failed -62

Apply the same workaround for soc24: detect the aborted-suspend state at
resume via the sign-of-life register and reset the device before re-init.

This is a workaround till a proper solution is finalized.

Fixes: 98b912c50e44 ("drm/amdgpu: Add soc24 common ip block (v2)")
Signed-off-by: Jakob Linke <jakob@linke.cx>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fed5bdbfe1d4a19a26c70f7fc58017dc88be1c18)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc24.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc24.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc24.c
@@ -515,8 +515,36 @@ static int soc24_common_suspend(struct a
 	return soc24_common_hw_fini(ip_block);
 }
 
+static bool soc24_need_reset_on_resume(struct amdgpu_device *adev)
+{
+	u32 sol_reg1, sol_reg2;
+
+	/* Will reset for the following suspend abort cases.
+	 * 1) Only reset dGPU side.
+	 * 2) S3 suspend got aborted and TOS is active.
+	 *    As for dGPU suspend abort cases the SOL value
+	 *    will be kept as zero at this resume point.
+	 */
+	if (!(adev->flags & AMD_IS_APU) && adev->in_s3) {
+		sol_reg1 = RREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_81);
+		msleep(100);
+		sol_reg2 = RREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_81);
+
+		return (sol_reg1 != sol_reg2);
+	}
+
+	return false;
+}
+
 static int soc24_common_resume(struct amdgpu_ip_block *ip_block)
 {
+	struct amdgpu_device *adev = ip_block->adev;
+
+	if (soc24_need_reset_on_resume(adev)) {
+		dev_info(adev->dev, "S3 suspend aborted, resetting...");
+		soc24_asic_reset(adev);
+	}
+
 	return soc24_common_hw_init(ip_block);
 }
 


