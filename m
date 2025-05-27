Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A4642A9B;
	Tue, 27 May 2025 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368186; cv=none; b=Y2FuH4OlPWqq46Bv5TYgP6rex/Rlv/WhCVK8GtPOR5UmWQEaljj1fCa9bJ4xxgg7TVr/Y3IyNCDYgbbazyxzvYKySm0ZmgE/RgT1PrFGgA9nIu8xNzBDO7T65qim+nrIPrHIAsrZ53mI1eAGX44Q5rZQjZWrmBFc2lqhL2XDsDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368186; c=relaxed/simple;
	bh=NpyWd07cx18En3uHGNCq29Xdlx2KjhzEpYMO2av8Gj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy9H5v0A9Vp/EySCY+8NHGv1QK/kdGXtHCufoI/cHsX6aBQA5e4yHwwhajGFZjgIlrkbabAluIfbUVAnOJV2gCLZp4GYjsIjTw1rOo5+uwuaHE2qodl1ECAqdp/upMuZiEpaFfusNxiiSy44KAr11rAz3nbUj5BZ83KSyAgMw/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9umQRBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9umQRBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A62C4CEE9;
	Tue, 27 May 2025 17:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368184;
	bh=NpyWd07cx18En3uHGNCq29Xdlx2KjhzEpYMO2av8Gj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9umQRBsU2ZZ/uUWYock98S4nbBiBphLVqYFGlDPeQOttO7EI0+rjjxWTFOtkY5iM
	 jrJJAufwled1inw/fX/TBs3cl4FTF+RBX2vqJHYSj0V/PDx1PCGwgOr9vvsVCMvs6D
	 V/FkUCCWptifFsj3RwRArfs7Og0nCIriMshbfYOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 626/783] drm/buddy: fix issue that force_merge cannot free all roots
Date: Tue, 27 May 2025 18:27:03 +0200
Message-ID: <20250527162538.643096885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

[ Upstream commit 467dce3817bd2b62ccd6fcfd7aae76f242ac907e ]

If buddy manager have more than one roots and each root have sub-block
need to be free. When drm_buddy_fini called, the first loop of
force_merge will merge and free all of the sub block of first root,
which offset is 0x0 and size is biggest(more than have of the mm size).
In subsequent force_merge rounds, if we use 0 as start and use remaining
mm size as end, the block of other roots will be skipped in
__force_merge function. It will cause the other roots can not be freed.

Solution: use roots' offset as the start could fix this issue.

Signed-off-by: Lin.Cao <lincao12@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241226070116.309290-1-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_buddy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index 103c185bb1c8a..ca42e6081d27c 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(drm_buddy_init);
  */
 void drm_buddy_fini(struct drm_buddy *mm)
 {
-	u64 root_size, size;
+	u64 root_size, size, start;
 	unsigned int order;
 	int i;
 
@@ -332,7 +332,8 @@ void drm_buddy_fini(struct drm_buddy *mm)
 
 	for (i = 0; i < mm->n_roots; ++i) {
 		order = ilog2(size) - ilog2(mm->chunk_size);
-		__force_merge(mm, 0, size, order);
+		start = drm_buddy_block_offset(mm->roots[i]);
+		__force_merge(mm, start, start + size, order);
 
 		WARN_ON(!drm_buddy_block_is_free(mm->roots[i]));
 		drm_block_free(mm, mm->roots[i]);
-- 
2.39.5



