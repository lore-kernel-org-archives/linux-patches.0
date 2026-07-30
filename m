Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4386E439902;
	Thu, 30 Jul 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422580; cv=none; b=od4budO4Gna4aladfEYL2r6rJwegMA4GcGLKkZrL1evTE8Cfw9eKZVBvFllCMK1PRU36Yn962l/Re5aVPeNUReafcX3e6aBX8n2LHmVeDHweAQ2Lt0WD4SMGvtuQHgD66acjiKuf+JxyAlOuSMf+9n8MFId2IKeldKoS7zxkgQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422580; c=relaxed/simple;
	bh=0r/9Cwv3/fgjJEfuScRkhLBDcFlEQVDIKwZKu1UvBLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFjrgeRwPMGf2gs3wTcYJDueQaTh7mYVTvLXIXmxdL99we9ypTnFtPgwq2AMu+Z4wjzrc6S/TZLkXEaX9eBJk6XZvwpd2wYfOsfrMKJW2JVl0Z3rIgMvcdX2TCbk25l6SinrfNA9dgnp1IwC4HpvQ9ZzNV2g/QPmVNS366S/0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcUZIhRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcUZIhRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E87F1F000E9;
	Thu, 30 Jul 2026 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422579;
	bh=4NfeTBZXciGfVrDERqh4KsYOfWsnetaXU5faaUmBBk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcUZIhRekFFGa6f8757QX8hTrFCUFrEIj9qJZFMPr1s4ZoLsobr+tKE8MqABhlBb5
	 KP/t0u/8YkgEllOLk/Wqm/czqkiq4+Yo8pSXmrhKcLO54Jw4hvfzs5dRIU/iyKafpi
	 6VXuKT0BHdX6JttcOEqnZV3egRho3SAZ/Ve6oaAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.1 460/744] drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved
Date: Thu, 30 Jul 2026 16:12:13 +0200
Message-ID: <20260730141454.074518376@linuxfoundation.org>
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
@@ -276,10 +276,12 @@ int amdgpu_bo_create_reserved(struct amd
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
@@ -302,7 +304,8 @@ int amdgpu_bo_create_reserved(struct amd
 	return 0;
 
 error_unpin:
-	amdgpu_bo_unpin(*bo_ptr);
+	if (free)
+		amdgpu_bo_unpin(*bo_ptr);
 error_unreserve:
 	amdgpu_bo_unreserve(*bo_ptr);
 


