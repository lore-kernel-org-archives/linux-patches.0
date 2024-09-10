Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DC218FDB7;
	Tue, 10 Sep 2024 09:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961658; cv=none; b=TiTnPk6wzHwZqry2BmXmqxTS7Atxyb+LU3yynqX3SAWk/xwa0QbEeJDW+A4c+6ZGAXPdX7SZTe+sZNp2bIRAJUKVMeSqfmDEmBRjcAIjLgSZiLFpFIUTwQwH22SlYV9IIoxglHefNlQFyAuDMz55WFRRqe9+x87bKshIb66K5Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961658; c=relaxed/simple;
	bh=+xE3ubkbYoWXQOoBwBEJYrAbhxaAyh8eXJn1MS0UfNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOO5Isw+xOvDGgLiR1L8Kkst1geToBIcQazd6X4IW+LE/UUCAalMnuLfI55EfqKup7dk38wLQsP8lUZ7UE2H0nk72PDY9IDCXbj4ySo8CYehqxrilVgvGpjDMHJ99R7ra6Wk+hXKfs/dPxUAQ7NeCGfiYwjkwliQ/qzXs7mCRHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umVCFdWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umVCFdWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9F7C4CEC3;
	Tue, 10 Sep 2024 09:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961658;
	bh=+xE3ubkbYoWXQOoBwBEJYrAbhxaAyh8eXJn1MS0UfNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umVCFdWVSVT1QK1tPhd6b6CVy6UxKeRFkjm633PzZFdGHQtFCWoLNQQt291FJs35H
	 yFvGlFo5tp2naIpkpuSzKxJxDRYSXbiSn12iOZQJhBKag79Su60+G5kicq8w7/DXe2
	 zvGkVyQa+rP7vH7ZkApmLYghq60Gumlf3m5HLa9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 145/375] drm/amdgpu/display: handle gfx12 in amdgpu_dm_plane_format_mod_supported
Date: Tue, 10 Sep 2024 11:29:02 +0200
Message-ID: <20240910092627.333630606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit ed17b63e7e25f03b40db66a8d5802b89aac40441 ]

All this code has undefined behavior on GFX12 and shouldn't be executed.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   | 47 ++++++++++---------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 70e45d980bb9..7d47acdd11d5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1400,8 +1400,6 @@ static bool amdgpu_dm_plane_format_mod_supported(struct drm_plane *plane,
 	const struct drm_format_info *info = drm_format_info(format);
 	int i;
 
-	enum dm_micro_swizzle microtile = amdgpu_dm_plane_modifier_gfx9_swizzle_mode(modifier) & 3;
-
 	if (!info)
 		return false;
 
@@ -1423,29 +1421,34 @@ static bool amdgpu_dm_plane_format_mod_supported(struct drm_plane *plane,
 	if (i == plane->modifier_count)
 		return false;
 
-	/*
-	 * For D swizzle the canonical modifier depends on the bpp, so check
-	 * it here.
-	 */
-	if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) == AMD_FMT_MOD_TILE_VER_GFX9 &&
-	    adev->family >= AMDGPU_FAMILY_NV) {
-		if (microtile == MICRO_SWIZZLE_D && info->cpp[0] == 4)
-			return false;
-	}
-
-	if (adev->family >= AMDGPU_FAMILY_RV && microtile == MICRO_SWIZZLE_D &&
-	    info->cpp[0] < 8)
-		return false;
+	/* GFX12 doesn't have these limitations. */
+	if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) <= AMD_FMT_MOD_TILE_VER_GFX11) {
+		enum dm_micro_swizzle microtile = amdgpu_dm_plane_modifier_gfx9_swizzle_mode(modifier) & 3;
 
-	if (amdgpu_dm_plane_modifier_has_dcc(modifier)) {
-		/* Per radeonsi comments 16/64 bpp are more complicated. */
-		if (info->cpp[0] != 4)
-			return false;
-		/* We support multi-planar formats, but not when combined with
-		 * additional DCC metadata planes.
+		/*
+		 * For D swizzle the canonical modifier depends on the bpp, so check
+		 * it here.
 		 */
-		if (info->num_planes > 1)
+		if (AMD_FMT_MOD_GET(TILE_VERSION, modifier) == AMD_FMT_MOD_TILE_VER_GFX9 &&
+		    adev->family >= AMDGPU_FAMILY_NV) {
+			if (microtile == MICRO_SWIZZLE_D && info->cpp[0] == 4)
+				return false;
+		}
+
+		if (adev->family >= AMDGPU_FAMILY_RV && microtile == MICRO_SWIZZLE_D &&
+		    info->cpp[0] < 8)
 			return false;
+
+		if (amdgpu_dm_plane_modifier_has_dcc(modifier)) {
+			/* Per radeonsi comments 16/64 bpp are more complicated. */
+			if (info->cpp[0] != 4)
+				return false;
+			/* We support multi-planar formats, but not when combined with
+			 * additional DCC metadata planes.
+			 */
+			if (info->num_planes > 1)
+				return false;
+		}
 	}
 
 	return true;
-- 
2.43.0



