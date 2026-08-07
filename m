Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E935A38C;
	Fri,  7 Aug 2026 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116414; cv=none; b=U6daWEf3R0KgadkWFk4Ceuv+9pMt3wh41oEDRR6sIjoM+EnRE91meJ17uI++q3s1b3NNHKL9moF6zZMyE4pSv3yc1d7PomeGVQv5l4ullFF36F7ib3a1UcXo74TZXm/y+nby+wymvee6ec5GkPF486UJHOcRcYIdyis1dxa1ops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116414; c=relaxed/simple;
	bh=iz8ajKHPUfiuRKEyZI1TQqUMOc2ujbbRjHBkbsDhajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jf1FerpnomV6PCOKcFYqZX6w3zJ2vaAdmZnPMrmJVUQD8vNgxO2kw06Z/GOkg4RPDv44F4TRaQcX4UEfE5vpFKxkkMiJKsTUB3cHhn8CsWJraXg1RCJx565tCuY1GCBx+Gax0+GTJIl0oHVTUZ4QOyFRUG7qPcviTIdaJ6GN/os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXSUbn7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXSUbn7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24031F000E9;
	Fri,  7 Aug 2026 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116413;
	bh=FZ3XgSJG77L7FxWF4efJSPy4ScI9QCHABwEDw6YGe00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXSUbn7E4FEKqD8m4Rb8zT/Op9WF/kOTYswfve9l4Fv5oqvkUWUxnpOlQWjCnVHzN
	 yohsIcJKy8ei2VlbroObhMUM4mgrnLHOyP/m4hh4zkVCR52mm6qykzB+IjM63tADFO
	 xCMNS2VhT0td+panAiQRMeKHfl+jye672kJkepC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/261] drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions
Date: Fri,  7 Aug 2026 16:39:41 +0200
Message-ID: <20260807143420.201268314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -219,7 +219,20 @@ static bool amdgpu_gtt_mgr_intersects(st
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
@@ -237,7 +250,20 @@ static bool amdgpu_gtt_mgr_compatible(st
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


