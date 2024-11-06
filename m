Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458C81DFE06;
	Wed,  6 Nov 2024 12:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896555; cv=none; b=o4NMF8rIv2LXBQRJfKZNVWrklT64GiQzNKqHdQvG3pR6aAyHK1KYK5Gq8eCHzIZUXna9C5M5kEHLw9glKP/bvtRm/TwD5U7YfLRF79QZeqdRBroevhYLagZEMn4qkUx0MFwRiCApjE/cQzutqTQDj7r4yMyB7Ex8IDbq/ae8cJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896555; c=relaxed/simple;
	bh=EkuoEfOkEXtvZxy8nxmCvSZ1vpMiqsGUaxXqqu7tNMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/EijPmCdPCXE95BFBZy3pkHfQ7/UsupGuulHqzttm+ZxDh5b72ASEW3P2P0n5YIDRsPPoDfIZqJULrGmyRLaWL9lQtf10plkGb4C/iIdmSD1d9t5NigC4zGAVgBFebgtOmhZubW1l2SDCrwKy3laz7dgbZms8/wJqbgyVik4Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVth5zKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVth5zKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF45EC4CECD;
	Wed,  6 Nov 2024 12:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896555;
	bh=EkuoEfOkEXtvZxy8nxmCvSZ1vpMiqsGUaxXqqu7tNMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVth5zKDjAi9PCYDnBOLpXcShj3b4iN0mwHTjtk1A6T/cIzg1G16eqb6XoShDwGVk
	 J4hmYzvY9L3utjDjIW/z2vSTl6xroCn079tdybyKwPslrEACzgWjZHtq1mCyCMsC/N
	 cFNW1jG4AdJId2p1vcEa0/baa/eIxorsqhagr+Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 195/245] drm/xe: Add mmio read before GGTT invalidate
Date: Wed,  6 Nov 2024 13:04:08 +0100
Message-ID: <20241106120324.044917292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 993ca0eccec65a2cacc3cefb15d35ffadc6f00fb ]

On LNL without a mmio read before a GGTT invalidate the GuC can
incorrectly read the GGTT scratch page upon next access leading to jobs
not getting scheduled. A mmio read before a GGTT invalidate seems to fix
this. Since a GGTT invalidate is not a hot code path, blindly do a mmio
read before each GGTT invalidate.

Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Reported-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3164
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241023221200.1797832-1-matthew.brost@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 5a710196883e0ac019ac6df2a6d79c16ad3c32fa)
[ Fix conflict with mmio vs gt argument ]
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
index 0cdbc1296e885..226542bb1442e 100644
--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -309,6 +309,16 @@ static void ggtt_invalidate_gt_tlb(struct xe_gt *gt)
 
 static void xe_ggtt_invalidate(struct xe_ggtt *ggtt)
 {
+	struct xe_device *xe = tile_to_xe(ggtt->tile);
+
+	/*
+	 * XXX: Barrier for GGTT pages. Unsure exactly why this required but
+	 * without this LNL is having issues with the GuC reading scratch page
+	 * vs. correct GGTT page. Not particularly a hot code path so blindly
+	 * do a mmio read here which results in GuC reading correct GGTT page.
+	 */
+	xe_mmio_read32(xe_root_mmio_gt(xe), VF_CAP_REG);
+
 	/* Each GT in a tile has its own TLB to cache GGTT lookups */
 	ggtt_invalidate_gt_tlb(ggtt->tile->primary_gt);
 	ggtt_invalidate_gt_tlb(ggtt->tile->media_gt);
-- 
2.43.0



