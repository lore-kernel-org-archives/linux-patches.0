Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CF41A23AF;
	Tue, 15 Jul 2025 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585540; cv=none; b=qY9XJxu3MxPjPtYEtkv8O8xQp9KJC86W9CBCCkV1aV+mKqsM4x2oAvJNHFpPQh/DC/0OabGzZhDpSlxl4i6eIPnO9cq2wbxqai3SC6AYp8wgP3xHTii7RtCxRArh27CIUY1WKZCcEutRK4t2jDAchpexGk4tTLrcCrUfo426I+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585540; c=relaxed/simple;
	bh=JlOZbVTyk3JxTd6vSnNPSEq0F01nCd9F0cJ44JbIEeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeftVRc59vjYZmRsbU8fSuGUoeVgItOdAiLwvz6N3ryC+f0jMi3kFLqazZwZV18C40kT5uNFxwLs3QfDNZPFh2ZhiTvZ2FiIFqEWDBa1vCg0LwHmj7yoyrylWmeeLH2XWy8dg4ELD57m1G23y8oUfrw8rrl4k+xylGP/m9oiPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1UORiT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1UORiT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F2C4CEE3;
	Tue, 15 Jul 2025 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585540;
	bh=JlOZbVTyk3JxTd6vSnNPSEq0F01nCd9F0cJ44JbIEeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1UORiT/kO1genn3U29ttf0sUZbdspRA10najjE2qGTGuw9zGh4zEKfTL2O/S6s1/
	 xpIulpO6qHABGgnapLWSGhBB2Jzo1M31P0Pv6Cu9HRR7da2lkyjz2MIHZsf/4Q3jxN
	 O48qMDDWfRNPSHSeeDeqPhuniTJXLmkBZw882r/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Akshata Jahagirdar <akshata.jahagirdar@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 078/163] drm/xe/bmg: fix compressed VRAM handling
Date: Tue, 15 Jul 2025 15:12:26 +0200
Message-ID: <20250715130811.862680701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit fee58ca135a7b979c8b75e6d2eac60d695f9209b upstream.

There looks to be an issue in our compression handling when the BO pages
are very fragmented, where we choose to skip the identity map and
instead fall back to emitting the PTEs by hand when migrating memory,
such that we can hopefully do more work per blit operation. However in
such a case we need to ensure the src PTEs are correctly tagged with a
compression enabled PAT index on dgpu xe2+, otherwise the copy will
simply treat the src memory as uncompressed, leading to corruption if
the memory was compressed by the user.

To fix this pass along use_comp_pat into emit_pte() on the src side, to
indicate that compression should be considered.

v2 (Jonathan): tweak the commit message

Fixes: 523f191cc0c7 ("drm/xe/xe_migrate: Handle migration logic for xe2+ dgfx")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Akshata Jahagirdar <akshata.jahagirdar@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250701103949.83116-2-matthew.auld@intel.com
(cherry picked from commit f7a2fd776e57bd6468644bdecd91ab3aba57ba58)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -860,7 +860,7 @@ struct dma_fence *xe_migrate_copy(struct
 		if (src_is_vram && xe_migrate_allow_identity(src_L0, &src_it))
 			xe_res_next(&src_it, src_L0);
 		else
-			emit_pte(m, bb, src_L0_pt, src_is_vram, copy_system_ccs,
+			emit_pte(m, bb, src_L0_pt, src_is_vram, copy_system_ccs || use_comp_pat,
 				 &src_it, src_L0, src);
 
 		if (dst_is_vram && xe_migrate_allow_identity(src_L0, &dst_it))


