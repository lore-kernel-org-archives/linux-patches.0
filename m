Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC17442FBF;
	Thu, 30 Jul 2026 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422384; cv=none; b=EJJoTABQlsngBFZMOBDbjz0dQdYSSxaYD4pWFp8HwjxuYDh3fT/nFGCLyFCSttoOKCcG3RtOCe0KVZyhlFYppRanc+pyOE5Q6XPQE++K7KnXjibH/uHjdYS5MRIuhO3gpk+WOtm5vE+dimzFEQq7Uo9Iw7CBxqvmRZNhBsIgslI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422384; c=relaxed/simple;
	bh=Y048KzgToTRaC6/wc00uq0JefuKZqnc94hKbpqcv2hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rISn0btZEVL2CwQmdolsxoP08yFXTtN3eSHqpum0rmJGBNZNsEzyy2GpL37BCEbcrx0dL2qFd7vaCMZ+y2DyB13wCDEoajlY6R0SqNGZhbEyxL/CZEX7eeNQIyYSQHWMFbiddlFQQOk+7MWj/8DV8p4Zg7huT4QDreBj6Ev1i1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eRTWIaP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eRTWIaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4141F000E9;
	Thu, 30 Jul 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422383;
	bh=pJbYqRXlWXtrteeQy2HXaJav9DgO34bzIor5FCTbfuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eRTWIaPd2bvDr36yIRmwQjxvIDNMOTLuKYP5D5YNxuwMbQhUfhZ54u9tYgltCXfM
	 0UC75MoycbDR7C4LJBj/PL6deD7c7HCiI/KJcwbo8S/tPVmFrWUO2HKQzp4o6HUllk
	 cTmDmU+jH09bBUH1gxVmIlGSAyBSePQkI8NxA4A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Honglei Huang <honghuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 420/744] drm/amd/display: use kvzalloc to allocate struct dc
Date: Thu, 30 Jul 2026 16:11:33 +0200
Message-ID: <20260730141453.223596495@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Huang <honghuan@amd.com>

commit 75050390151a14802be433c3856ddcb483cecd24 upstream.

struct dc has grown large over time (most of it the two inlined
dc_scratch_space copies) and now sits close to the page allocator's 4 MiB
contiguous allocation limit. Its actual size is not fixed by the source
alone, it also depends on the compiler and the .config, so it can easily
cross 4 MiB, e.g. with a newer GCC or a config change.

dc_create() allocates it with kzalloc(). Once struct dc exceeds 4 MiB the
request is rounded up to order 11 (8 MiB), which is above MAX_PAGE_ORDER,
so the page allocator warns and returns NULL. dc_create() then fails, DM
init fails and amdgpu probe aborts with -EINVAL:

  WARNING: mm/page_alloc.c:5197 at __alloc_frozen_pages_noprof+0x2f9/0x380
   dc_create+0x38/0x660 [amdgpu]
   amdgpu_dm_init+0x2d9/0x510 [amdgpu]
   dm_hw_init+0x1b/0x90 [amdgpu]
   amdgpu_device_init.cold+0x150d/0x1e13 [amdgpu]
   amdgpu_driver_load_kms+0x19/0x80 [amdgpu]
   amdgpu_pci_probe+0x1e2/0x4c0 [amdgpu]

dc_create() then returns NULL and DM init fails, which aborts the whole
GPU init and makes amdgpu probe fail with -EINVAL ("hw_init of IP block
<dm> failed -22"), leaving the display unusable. The subsequent
amdgpu_irq_put() warnings during teardown are just fallout of unwinding
a half-initialized device.

struct dc is a software-only bookkeeping structure that is never handed
to hardware DMA and is only ever kept as an opaque pointer, so it does
not require physically contiguous memory. Allocate it with kvzalloc()
(and free it with kvfree()) so that the allocator can fall back to
vmalloc() when a contiguous allocation of that size is not available,
which also avoids the MAX_PAGE_ORDER warning entirely.

v2:
 - Rebase to amd-staging-drm-next.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5406
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Honglei Huang <honghuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 991e0516a8072f2292681c6ae98a924ab0e32575)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1507,7 +1507,7 @@ static void disable_vbios_mode_if_requir
 
 struct dc *dc_create(const struct dc_init_data *init_params)
 {
-	struct dc *dc = kzalloc_obj(*dc);
+	struct dc *dc = kvzalloc_obj(*dc);
 	unsigned int full_pipe_count;
 
 	if (!dc)
@@ -1555,7 +1555,7 @@ struct dc *dc_create(const struct dc_ini
 
 destruct_dc:
 	dc_destruct(dc);
-	kfree(dc);
+	kvfree(dc);
 	return NULL;
 }
 
@@ -1604,7 +1604,7 @@ void dc_deinit_callbacks(struct dc *dc)
 void dc_destroy(struct dc **dc)
 {
 	dc_destruct(*dc);
-	kfree(*dc);
+	kvfree(*dc);
 	*dc = NULL;
 }
 


