Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF17339387;
	Fri,  7 Aug 2026 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115553; cv=none; b=WjbESz5EBWgMRdXK9NXaqKBE6mYmx5h8dwJMjt325WiGa2JLDDkksplzKGYPEnRPssaEm7n/dKK6OxwkOWURpm5XGANRNTYadKiTve48ClMF8gBtlnl6b+LE3Z8JxR17b2FPFF0T0pxwmlEJg6a69V3U/95NJbBnP8AV1apodWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115553; c=relaxed/simple;
	bh=oh8JRmLIiJB1x5LYBqGyMld2cG+0Bw8d8ZMdhtSObtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz33XDY3N8YRPGRFDOAm1b2VnZWvsSbzHFtcOLCY1/cYIBHO64K5SZ+ebicUkqSZoMQnZb6AOQzmCS7dCh2JOeF5uo8q0YVwYPQmbJxKTPjFTmIOnoYj+fGRauDynMt7bUzjnDGMjT50PMZo8sXxi6AFDRMEiHOdxqvDUkdd2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh9O3lob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh9O3lob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFC81F00A3A;
	Fri,  7 Aug 2026 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115548;
	bh=EtmuGzHlEN9dUWcWyoFCXQrsCmQqEN/f0dMwbKkXHpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eh9O3lobXRvHZ7ZupIWpih1WUGZdFx9LVTrUuwtv9q/MqOOjbTM0gk3cqMJmPc1dE
	 dWGHpWExZCHmlecEobVgsmUHpCVz625po9R1+JpZv+Kg9Dw8wIaLrHr0urU0x67I60
	 eBGYjBDzdFp9gNIwvkThebL3qtMHviX+SMZE1N0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 314/396] drm/vc4: Zero the tile state data array before each BIN job
Date: Fri,  7 Aug 2026 16:37:54 +0200
Message-ID: <20260807143431.039551012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,6 +384,23 @@ validate_tile_binning_config(VALIDATE_AR
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
@@ -399,13 +416,13 @@ validate_tile_binning_config(VALIDATE_AR
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


