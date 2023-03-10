Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F11C847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F730C4339B;
	Fri, 10 Mar 2023 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456704;
	bh=gTzEVR3XXg2WghnyY8RBorOX4mRbHhYY2q1bR7+rKpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsK4aNhFXoHjsEmMLtzEEe0JCLB6oCv1uKFQP7Wf2jFCcZA2tM1brUs7ZO60i/6PN
	 li+4D9iDO7608SJx2tD18+Qy5fntOcNxql3ga7Mlqh5QoxI3M0XHPxKfk6PEk7hgYY
	 lnxhXAh53z9++9XovTA3AFb12yVhEDDDlowi3ylM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 077/211] drm/i915/xelpmp: Consider GSI offset when doing MCR lookups
Date: Fri, 10 Mar 2023 14:37:37 +0100
Message-Id: <20230310133721.123059098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 33c25354939099b76ecb6c82d1c7c50400fbcca6 ]

MCR range tables use the final MMIO offset of a register (including the
0x380000 GSI offset when applicable).  Since the i915_mcr_reg_t passed
as a parameter during steering lookup does not include the GSI offset,
we need to add it back in for GSI registers before searching the tables.

Fixes: a7ec65fc7e83 ("drm/i915/xelpmp: Add multicast steering for media GT")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230214001906.1477370-1-matthew.d.roper@intel.com
(cherry picked from commit d6683bbe70d4cdbf3da6acecf7d569cc6f0b4382)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
index 58ea3325bbdaa..fa2b9c48f39b2 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_mcr.c
@@ -464,12 +464,15 @@ static bool reg_needs_read_steering(struct intel_gt *gt,
 				    i915_mcr_reg_t reg,
 				    enum intel_steering_type type)
 {
-	const u32 offset = i915_mmio_reg_offset(reg);
+	u32 offset = i915_mmio_reg_offset(reg);
 	const struct intel_mmio_range *entry;
 
 	if (likely(!gt->steering_table[type]))
 		return false;
 
+	if (IS_GSI_REG(offset))
+		offset += gt->uncore->gsi_offset;
+
 	for (entry = gt->steering_table[type]; entry->end; entry++) {
 		if (offset >= entry->start && offset <= entry->end)
 			return true;
-- 
2.39.2



