Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345E2155335;
	Mon, 16 Sep 2024 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488108; cv=none; b=JndGkn3XU0SJto9YIN54ANZedFAhuiLHDdUXNp8YGJFznQqyoHQ+p76PTunYZEjDunvLYPPjLANvgRlRHzYqiVsnAew8TyUsnKXj9FLxYSNJNOM3IvaDSoMxSVX5ozNfhyECp5VYrw58wZyMm9exNaBT4jZdHq91b42xxQzNEv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488108; c=relaxed/simple;
	bh=YAqKrZzhHSU8qJK736bDXq1uZF8K6jbG7NIHW45dw2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxwyuySNZ5Hs+y1qf69JjDWtCqgfATrTGUhR614QmYI/OTPPAXuTFe7YZNWugnIw0gwq7Pg8dKuytjT2Elx2Mjg1NiSZ+jy9ea+/vCFEMKn5tEIaIDcndf8ioz4JCBFWJS0LaMhl3aIqb8J0fifup4PwneIbdlHF+5DCERfs5/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ3dWJ6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ3dWJ6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12DDC4CEC4;
	Mon, 16 Sep 2024 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488108;
	bh=YAqKrZzhHSU8qJK736bDXq1uZF8K6jbG7NIHW45dw2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQ3dWJ6gZ4fIMgcZXOmJjr//NsLAf3/ONa4YQCRmaqPG0imNJcJdG/wEX8zkTVZRa
	 6EKPXBWp+EuhuorFqOVG0a4r7+M5sK0PbuqO0Nld99dZCH6JgQpeAzd7acnsKpvZ/1
	 34IPJbOZ3azzjo3X/wwvjXZzljUHYfeQ/7W7Io5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/63] drm/i915/guc: prevent a possible int overflow in wq offsets
Date: Mon, 16 Sep 2024 13:44:40 +0200
Message-ID: <20240916114223.195319963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit d3d37f74683e2f16f2635ee265884f7ca69350ae ]

It may be possible for the sum of the values derived from
i915_ggtt_offset() and __get_parent_scratch_offset()/
i915_ggtt_offset() to go over the u32 limit before being assigned
to wq offsets of u64 type.

Mitigate these issues by expanding one of the right operands
to u64 to avoid any overflow issues just in case.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: c2aa552ff09d ("drm/i915/guc: Add multi-lrc context registration")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patchwork.freedesktop.org/patch/msgid/20240725155925.14707-1-n.zhandarovich@fintech.ru
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 1f1c1bd56620b80ae407c5790743e17caad69cec)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fecdc7ea78eb..56df4c4a8a1a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -2603,9 +2603,9 @@ static void prepare_context_registration_info_v70(struct intel_context *ce,
 		ce->parallel.guc.wqi_tail = 0;
 		ce->parallel.guc.wqi_head = 0;
 
-		wq_desc_offset = i915_ggtt_offset(ce->state) +
+		wq_desc_offset = (u64)i915_ggtt_offset(ce->state) +
 				 __get_parent_scratch_offset(ce);
-		wq_base_offset = i915_ggtt_offset(ce->state) +
+		wq_base_offset = (u64)i915_ggtt_offset(ce->state) +
 				 __get_wq_offset(ce);
 		info->wq_desc_lo = lower_32_bits(wq_desc_offset);
 		info->wq_desc_hi = upper_32_bits(wq_desc_offset);
-- 
2.43.0



