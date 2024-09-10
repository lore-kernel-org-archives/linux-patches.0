Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD5B183CB0;
	Tue, 10 Sep 2024 10:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963212; cv=none; b=NXrH3H2f6QwCDUg5K2wN+6OEQuBgrIuusWv7g4v2jFkQ1lNkOvwAc5Fd+je3O/NPuY7jiXZ2YggMozk79v5UpkwrT/sEP9TuBGW0HIa9XFufspQBxF0d2mm5q6Opujq20CXVaeogHEbnRnvo4UHQVWuBlGznvXZ2H56+PKE0xBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963212; c=relaxed/simple;
	bh=vP9AYutE3SVWF/NO0vVG8GggnrLVwwvRlZsKXq0s98g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1S0+qshYgbE++3wcrsD+nVUPkeeT/xPlG4NQpUCdsaIHAU9Gwl3NBTyEwWWxVgkfxvMLXqr59CgyylEJa/w/foQscdvANlKU5rglKfoEpmXHHJiZd2KBBaL+hmPI59eBPYzyjxEOEkqaUwFxPcD2hOoW3SS4kazxwkMxnksXwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5B7nUlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5B7nUlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458DBC4CEC6;
	Tue, 10 Sep 2024 10:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963212;
	bh=vP9AYutE3SVWF/NO0vVG8GggnrLVwwvRlZsKXq0s98g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5B7nUlQ74F/tMZbq390tSpi7kMHJHYqgzvcGn6Yvwy6xH/9CE0Zs8MlY9y/ucTJM
	 svsWULnLZTuiBupwye1BHT5ziosZOKHCpQuFKwxFNkHMR1X80Jfh9qxJbTOcgdTc0A
	 G05InGnyg1ONa0ZJhRPBep52LxW95wstT1uMsh00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/192] drm/amdgpu: handle gfx12 in amdgpu_display_verify_sizes
Date: Tue, 10 Sep 2024 11:33:18 +0200
Message-ID: <20240910092605.021304128@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac773b191071..cd0bccc95205 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -997,6 +997,30 @@ static int amdgpu_display_verify_sizes(struct amdgpu_framebuffer *rfb)
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
 
@@ -1032,7 +1056,8 @@ static int amdgpu_display_verify_sizes(struct amdgpu_framebuffer *rfb)
 			return ret;
 	}
 
-	if (AMD_FMT_MOD_GET(DCC, modifier)) {
+	if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) <= AMD_FMT_MOD_TILE_VER_GFX11 &&
+	    AMD_FMT_MOD_GET(DCC, modifier)) {
 		if (AMD_FMT_MOD_GET(DCC_RETILE, modifier)) {
 			block_size_log2 = get_dcc_block_size(modifier, false, false);
 			get_block_dimensions(block_size_log2 + 8, format_info->cpp[0],
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 52ce13488eaf..6245928d76ee 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -1420,6 +1420,8 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
  *    6 - 64KB_3D
  *    7 - 256KB_3D
  */
+#define AMD_FMT_MOD_TILE_GFX12_256B_2D 1
+#define AMD_FMT_MOD_TILE_GFX12_4K_2D 2
 #define AMD_FMT_MOD_TILE_GFX12_64K_2D 3
 #define AMD_FMT_MOD_TILE_GFX12_256K_2D 4
 
-- 
2.43.0



