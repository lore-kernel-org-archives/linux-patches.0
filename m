Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E0187347;
	Mon, 12 Aug 2024 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480417; cv=none; b=qnDP2jRgX6YvJwRWp7hJeqm/aA53m91SoQ9t7B/L4LDj45Qp0NdrDtj4JGX4IOSpMcgUQ6rLA8qdbNpRHX5JiLyxND7J4ypKkt8ja+rio7nv2b40Om72awh3bFMWMYF1k5yR4QOPk25fe1bC/8Nxmv+MxpkTM5CLeSMMNjWGvr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480417; c=relaxed/simple;
	bh=jiv6dXq008CxpPSgLJDeuot7Ncn0r8jRR3BqE2kordY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNn7tqgTjPZ9I9YFYmbtdMlqDUlFeomHFwP3AfwosD92ytu0oolmAr5oXP12POkcaNJ7pBO5CdND5a1TxwzSkzGSmoiji39Q6Y8+/BquOoZOEt0Ve/8ExXZMUI1GRF8Xg1iSj9GlSVbNDd+YHLvMpkU2ev722cZuKHYPDHreq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4bhWHxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4bhWHxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E544CC32782;
	Mon, 12 Aug 2024 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480417;
	bh=jiv6dXq008CxpPSgLJDeuot7Ncn0r8jRR3BqE2kordY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4bhWHxNKB8XnfJrrbVG+pg9H8HYEE6XCP88FWNpTepL5+inuzyqxJKoBX/amc6mb
	 5mzsoZzmUMAvcNeUSTQAq1LHBZROOlGkhGlav7XjcSHTUIgqE7VcRz9RvFt0hK8/CP
	 HGA0Bh6fpQ/t1kPMacPJF9Yfc289Gy53ImJFj3q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 158/263] drm/i915: Allow evicting to use the requested placement
Date: Mon, 12 Aug 2024 18:02:39 +0200
Message-ID: <20240812160152.595830322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 264b5b5980061d8c6a6a30c031cdec1179fe2bae ]

In commit a78a8da51b36 ("drm/ttm: replace busy placement with flags v6"),
the old system of having a separate placement list (for placements
which should be used without eviction) and a 'busy' placement list (for
placements which should be attempted if eviction is required) was
replaced with a new one where placements could be marked 'FALLBACK' (to
be attempted if eviction is required) or 'DESIRED' (to be attempted
first, but not if eviction is required).

i915 had always included the requested placement in the list of
'busy' placements: i.e., the placement could be used either if eviction
is required or not. But when the new system was put in place, the
requested (first) placement was marked 'DESIRED', so would never be used
if eviction became necessary. While a bug in the original commit
prevented this flag from working, when this was fixed in
4a0e7b3c ("drm/i915: fix applying placement flag"), it caused long hangs
on DG2 systems with small BAR.

Don't mark the requested placement DESIRED (or FALLBACK), allowing it to
be used in both situations. This matches the old behaviour, and resolves
the hangs.

Thanks to Justin Brewer for bisecting the issue.

Fixes: a78a8da51b36 ("drm/ttm: replace busy placement with flags v6")
Fixes: 4a0e7b3c3753 ("drm/i915: fix applying placement flag")
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11255
Signed-off-by: David Gow <david@davidgow.net>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240804091851.122186-2-david@davidgow.net
(cherry picked from commit 54bf0af90844fbf18f5be3272eda69198dfdb622)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index e6f177183c0fa..fb848fd8ba15a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -165,7 +165,6 @@ i915_ttm_placement_from_obj(const struct drm_i915_gem_object *obj,
 	i915_ttm_place_from_region(num_allowed ? obj->mm.placements[0] :
 				   obj->mm.region, &places[0], obj->bo_offset,
 				   obj->base.size, flags);
-	places[0].flags |= TTM_PL_FLAG_DESIRED;
 
 	/* Cache this on object? */
 	for (i = 0; i < num_allowed; ++i) {
-- 
2.43.0



