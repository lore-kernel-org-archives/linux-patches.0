Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A7233A6EB;
	Fri,  9 Oct 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555927; cv=none; b=muAlH4xzqW6uzOTRncLYiMkv7XyB+QoeyB1J+vjITTawTYM8tkG+N3g6ekShuQfh6aR7BrU1i1vd4N603aUQ2+Ql+0tZFdsoCwYCZT2hpFT2qUB+hxiRpZ9hOb86rMeyAFVZYf9pVHtvdimRjkUilsgLVIwh1OIehDxU8JJpTZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555927; c=relaxed/simple;
	bh=tUuhplv5FGQSrFlh3OreVBEEeAEZnPBy4yEGPG7YiEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEwh1UXIyJMwNvo0+SuQpt2WScluWpOFhTMMlInNSYl7/w0+Cv+DGaP6oHfbBoypaDbVs+lYbTZxFD+e13y4lA0+6btYZKQfd6Y4Xtop0nTohS84st7zO15r7Zd5zubhAVs9nGWrtmCcZKEuB9I4BWTwij0m2/WiuP9C9beUgT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fJm/25x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fJm/25x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613571F000FF;
	Fri,  9 Oct 2026 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555925;
	bh=ADQdsBb7bmJWErJn/GUS3/5ggUPUBdfnQkfnYnkGuPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fJm/25xdb3CMUFWgPT2rZ4pMm+AD0uEXqkTkUvVazFiJ7NZ56/4d6LMXhfuM5ZSv
	 2R01GnQUAnzyEH4ujrgWF9aFTnBdEe80A3O6XWrBzq8QBazkJcV3rWLvdqlNa7DtBw
	 Bx8gS1u9jYSwlAI+RUZbtptmRUG4YdznEnHm3LHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 140/403] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Fri,  9 Oct 2026 16:08:21 +0200
Message-ID: <20261009140955.349000320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willian Oliveira <williandossantosdeoliveira287@gmail.com>

commit cc172e177795c5f87bc2d71768d077e1c10633e8 upstream.

The firmware requested in gfx_v6_0_init_microcode() is not released
when the GFX block is torn down, leaking the firmware resources.

Add gfx_v6_0_free_microcode() and call it from gfx_v6_0_sw_fini()
to release the PFP, ME, CE and RLC firmware.

Signed-off-by: Willian Oliveira <williandossantosdeoliveira287@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 386e81346f95ab0be5a82c5535de932e7a456924)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -322,6 +322,14 @@ static const u32 verde_rlc_save_restore_
 	0x00000000
 };
 
+static void gfx_v6_0_free_microcode(struct amdgpu_device *adev)
+{
+	amdgpu_ucode_release(&adev->gfx.pfp_fw);
+	amdgpu_ucode_release(&adev->gfx.me_fw);
+	amdgpu_ucode_release(&adev->gfx.ce_fw);
+	amdgpu_ucode_release(&adev->gfx.rlc_fw);
+}
+
 static int gfx_v6_0_init_microcode(struct amdgpu_device *adev)
 {
 	const char *chip_name;
@@ -3187,6 +3195,7 @@ static int gfx_v6_0_sw_fini(struct amdgp
 		amdgpu_ring_fini(&adev->gfx.compute_ring[i]);
 
 	amdgpu_gfx_rlc_fini(adev);
+	gfx_v6_0_free_microcode(adev);
 
 	return 0;
 }


