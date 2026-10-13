Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E3C4F68CD;
	Tue, 13 Oct 2026 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895903; cv=none; b=ub3i5JvSkkEL/SXZnZuN+/Ce39pByqtW8+zGcsT6NG0arS85+hsGQSjFQjg1Br+zeihwfJNx89yIP0++H/23dhuHsmOlqdA5m2H44vJzuPfKFfluN0tX/K1SGvBG4+3AQnzfwUaqQgpJDletJ5fAfxSFAXNqc9VpQ/W1F5DeHnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895903; c=relaxed/simple;
	bh=IfKaEPmkCbDQDefH21rMZVDFj/+X5OT4lFhKGha5yEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLWKCh3bn0qQFdOQ1NNC1O826NtKsRdlr2SkY6Cbx5gy0Qc6/+5/eyYnciBKI0frM/bo5stN2AXhGpM9luQRs1ef1NzJAQw82LsNDNorkCYjyPS/n9onuetfVeVOUnSBDYvz84c6HAVWkkCmjeXpdeCtAxlmZi5wxvUvti8JjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFcJjILo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFcJjILo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEDC1F000FF;
	Tue, 13 Oct 2026 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895901;
	bh=M3s/yLE0nHCrl7UpF8QVJ6iTqauqM9M+fnAjg/l28go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFcJjILotdO3SJUgyyLj2SmGHeI/jHdiQfpWBy4iXbvxgKTgI1844dVSC0wOSW+D4
	 +ERkDiabtPoLZh1xtRXEgTRcskOxDzWiL61/0Q2VdrySMeg96c/75ylF/EB50STgGR
	 bXWTwv7albkk5HBsMI5yIXKXINU162R+QlpfSrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleel Kudchadker <Saleel.Kudchadker@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 432/497] drm/amdkfd: align SDMA doorbell base for shader doorbell writes
Date: Tue, 13 Oct 2026 13:39:59 +0200
Message-ID: <20261013112918.140246427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,12 +424,32 @@ static int allocate_doorbell(struct qcm_
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


