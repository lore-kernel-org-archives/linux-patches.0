Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8266E30C361;
	Thu, 16 Jul 2026 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211688; cv=none; b=NI+Lb4xr7etiUsgMPzyzjuwVMKnHwx98ncEgELnCztccFPA4q6XBXvOnGSX+GVljArdbiYaPFKRr582dsKspnj7Z5pOuYY0HlZgKZoST2mhjBGGitW9n+Ag/sYVYA87B8b9A0jloSVBBlm7NF+UCubQha3y+oHF29Gqqlb3hRRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211688; c=relaxed/simple;
	bh=7CGeNH+8Nz36AgMASwupVdPONhJvO36FmwUY0kcoLak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMpH1Gw2oFbEO82vPmojoYKzxPP2bACxQMBy0UskkAyPuPTCWlxBRXuY+AC58h6K/AYpjHLLPr++FScm7FicK0tR61VLSANHrDvyrqthgkwnhVqD5zVk5yBxi49I0AIXQP0FD3vI7Rv1BcqxAcML3htbFEsYzWRBOP2ZtUMuDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoWBqkfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoWBqkfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76F01F000E9;
	Thu, 16 Jul 2026 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211687;
	bh=+jKb9lVt1ildreAJSZrQFxZrYZ9xBQUpliS7AfqB8T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoWBqkfHfVTgyLQnYzSFeOk6pVAjJrVyBYzcEbLKe3MqHNzsRyoF5Vvu4za2erFyB
	 WgSZYHpeN2lToABu4TI2MIW48lqi5TDyrmm1ToG8FmzS9eugjsZXpXpZjfJwYo9AbH
	 AnN117LTbUVdtBw5ohIz5RBngL3y3Rq/SNTKYqVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/349] drm/i915: ensure segment offset never exceeds allowed max
Date: Thu, 16 Jul 2026 15:29:35 +0200
Message-ID: <20260716133034.241894825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 2e0438f9c3d25eea8bc8e9b4dcff7edfb64cb9e7 ]

Commit 255fc1703e42 ("drm/i915/gem: Calculate object page offset for
partial memory mapping") introduced a new offset, which accounts for
userspace mapping not starting from the beginning of object's scatterlist.

This works fine for cases where first object pte is larger than the new
offset - "r->sgt.curr" counter is set to the offset to match the difference
in the number of total pages. However, if object's first pte's size is
equal to or smaller than the offset, then information about the offset
in userspace is covered up by moving "r->sgt" pointer in remap_sg():

	r->sgt.curr += PAGE_SIZE;
	if (r->sgt.curr >= r->sgt.max)
		r->sgt = __sgt_iter(__sg_next(r->sgt.sgp), use_dma(r->iobase));

This means that two or more pages from virtual memory are counted for
only one page in object's memory, because after moving "r->sgt" pointer
"r->sgt.curr" will be 0.

We should account for this mismatch by moving "r->sgt" pointer to the
next pte. For that we may use "r.sgt.max", which already holds the max
allowed size. This change also eliminates possible confusion, when
looking at i915_scatterlist.h and remap_io_sg() code: former has
scatterlist pointer definition, which differentiates "s.max" value
based on "dma" flag (sg_dma_len() is used only when the flag is
enabled), while latter uses sg_dma_len() indiscriminately.

This patch aims to resolve issue:
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12031

v3:
 - instead of checking if r.sgt.curr would exceed allowed max, changed
the value in the while loop to be aligned with `dma` value

v4:
 - remove unnecessary parent relation

v5:
 - update commit message with explanation about page counting mismatch
 and link to the issue

Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/upbjdavlbcxku63ns4vstp5kgbn2anxwewpmnppszgb67fn66t@tfclfgkqijue
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_mm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
index f5c97a620962b6..76e2801619f092 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -143,8 +143,8 @@ int remap_io_sg(struct vm_area_struct *vma,
 	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
 	GEM_BUG_ON((vma->vm_flags & EXPECTED_FLAGS) != EXPECTED_FLAGS);
 
-	while (offset >= sg_dma_len(r.sgt.sgp) >> PAGE_SHIFT) {
-		offset -= sg_dma_len(r.sgt.sgp) >> PAGE_SHIFT;
+	while (offset >= r.sgt.max >> PAGE_SHIFT) {
+		offset -= r.sgt.max >> PAGE_SHIFT;
 		r.sgt = __sgt_iter(__sg_next(r.sgt.sgp), use_dma(iobase));
 		if (!r.sgt.sgp)
 			return -EINVAL;
-- 
2.53.0



