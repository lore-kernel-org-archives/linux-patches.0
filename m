Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABD92C026C;
	Sat, 17 Oct 2026 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254336; cv=none; b=dkh8xkF+0Dss0KbHBTsDb1gHx7MKsysq1hGoPAIKiWkkwyeDiBcI1cq8rTues0O07RCHd3B7Dmqa5YuDkL+1i0opJG0RMEqtjIl0Y/5WDLHft5IcTJlCLHwe7z9DRnW8yLjdWw7ZYYOV/y5VXcx6WbUcp0dLhySEWWs8coo1h38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254336; c=relaxed/simple;
	bh=pbUKzbjcayISs7eTgdtOSmiewaxpi0cusHTFQL51vLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAFyQTCsZYOqsXtNgVo73U2XcUom+By/TMkxu+nKPx86YH1d3IhTzsbX5nA22RW/5bOYduGeKJTzfJfOikJTK5tyUfDTUwQomUOvkfZohZNzulBjku4cXPqzCJXRxrUo5bBGCdv6hXi3a22xbbP0JvlJmfiFFE1igi6jFr29fYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJOnW4GS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJOnW4GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11C31F000C4;
	Sat, 17 Oct 2026 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254335;
	bh=pkDGDeKD/QZkTgyN5OX3elM/zVzglilfvrE5hQ/fDMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJOnW4GSDT8o2FOs/yO/5HNFWiuaWvwqt9DngZ/JhKMsXDdNn7e3zi8bu5ZxB0KlH
	 IzjgdpzFtZBt0Fez0q66gxo8XagC0H2XUa+peEqh4ITjaIRE9QqR2hR+7/+4ix8PbT
	 piy+e/0iyheg4E4c9uzYRmD/HS+SjUGgUPcs9JkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Honglei Huang <honghuan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/869] drm/amd/display: use kvzalloc to allocate struct dc
Date: Sat, 17 Oct 2026 17:54:13 +0200
Message-ID: <20261017160047.698430972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 070cca8b521b6..ad1cc546ba48d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1377,7 +1377,7 @@ static void disable_vbios_mode_if_required(
 
 struct dc *dc_create(const struct dc_init_data *init_params)
 {
-	struct dc *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
+	struct dc *dc = kvzalloc(sizeof(*dc), GFP_KERNEL);
 	unsigned int full_pipe_count;
 
 	if (!dc)
@@ -1425,7 +1425,7 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 
 destruct_dc:
 	dc_destruct(dc);
-	kfree(dc);
+	kvfree(dc);
 	return NULL;
 }
 
@@ -1474,7 +1474,7 @@ void dc_deinit_callbacks(struct dc *dc)
 void dc_destroy(struct dc **dc)
 {
 	dc_destruct(*dc);
-	kfree(*dc);
+	kvfree(*dc);
 	*dc = NULL;
 }
 
-- 
2.53.0



