Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D186235CB60;
	Fri,  7 Aug 2026 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116330; cv=none; b=hbcU4E7agusgUr8b71KjE1NrcnaIpYU1sJp0BECl4WYZcjCtpp05X9xn3i3MtWEB4XGBoCElT3KNDeqQxArrS5Uh7MpH9DV1bvZkI7s9OIloHcl/eFWZoPuhnVQLM1AyfZny+9TsG3cQAWoYFSBLgTD295N3WXAmPg6+1IzKI+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116330; c=relaxed/simple;
	bh=N/dQNo9pNWz3VjkCVc04lXpbsRyHZJCWJHdwaRal3/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqa4S0Biq+nBDtepgWx2Q/nY41I3jM+DgxVzFjU9VLwiNpYF0L7AKDbFOOFfnWw/KlFS2SfV6Q2C8BNOd2RJyDRzWDv4vCUE/da5A+ZnW/+jTcLmeKZxEPIYIFHEh5eT7A7bCgElsjJUUOT67Cz5+OaDTDHLDxWmRiW9gbw9MlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLt3R7Xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLt3R7Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B7B1F000E9;
	Fri,  7 Aug 2026 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116328;
	bh=gUbZQHbk0lhMoQqb7lUMaR7WSq0HNviXjLtOUGY2yZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLt3R7Xy3ms3cHfKhl88jGCZm9SPksXEc1vQOMU7Noqh1FyvAi4DVdEqJHr/5G1s/
	 Fwr0esCGbOjg7kvGyhvdKaNXidr/r+32lCwi0ZOACnjekeet3KXyGhprpqP76HHd4e
	 zVSXKQFMxYqjQi4u4UaY/KwSe2uMHBOOqVbLFis0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harkirat Gill <harkirat.gill@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 192/261] drm/amdgpu: cap GTT size to physical RAM on APUs
Date: Fri,  7 Aug 2026 16:39:09 +0200
Message-ID: <20260807143419.509858287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Harkirat Gill <harkirat.gill@amd.com>

commit 5e70f6804b4d6256058c360b10e044ee04ea4a4e upstream.

On APUs, the GTT pool is backed by system RAM, but its size is not bound
to the non-carveout memory that actually backs it. A user can end up
with GTT + VRAM exceeding total physical memory through the following
sequence:

 - Have a large non-carveout memory space (~128GB) and accordingly set a
   large GTT (~100GB) via the ttm module parameter.
 - Lower the non-carveout memory space in BIOS by increasing the UMA
   Frame Buffer Size (VRAM) to 64GB.
 - The previously set GTT value (~100GB) persists, even though the new
   non-carveout space (64GB) can no longer back it.

This leads to a case where kernel reports GTT (100GB) + VRAM (64GB)
despite the sum being greater than total physical memory (128GB).

Cap the GTT size to totalram_pages() on APUs. totalram_pages() already
excludes the VRAM carveout, so the resulting GTT can never exceed the
system RAM that actually backs it.

Signed-off-by: Harkirat Gill <harkirat.gill@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Assisted-by: Claude:claude-opus-4
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5dafdd649280c7dc6c22c8f877da3f54fcc441e1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1976,6 +1976,18 @@ int amdgpu_ttm_init(struct amdgpu_device
 	else
 		gtt_size = (uint64_t)amdgpu_gtt_size << 20;
 
+	/* Cap GTT so that it does not exceed total physical RAM. */
+	if (adev->flags & AMD_IS_APU) {
+		u64 phys_ram = (u64)totalram_pages() << PAGE_SHIFT;
+
+		if (gtt_size > phys_ram) {
+			gtt_size = phys_ram;
+			dev_info(adev->dev,
+				 "Capping GTT to %uM to not exceed available system memory\n",
+				 (unsigned int)(gtt_size / (1024 * 1024)));
+		}
+	}
+
 	/* Initialize GTT memory pool */
 	r = amdgpu_gtt_mgr_init(adev, gtt_size);
 	if (r) {


