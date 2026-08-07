Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68CC18E02A;
	Fri,  7 Aug 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115768; cv=none; b=JRJSACNRbY9JpyNlS0GB+RJKeZ1aW+EwTXe/i/gcz9utVhTueobzaHmVfDV3AoD6tpofky8xq+5HTmAUJvman6gvFV8tIBzNvj6VbHdo0+NQQKkKuIGhR6TPRlpZ6FApduer7gPjDgjiROGiUc4oy04GG9WvDqaDwh3R/ljhoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115768; c=relaxed/simple;
	bh=muujkqlRhikUnKMTFBb1v9ef58p1jV4MbsApsBrJQSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8CH+3kqYSQ5CVJztZCfKnyHtPVvbIfpLJMcynNNekVAssrNIXpr/G2Ri5heqiqhNohcOnYlzECc2AIEMXrDcCQH1YW9tRS0JRRQ1r84cnJydPEy+XBlf11MTPd9/oo7C2usmK+3tLWTrw9icJrBgzNCgZQc18S/L6SrJDanNT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pl+Lf+42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pl+Lf+42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEEA1F000E9;
	Fri,  7 Aug 2026 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115766;
	bh=zIQk3FjvmCnuFWMGq3bGXVRtthy34KfkwuGYAWxZHA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pl+Lf+42QFg979AcIDPbOB3/n/EdM/AFfD28mVqueOdvkXAnigQ2PcZGcdu20LSmQ
	 VwxVnWngnRdaDihR8Q6E6PJs9Xq3EwBiSr9AlOOf7L95D9cxfGajvss1jxnvmzHaT6
	 AZTN/CWkEvesu69H/6p/o0kFbHIM9aqFJRypQw4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 383/396] drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC
Date: Fri,  7 Aug 2026 16:39:03 +0200
Message-ID: <20260807143432.539366266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 7bc597ce74bab4153b2009c92eccf889e9d74044 ]

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
Signed-off-by: Review <review@local>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3032,11 +3032,26 @@ static int op_lock_and_prep(struct drm_e
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


