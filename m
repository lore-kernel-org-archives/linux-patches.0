Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671032C2340;
	Mon, 18 Aug 2025 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526170; cv=none; b=jpa1wRaPBrEFOwSWpxLXhKqda4dfCdNq07zW7FLzOAImmzfcf563holfPgG3lBt7+SoQl6YPbSUzkR/RCQQ2AUB3O0QxiKFtIl0E5hwyKwktoUEGrMFaR/iAJY01jzRcaNT07q7Aim02Cd2321QulCblpInvJpQAzc7QIgubOs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526170; c=relaxed/simple;
	bh=UqBH+/pjXY9kJh8/82fFDPBpwIw6dOMeMvrzpfekl+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC7LPXZPES7lPuM120YXQsniI9G1OLyNlbNmGgk+cOrT7VTGGho5HKFfBGvlzulh8dQ64p9fcJvHcH/LFZqhx7f6jye4nxQ93rOiNKUFCKXtZhQLTc8JIYIXaBczE+GlyNELzvXMwK2Yi5dDJjRPO1Pyw2vM4CRaVrctPqXhWqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYgc9PSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYgc9PSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2A6C4CEEB;
	Mon, 18 Aug 2025 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526170;
	bh=UqBH+/pjXY9kJh8/82fFDPBpwIw6dOMeMvrzpfekl+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYgc9PSLhHHB05NxddGFsvMCDhGuFPjfGScQMuUr04MvmJFvcsy/naScvi4UwZmn/
	 o9wwLAYB/OsZHiJaK4CqJVSggMEHA1Mkrrusg/yPy13IWL8mkHWfSnxJMYNCgU32MU
	 iZPnCE7giXPqhbXfh46LJ/Yj225wyaVRjpm5PJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 477/570] drm/xe/migrate: prevent infinite recursion
Date: Mon, 18 Aug 2025 14:47:44 +0200
Message-ID: <20250818124524.261074264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 9d7a1cbebbb691891671def57407ba2f8ee914e8 ]

If the buf + offset is not aligned to XE_CAHELINE_BYTES we fallback to
using a bounce buffer. However the bounce buffer here is allocated on
the stack, and the only alignment requirement here is that it's
naturally aligned to u8, and not XE_CACHELINE_BYTES. If the bounce
buffer is also misaligned we then recurse back into the function again,
however the new bounce buffer might also not be aligned, and might never
be until we eventually blow through the stack, as we keep recursing.

Instead of using the stack use kmalloc, which should respect the
power-of-two alignment request here. Fixes a kernel panic when
triggering this path through eudebug.

v2 (Stuart):
 - Add build bug check for power-of-two restriction
 - s/EINVAL/ENOMEM/

Fixes: 270172f64b11 ("drm/xe: Update xe_ttm_access_memory to use GPU for non-visible access")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250731093807.207572-6-matthew.auld@intel.com
(cherry picked from commit 38b34e928a08ba594c4bbf7118aa3aadacd62fff)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 07a5161c7d5b..c0e2656a14d2 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1820,15 +1820,19 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 	if (!IS_ALIGNED(len, XE_CACHELINE_BYTES) ||
 	    !IS_ALIGNED((unsigned long)buf + offset, XE_CACHELINE_BYTES)) {
 		int buf_offset = 0;
+		void *bounce;
+		int err;
+
+		BUILD_BUG_ON(!is_power_of_2(XE_CACHELINE_BYTES));
+		bounce = kmalloc(XE_CACHELINE_BYTES, GFP_KERNEL);
+		if (!bounce)
+			return -ENOMEM;
 
 		/*
 		 * Less than ideal for large unaligned access but this should be
 		 * fairly rare, can fixup if this becomes common.
 		 */
 		do {
-			u8 bounce[XE_CACHELINE_BYTES];
-			void *ptr = (void *)bounce;
-			int err;
 			int copy_bytes = min_t(int, bytes_left,
 					       XE_CACHELINE_BYTES -
 					       (offset & XE_CACHELINE_MASK));
@@ -1837,22 +1841,22 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 			err = xe_migrate_access_memory(m, bo,
 						       offset &
 						       ~XE_CACHELINE_MASK,
-						       (void *)ptr,
-						       sizeof(bounce), 0);
+						       bounce,
+						       XE_CACHELINE_BYTES, 0);
 			if (err)
-				return err;
+				break;
 
 			if (write) {
-				memcpy(ptr + ptr_offset, buf + buf_offset, copy_bytes);
+				memcpy(bounce + ptr_offset, buf + buf_offset, copy_bytes);
 
 				err = xe_migrate_access_memory(m, bo,
 							       offset & ~XE_CACHELINE_MASK,
-							       (void *)ptr,
-							       sizeof(bounce), write);
+							       bounce,
+							       XE_CACHELINE_BYTES, write);
 				if (err)
-					return err;
+					break;
 			} else {
-				memcpy(buf + buf_offset, ptr + ptr_offset,
+				memcpy(buf + buf_offset, bounce + ptr_offset,
 				       copy_bytes);
 			}
 
@@ -1861,7 +1865,8 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 			offset += copy_bytes;
 		} while (bytes_left);
 
-		return 0;
+		kfree(bounce);
+		return err;
 	}
 
 	dma_addr = xe_migrate_dma_map(xe, buf, len + page_offset, write);
-- 
2.50.1



