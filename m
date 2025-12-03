Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24291313E3D;
	Wed,  3 Dec 2025 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776886; cv=none; b=bOtRxHsMQY9MR/4q6gpfV1PI1S0OhyFhSdHWrElOAO5j/AA/dfHj25rlYRaJ5j96w9u2/ZZNrO5Pee4MnWUjYIx09V8fPUz5LQgGXu8ftcHditaurCf3tCM9S4yVZ8WnrKCHVbwlj/ftBQuFwb/Q8NQU0OqJzwKHNYy7K5eqDdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776886; c=relaxed/simple;
	bh=xI/QPtfoX4SBYeQscD+2JpInZQpaq38uLOFZRA6xPSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drzM50kRWfXRPFP2zjJCj7TcGtCaCFuaoL+uqJUbBT3lCLcM7vQY8WhIJ8+/94nAK0IErwdAxisqG0wgxMAIv7u75yq85fG5opHg/WV38CkNzltbsSugQAaXL89cRpK+qescDSH3C5yRblfEzx/7ZSwEyXi4o7mQuGBT1sb7Ryg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6BDmRTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6BDmRTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC80C4CEF5;
	Wed,  3 Dec 2025 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776886;
	bh=xI/QPtfoX4SBYeQscD+2JpInZQpaq38uLOFZRA6xPSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6BDmRTIQ1ZvGqYonGw97uvUH0vWFpMLW7o7qSeFMbPcgE0X71GM6mk0RyEjpLDOZ
	 ar6ZrKPdWK5i24KwP2zmbldECc0G89y8UUF+ZPSgOdWg1sxYHaVLmT792CKofNs5Zz
	 nozjXP0GhuLU5FfwCXVuNVUCxN/UAT66y9fFeyns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 017/146] drm/xe: Fix conversion from clock ticks to milliseconds
Date: Wed,  3 Dec 2025 16:26:35 +0100
Message-ID: <20251203152347.099285517@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Chegondi <harish.chegondi@intel.com>

[ Upstream commit 7276878b069c57d9a9cca5db01d2f7a427b73456 ]

When tick counts are large and multiplication by MSEC_PER_SEC is larger
than 64 bits, the conversion from clock ticks to milliseconds can go bad.

Use mul_u64_u32_div() instead.

Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Harish Chegondi <harish.chegondi@intel.com>
Suggested-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Fixes: 49cc215aad7f ("drm/xe: Add xe_gt_clock_interval_to_ms helper")
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/1562f1b62d5be3fbaee100f09107f3cc49e40dd1.1763408584.git.harish.chegondi@intel.com
(cherry picked from commit 96b93ac214f9dd66294d975d86c5dee256faef91)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_clock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_clock.c b/drivers/gpu/drm/xe/xe_gt_clock.c
index 4f011d1573c65..f65d1edd05671 100644
--- a/drivers/gpu/drm/xe/xe_gt_clock.c
+++ b/drivers/gpu/drm/xe/xe_gt_clock.c
@@ -93,11 +93,6 @@ int xe_gt_clock_init(struct xe_gt *gt)
 	return 0;
 }
 
-static u64 div_u64_roundup(u64 n, u32 d)
-{
-	return div_u64(n + d - 1, d);
-}
-
 /**
  * xe_gt_clock_interval_to_ms - Convert sampled GT clock ticks to msec
  *
@@ -108,5 +103,5 @@ static u64 div_u64_roundup(u64 n, u32 d)
  */
 u64 xe_gt_clock_interval_to_ms(struct xe_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * MSEC_PER_SEC, gt->info.reference_clock);
+	return mul_u64_u32_div(count, MSEC_PER_SEC, gt->info.reference_clock);
 }
-- 
2.51.0



