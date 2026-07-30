Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96638443A8A;
	Thu, 30 Jul 2026 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422342; cv=none; b=L+F0+ER6CY4WCbDLtCP9cCUMvGYr4GOVk0EKMKMEyrTMo/e96u3M21YbHzMIiBCUjKeaBiyOuO+skaDLiNTu6AXoVbkCa31qFoD2bpidwGdaLETT8b4I880vOIhG7oUf3muQBpO8gXlErNxo+Ikvharh3HJCln/ilkLpRsyniUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422342; c=relaxed/simple;
	bh=YqSobrbzejy8zWHfpyLgh/f4LRdcVKGTqc8+RgYsQ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nL59LYNSF6asRfd2b0ltkjqRCd6xnSS5SJLnqemBeFZnCYkakNN+PslbRIeiJZg4vk6izPQcMbSz+lxYQGK5uGAhhlRKZ0mJ8RQzOPAvPZUczPX/uQIEkdsZn4lGbHOf3OnxZXpYBR89F9PCWVqF1Il0WsWERemR/a80omPYjhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRWk4Us4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRWk4Us4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07C11F000E9;
	Thu, 30 Jul 2026 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422341;
	bh=Vpet26Ou2hoYnBg1a2RP8xab9zKxgbZkgA9lUoHZZqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRWk4Us4RKuYp4IlJB0LZFDns9Y8Ea/4qjafNr/jsbFr2dZXmi5s7WiE3Bkvk3BQZ
	 1OcNZjrqE/K3sb255iJzQUlpnwVm3/BFm5mrKQIJ5grmnoBmagG4/7t8HrjsZgCPsQ
	 8H/GLDmIAYdS8A2dUDdNtapbZvMkzdG0OOgPbHcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 403/744] drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC
Date: Thu, 30 Jul 2026 16:11:16 +0200
Message-ID: <20260730141452.858712478@linuxfoundation.org>
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

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

commit 7bc597ce74bab4153b2009c92eccf889e9d74044 upstream.

When prefetch region is DRM_XE_CONSULT_MEM_ADVISE_PREF_LOC for a BO VMA,
the code used it as an index into region_to_mem_type[], causing an
out-of-bounds access since the value is -1.

Resolve the preferred location for BO VMAs directly: local VRAM on dGFX
(using the BO's tile placement) or system memory on iGPU.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

v2:
-Fix null dereference

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: c1bb69a2e8e2 ("drm/xe/svm: Consult madvise preferred location in prefetch")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20260624174943.2808767-2-himal.prasad.ghimiray@intel.com
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
(cherry picked from commit d9a4906ac03be9f6ed3f3b45c56c866b867fd75b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3256,11 +3256,26 @@ static int op_lock_and_prep(struct drm_e
 						    .request_decompress = false,
 						    .check_purged = true,
 					    });
-		if (!err && !xe_vma_has_no_bo(vma))
-			err = xe_bo_migrate(xe_vma_bo(vma),
-					    region_to_mem_type[region],
-					    NULL,
-					    exec);
+		if (!err && !xe_vma_has_no_bo(vma)) {
+			struct xe_bo *bo = xe_vma_bo(vma);
+			u32 mem_type;
+
+			if (region == DRM_XE_CONSULT_MEM_ADVISE_PREF_LOC) {
+				unsigned int i;
+
+				mem_type = XE_PL_TT;
+				for (i = 0; i < bo->placement.num_placement; i++) {
+					if (mem_type_is_vram(bo->placements[i].mem_type)) {
+						mem_type = bo->placements[i].mem_type;
+						break;
+					}
+				}
+			} else {
+				mem_type = region_to_mem_type[region];
+			}
+
+			err = xe_bo_migrate(bo, mem_type, NULL, exec);
+		}
 		break;
 	}
 	default:


