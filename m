Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405FF33B6EF;
	Mon, 20 Apr 2026 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701266; cv=none; b=AwFjP9gqCXUwCx/AyaZF+PPiROJ4QrdKC9uBvcWQ1xQlFUGDYkqHUCAMlUcwN2wKa623A5pU9RypS4yIFocQ2pJp6PS6IKCPKc37+9cKtgtyUwi6e2qI7yXglLseRMKcR0PvKlzbfQ70KxL+B2LymlecaNbCmCSXVnpRGqNU/eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701266; c=relaxed/simple;
	bh=uXB4yOuhDxA5Ct4XQUcIE25z199aGQ9XQPr+PC2UDjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5TtRc/MD5zsIG+Jx1zB/SEp1kCowkdw7MyeirMms84xuKvUqzpnrl4iYziNX4Rt5lvVemW430T2gWQZ5Lzl9/5u9PLCvn1C8OZD3Xwq3OwlyreWF/Qq0fERNP/Kt7oZAlMn8Ldeb1TKwOMRB/jqcX6Whx7eWbrUQJKFjcuyeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udsDVVi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udsDVVi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8443C19425;
	Mon, 20 Apr 2026 16:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701266;
	bh=uXB4yOuhDxA5Ct4XQUcIE25z199aGQ9XQPr+PC2UDjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udsDVVi7Y4PPgPKU7u78p6MvCoOKwJWQANWAu+t0qTaW/d6Kydj6dpb2DjsYAxuTy
	 k1ionRBCXtLZ3RlXBDkMdXeGIhA2Afm04ZsUSy42zzTyZ5tmMEn5qhdsL7Igc7VMhi
	 /ZUvgQaVq6EV/XYxcoalIQ9x/FnT/oksDzF/+wgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/162] drm/amdgpu: Handle GPU page faults correctly on non-4K page systems
Date: Mon, 20 Apr 2026 17:40:46 +0200
Message-ID: <20260420153927.533705162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 4e9597f22a3cb8600c72fc266eaac57981d834c8 ]

During a GPU page fault, the driver restores the SVM range and then maps it
into the GPU page tables. The current implementation passes a GPU-page-size
(4K-based) PFN to svm_range_restore_pages() to restore the range.

SVM ranges are tracked using system-page-size PFNs. On systems where the
system page size is larger than 4K, using GPU-page-size PFNs to restore the
range causes two problems:

Range lookup fails:
Because the restore function receives PFNs in GPU (4K) units, the SVM
range lookup does not find the existing range. This will result in a
duplicate SVM range being created.

VMA lookup failure:
The restore function also tries to locate the VMA for the faulting address.
It converts the GPU-page-size PFN into an address using the system page
size, which results in an incorrect address on non-4K page-size systems.
As a result, the VMA lookup fails with the message: "address 0xxxx VMA is
removed".

This patch passes the system-page-size PFN to svm_range_restore_pages() so
that the SVM range is restored correctly on non-4K page systems.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 074fe395fb13247b057f60004c7ebcca9f38ef46)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 13252c27cf55e..a29d01202b5b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2806,14 +2806,14 @@ bool amdgpu_vm_handle_fault(struct amdgpu_device *adev, u32 pasid,
 	if (!root)
 		return false;
 
-	addr /= AMDGPU_GPU_PAGE_SIZE;
-
 	if (is_compute_context && !svm_range_restore_pages(adev, pasid, vmid,
-	    node_id, addr, ts, write_fault)) {
+	    node_id, addr >> PAGE_SHIFT, ts, write_fault)) {
 		amdgpu_bo_unref(&root);
 		return true;
 	}
 
+	addr /= AMDGPU_GPU_PAGE_SIZE;
+
 	r = amdgpu_bo_reserve(root, true);
 	if (r)
 		goto error_unref;
-- 
2.53.0



