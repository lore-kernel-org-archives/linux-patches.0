Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABBD24E4CE;
	Wed,  7 May 2025 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644300; cv=none; b=aeAsPSzkOupsZOTBr+C1OsC+f64AEitIkW2aWI7Azz1683zKPu/oDU7YJoCIWcC+9Q91BotyMY6O6QE9XYLDkzcCM6/uG0gDZwQL9rqfLNQXbJuZqDVeicN7EPse8nTtg2zPFy4bySK9RwrShDYT9HMAikypG4R1k1va/XS1WiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644300; c=relaxed/simple;
	bh=LtlXRditCIBqF9QFvXzjHlQlad8a/Rxy9gjY+gzbglc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfQAOI8tz0WyxjXCp55s49XhSSzrxF4ZJQmsPPKNnDSZag3aOASQ0ZkkuewarpC0ouSZzxRrbUuOadeUhVjBnDKnChvcLAd/CbVqawkWd0SEcCeqjgLnV/okOIqPy1VfXcgd4dZgb9ABzU8wafjU6x9qR4RPzRPeb+evlfhflyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/lLAHqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/lLAHqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC9C4CEE2;
	Wed,  7 May 2025 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644297;
	bh=LtlXRditCIBqF9QFvXzjHlQlad8a/Rxy9gjY+gzbglc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/lLAHqSdlNLXuvKLOXvmE9M1DRANB0lWVuFuvm77rjD6HRUxIocxDFHiJT/Z614F
	 bbyplKtcg6evikH0r1rTf1wduTsVBnyVUEnk24fUc8gXxxr7QJ7+jv3OSvqtLTBrPT
	 0qFLy7tL5r7+/LsVIftqpDUtnsIwNbChAjflUMz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Graunke <kenneth@whitecape.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.14 152/183] drm/xe: Invalidate L3 read-only cachelines for geometry streams too
Date: Wed,  7 May 2025 20:39:57 +0200
Message-ID: <20250507183831.020270149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Kenneth Graunke <kenneth@whitecape.org>

commit e775278cd75f24a2758c28558c4e41b36c935740 upstream.

Historically, the Vertex Fetcher unit has not been an L3 client.  That
meant that, when a buffer containing vertex data was written to, it was
necessary to issue a PIPE_CONTROL::VF Cache Invalidate to invalidate any
VF L2 cachelines associated with that buffer, so the new value would be
properly read from memory.

Since Tigerlake and later, VERTEX_BUFFER_STATE and 3DSTATE_INDEX_BUFFER
have included an "L3 Bypass Enable" bit which userspace drivers can set
to request that the vertex fetcher unit snoop L3.  However, unlike most
true L3 clients, the "VF Cache Invalidate" bit continues to only
invalidate the VF L2 cache - and not any associated L3 lines.

To handle that, PIPE_CONTROL has a new "L3 Read Only Cache Invalidation
Bit", which according to the docs, "controls the invalidation of the
Geometry streams cached in L3 cache at the top of the pipe."  In other
words, the vertex and index buffer data that gets cached in L3 when
"L3 Bypass Disable" is set.

Mesa always sets L3 Bypass Disable so that the VF unit snoops L3, and
whenever it issues a VF Cache Invalidate, it also issues a L3 Read Only
Cache Invalidate so that both L2 and L3 vertex data is invalidated.

xe is issuing VF cache invalidates too (which handles cases like CPU
writes to a buffer between GPU batches).  Because userspace may enable
L3 snooping, it needs to issue an L3 Read Only Cache Invalidate as well.

Fixes significant flickering in Firefox on Meteorlake, which was writing
to vertex buffers via the CPU between batches; the missing L3 Read Only
invalidates were causing the vertex fetcher to read stale data from L3.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4460
Fixes: 6ef3bb60557d ("drm/xe: enable lite restore")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250330165923.56410-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 61672806b579dd5a150a042ec9383be2bbc2ae7e)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/instructions/xe_gpu_commands.h |    1 +
 drivers/gpu/drm/xe/xe_ring_ops.c                  |   13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/instructions/xe_gpu_commands.h
+++ b/drivers/gpu/drm/xe/instructions/xe_gpu_commands.h
@@ -41,6 +41,7 @@
 
 #define GFX_OP_PIPE_CONTROL(len)	((0x3<<29)|(0x3<<27)|(0x2<<24)|((len)-2))
 
+#define	  PIPE_CONTROL0_L3_READ_ONLY_CACHE_INVALIDATE	BIT(10)	/* gen12 */
 #define	  PIPE_CONTROL0_HDC_PIPELINE_FLUSH		BIT(9)	/* gen12 */
 
 #define   PIPE_CONTROL_COMMAND_CACHE_INVALIDATE		(1<<29)
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -141,7 +141,8 @@ emit_pipe_control(u32 *dw, int i, u32 bi
 static int emit_pipe_invalidate(u32 mask_flags, bool invalidate_tlb, u32 *dw,
 				int i)
 {
-	u32 flags = PIPE_CONTROL_CS_STALL |
+	u32 flags0 = 0;
+	u32 flags1 = PIPE_CONTROL_CS_STALL |
 		PIPE_CONTROL_COMMAND_CACHE_INVALIDATE |
 		PIPE_CONTROL_INSTRUCTION_CACHE_INVALIDATE |
 		PIPE_CONTROL_TEXTURE_CACHE_INVALIDATE |
@@ -152,11 +153,15 @@ static int emit_pipe_invalidate(u32 mask
 		PIPE_CONTROL_STORE_DATA_INDEX;
 
 	if (invalidate_tlb)
-		flags |= PIPE_CONTROL_TLB_INVALIDATE;
+		flags1 |= PIPE_CONTROL_TLB_INVALIDATE;
 
-	flags &= ~mask_flags;
+	flags1 &= ~mask_flags;
 
-	return emit_pipe_control(dw, i, 0, flags, LRC_PPHWSP_SCRATCH_ADDR, 0);
+	if (flags1 & PIPE_CONTROL_VF_CACHE_INVALIDATE)
+		flags0 |= PIPE_CONTROL0_L3_READ_ONLY_CACHE_INVALIDATE;
+
+	return emit_pipe_control(dw, i, flags0, flags1,
+				 LRC_PPHWSP_SCRATCH_ADDR, 0);
 }
 
 static int emit_store_imm_ppgtt_posted(u64 addr, u64 value,


