Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A50A1A0DE8;
	Thu,  6 Jun 2024 14:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683686; cv=none; b=TZ392qlU6DjNcbynSzu+Tu54fK7BOoOEsG1WY3Zdl0vylfmXadRMRvXoADk0tX7g/mm0QcUBJk0MKIzzUWAhzpGnRhZ+lTZfoKrP3NDbsX2Mv6+fsAG9X0EZSoTO5/k6GQELE1/g3pjPSyiEpUyh8mYJbhfZnQxjzmVRizaODs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683686; c=relaxed/simple;
	bh=Zj1qKAm8Et4Ebfki8OFlPRXj+euJJYmR3eInuOBgTTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clNZ/QxYUlGxlp48kIdjNrhZW09spVCyVAq2G+B7pskqcDSGFQbipdL8LvRZzHlwYvI25n32I7L60Cq/Gh1U4IaUCKsVtKPFcYAdAjcXuN3t9E8Lgd5L6BlRfIy/kTHuIbRG2PQV8kPJREqtwwS1ghRsAfTAUvrlcUNk5+zR/C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAmy1yqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAmy1yqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B74C32781;
	Thu,  6 Jun 2024 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683686;
	bh=Zj1qKAm8Et4Ebfki8OFlPRXj+euJJYmR3eInuOBgTTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAmy1yqzkD6N9rcQeY7Kz4UJJRiheeCjtCz5lLxQwtcy2uBL8OBJ+vPsf2T+lqt3m
	 AYvnfHWqcx+H/ttn6qf4GOuBDves+L8BuPFH5YwrjmNASTueSNGh3xv0n/7GqMDw73
	 iJhTvLDax0jaVJSL3xmsZ0Yfbc41fxH92xRdNYJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 592/744] drm/amdgpu: Fix buffer size in gfx_v9_4_3_init_ cp_compute_microcode() and rlc_microcode()
Date: Thu,  6 Jun 2024 16:04:24 +0200
Message-ID: <20240606131751.461069489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit acce6479e30f73ab0872e93a75aed1fb791d04ec ]

The function gfx_v9_4_3_init_microcode in gfx_v9_4_3.c was generating
about potential truncation of output when using the snprintf function.
The issue was due to the size of the buffer 'ucode_prefix' being too
small to accommodate the maximum possible length of the string being
written into it.

The string being written is "amdgpu/%s_mec.bin" or "amdgpu/%s_rlc.bin",
where %s is replaced by the value of 'chip_name'. The length of this
string without the %s is 16 characters. The warning message indicated
that 'chip_name' could be up to 29 characters long, resulting in a total
of 45 characters, which exceeds the buffer size of 30 characters.

To resolve this issue, the size of the 'ucode_prefix' buffer has been
reduced from 30 to 15. This ensures that the maximum possible length of
the string being written into the buffer will not exceed its size, thus
preventing potential buffer overflow and truncation issues.

Fixes the below with gcc W=1:
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c: In function ‘gfx_v9_4_3_early_init’:
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:379:52: warning: ‘%s’ directive output may be truncated writing up to 29 bytes into a region of size 23 [-Wformat-truncation=]
  379 |         snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_rlc.bin", chip_name);
      |                                                    ^~
......
  439 |         r = gfx_v9_4_3_init_rlc_microcode(adev, ucode_prefix);
      |                                                 ~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:379:9: note: ‘snprintf’ output between 16 and 45 bytes into a destination of size 30
  379 |         snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_rlc.bin", chip_name);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:413:52: warning: ‘%s’ directive output may be truncated writing up to 29 bytes into a region of size 23 [-Wformat-truncation=]
  413 |         snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_mec.bin", chip_name);
      |                                                    ^~
......
  443 |         r = gfx_v9_4_3_init_cp_compute_microcode(adev, ucode_prefix);
      |                                                        ~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c:413:9: note: ‘snprintf’ output between 16 and 45 bytes into a destination of size 30
  413 |         snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_mec.bin", chip_name);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 86301129698b ("drm/amdgpu: split gc v9_4_3 functionality from gc v9_0")
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 7c9a7ab9df3bb..af46823e43367 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -425,7 +425,7 @@ static int gfx_v9_4_3_init_cp_compute_microcode(struct amdgpu_device *adev,
 
 static int gfx_v9_4_3_init_microcode(struct amdgpu_device *adev)
 {
-	char ucode_prefix[30];
+	char ucode_prefix[15];
 	int r;
 
 	amdgpu_ucode_ip_version_decode(adev, GC_HWIP, ucode_prefix, sizeof(ucode_prefix));
-- 
2.43.0



