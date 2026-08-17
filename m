Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8C40F8DF;
	Mon, 17 Aug 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975697; cv=none; b=AoEmMyNaaNjsJsVgfHQlLRY79tzuvxOP7B1LsARrRrz+EqaabmiR0R9/eHq5bgDsez698AyXK+8DlAL0z+wCa2JRxbd8L4beDPxYxOSGfmjFo6JdOk1O0STQ6b/M48wXbRXxiwBdDKjTGZwFXwPtVVRjM4baXdo3M3go4gpUTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975697; c=relaxed/simple;
	bh=vMw9oVx/mBpyBObgZLW/OmVJqrLrMXUiEwGIlhIzYLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1jRceBWFbBqA5cA02oyilahrTOnHLQh8dzcWUQ+sbswwDMB59w9x1cYc24DDZzDF7fCZoiCfflbltZXaNjv9G3r0HYS4hiUmKnimq1b4Mmvo2d92RZBSwh8kIetC2wdnjLtZ04uFH8qcabWi/2iXIPj4qfDOtWsWb3WXA9Oeqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7/Z6uL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7/Z6uL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82F71F000E9;
	Mon, 17 Aug 2026 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975696;
	bh=ZIOfF8AH3kcaAawO4ZS8pYvJz3l7q9Mgs4BtJc9i4sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7/Z6uL5RULTipXlBZOIZJVhRdhdsIaZ6soaIZ0hl/4vunuZE6z48kCNWK/HZ8yvz
	 O9PE1zQ0DCTM+7ao1C5QR6nynhWHzaf/x394LsLgI4V7zoiG5mGca8nRAEqIgYYFu6
	 kVM4juU1/+6NpoGdxaEKIUj48wlddsGmAszu0e2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.10 118/389] drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved
Date: Mon, 17 Aug 2026 15:29:17 +0200
Message-ID: <20260817132543.770136836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -275,10 +275,12 @@ int amdgpu_bo_create_reserved(struct amd
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
@@ -301,7 +303,8 @@ int amdgpu_bo_create_reserved(struct amd
 	return 0;
 
 error_unpin:
-	amdgpu_bo_unpin(*bo_ptr);
+	if (free)
+		amdgpu_bo_unpin(*bo_ptr);
 error_unreserve:
 	amdgpu_bo_unreserve(*bo_ptr);
 


