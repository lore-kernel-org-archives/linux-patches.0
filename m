Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6371C9B61;
	Tue,  8 Oct 2024 12:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391826; cv=none; b=EO0FsjiKMx2yJAdkqdbSpqLVXUsRGlHJ32CMz2/RCvfE3OHL4sKvsGk4XCFH48nNz9rIgkl0HVTzSPapzDiKdiiZKCpwWD5rOgvVxwgJrWYrqTXhwnb3n0/6RXIxjzhAjllA8w2TT0FjAFdF3rSyxLtrjkfljYoNm0U2J6cfvkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391826; c=relaxed/simple;
	bh=hDk0ZbI0zj4xSQsPkCH0WwJIzr1B8RYINjJcyClZ8sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAIsOVJZ0F8LDK3FK+jaN1ObVm2apgFGJA83NFa3QwMYyPvdNm9PCKLF2+BOV5756CYC8IFcHGSNM3VszkN9laVKKFDR4yDsvSSwvvBVuBkevWZwTYVM/FDLfInc3hOOdcZxbURHYeKzn6Q2v/xa7Ok4Y1oM9Nd/W0nyUO9NARw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWdrFMAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWdrFMAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E9BC4CEC7;
	Tue,  8 Oct 2024 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391825;
	bh=hDk0ZbI0zj4xSQsPkCH0WwJIzr1B8RYINjJcyClZ8sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWdrFMAl3u0u5j6B/C5UQTsdTtq6YWdLZiAOYJCOdiE0cnU88Y95pJG6qUml5r2EF
	 r7IRPk8V6RgwE3aGEz4ZiDEgwB4SG8FeFaKH4+nRRj2kNAwVFe1/mQl6A3oakHCJeZ
	 kimwgZJNUuN8p5J8QwOFvzdCCvW6JlqrJaCJkQWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 233/558] drm/xe: Name and document Wa_14019789679
Date: Tue,  8 Oct 2024 14:04:23 +0200
Message-ID: <20241008115711.512366255@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 1d734a3e5d6bb266f52eaf2b1400c5d3f1875a54 ]

Early in the development of Xe we identified an issue with SVG state
handling on DG2 and MTL (and later on Xe2 as well).  In
commit 72ac304769dd ("drm/xe: Emit SVG state on RCS during driver load
on DG2 and MTL") and commit fb24b858a20d ("drm/xe/xe2: Update SVG state
handling") we implemented our own workaround to prevent SVG state from
leaking from context A to context B in cases where context B never
issues a specific state setting.

The hardware teams have now created official workaround Wa_14019789679
to cover this issue.  The workaround description only requires emitting
3DSTATE_MESH_CONTROL, since they believe that's the only SVG instruction
that would potentially remain unset by a context B, but still cause
notable issues if unwanted values were inherited from context A.
However since we already have a more extensive implementation that emits
the entire SVG state and prevents _any_ SVG state from unintentionally
leaking, we'll stick with our existing implementation just to be safe.

Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240812181042.2013508-2-matthew.d.roper@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c        | 35 +++++++++++++++++++++---------
 drivers/gpu/drm/xe/xe_wa_oob.rules |  2 ++
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 58121821f0814..974a9cd8c3795 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -5,6 +5,8 @@
 
 #include "xe_lrc.h"
 
+#include <generated/xe_wa_oob.h>
+
 #include <linux/ascii85.h>
 
 #include "instructions/xe_mi_commands.h"
@@ -24,6 +26,7 @@
 #include "xe_memirq.h"
 #include "xe_sriov.h"
 #include "xe_vm.h"
+#include "xe_wa.h"
 
 #define LRC_VALID				BIT_ULL(0)
 #define LRC_PRIVILEGE				BIT_ULL(8)
@@ -1581,19 +1584,31 @@ void xe_lrc_emit_hwe_state_instructions(struct xe_exec_queue *q, struct xe_bb *b
 	int state_table_size = 0;
 
 	/*
-	 * At the moment we only need to emit non-register state for the RCS
-	 * engine.
+	 * Wa_14019789679
+	 *
+	 * If the driver doesn't explicitly emit the SVG instructions while
+	 * setting up the default LRC, the context switch will write 0's
+	 * (noops) into the LRC memory rather than the expected instruction
+	 * headers.  Application contexts start out as a copy of the default
+	 * LRC, and if they also do not emit specific settings for some SVG
+	 * state, then on context restore they'll unintentionally inherit
+	 * whatever state setting the previous context had programmed into the
+	 * hardware (i.e., the lack of a 3DSTATE_* instruction in the LRC will
+	 * prevent the hardware from resetting that state back to any specific
+	 * value).
+	 *
+	 * The official workaround only requires emitting 3DSTATE_MESH_CONTROL
+	 * since that's a specific state setting that can easily cause GPU
+	 * hangs if unintentionally inherited.  However to be safe we'll
+	 * continue to emit all of the SVG state since it's best not to leak
+	 * any of the state between contexts, even if that leakage is harmless.
 	 */
-	if (q->hwe->class != XE_ENGINE_CLASS_RENDER)
-		return;
-
-	switch (GRAPHICS_VERx100(xe)) {
-	case 1255:
-	case 1270 ... 2004:
+	if (XE_WA(gt, 14019789679) && q->hwe->class == XE_ENGINE_CLASS_RENDER) {
 		state_table = xe_hpg_svg_state;
 		state_table_size = ARRAY_SIZE(xe_hpg_svg_state);
-		break;
-	default:
+	}
+
+	if (!state_table) {
 		xe_gt_dbg(gt, "No non-register state to emit on graphics ver %d.%02d\n",
 			  GRAPHICS_VER(xe), GRAPHICS_VERx100(xe) % 100);
 		return;
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 08f7336881e32..d4c33dbc14c7a 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -30,3 +30,5 @@
 22019338487	MEDIA_VERSION(2000)
 		GRAPHICS_VERSION(2001)
 16023588340	GRAPHICS_VERSION(2001)
+14019789679	GRAPHICS_VERSION(1255)
+		GRAPHICS_VERSION_RANGE(1270, 2004)
-- 
2.43.0



