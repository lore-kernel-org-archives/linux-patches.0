Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0705744211F;
	Thu, 30 Jul 2026 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424417; cv=none; b=VhCN5cPJ6QbuYw0Vb7t2fHp0THbt6r5kWY/irrhd1P9KUcF+PizcKeme57J1pb4hvtjzGsOCeSgPQhIWfRtRftU4tBHDcwvYHzSD4o1lInielJ0UKj0s4NOsUeKdQI9iLpCQGQsH9P8ykYc7HUiqYR4DcC5F98jjzpva7l8K4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424417; c=relaxed/simple;
	bh=54TODoo40CcMq8nJ7DVPo7Vy/KH29g8A742ydF/OcBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUGxpsxLsIGQgF5K2QJSu1xlXJN+tOBZ0SI+tusekd6+SYpuV4LTPByOUPO3UG4omRQ5iLa4DXUKcYSeS0Jc4DLCZH3LaRQrWGd7rdqOe24DiHlqGuyp+DPUPIZLl5M5GWowJ6S7SQ0XRTFxlHxEYMYLN8G8vNtebnHOrRIemMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+NVl8X6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+NVl8X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E38F1F000E9;
	Thu, 30 Jul 2026 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424415;
	bh=vSuuuqLDtFAKfQv2SrQ6ODv6WMI3VoyhEbs1XivjxPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+NVl8X6N7/4nBPp69hThddvQZ+4xGlR8q8H+Wa5C/Bm42XTx0hEL6NLuscDdV+ru
	 jcIvUUww6G345KC0r8WY4yVmL5oLDhUZzw4t99GVaolWbqzH3k75GwHF8w8Lc7riYf
	 0UURMgmx0N/kWA+bBPWiBifdSeCG9yXMVYVSvXPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.18 386/675] drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved
Date: Thu, 30 Jul 2026 16:11:56 +0200
Message-ID: <20260730141453.339328781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -284,10 +284,12 @@ int amdgpu_bo_create_reserved(struct amd
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
@@ -310,7 +312,8 @@ int amdgpu_bo_create_reserved(struct amd
 	return 0;
 
 error_unpin:
-	amdgpu_bo_unpin(*bo_ptr);
+	if (free)
+		amdgpu_bo_unpin(*bo_ptr);
 error_unreserve:
 	amdgpu_bo_unreserve(*bo_ptr);
 


