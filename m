Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356E63932E9;
	Thu, 30 Jul 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427563; cv=none; b=h3xl5LAMfFE4vNFrxy4+rCWeLqKPlHcIVGKbXaPFwYK6YR/TQmTAQY6vh4IY381danh4tDyaL8LcjwdM9t4t96Xrh7hrcXj9cJEImZgCZX2EbLM3nu36I4TF0larW1mS6zAry0e2/B4I0CXp/TfucrPT0vk4MnsVrU8EKWG4AVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427563; c=relaxed/simple;
	bh=6lcS5mcx+0IL42aHZqHhh5SufHEmzOgdAaDMceAD8hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOx9+dTXqAyY8RhGpPDWw1boFNEAsNpPsuhs0XOkanBL3zchvsvTVbuyNlxqGirQl7HWFFsY06gcVsck5mli3M4GTWkUtLVTSB5iZG3W6ymCRrprwLiinPthbXR3TkgPCvbRn4Cb3v/UHgGWS65bTSsh9E2Ouy55zl2Z5FCsZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrZseubm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrZseubm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B065B1F000E9;
	Thu, 30 Jul 2026 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427562;
	bh=Qdv+Lg4zkTlVeMxrGoV/+ZdOMuhyFicnjxxK5Gg/HJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrZseubmprCaH4/iXP9Xlqqt4hReQomOt6IYf16j0Rm3MHGfJAituuiwO7g/vwgY9
	 2qR0gQ3ht8QWq7Bpp5d8CU8BajQaECjXA+5i5Kt4nuvsDq/rpFLv8Hra1dyl90msDy
	 NM8TK/7L9ynIVlJl+4AT9mQ3dyHctBRKov4tLjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 213/484] drm/amdgpu: validate CP_GFX_SHADOW chunk size in CS pass1
Date: Thu, 30 Jul 2026 16:11:50 +0200
Message-ID: <20260730141428.100569255@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 84c4c36acd5c4b2558b5069f869a165b2c655c84 upstream.

Add a minimum-length check for the AMDGPU_CHUNK_ID_CP_GFX_SHADOW chunk in
amdgpu_cs_pass1(), matching the gate already present for the IB, FENCE and
BO_HANDLES chunk types.

The CP_GFX_SHADOW case previously shared a bare break with the dependency
and syncobj chunk types, which do not dereference a fixed-size struct. When
userspace submits this chunk with length_dw == 0, vmemdup_array_user() is
called with size 0 and returns ZERO_SIZE_PTR, which passes the IS_ERR()
check. amdgpu_cs_p2_shadow() then dereferences chunk->kdata as a struct
drm_amdgpu_cs_chunk_cp_gfx_shadow (reading shadow->flags), faulting on the
ZERO_SIZE_PTR and causing a NULL-pointer dereference.

This is reachable by an unprivileged process in the render group. Reject
undersized chunks with -EINVAL during pass1 so the bad submission is
rejected before pass2 ever dereferences the data.

Fixes: ac9287055ff1 ("drm/amdgpu: add gfx shadow CS IOCTL support")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7f61b2eef7415eccdb40850aca0de94211948657)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -272,13 +272,17 @@ static int amdgpu_cs_pass1(struct amdgpu
 				goto free_partial_kdata;
 			break;
 
+		case AMDGPU_CHUNK_ID_CP_GFX_SHADOW:
+			if (size < sizeof(struct drm_amdgpu_cs_chunk_cp_gfx_shadow))
+				goto free_partial_kdata;
+			break;
+
 		case AMDGPU_CHUNK_ID_DEPENDENCIES:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_IN:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_OUT:
 		case AMDGPU_CHUNK_ID_SCHEDULED_DEPENDENCIES:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_TIMELINE_WAIT:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_TIMELINE_SIGNAL:
-		case AMDGPU_CHUNK_ID_CP_GFX_SHADOW:
 			break;
 
 		default:


