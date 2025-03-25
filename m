Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37E5258CD1;
	Tue, 25 Mar 2025 12:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906441; cv=none; b=u5xFa979dsSYZy8mMvoj8JcUZppch0lAfVeIFHQSx5KyR596M03Q+lO5MSG3QWYZeKTWi+IpxpTq8j3tJXqK4J1of/vWFlMV2bZIg2jJAniU2VWCsK3knUR+rhaQjA4pzBOwTlJwECWs4hQNTlgsapAh2Da8ltSwj9vuU2rC6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906441; c=relaxed/simple;
	bh=BtuaNMr8dPjrJAts6EoT2ws8/KmfMUv3Rw9uyea6XoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXs7emm6zd5tTFEJudE1xydPgLZ85yDVIAYlNeMCKRxy9XkBw4xmFq43kQTwJbBd4LSsMLJm/vJ7mmWGdIzXSmf1xwS6RzeyUwoW3QaiIiaQM9HnDaKCMUOfr9sovgiGphD0COkGKcp1PumMTEHLWUMldSy6suwWVeFhMfWanHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFs5UKCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFs5UKCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E4AC4CEE4;
	Tue, 25 Mar 2025 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906440;
	bh=BtuaNMr8dPjrJAts6EoT2ws8/KmfMUv3Rw9uyea6XoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFs5UKCiXKEI6ozn75RYjgQyHm9quHSCtM8xlP29H3VWehczW+NbGpuxoiBtNu8Ml
	 6SgFJo+/2IfIQy3xtjztpI2tFtstVo56Po6/qwyUNpP5tZGnM0lpT34tN6VOanc54d
	 6keRNVpyjoy9Yb0phjjoe7FtFZ6gi82O7OFnkNH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 101/116] drm/amdkfd: Fix user queue validation on Gfx7/8
Date: Tue, 25 Mar 2025 08:23:08 -0400
Message-ID: <20250325122151.786662934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit 542c3bb836733a1325874310d54d25b4907ed10e upstream.

To workaround queue full h/w issue on Gfx7/8, when application create
AQL queue, the ring buffer bo allocate size is queue_size/2 and
map queue_size ring buffer to GPU in 2 pieces using 2 attachments, each
attachment map size is queue_size/2, with same ring_bo backing memory.

For Gfx7/8, user queue buffer validation should use queue_size/2 to
verify ring_bo allocation and mapping size.

Fixes: 68e599db7a54 ("drm/amdkfd: Validate user queue buffers")
Suggested-by: Tomáš Trnka <trnka@scm.com>
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7a477735f1771b9a9346a5fbd09d7ff0641723a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 24396a2c77bd..4afff7094caf 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -233,6 +233,7 @@ void kfd_queue_buffer_put(struct amdgpu_bo **bo)
 int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_properties *properties)
 {
 	struct kfd_topology_device *topo_dev;
+	u64 expected_queue_size;
 	struct amdgpu_vm *vm;
 	u32 total_cwsr_size;
 	int err;
@@ -241,6 +242,15 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 	if (!topo_dev)
 		return -EINVAL;
 
+	/* AQL queues on GFX7 and GFX8 appear twice their actual size */
+	if (properties->type == KFD_QUEUE_TYPE_COMPUTE &&
+	    properties->format == KFD_QUEUE_FORMAT_AQL &&
+	    topo_dev->node_props.gfx_target_version >= 70000 &&
+	    topo_dev->node_props.gfx_target_version < 90000)
+		expected_queue_size = properties->queue_size / 2;
+	else
+		expected_queue_size = properties->queue_size;
+
 	vm = drm_priv_to_vm(pdd->drm_priv);
 	err = amdgpu_bo_reserve(vm->root.bo, false);
 	if (err)
@@ -255,7 +265,7 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 		goto out_err_unreserve;
 
 	err = kfd_queue_buffer_get(vm, (void *)properties->queue_address,
-				   &properties->ring_bo, properties->queue_size);
+				   &properties->ring_bo, expected_queue_size);
 	if (err)
 		goto out_err_unreserve;
 
-- 
2.49.0



