Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662D31A6E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0A5C433C8;
	Wed, 20 Sep 2023 12:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214090;
	bh=F1ffmLaguFndy/7KYyKgaaauKquwLM+dXitxni/gzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/IyaeBIfd0Em4Jx1D89P4TMrCWwdJRZaJ8e0So0venqxznn2dj471+Sn/DydO1bM
	 W6AMc2XTUUt0muvLqPHDRviem15Xh5PVWrXBz+e2GLDetZJ9aFa61amV7KRfMDhe0m
	 FHqSzKs+0B8JPs2/HaM3JCFti6LXwHfhMwiQkvss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 108/110] drm/amdgpu: fix amdgpu_cs_p1_user_fence
Date: Wed, 20 Sep 2023 13:32:46 +0200
Message-ID: <20230920112834.453838164@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 35588314e963938dfdcdb792c9170108399377d6 upstream.

The offset is just 32bits here so this can potentially overflow if
somebody specifies a large value. Instead reduce the size to calculate
the last possible offset.

The error handling path incorrectly drops the reference to the user
fence BO resulting in potential reference count underflow.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -45,7 +45,6 @@ static int amdgpu_cs_user_fence_chunk(st
 	struct drm_gem_object *gobj;
 	struct amdgpu_bo *bo;
 	unsigned long size;
-	int r;
 
 	gobj = drm_gem_object_lookup(p->filp, data->handle);
 	if (gobj == NULL)
@@ -60,23 +59,14 @@ static int amdgpu_cs_user_fence_chunk(st
 	drm_gem_object_put(gobj);
 
 	size = amdgpu_bo_size(bo);
-	if (size != PAGE_SIZE || (data->offset + 8) > size) {
-		r = -EINVAL;
-		goto error_unref;
-	}
-
-	if (amdgpu_ttm_tt_get_usermm(bo->tbo.ttm)) {
-		r = -EINVAL;
-		goto error_unref;
-	}
+	if (size != PAGE_SIZE || data->offset > (size - 8))
+		return -EINVAL;
 
-	*offset = data->offset;
+	if (amdgpu_ttm_tt_get_usermm(bo->tbo.ttm))
+		return -EINVAL;
 
+	*offset = data->offset;
 	return 0;
-
-error_unref:
-	amdgpu_bo_unref(&bo);
-	return r;
 }
 
 static int amdgpu_cs_bo_handles_chunk(struct amdgpu_cs_parser *p,


