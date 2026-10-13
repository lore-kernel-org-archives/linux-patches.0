Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8AF47AF65;
	Tue, 13 Oct 2026 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893134; cv=none; b=HRZQAB2dJJKaflY02awFhWAtFO0oLKA2ZRsnaIb4XPEQTHFqQAJ5XaE/dhzJ+mPDmdLHTwEsKYEGiOhbYJ+iZiiErd2wQfjBuWVDGtDqQe0ou3SB1cHKO58BURKgR91gkwC9PqyyeNzEuMqt/cbJf2oga8UInZJwydYxEhylp1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893134; c=relaxed/simple;
	bh=cDqaeoymDZ6FEqDajH4/C65vp0MnQFS/SiZMvhEsWD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlaN+U+nEYRb3kho/RR0zdQ7dXL67JZFxbMNg3e12UChlyT1d/he0T1l/s1YQb/kGJtiUKJAHsrJ5PvM+Zzs/Es3/2cF92teWjaA/5ilZaRLHz+6Jxw67c3yJaSVqjTh3qsKqarty3gb39rFB8Uf26Uatzq8ecL9QsqIB94HYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsvh9aSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsvh9aSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A33E1F000FF;
	Tue, 13 Oct 2026 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893133;
	bh=pJe3YDOoaxD90NdqjPLoxumf/w5Z307S4/PfhD5YvwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsvh9aSo9GZr6B3o6ZvqdR6jUEQ9G0xK6rOjSxB7lkbVgiLFgLBxZa+SN6uft2k1K
	 G0xmjS1pUzqefGHJOUoTFhYDwMxztDbMiixLPrOgA7M9NiMa/Q2DR7q7/EQ0cH6yKf
	 fjUe7A4dTyqPMEV4+cunexXvAA1RtqRRdRAg1o5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 125/621] drm/amdgpu/userq: only accept doorbell BOs as queue doorbell
Date: Tue, 13 Oct 2026 13:32:00 +0200
Message-ID: <20261013112923.824429304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 7f7c88dbf4d543f6703e53bdeed380e886733167 upstream.

amdgpu_userq_get_doorbell_index() pins any BO passed as doorbell_handle
into the doorbell domain. For a regular BO, TTM moves it with
ttm_bo_move_null() and its contents are lost. Since an importer on the
same device gets the exporter's GEM object, a client can do this to a
buffer another client shared with it.

Reject BOs that were not created in the doorbell domain.

v2: drop the error message, use a local abo variable (Christian)

Fixes: f09c1e6077ab ("drm/amdgpu: generate doorbell index for userqueue")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f7497bbc19db4821c62b9d97b31c9086feb2d917)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -317,6 +317,7 @@ amdgpu_userq_get_doorbell_index(struct a
 	uint64_t index;
 	struct drm_gem_object *gobj;
 	struct amdgpu_userq_obj *db_obj = db_info->db_obj;
+	struct amdgpu_bo *abo;
 	int r, db_size;
 
 	gobj = drm_gem_object_lookup(filp, db_info->doorbell_handle);
@@ -325,7 +326,17 @@ amdgpu_userq_get_doorbell_index(struct a
 		return -EINVAL;
 	}
 
-	db_obj->obj = amdgpu_bo_ref(gem_to_amdgpu_bo(gobj));
+	/*
+	 * Pinning a regular BO into the doorbell domain would discard its
+	 * contents, possibly those of a buffer shared by another client.
+	 */
+	abo = gem_to_amdgpu_bo(gobj);
+	if (!(abo->preferred_domains & AMDGPU_GEM_DOMAIN_DOORBELL)) {
+		drm_gem_object_put(gobj);
+		return -EINVAL;
+	}
+
+	db_obj->obj = amdgpu_bo_ref(abo);
 	drm_gem_object_put(gobj);
 
 	r = amdgpu_bo_reserve(db_obj->obj, true);


