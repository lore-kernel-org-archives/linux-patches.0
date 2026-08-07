Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D8339B41;
	Fri,  7 Aug 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114578; cv=none; b=pK2i4++LiaiCKf2dqiNeU682WkeL5GEY8OgqKJ7gQSghF2A+Wa7W4WL+8Obb6MAWrfV9TvqacuXknUA3MY7j1Zjc/Z7AhF/bTkvSGll+sLvBcNQ4RGtD34nWFf4HGQ9DzRgpLx03w9W+d30Mv7AimDMhfy0/7v2tKHMNMPvubuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114578; c=relaxed/simple;
	bh=eIP+E2CXV4IXNHXG2P1NrC6TiC6HoL5U76sVQeI2r2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H75RfM00/cy74yQadipe1F0GO00w9GkuL5s66RgIsHyYqX29USOuR5SwxotmIHZ49+X8onEHFWfbdelYZ020xOwWBCQsnlts4IPWI0G5qOQpdf4Rm7NQKyTat6MeOHHkAlOqtWzmsTqP+I0w3knp6ObR/9AGArVPNTs+3tDiSUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSK0M/QR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSK0M/QR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEAC1F00A3A;
	Fri,  7 Aug 2026 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114573;
	bh=ADIbMot0fR09Sv64F062xL0YM3YANUz3yM+TnEmKsMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSK0M/QR4k07RuUMgvazDCmYiHimfJmhig/ajMl6wtDetmSLnZz9eCao1sJINswbo
	 gRcb7rT/ZrLNQCRdW1PNVBqqfIQqwwD/6e/86Tc64SjMatf/jnEN22APzdCT0vzTSV
	 Wt+jzN3f181mXJP8h3ikowljU0dIp3wmgmgYyWCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/337] drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions
Date: Fri,  7 Aug 2026 16:38:32 +0200
Message-ID: <20260807143425.226459323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 8882f8897e554053af9e72f4c2da8b1e2cce56c7 ]

When testing intersection and compatibility, respect
the actual placement requirements. This is a pre-requisite
for ensuring that UVD CS BOs do not cross 256M segments.

Fixes: ded910f368a5 ("drm/amdgpu: Implement intersect/compatible functions")
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bc06579ca29dee9c245a41b12e39c7bb6938af5d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c |   30 ++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
@@ -217,7 +217,20 @@ static bool amdgpu_gtt_mgr_intersects(st
 				      const struct ttm_place *place,
 				      size_t size)
 {
-	return !place->lpfn || amdgpu_gtt_mgr_has_gart_addr(res);
+	const struct drm_mm_node *const node = &to_ttm_range_mgr_node(res)->mm_nodes[0];
+	const u32 num_pages = PFN_UP(size);
+
+	if (!place->lpfn)
+		return true;
+
+	if (!amdgpu_gtt_mgr_has_gart_addr(res))
+		return false;
+
+	if (place->fpfn >= (node->start + num_pages) ||
+	    (place->lpfn && place->lpfn <= node->start))
+		return false;
+
+	return true;
 }
 
 /**
@@ -235,7 +248,20 @@ static bool amdgpu_gtt_mgr_compatible(st
 				      const struct ttm_place *place,
 				      size_t size)
 {
-	return !place->lpfn || amdgpu_gtt_mgr_has_gart_addr(res);
+	const struct drm_mm_node *const node = &to_ttm_range_mgr_node(res)->mm_nodes[0];
+	const u32 num_pages = PFN_UP(size);
+
+	if (!place->lpfn)
+		return true;
+
+	if (!amdgpu_gtt_mgr_has_gart_addr(res))
+		return false;
+
+	if (node->start < place->fpfn ||
+	    (place->lpfn && (node->start + num_pages) > place->lpfn))
+		return false;
+
+	return true;
 }
 
 /**


