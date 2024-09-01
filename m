Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C1E28387;
	Sun,  1 Sep 2024 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208198; cv=none; b=uRoZP/+xZqL9guzHOCbSIti+CfuNi+0jGqL7LysL3zE6gr7M72KUNjlptbtDblG5v5Z4B0LkO3drvH++bxz5dU3LUaRD88RFHJGaHf9pfPk6ijRM8lxn4OgvZ5f4FSwBwo5aHCLEO7BCTTE+T8zltLC5UHZAawpANo6QtpUwu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208198; c=relaxed/simple;
	bh=vICCKWGRUXY7jAMjrrRKpJ7PObNL8r53dWRYShrMgws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEViAYRRAmuDwmUQCpdJ5rLUonrXk5N8+R9md1PSDZtUc+eFEeRW3t7EujxT9Jzsj3Oa8sSg76OdmZkysfUk5jTQI4WUwbTFZNlnQcDrohZyC9PzgQ9v3uyrXsdnlTzKL7reb50qYyFVZng5OEm4jwlCc1pg2IIMvNUpLVIJ5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDHloLQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDHloLQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95317C4CEC3;
	Sun,  1 Sep 2024 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208198;
	bh=vICCKWGRUXY7jAMjrrRKpJ7PObNL8r53dWRYShrMgws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDHloLQylVymHn/XkJFTduUubgQrpIQs1I68dXTQ2AJnKBNg9P8EQ6lax0sc0pLOb
	 eLbmG2bw3XSkXCoSAQzaCg+xg/winkVTroLYDwAh6/V2GWpwrrgIVyBHRCOzMTyfom
	 i51Dt9Li8VhCGAxEdm+K/qP2wyhVxKgLmVCeTv0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 001/149] drm/amdgpu/mes: fix mes ring buffer overflow
Date: Sun,  1 Sep 2024 18:15:12 +0200
Message-ID: <20240901160817.520390148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

commit 11752c013f562a1124088a35bd314aa0e9f0e88f upstream.

wait memory room until enough before writing mes packets
to avoid ring buffer overflow.

v2: squash in sched_hw_submission fix

Fixes: de3246254156 ("drm/amdgpu: cleanup MES11 command submission")
Fixes: fffe347e1478 ("drm/amdgpu: cleanup MES12 command submission")
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 34e087e8920e635c62e2ed6a758b0cd27f836d13)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    2 ++
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c   |   18 ++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -212,6 +212,8 @@ int amdgpu_ring_init(struct amdgpu_devic
 	 */
 	if (ring->funcs->type == AMDGPU_RING_TYPE_KIQ)
 		sched_hw_submission = max(sched_hw_submission, 256);
+	if (ring->funcs->type == AMDGPU_RING_TYPE_MES)
+		sched_hw_submission = 8;
 	else if (ring == &adev->sdma.instance[0].page)
 		sched_hw_submission = 256;
 
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -163,7 +163,7 @@ static int mes_v11_0_submit_pkt_and_poll
 	const char *op_str, *misc_op_str;
 	unsigned long flags;
 	u64 status_gpu_addr;
-	u32 status_offset;
+	u32 seq, status_offset;
 	u64 *status_ptr;
 	signed long r;
 	int ret;
@@ -191,6 +191,13 @@ static int mes_v11_0_submit_pkt_and_poll
 	if (r)
 		goto error_unlock_free;
 
+	seq = ++ring->fence_drv.sync_seq;
+	r = amdgpu_fence_wait_polling(ring,
+				      seq - ring->fence_drv.num_fences_mask,
+				      timeout);
+	if (r < 1)
+		goto error_undo;
+
 	api_status = (struct MES_API_STATUS *)((char *)pkt + api_status_off);
 	api_status->api_completion_fence_addr = status_gpu_addr;
 	api_status->api_completion_fence_value = 1;
@@ -203,8 +210,7 @@ static int mes_v11_0_submit_pkt_and_poll
 	mes_status_pkt.header.dwsize = API_FRAME_SIZE_IN_DWORDS;
 	mes_status_pkt.api_status.api_completion_fence_addr =
 		ring->fence_drv.gpu_addr;
-	mes_status_pkt.api_status.api_completion_fence_value =
-		++ring->fence_drv.sync_seq;
+	mes_status_pkt.api_status.api_completion_fence_value = seq;
 
 	amdgpu_ring_write_multiple(ring, &mes_status_pkt,
 				   sizeof(mes_status_pkt) / 4);
@@ -224,7 +230,7 @@ static int mes_v11_0_submit_pkt_and_poll
 		dev_dbg(adev->dev, "MES msg=%d was emitted\n",
 			x_pkt->header.opcode);
 
-	r = amdgpu_fence_wait_polling(ring, ring->fence_drv.sync_seq, timeout);
+	r = amdgpu_fence_wait_polling(ring, seq, timeout);
 	if (r < 1 || !*status_ptr) {
 
 		if (misc_op_str)
@@ -247,6 +253,10 @@ static int mes_v11_0_submit_pkt_and_poll
 	amdgpu_device_wb_free(adev, status_offset);
 	return 0;
 
+error_undo:
+	dev_err(adev->dev, "MES ring buffer is full.\n");
+	amdgpu_ring_undo(ring);
+
 error_unlock_free:
 	spin_unlock_irqrestore(&mes->ring_lock, flags);
 


