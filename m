Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA439143880;
	Tue, 10 Sep 2024 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964680; cv=none; b=KHmk7BS/Z5B7LS2/jmExDAtYqvthdNf1HKqSi6pK5Z21LVtE2D+K2TQvrz7q7SrWDiLl2PvsOW26iBtsUY6YEoAhbrNTZXc9b2/SlbHTv1JwnawJJKVrcOkFlMGqDDDv2IpQZxi0HEdhoTd3ZCVQGOkZm5dQrknnUkp0bg5HDAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964680; c=relaxed/simple;
	bh=Gfi5I0fCujTRfj2y3obGtpsk9Wwkc1b1Ht8d+FFPIJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2RApx/rT7MJNhODdLDfARVThnPv5iv/O07uKfSrcj8UkWR0AU6pzm15pEMVnysrlWgQTSxfulwAwsPpJceiqVP+BgD/0QAtnseLPhgSqoTfpckMUyQNb1uS43PNJmNg7DGg+zlK3kLlLbUho7IgiDGKN4qN6riqKaGrAF1VQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q59Kr5Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q59Kr5Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77933C4CEC3;
	Tue, 10 Sep 2024 10:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964679;
	bh=Gfi5I0fCujTRfj2y3obGtpsk9Wwkc1b1Ht8d+FFPIJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q59Kr5OlwhD6VlRi+jlFUVTtv14zthTuwHmJvtmQmAs4CS+SvgNqR7Z/aJEDa09zB
	 e9V3N4USDVKuboF4B20G1G6neeJKjeZuUxfsG+2x4p786/v71aqJBUwjyWo+nktJHw
	 hnX0iILFYtjmuxAVGLc+vWAA3+o87ZLRvYQK1mwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/269] drm/amdgpu: handle gfx12 in amdgpu_display_verify_sizes
Date: Tue, 10 Sep 2024 11:33:45 +0200
Message-ID: <20240910092616.358568217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit 8dd1426e2c80e32ac1995007330c8f95ffa28ebb ]

It verified GFX9-11 swizzle modes on GFX12, which has undefined behavior.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 27 ++++++++++++++++++++-
 include/uapi/drm/drm_fourcc.h               |  2 ++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index 82ad2b01f2e9..5fbb9caa7415 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1033,6 +1033,30 @@ static int amdgpu_display_verify_sizes(struct amdgpu_framebuffer *rfb)
 			block_width = 256 / format_info->cpp[i];
 			block_height = 1;
 			block_size_log2 = 8;
+		} else if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) >= AMD_FMT_MOD_TILE_VER_GFX12) {
+			int swizzle = AMD_FMT_MOD_GET(TILE, modifier);
+
+			switch (swizzle) {
+			case AMD_FMT_MOD_TILE_GFX12_256B_2D:
+				block_size_log2 = 8;
+				break;
+			case AMD_FMT_MOD_TILE_GFX12_4K_2D:
+				block_size_log2 = 12;
+				break;
+			case AMD_FMT_MOD_TILE_GFX12_64K_2D:
+				block_size_log2 = 16;
+				break;
+			case AMD_FMT_MOD_TILE_GFX12_256K_2D:
+				block_size_log2 = 18;
+				break;
+			default:
+				drm_dbg_kms(rfb->base.dev,
+					    "Gfx12 swizzle mode with unknown block size: %d\n", swizzle);
+				return -EINVAL;
+			}
+
+			get_block_dimensions(block_size_log2, format_info->cpp[i],
+					     &block_width, &block_height);
 		} else {
 			int swizzle = AMD_FMT_MOD_GET(TILE, modifier);
 
@@ -1068,7 +1092,8 @@ static int amdgpu_display_verify_sizes(struct amdgpu_framebuffer *rfb)
 			return ret;
 	}
 
-	if (AMD_FMT_MOD_GET(DCC, modifier)) {
+	if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) <= AMD_FMT_MOD_TILE_VER_GFX11 &&
+	    AMD_FMT_MOD_GET(DCC, modifier)) {
 		if (AMD_FMT_MOD_GET(DCC_RETILE, modifier)) {
 			block_size_log2 = get_dcc_block_size(modifier, false, false);
 			get_block_dimensions(block_size_log2 + 8, format_info->cpp[0],
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index fb3040677815..5eed091d4c29 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -1504,6 +1504,8 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
  *    6 - 64KB_3D
  *    7 - 256KB_3D
  */
+#define AMD_FMT_MOD_TILE_GFX12_256B_2D 1
+#define AMD_FMT_MOD_TILE_GFX12_4K_2D 2
 #define AMD_FMT_MOD_TILE_GFX12_64K_2D 3
 #define AMD_FMT_MOD_TILE_GFX12_256K_2D 4
 
-- 
2.43.0



