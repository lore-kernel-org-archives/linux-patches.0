Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD98335566;
	Thu, 28 May 2026 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999175; cv=none; b=lFJIEMPi94NSWk71CznttNNWaLOGFikyqCHpApGxYshfP8PyfA+S32rwjJxwwviKq/Kg21IrsPoqmWwRQ9xBgRwhgL7+7vb9J0lPcsv4Yx3oTXI3svXkAVtKRfnBnmEi//tjLNl22BCIbkVDqnhan7Jkxus3xoVv6kW5HEDZqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999175; c=relaxed/simple;
	bh=JjFbkMBQ663BbMZ0WJeWw6FAnLDSudBAbHqE4LXhvfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QvXERDjLrZreba/IAPooMmAeyoRh44PxF6WXFtcpl/f/ijlWlbtWUN6dzCbLNQ7XshP/tkp+CgwSMu3neKyI4TkicaBAsLfSCgUiEL+IKbN+9Ph9hIF4fX0LaBva+ULZ8r4b+s8tmaYY3zYMfKMqUIlLvDGA19y9uS0shJU/ex4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIyUqaQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIyUqaQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267351F000E9;
	Thu, 28 May 2026 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999174;
	bh=DQg5v20c7Z77dsjFLPZp6AHuCysRNAjRWOKUNGUYqSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIyUqaQwE3QrTjA0bJCsHiAqHWw9bedq+UMjLgvaHRlEiHSCmHxqZPzTmAiFrmWdd
	 vXfNF9qeVNRwWHKmNtvpurGnMCKlLZmpeOZmi0D2CCkcp9PoFKtosHP2i7NLWaggJj
	 dcg8BxYeK/HKiX9CekGMl9GGT7TL5vF+p7su0D2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 398/461] drm/amdgpu: Align amdgpu_gtt_mgr entries to TLB size on Tahiti (v2)
Date: Thu, 28 May 2026 21:48:47 +0200
Message-ID: <20260528194658.991932281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 4d798ea0712fddbd35b439cef32b8ac735eb76f9 ]

The TLB is organized in groups of 8 entries, each one is 4K.
On Tahiti, the HW requires these GART entries to be 32K-aligned.

This fixes a VCE 1 firmware validation failure that can happen
after suspend/resume since we use amdgpu_gtt_mgr for VCE 1.

v2:
- Change variable declaration order
- Add comment about "V bit HW bug"

Fixes: 698fa62f56aa ("drm/amdgpu: Add helper to alloc GART entries")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 530411b465ef0b2c0cc18c2e3d7e38422b1117d1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
index ac276bb53c7c2..9dd6cfd6c0fe0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c
@@ -199,11 +199,18 @@ int amdgpu_gtt_mgr_alloc_entries(struct amdgpu_gtt_mgr *mgr,
 				 enum drm_mm_insert_mode mode)
 {
 	struct amdgpu_device *adev = container_of(mgr, typeof(*adev), mman.gtt_mgr);
+	u32 alignment = 0;
 	int r;
 
+	/* Align to TLB L2 cache entry size to work around "V bit HW bug" */
+	if (adev->asic_type == CHIP_TAHITI) {
+		alignment = 32 * 1024 / AMDGPU_GPU_PAGE_SIZE;
+		num_pages = ALIGN(num_pages, alignment);
+	}
+
 	spin_lock(&mgr->lock);
 	r = drm_mm_insert_node_in_range(&mgr->mm, mm_node, num_pages,
-					0, GART_ENTRY_WITHOUT_BO_COLOR, 0,
+					alignment, GART_ENTRY_WITHOUT_BO_COLOR, 0,
 					adev->gmc.gart_size >> PAGE_SHIFT,
 					mode);
 	spin_unlock(&mgr->lock);
-- 
2.53.0



