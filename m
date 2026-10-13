Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506684F4CEA;
	Tue, 13 Oct 2026 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893575; cv=none; b=NQffEU1czGdMlhq7zr89ogpJak9UbnfsHTGs7LPZ3cacJVCs2h/5aWoWG63/FOeglNPOk9U9oYbd+VpFHWDQ/+xeRzz5j5U0VUSHKaKeRGD+UOb/oItct8mG4wMYjBZuZNo3u+idc13kCwSEhOKqu2wUrIAy7fQ1+j784zpXZUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893575; c=relaxed/simple;
	bh=rQ7VCFSQQNG9bUXbnr3v7c05PioVlcCtG7k9QXEAeug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdDd/46SbR7z30oi/QGP7M+eCA1NxBFgCW4u3+egCM4S0yUKtxWs6cgncUl6NgcG5kXw86mANlh4C6zARIjRcj+eVRvjOdTmrgxXwD3s5T3qSiSJfuEO9f7pvHJgPUAFSZ7aWbXyNeB56CisQtl5ek0etMS3A7o0lzR56R8fUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuptGYVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuptGYVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF811F000FF;
	Tue, 13 Oct 2026 12:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893574;
	bh=DmglSoN640He8TbS4HcIvazfaFrwM5+CNbIBNuWqZZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuptGYVP5wByWvBqlZXxLoyR9IIQsmtLBTXvch79Mp+Sn3tfZUbSDRMR7r3Shbfkt
	 bg9nnqPT9bVjvrlLo+WAjbnUXr/jWC00mMncDMmZy9xL0ZGDlwEWkPyYGDPre1+q94
	 1YBPTmwgeCgO8WbbfMAFEMr+OY33EnZRwF1Z5uNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Honglei Huang <honghuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/621] drm/amd/display: use kvzalloc to allocate struct dc
Date: Tue, 13 Oct 2026 13:34:26 +0200
Message-ID: <20261013112927.292749407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Huang <honghuan@amd.com>

[ Upstream commit 75050390151a14802be433c3856ddcb483cecd24 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2abeb956260e4..1c312f2e128fc 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1482,7 +1482,7 @@ static void disable_vbios_mode_if_required(
 
 struct dc *dc_create(const struct dc_init_data *init_params)
 {
-	struct dc *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
+	struct dc *dc = kvzalloc(sizeof(*dc), GFP_KERNEL);
 	unsigned int full_pipe_count;
 
 	if (!dc)
@@ -1530,7 +1530,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 
 destruct_dc:
 	dc_destruct(dc);
-	kfree(dc);
+	kvfree(dc);
 	return NULL;
 }
 
@@ -1580,7 +1580,7 @@ void dc_deinit_callbacks(struct dc *dc)
 void dc_destroy(struct dc **dc)
 {
 	dc_destruct(*dc);
-	kfree(*dc);
+	kvfree(*dc);
 	*dc = NULL;
 }
 
-- 
2.53.0



