Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EEF412C05;
	Fri,  7 Aug 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116318; cv=none; b=He/3P3ILmTQC6noyHBolgFsIlfRFtDzn5iSZWq4ke/hQ6++t+vnxWpnvK7JoGRUfXcQlfGcjRdbknK4S0eeSGtBEgDFVHOssGaXjsXiVP8/EpfBlT4TjosE5vYfiN83Z6/ELolw4zvPP8P1dKoGRruAPOl8KS6FsAGqp+TwinDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116318; c=relaxed/simple;
	bh=vm0frEBhzlKiBEkeHNGOQG19egOjvYPcKtQCFupic/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRhXm0k4zOEcxBRZsfYihIzt2dKX9k+3Yh20MGwW5deyxrbeOl0C9xHv0jYtFQyvoweNDL9M1Du7LYvMlOL10j/Drjts91bjvsYRSXBLMHEUWwQ/nK7Y1FW2B/ubAuNLDaLQxeyn4aXIHYJgmF0rbY0R1jiUQn2hGrmL3C/Fe6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZ1M4AYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZ1M4AYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C2D1F000E9;
	Fri,  7 Aug 2026 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116317;
	bh=vJytkU2r8bMOhD1HkqSYo9bpXKfwrrzGyXSug4OxHyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZ1M4AYpO9acSVzN+RcZ+VoLiaHpQ0cIhgA5tXCCFVQv2ME4lPktjNsLSO8sX/JJb
	 gNzck+nfyOhVnzJ1rqjzTtdRXuDsbFrMhvaYqJSqS4YvDwWdOzA2e06xcLirXXqiDL
	 vepsvmU1pGrxTRbgYG6EuAotUewFDn7E7LBx1uJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.6 189/261] drm/vc4: Zero the tile state data array before each BIN job
Date: Fri,  7 Aug 2026 16:39:06 +0200
Message-ID: <20260807143419.444168594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 48a570c964d8e37d353381e4195106277e17f5cb upstream.

The binner BO is a single 16MB buffer split into 512KB slots that are
handed out to jobs at submission time and recycled as jobs complete,
without ever being cleared. Each slot holds the job's Tile State Data
Array (TSDA) at its start, followed by the tile allocation pool.

While the tile allocation pool is only walked by the render thread
through branches the binner generated during the current job, the
TSDA is the PTB's own per-tile bookkeeping and is consumed by the
hardware itself. Although the kernel sets the "Auto-initialise Tile
State Data Array" flag in the tile binning mode configuration, the
PTB demonstrably still acts on stale tile state left by the slot's
previous user: the binner ends up creating invalid command streams
with invalid primitive streams and branches, which can cause GPU hangs
as observed in [1][2].

Zero the TSDA when the job's binning slot is configured. This clears
48 bytes per tile (~24KB for a 1080p frame) in the submission path, and
guarantees the PTB never sees another job's tile state.

The tile count is only checked for being non-zero today, so the 8-bit
fields it comes from can describe a tile state array almost six times
larger than the slot it has to live in. Bound it before the slot is
handed out, since such size decides how much of the slot is left for
the tile alloc pool.

Link: https://github.com/raspberrypi/linux/issues/3221 [1]
Link: https://github.com/raspberrypi/linux/issues/5780 [2]
Fixes: 553c942f8b2c ("drm/vc4: Allow using more than 256MB of CMA memory.")
Cc: stable@vger.kernel.org
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260727-vc4-bin-oom-fixes-v2-2-0d8a5eddc7c9@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_validate.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_validate.c
+++ b/drivers/gpu/drm/vc4/vc4_validate.c
@@ -387,6 +387,23 @@ validate_tile_binning_config(VALIDATE_AR
 		return -EINVAL;
 	}
 
+	/* The tile state data array is 48 bytes per tile, and we put it at
+	 * the start of a BO containing both it and the tile alloc.
+	 */
+	tile_state_size = 48 * tile_count;
+
+	/* Since the tile alloc array will follow us, align. */
+	tile_state_size = roundup(tile_state_size, 4096);
+
+	/* Reject configurations whose tile state would leave no room for
+	 * the tile alloc pool that follows it in the slot.
+	 */
+	if (tile_state_size >= vc4->bin_alloc_size) {
+		DRM_DEBUG("Tile binning config of %dx%d too large\n",
+			  exec->bin_tiles_x, exec->bin_tiles_y);
+		return -EINVAL;
+	}
+
 	bin_slot = vc4_v3d_get_bin_slot(vc4);
 	if (bin_slot < 0) {
 		if (bin_slot != -EINTR && bin_slot != -ERESTARTSYS) {
@@ -402,13 +419,13 @@ validate_tile_binning_config(VALIDATE_AR
 	exec->bin_slots |= BIT(bin_slot);
 	bin_addr = vc4->bin_bo->base.dma_addr + bin_slot * vc4->bin_alloc_size;
 
-	/* The tile state data array is 48 bytes per tile, and we put it at
-	 * the start of a BO containing both it and the tile alloc.
-	 */
-	tile_state_size = 48 * tile_count;
+	exec->tile_alloc_offset = bin_addr + tile_state_size;
 
-	/* Since the tile alloc array will follow us, align. */
-	exec->tile_alloc_offset = bin_addr + roundup(tile_state_size, 4096);
+	/* The TSDA area must be zeroed out before use, otherwise the PTB might
+	 * consume a stale tile state.
+	 */
+	memset(vc4->bin_bo->base.vaddr + bin_slot * vc4->bin_alloc_size, 0,
+	       tile_state_size);
 
 	*(uint8_t *)(validated + 14) =
 		((flags & ~(VC4_BIN_CONFIG_ALLOC_INIT_BLOCK_SIZE_MASK |


