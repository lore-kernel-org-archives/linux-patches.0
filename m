Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF513847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B128C433C7;
	Wed,  9 Aug 2023 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578290;
	bh=yMuxpVUPJ9x0mdWLUmMz2TxM+XlrPvkPIR/KXfL/sZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpUxYfq6xuweb9LHWRUR9P8clA+KvSXdGDrzLLT3u4FMnHvMQhreYHLZbkomk01JL
	 3gR4z+18TJpsO+/PR1YqpkqZ/Soj4P9TxvxVpa9K7YKF6vfCBwPBBa4a2knkfJi0fw
	 DAPlw2q6FdG4sMiMSzXjjoFkV7HMam3pGH/xbNI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 165/165] drm/i915/gt: Enable the CCS_FLUSH bit in the pipe control and in the CS
Date: Wed,  9 Aug 2023 12:41:36 +0200
Message-ID: <20230809103648.174968049@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andi Shyti <andi.shyti@linux.intel.com>

[ Upstream commit 824df77ab2107d8d4740b834b276681a41ae1ac8 ]

Enable the CCS_FLUSH bit 13 in the control pipe for render and
compute engines in platforms starting from Meteor Lake (BSPEC
43904 and 47112).

For the copy engine add MI_FLUSH_DW_CCS (bit 16) in the command
streamer.

Fixes: 972282c4cf24 ("drm/i915/gen12: Add aux table invalidate for all engines")
Requires: 8da173db894a ("drm/i915/gt: Rename flags with bit_group_X according to the datasheet")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230725001950.1014671-6-andi.shyti@linux.intel.com
(cherry picked from commit b70df82b428774875c7c56d3808102165891547c)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_engine_cs.c     | 11 +++++++++++
 drivers/gpu/drm/i915/gt/intel_gpu_commands.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
index 024e212b5f80d..2702ad4c26c88 100644
--- a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
@@ -264,6 +264,13 @@ int gen12_emit_flush_rcs(struct i915_request *rq, u32 mode)
 
 		bit_group_0 |= PIPE_CONTROL0_HDC_PIPELINE_FLUSH;
 
+		/*
+		 * When required, in MTL and beyond platforms we
+		 * need to set the CCS_FLUSH bit in the pipe control
+		 */
+		if (GRAPHICS_VER_FULL(rq->i915) >= IP_VER(12, 70))
+			bit_group_0 |= PIPE_CONTROL_CCS_FLUSH;
+
 		bit_group_1 |= PIPE_CONTROL_TILE_CACHE_FLUSH;
 		bit_group_1 |= PIPE_CONTROL_FLUSH_L3;
 		bit_group_1 |= PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH;
@@ -378,6 +385,10 @@ int gen12_emit_flush_xcs(struct i915_request *rq, u32 mode)
 		cmd |= MI_INVALIDATE_TLB;
 		if (rq->engine->class == VIDEO_DECODE_CLASS)
 			cmd |= MI_INVALIDATE_BSD;
+
+		if (gen12_needs_ccs_aux_inv(rq->engine) &&
+		    rq->engine->class == COPY_ENGINE_CLASS)
+			cmd |= MI_FLUSH_DW_CCS;
 	}
 
 	*cs++ = cmd;
diff --git a/drivers/gpu/drm/i915/gt/intel_gpu_commands.h b/drivers/gpu/drm/i915/gt/intel_gpu_commands.h
index 02125a1db2796..2bd8d98d21102 100644
--- a/drivers/gpu/drm/i915/gt/intel_gpu_commands.h
+++ b/drivers/gpu/drm/i915/gt/intel_gpu_commands.h
@@ -300,6 +300,7 @@
 #define   PIPE_CONTROL_QW_WRITE				(1<<14)
 #define   PIPE_CONTROL_POST_SYNC_OP_MASK                (3<<14)
 #define   PIPE_CONTROL_DEPTH_STALL			(1<<13)
+#define   PIPE_CONTROL_CCS_FLUSH			(1<<13) /* MTL+ */
 #define   PIPE_CONTROL_WRITE_FLUSH			(1<<12)
 #define   PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH	(1<<12) /* gen6+ */
 #define   PIPE_CONTROL_INSTRUCTION_CACHE_INVALIDATE	(1<<11) /* MBZ on ILK */
-- 
2.40.1



