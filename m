Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A4B407CEF;
	Thu, 30 Jul 2026 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427737; cv=none; b=YsN8xfFVoBrs1S/VkynPivzX4UEhdHLjoOfzP8q8T5fEH7vt+3inJerAIfUI7tSRHEOg5F8LGNXZp+Qj3SXQBKxj9UPwjZTuhZs9zmuuhIgUkZSUnwcWY3DYXdCF5nrFwuhN3qR8Az5BB+fDTAqbgnUS+JF0qnkvN+7TFacela8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427737; c=relaxed/simple;
	bh=qVWzr7LajtbHBlVic3eilWT4FZamzxvWZ/Ne8PWFesw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMyDBcBLnF9cKAd1YbdN1oczTfMqYaRKqIt8uTnZB74mbNzQDTo5nQ/D1g5Kan0wIXz4tU/j53nFEtZ8Og7T2NYELxD1SAkO7+kYYk98qu81DY+sq1Xq8HNUfBz3GYiBPs9nNeqenEEwcnakK8uCWCsfFIO1MeHM0snU0YJFPko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQXNPUv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQXNPUv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5C81F000E9;
	Thu, 30 Jul 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427735;
	bh=aGbwXsZedlDd4dGqplgF/UNGDiPue1KXepeYmiaJSc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQXNPUv3u0HcxABbVbh09XqQB9SocBwtDPYla5OGJ61Bg7SfGwygHSdODskyZW/6B
	 Tqre5sKtvx2AXvVc+GrcsRKpS1ZIcpK+pzTfnwO00qjVBypw+fXWRKAOw060w1n/zm
	 S5B1//oucsRubcOgoYw0E+sjbJuGdpSDrZzkzp5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 231/484] drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved
Date: Thu, 30 Jul 2026 16:12:08 +0200
Message-ID: <20260730141428.497313442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Zhu Lingshan <lingshan.zhu@amd.com>

commit a2f895f3c852063258d62e9f74b081de07ca95df upstream.

amdgpu_bo_create_reserved() only allocates a new BO when
*bo_ptr (struct amdgpu_bo **bo_ptr as input parameter) is
NULL, it simply skips creation when *bo_ptr is non-NULL.
But it unconditionally reserves, pins, gart allocates
and maps the BO afterwards.

When the same non-NULL BO pointer is passed in again,
for example firmware buffers that live in adev and are
re-loaded on every resume / cp_resume / start
under AMDGPU_FW_LOAD_DIRECT, amdgpu_bo_pin() just increases
pin_count unconditionally, however the matching teardown only unpins
once, so pin_count never drops to zero, so TTM is not able
to move, swap or evict a BO, causing BO leaks.

This commit fixes this issue by only pinning the bo
once at creation, and repeated calls no longer
take additional pin references.

Signed-off-by: Zhu Lingshan <lingshan.zhu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3ddc0ae76202c447b6aec61e907b852bc94671cf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -285,10 +285,12 @@ int amdgpu_bo_create_reserved(struct amd
 		goto error_free;
 	}
 
-	r = amdgpu_bo_pin(*bo_ptr, domain);
-	if (r) {
-		dev_err(adev->dev, "(%d) kernel bo pin failed\n", r);
-		goto error_unreserve;
+	if (free) {
+		r = amdgpu_bo_pin(*bo_ptr, domain);
+		if (r) {
+			dev_err(adev->dev, "(%d) kernel bo pin failed\n", r);
+			goto error_unreserve;
+		}
 	}
 
 	r = amdgpu_ttm_alloc_gart(&(*bo_ptr)->tbo);
@@ -311,7 +313,8 @@ int amdgpu_bo_create_reserved(struct amd
 	return 0;
 
 error_unpin:
-	amdgpu_bo_unpin(*bo_ptr);
+	if (free)
+		amdgpu_bo_unpin(*bo_ptr);
 error_unreserve:
 	amdgpu_bo_unreserve(*bo_ptr);
 


