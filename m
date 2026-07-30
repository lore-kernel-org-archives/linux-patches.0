Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518E5443A9F;
	Thu, 30 Jul 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422297; cv=none; b=oxviuPid6KdFTZMIlTKAZf55vHWp6fDGsn+F3aeUZhlRwRUX6e92CucAAN0VH8LVjIJH4ChGNQLNI8x0fWdOtbQGRhKxC6iow7QMYhATjMQ34pYvVLEM3bTvZTFg43duS1U5HZNq3nzS9BD6IHVxdB+YF42d5Rh9MrRzWgAt3L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422297; c=relaxed/simple;
	bh=/QHS50edNI0RONR32ZSExkb60TYc5X6U6Sow3yZ//G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpWJeVb/1TeF/yuDp5xCzJsYZmHAYQskbO4L/EKi2qGPkiTnjXLj24HS5z9rUkKLQvVYFgeUTONP9LVmSDqdxOMUwyA8jdGT23yO4oJIdnYa6C5zlF8B2u7cDa6hiw/Nu0x+USAhS4cGjBZ3XkKPz7KFPVGmtIXShjO6GqhPVYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cL5ZmD3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cL5ZmD3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4061F000E9;
	Thu, 30 Jul 2026 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422296;
	bh=x/rTeR4C7kBychYxtBbHjUqCvW5Iwp02Kja6CxC3klY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cL5ZmD3pCu1reFUHgiAeMsbnrnSpflVnPCheolw1b8KFB94WeTCHly3BOE8RZ4XKI
	 aRpBIspDMQ5efV85m6d0m2o54FzAyFLtENqtz59lBl0d1kKC9l8myl3neP/5njP+lf
	 lSzHZ+T9lkcalG4GxkIZP06o1+fbDHZNjeMrwWTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 390/744] drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions
Date: Thu, 30 Jul 2026 16:11:03 +0200
Message-ID: <20260730141452.577679105@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 8882f8897e554053af9e72f4c2da8b1e2cce56c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c |   30 ++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
@@ -272,7 +272,20 @@ static bool amdgpu_gtt_mgr_intersects(st
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
@@ -290,7 +303,20 @@ static bool amdgpu_gtt_mgr_compatible(st
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


