Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE63D45E5;
	Tue, 13 Oct 2026 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893119; cv=none; b=gYhb3mxSvVrwyDSDZiqlQwO9MoXlCf+blC+WCikSB6xSScEi402sIpSVlElBPWcfLZt7S8ooBxpRlilROBzfNp95ZHzNTKwNGwyWtg9HC+AIwBeRBXuK5JTRNEPXG7W/9XYxg3NtLtnCkCD/yOmP9dM6+UpT49R3geZF3Ss5st4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893119; c=relaxed/simple;
	bh=CMbiUY8LzAomsYcbgsBn14kk2ofBssiByOVAYRZL1do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4KeBm0j8NIkrHFi7v6sS1TmKTwLrlZa2EQAnjEEaJxeLAKDyJ3o2wLR4zPFqY8HD26IUMNSVz+9gI3/neX9AuigLgpYarPs7N+oE3oA1ge+DNqBSN87/K0OsfC1FkUvBZ4IKJYGKLnjFLHCRiHVYvgeo5iyRYRvK/4TqsmaQRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np90K9iz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np90K9iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EACB1F000FF;
	Tue, 13 Oct 2026 12:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893118;
	bh=SMYk1GszHIzYcE5DTR4JUzGTXHmlCLya39VlQ+oBGZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=np90K9izOr7vt0fVsu8nd1vvpDoP+AFQkpmzexPHgfqhAkqqikIB9msqoJ7ZIHxmy
	 0/qUpARCqLEfeC+0dkb0jamtVeI75BsHgUugyE9b7NMXWM/VEU0WG9t/lM7NJ8fSH+
	 vqCN6XP9nzbYrjzt2qUsW2fYONu2Q0XylXV22PmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleel Kudchadker <Saleel.Kudchadker@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 120/621] drm/amdkfd: align SDMA doorbell base for shader doorbell writes
Date: Tue, 13 Oct 2026 13:31:55 +0200
Message-ID: <20261013112923.707605316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saleel Kudchadker <Saleel.Kudchadker@amd.com>

commit f145d5b3f740de05d85257acdc82f6877180f5c6 upstream.

On GC 9.4.3, 9.4.4 and 9.5.0, doorbell writes issued from shaders are
routed to an SDMA engine at 32-byte (4 doorbell index) granularity.
SDMA engine doorbell ranges are 10 indices apart, so the range of every
odd engine starts 2 indices into a 4-index block that begins in the
previous engine's range. A shader ringing the doorbell of a queue on an
odd engine therefore rings the previous engine instead. The intended
queue never sees the doorbell, so its work stalls and the application
hangs.

Align the per-engine doorbell base up to a 4-index boundary on these
ASICs. Each engine only uses 4 of its 10 indices, so the aligned base
plus the queue offset stays within the engine's range. Even engines are
already aligned, so only the doorbell IDs of odd-engine queues change.

Only doorbells rung by the device itself are routed this way. Doorbell
writes from the host, including the kernel's own SDMA rings, are not
affected.

The doorbell ID of an SDMA queue is saved in CRIU checkpoints and
checked again on restore. A checkpoint taken before this change that
contains an SDMA queue on an odd engine will fail to restore with
-EINVAL. This is intentional: the restored process still holds the old
doorbell address, so accepting the stale ID would bring back the same
stall.

Tested on MI300X with a shader-rung SDMA doorbell test: queues on odd
engines hung before this change and complete with it.

v2: use u32 instead of uint32_t for the new locals (checkpatch)
v3: name the routing granularity, use dev->node_id, document the
    layout invariants, describe impact
v4: express the granularity in doorbell indices, drop unrelated
    cleanups, explain the CRIU restore behavior, add test note

Fixes: 6df442a03d1a ("drm/amdgpu: add new doorbell assignment table for aqua_vanjaram")
Signed-off-by: Saleel Kudchadker <Saleel.Kudchadker@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ee1379e6d7da47bdf7a8d5b89c2d1b28473701fb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   32 ++++++++++++++----
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                 |    7 +++
 2 files changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -459,12 +459,32 @@ static int allocate_doorbell(struct qcm_
 		 * we need the physical sdma engine id in order to get the
 		 * correct doorbell offset.
 		 */
-		uint32_t valid_id = idx_offset[qpd->dqm->dev->node_id *
-					       get_num_all_sdma_engines(qpd->dqm) +
-					       q->properties.sdma_engine_id]
-						+ (q->properties.sdma_queue_id & 1)
-						* KFD_QUEUE_DOORBELL_MIRROR_OFFSET
-						+ (q->properties.sdma_queue_id >> 1);
+		u32 engine_base = idx_offset[dev->node_id *
+					     get_num_all_sdma_engines(qpd->dqm) +
+					     q->properties.sdma_engine_id];
+		u32 valid_id;
+
+		/*
+		 * With the aqua_vanjaram doorbell layout, a shader doorbell
+		 * write whose 32-byte block starts in the previous engine's
+		 * range rings that engine instead. Engine ranges are 10
+		 * indices apart (sdma_doorbell_range = 20 dwords, halved for
+		 * 8-byte doorbells, in aqua_vanjaram_doorbell_index_init()),
+		 * which puts odd engines 2 indices into a shared block.
+		 * Aligning costs at most 2 indices, and 8 queues per engine use
+		 * only 4 of the 10, so the aligned base stays in range. The
+		 * 512-index mirror offset keeps the alignment.
+		 */
+		if (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 3) ||
+		    KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 4) ||
+		    KFD_GC_VERSION(dev) == IP_VERSION(9, 5, 0))
+			engine_base = ALIGN(engine_base,
+					    KFD_SDMA_SHADER_DOORBELL_GRANULARITY);
+
+		valid_id = engine_base +
+			   (q->properties.sdma_queue_id & 1) *
+			   KFD_QUEUE_DOORBELL_MIRROR_OFFSET +
+			   (q->properties.sdma_queue_id >> 1);
 
 		if (restore_id && *restore_id != valid_id)
 			return -EINVAL;
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -132,6 +132,13 @@
  */
 #define KFD_QUEUE_DOORBELL_MIRROR_OFFSET 512
 
+/*
+ * On GC 9.4.3, 9.4.4 and 9.5.0, doorbell writes issued from shaders are
+ * routed to an SDMA engine at 32-byte granularity, i.e. 4 indices with the
+ * 8-byte SDMA doorbells used on SOC15.
+ */
+#define KFD_SDMA_SHADER_DOORBELL_GRANULARITY 4
+
 /**
  * enum kfd_ioctl_flags - KFD ioctl flags
  * Various flags that can be set in &amdkfd_ioctl_desc.flags to control how


