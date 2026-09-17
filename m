Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FDA5AA689;
	Thu, 17 Sep 2026 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661245; cv=none; b=pzAVmBPUf91ceMdTRkpBvydL/fyuyXqBJVpFRyAG2YtOZUm2SuFYdUGiOIqFdA0eGmv52OpF+sWbjHNvJChsndACoINIbQ3KaW5f0prM4DiZqkQcfe2reGuMN9wIJCXy+Mn4mihT/RnyDNmOMdJ9wbts0PEnJpbznH+J821MNVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661245; c=relaxed/simple;
	bh=AFQNve8C9/NISTJopoRXda5UTrBHGF9qOen5gm2CkEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTs7pkD2u73nSBURivwo/DYwiACc0Ck1cvYMsKUQD7vnIb+18FVSpjWRI3y2AG3H6R1ObyumnPkm9X43AF7XmQNqbhcO7pGwxdseMDmEYvF4VN48APZ1Cx52sbw9KOnsbk3IRsHFXOJK8XtEEpcdNAtUBj9Cp0UA7GjTGWdWALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjeRZNEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjeRZNEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8541F000FF;
	Thu, 17 Sep 2026 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661244;
	bh=fNFH8FXqiPWtUJWXdYyNSFKQWcukF+5jWSMl2+4pkQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjeRZNEcWmawdhbo3dmnGSknhv/xvBVQxtLcZU5RzzpQfGx6X7Z/sZadKXQ/7gEHB
	 I8wd90rKeaWNVDiChI/kOiC4GVD8jdua+z7iV9DVQDZTNdPjEj+4UIOhQXn0UZcao5
	 IvwtyKG0v2pg0bnT4tm9fDFuezIaAzmfts2Ry0tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0132/1250] drm/amdgpu/userq: pin mqd and fw object bo to avoid eviction
Date: Thu, 17 Sep 2026 15:58:47 +0100
Message-ID: <20260917151555.622917131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit a3bbf32a336939a1d21b9561f8e53333b684b7ef ]

mqd and fw objects are queue core objects which should remain
valid and never be unmapped and evicted for user queues to work
properly.

During eviction if these buffers are evicted the hw continue to
use the invalid addresses and caused page faults and system hung.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 7e3175f82a20d..0f4281c9aea2f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -270,16 +270,20 @@ int amdgpu_userq_create_object(struct amdgpu_userq_mgr *uq_mgr,
 		goto free_obj;
 	}
 
+	r = amdgpu_bo_pin(userq_obj->obj, AMDGPU_GEM_DOMAIN_GTT);
+	if (r)
+		goto unresv;
+
 	r = amdgpu_ttm_alloc_gart(&(userq_obj->obj)->tbo);
 	if (r) {
 		drm_file_err(uq_mgr->file, "Failed to alloc GART for userqueue object (%d)", r);
-		goto unresv;
+		goto unpin_bo;
 	}
 
 	r = amdgpu_bo_kmap(userq_obj->obj, &userq_obj->cpu_ptr);
 	if (r) {
 		drm_file_err(uq_mgr->file, "Failed to map BO for userqueue (%d)", r);
-		goto unresv;
+		goto unpin_bo;
 	}
 
 	userq_obj->gpu_addr = amdgpu_bo_gpu_offset(userq_obj->obj);
@@ -287,11 +291,13 @@ int amdgpu_userq_create_object(struct amdgpu_userq_mgr *uq_mgr,
 	memset(userq_obj->cpu_ptr, 0, size);
 	return 0;
 
+unpin_bo:
+	amdgpu_bo_unpin(userq_obj->obj);
 unresv:
 	amdgpu_bo_unreserve(userq_obj->obj);
-
 free_obj:
 	amdgpu_bo_unref(&userq_obj->obj);
+
 	return r;
 }
 
@@ -299,6 +305,7 @@ void amdgpu_userq_destroy_object(struct amdgpu_userq_mgr *uq_mgr,
 				 struct amdgpu_userq_obj *userq_obj)
 {
 	amdgpu_bo_kunmap(userq_obj->obj);
+	amdgpu_bo_unpin(userq_obj->obj);
 	amdgpu_bo_unref(&userq_obj->obj);
 }
 
-- 
2.53.0



