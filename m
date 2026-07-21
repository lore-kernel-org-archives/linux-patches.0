Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9911F3D56;
	Tue, 21 Jul 2026 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653643; cv=none; b=fEux1tsu4BIRT3d+VQGeDfBDlRhwDJMuNeotkTLdiFzVLRlPJZ0n2kkQUQQZagKJVE0G9TenAJvAfXanaCB/WDus9fc2tQFBnn195Z8cQIqJmny3R1H7haxpgEcy3/HPLrTBebyGDY9nuGtT9sCBbUgsyXlTKkInVMql73slNDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653643; c=relaxed/simple;
	bh=TuPQ/0iGBypVt+FkkqSpHp2nKOfKlcux596CSkf59xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xjk2niEPoXp6qUNv0SmrADBiXoMNtrnsJkRqWY3ymqDx73h6hqHqAO7ZyIBOEmFHywP3BZKoQ9aWY1WhonaennObAQFZotAvUGB6uTnu6amehe0SxZXzjW1YZIpwSCqaR1RZQBuEez97XLfiyA2q5fQmT51Te2lHWLy/M/6ykCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ7Rm1e+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ7Rm1e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B402A1F00A3D;
	Tue, 21 Jul 2026 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653642;
	bh=RISSBWn1n/llKA5PMlH32srpAExXT0ZlCvR5ICZ1wDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJ7Rm1e+tjRrixjn7AeHjvKqkPPRwUjnefkI+KjcTRx2wNYNsQHqPfBC6lYVY2Lk+
	 mNGSjP28a9OacojJNRJlcuesZ8SIykaIEn83r77IcfcP3HyB/n3U2xrtsYq9pzAv1X
	 tZAG/u3q9sItvbntNz3R02TJYRBzDBau7lP3ZOkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1404/2077] drm/xe: fix NPD in bo_meminfo()
Date: Tue, 21 Jul 2026 17:17:57 +0200
Message-ID: <20260721152625.924373888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit b5c55015d4164a0f206bcdcf2985da948b3c7837 ]

When a buffer object is purged, its ttm.resource is set to NULL via the
TTM pipeline gutting flow. However, the BO remains in the client's
object list until userspace explicitly closes the GEM handle. If memory
stats are queried during this time, accessing bo->ttm.resource->mem_type
will result in a NULL pointer dereference.

Fix this by safely skipping purged BOs in bo_meminfo, as they no longer
consume any memory.

User is getting NPD on device resume, and possible theory is that in
bo_move(), if we need to evict something to SYSTEM to save the CCS state,
but the BO is marked as dontneed, this won't trigger a move but will
nuke the pages, leaving us with a NULL bo resource. And the meminfo()
doesn't look ready to handle a NULL resource.

v2 (Sashiko):
 - There could potentially be other cases where we might end up with a
   NULL resource, so make this a general NULL check for now.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8419
Fixes: ad9843aac91a ("drm/xe/madvise: Implement purgeable buffer object support")
Assisted-by: Copilot:gemini-3.1-pro-preview
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Tested-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260625152054.450125-6-matthew.auld@intel.com
(cherry picked from commit c9a8e7daa0afe3161111e27fd92176e608c7f186)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_drm_client.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_drm_client.c b/drivers/gpu/drm/xe/xe_drm_client.c
index 84b66147bf4944..81020b4b344e08 100644
--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -168,10 +168,20 @@ static void bo_meminfo(struct xe_bo *bo,
 		       struct drm_memory_stats stats[TTM_NUM_MEM_TYPES])
 {
 	u64 sz = xe_bo_size(bo);
-	u32 mem_type = bo->ttm.resource->mem_type;
+	u32 mem_type;
 
 	xe_bo_assert_held(bo);
 
+	/*
+	 * The resource can be NULL if the BO has been purged, plus maybe some
+	 * other cases. Either way there shouldn't be any memory to account for,
+	 * or a current resource to account this against, so skip for now.
+	 */
+	if (!bo->ttm.resource)
+		return;
+
+	mem_type = bo->ttm.resource->mem_type;
+
 	if (drm_gem_object_is_shared_for_memory_stats(&bo->ttm.base))
 		stats[mem_type].shared += sz;
 	else
-- 
2.53.0



