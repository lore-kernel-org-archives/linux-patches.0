Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3902711198;
	Sat,  3 Feb 2024 04:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933869; cv=none; b=ftETyuJRTStYz/HTKRGygtBJ1+0OskBH6piDJySYddz2S8XRnwTEbKsrzwyZ78+Yo0iwveGvhVEzTvSs1Anol8P+JvodY1i2t5kWRNH/QpNkRnx/u3sR2fwiiq1nvPk+5BuSVaxkZHmS+FtRfMA+z3s/vnh764U1meluKRkpT5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933869; c=relaxed/simple;
	bh=G88xCkwoWx+tB+ria/lBDJHFHpPqsZy/Ns6Cr22CLhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2rspmrkyWmfnlyERj5NEoWEoVT543pN0fowjeZ2NzGQT+Q5XvXIGA9a1UN1UvYN1n1idyOFhoC3Q6yQJeK0QYMWrilQElaEwrmz5K7StJoWazkmpGFLCCP8DQq1Gvm0q2y/kMoH7AzlanvU37a0Bc/RUz4KXfJxBAbHM1FibxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgQbXxkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgQbXxkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0132DC43394;
	Sat,  3 Feb 2024 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933869;
	bh=G88xCkwoWx+tB+ria/lBDJHFHpPqsZy/Ns6Cr22CLhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgQbXxkVbfJwc+1ImSCpUc42iawl5S4SmYg1hO4y7HQL45nyruYBx8pbDjmgM3yZu
	 Q8wOaCxkSw+fL8HYJ48OCiRR1VpLSDRWuBfBxfa6ldIUYHxQmtH2nHXhTdSwyydkzC
	 55M0AcAl1fzQy08u5nztn4dI+9ea7+fpPxpZESHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alice Wong <shiwei.wong@amd.com>,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 206/353] drm/amdkfd: fix mes set shader debugger process management
Date: Fri,  2 Feb 2024 20:05:24 -0800
Message-ID: <20240203035410.210647193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit bd33bb1409b494558a2935f7bbc7842def957fcd ]

MES provides the driver a call to explicitly flush stale process memory
within the MES to avoid a race condition that results in a fatal
memory violation.

When SET_SHADER_DEBUGGER is called, the driver passes a memory address
that represents a process context address MES uses to keep track of
future per-process calls.

Normally, MES will purge its process context list when the last queue
has been removed.  The driver, however, can call SET_SHADER_DEBUGGER
regardless of whether a queue has been added or not.

If SET_SHADER_DEBUGGER has been called with no queues as the last call
prior to process termination, the passed process context address will
still reside within MES.

On a new process call to SET_SHADER_DEBUGGER, the driver may end up
passing an identical process context address value (based on per-process
gpu memory address) to MES but is now pointing to a new allocated buffer
object during KFD process creation.  Since the MES is unaware of this,
access of the passed address points to the stale object within MES and
triggers a fatal memory violation.

The solution is for KFD to explicitly flush the process context address
from MES on process termination.

