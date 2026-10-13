Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83FC4F3EC0;
	Tue, 13 Oct 2026 12:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894969; cv=none; b=fnXImwWIV4BI5eI4HGmDRiZdoGL/VZox+kQtYfiqzSvgUZYQg7/eylRQXrO90kLWRWQZ0rOxtZibG6Hqj6adTWccCAJE0XiUuKrm3bBkVCUPo/DhATroBfUKlHY/2NbF9z5MiKIqahhTZ6Voh4s3lM7b5zxNyZIVNa9R/0AN4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894969; c=relaxed/simple;
	bh=c6P+ZH4u1TSnJf+nTSZq87AxhWD8hFff52qDNdrjIJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCHsJ1JYHKTJWIpWgYa5qrJ19vYvi10soLdQW/mf7IzJs62pI9jwAPYe3rHZrc9h/m7hCRbZkipdUGrrkpsUGrGJKnV6ZOjiQ115cQMnAVz86DqIv5zCJr/oInh4DK8rY5HeXmIE+7y4aEkoV4g3W9iv2Gm5eg5zrNtBy0tINQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIfOhCdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIfOhCdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32251F000FF;
	Tue, 13 Oct 2026 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894968;
	bh=tKOhLRxK6JFJEE6JhkXx4rprSCP1/127TrqGiVKWipQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIfOhCdmvDshdHEOHmhqRtj1RsKxPiC9Pof0Hk9q4JZEUBi46fW/1RYUZUr8KLKNI
	 ol9YM4TE+DoM7+Dod2FXtnCCCJMugl4LGYhlEZ8z93zIr21fJxHy2tbBW9ZfBU58Sp
	 l+epJkrzQfuBTkmGooqxl8GsWRVdJte8t4s3pp+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 116/497] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Tue, 13 Oct 2026 13:34:43 +0200
Message-ID: <20261013112910.644064476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -308,6 +308,14 @@ static const u32 verde_rlc_save_restore_
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
@@ -3184,6 +3192,7 @@ static int gfx_v6_0_sw_fini(void *handle
 		amdgpu_ring_fini(&adev->gfx.compute_ring[i]);
 
 	amdgpu_gfx_rlc_fini(adev);
+	gfx_v6_0_free_microcode(adev);
 
 	return 0;
 }


