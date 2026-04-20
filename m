Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C1F3A5E76;
	Mon, 20 Apr 2026 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691551; cv=none; b=BjHSm9JsA66cZkskLHLf1lsf7dNilz3FPdsIaiCEFKMx0lv6Ob/sMkO0YVpdD120Z2+J1/dk6fn94xTtl1e2ZTQjneeckHyUO6MSKO84tAStrvAHDsewCoCEiGKbkQukrXGPgW1guOvGqdHdCSamPkjwHJjHtmFkQIWTiAoOzi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691551; c=relaxed/simple;
	bh=ycZpoJi5BaOEeOASo6A14ji3O9M03WqM/G9Lrtm/gu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldieklqbxXFcItX2Uha6EVG5jfe0nH8IAFA1Ig1SIMauTLPZMOUsxMfsgyHrt49OBgwY6gwVgqYvBq4UxsHuU8sL+/VcQ8D6izxx0h+QPfRg4I3F3hOWJGPs3An32GD4EKAk2qNNBARp3112RQKGTqJbvlGsrsEBfTqIL47d9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVOzq3Pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVOzq3Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB0C19425;
	Mon, 20 Apr 2026 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691551;
	bh=ycZpoJi5BaOEeOASo6A14ji3O9M03WqM/G9Lrtm/gu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVOzq3PpYNbxyGrduKrTo1dKhRf3WJl+4v6PzgbvPsKlKTNoHH/WiIHH97LJAmnBF
	 9LJlL05lcDoh8T2eGXSbgEL+Cl47BqBwrJCORselGqXs6WgSCns/TRw0kvxvbBzzqP
	 5p8oTGdEr4hggfso9JyBqhRbmdZMBYgEW+zMiHA6639Zm+1E5KdlTsg0Nn5/HtZSoV
	 giFVe0k1B56RgVSBsuxayWJeWhoVodKoaVkcfHtDbNji3m8LmvFTxQjlxk2SkP4YST
	 yh77HArNjLTkajwwD0GZOwypI5csSkxSGUQ4M2mvtRxGjMEOZS+X2lwqh1EkJDpDmU
	 ZT68fQEAJIfLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: Handle GPU page faults correctly on non-4K page systems
Date: Mon, 20 Apr 2026 09:18:09 -0400
Message-ID: <20260420132314.1023554-95-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index f2e00f408156c..69080e3734891 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2960,14 +2960,14 @@ bool amdgpu_vm_handle_fault(struct amdgpu_device *adev, u32 pasid,
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