Note that the flush call and the MES debugger calls use the same MES
interface but are separated as KFD calls to avoid conflicting with each
other.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Tested-by: Alice Wong <shiwei.wong@amd.com>
Reviewed-by: Eric Huang <jinhuieric.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c       | 31 +++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h       | 10 +++---
 .../amd/amdkfd/kfd_process_queue_manager.c    |  1 +
 drivers/gpu/drm/amd/include/mes_v11_api_def.h |  3 +-
 4 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 9ddbf1494326..30c010836658 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -886,6 +886,11 @@ int amdgpu_mes_set_shader_debugger(struct amdgpu_device *adev,
 	op_input.op = MES_MISC_OP_SET_SHADER_DEBUGGER;
 	op_input.set_shader_debugger.process_context_addr = process_context_addr;
 	op_input.set_shader_debugger.flags.u32all = flags;
+
+	/* use amdgpu mes_flush_shader_debugger instead */
+	if (op_input.set_shader_debugger.flags.process_ctx_flush)
+		return -EINVAL;
+
 	op_input.set_shader_debugger.spi_gdbg_per_vmid_cntl = spi_gdbg_per_vmid_cntl;
 	memcpy(op_input.set_shader_debugger.tcp_watch_cntl, tcp_watch_cntl,
 			sizeof(op_input.set_shader_debugger.tcp_watch_cntl));
@@ -905,6 +910,32 @@ int amdgpu_mes_set_shader_debugger(struct amdgpu_device *adev,
 	return r;
 }
 
+int amdgpu_mes_flush_shader_debugger(struct amdgpu_device *adev,
+				     uint64_t process_context_addr)
+{
+	struct mes_misc_op_input op_input = {0};
+	int r;
+
+	if (!adev->mes.funcs->misc_op) {
+		DRM_ERROR("mes flush shader debugger is not supported!\n");
+		return -EINVAL;
+	}
+
+	op_input.op = MES_MISC_OP_SET_SHADER_DEBUGGER;
+	op_input.set_shader_debugger.process_context_addr = process_context_addr;
+	op_input.set_shader_debugger.flags.process_ctx_flush = true;
+
+	amdgpu_mes_lock(&adev->mes);
+
+	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	if (r)
+		DRM_ERROR("failed to set_shader_debugger\n");
+
+	amdgpu_mes_unlock(&adev->mes);
+
+	return r;
+}
+
 static void
 amdgpu_mes_ring_to_queue_props(struct amdgpu_device *adev,
 			       struct amdgpu_ring *ring,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
index a27b424ffe00..c2c88b772361 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -291,9 +291,10 @@ struct mes_misc_op_input {
 			uint64_t process_context_addr;
 			union {
 				struct {
-					uint64_t single_memop : 1;
-					uint64_t single_alu_op : 1;
-					uint64_t reserved: 30;
+					uint32_t single_memop : 1;
+					uint32_t single_alu_op : 1;
+					uint32_t reserved: 29;
+					uint32_t process_ctx_flush: 1;
 				};
 				uint32_t u32all;
 			} flags;
@@ -369,7 +370,8 @@ int amdgpu_mes_set_shader_debugger(struct amdgpu_device *adev,
 				const uint32_t *tcp_watch_cntl,
 				uint32_t flags,
 				bool trap_en);
-
+int amdgpu_mes_flush_shader_debugger(struct amdgpu_device *adev,
+				uint64_t process_context_addr);
 int amdgpu_mes_add_ring(struct amdgpu_device *adev, int gang_id,
 			int queue_type, int idx,
 			struct amdgpu_mes_ctx_data *ctx_data,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 77f493262e05..8e55e78fce4e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -87,6 +87,7 @@ void kfd_process_dequeue_from_device(struct kfd_process_device *pdd)
 		return;
 
 	dev->dqm->ops.process_termination(dev->dqm, &pdd->qpd);
+	amdgpu_mes_flush_shader_debugger(dev->adev, pdd->proc_ctx_gpu_addr);
 	pdd->already_dequeued = true;
 }
 
diff --git a/drivers/gpu/drm/amd/include/mes_v11_api_def.h b/drivers/gpu/drm/amd/include/mes_v11_api_def.h
index b1db2b190187..e07e93167a82 100644
--- a/drivers/gpu/drm/amd/include/mes_v11_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v11_api_def.h
@@ -571,7 +571,8 @@ struct SET_SHADER_DEBUGGER {
 		struct {
 			uint32_t single_memop : 1;  /* SQ_DEBUG.single_memop */
 			uint32_t single_alu_op : 1; /* SQ_DEBUG.single_alu_op */
-			uint32_t reserved : 30;
+			uint32_t reserved : 29;
+			uint32_t process_ctx_flush : 1;
 		};
 		uint32_t u32all;
 	} flags;
-- 
2.43.0



