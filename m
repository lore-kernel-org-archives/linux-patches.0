Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215338;
	b=Zrt/Zo3wLDy1OseA1E1PIRA51Di/MBguVldFfgjwE9bAue8jCW6TjyyvP0xLz2DPbZO8
	 /n7AzBT277hGAF8mfru41VUYGNjDA5LNl39UbvEVQCopdln4sOX3Ll+aZ5k8xC0Cqf9Cb
	 StD3d8jkurTz9rvjT2mBrA6DWcQesu8HP9rXei3PCH1C5S/Jq9vsqTOIC2ei6xdcTPRuS
	 t1b+lH7pjkLoP0F2LCH84N0V2zIWdZcOzd/MJqwcbOc+ngUOansxMsHCARlnxIL4SKdfO
	 rPQLWH8DCqfDpSmx6dtyNZGLeY1dzKB7C6CNNUYF2v7seuJeEHxpE6ohIGh9910Bskg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=js7d9CnTj2OjEzvthB2gAbqNdxOdUmupbatIO3E/aC8=;
	b=Kfvb8LgOUxA5tg5+PSN09jpwcfZhV6o94zXk6LZcGNsrI5BWl5gsJZXKAtELhjQI6CbI
	 AQfdVlhxYsX846ixLxf+xHwnYDJ/RcdGQAOZ+a5Nh73CMvRsgYJ51Z7nesHreLo3zVIjJ
	 J4p4tldP7A+oe3hSVldjnOfEOVw4xqbph+XBl4NYyighr+WHZ+Sd1G9jWr2S5X38WaJwr
	 XJYOa3La8wBP+H1SV0Sgxu/am9tAdAhmtlrIWzD10U5lLNbDNxhJnfbriLaQc+L4O5B1g
	 wd0c9B6QkgOqzbkMbj+lh0efqBN9xRfHTs/EpvciAPrJ8BWfPsGZVT9GkS4Q6PhkhfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmR8ELXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0758F606A31A;
	Wed, 28 Oct 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmR8ELXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B7C1F01828;
	Wed, 28 Oct 2026 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215337;
	bh=js7d9CnTj2OjEzvthB2gAbqNdxOdUmupbatIO3E/aC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmR8ELXdTPEVbIXloYzQsvfzDP9WHQdDdqLY3IZhStlqLLfV3E115K7DQhqjehQbD
	 qmdq97sSclpCvLp6MMkRsocjGXBF4b4D7qZ+l1Hhal3xZN+cEWFTNtcDggdtN8PCye
	 MXtCIOfgjcLNGJMqKLlTwDmO+hFoghLchQ0AYtCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <david.yatsin@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1174/1887] drm/amdkfd: Check bounds on CRIU restore queue type and mqd size
Date: Wed, 28 Oct 2026 17:54:30 +0100
Message-ID: <20261028170526.122595144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit 47ea05f246bebc81c7796f56265cffd812cf0601 ]

We weren't checking whether the values provided in the private
data in kfd CRIU restore were within bounds.

For queue type, add a KFD_QUEUE_TYPE_MAX and ensure the provided
type is less than it.

For mqd_size, add new function mqd_size_from_queue_type and confirm
that the provided mqd_size matches expectations.

Reviewed-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f19d8086f6644083c913d70bfdeee20e1b6f46a5)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c |  5 ++++
 .../drm/amd/amdkfd/kfd_device_queue_manager.h |  2 ++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |  3 ++-
 .../amd/amdkfd/kfd_process_queue_manager.c    | 24 +++++++++++++------
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 689abc3d3a395..976e2c808679a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2437,6 +2437,11 @@ static void kfd_process_hw_exception(struct work_struct *work)
 	amdgpu_amdkfd_gpu_reset(dqm->dev->adev);
 }
 
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm, enum kfd_queue_type type)
+{
+	return dqm->mqd_mgrs[get_mqd_type_from_queue_type(type)]->mqd_size;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 static void seq_reg_dump(struct seq_file *m,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index a537b9ef3e167..593f5d273aa98 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -279,6 +279,8 @@ unsigned int get_queues_per_pipe(struct device_queue_manager *dqm);
 unsigned int get_pipes_per_mec(struct device_queue_manager *dqm);
 unsigned int get_num_sdma_queues(struct device_queue_manager *dqm);
 unsigned int get_num_xgmi_sdma_queues(struct device_queue_manager *dqm);
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm,
+				enum kfd_queue_type type);
 
 static inline unsigned int get_sh_mem_bases_32(struct kfd_process_device *pdd)
 {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 6af058e146ed8..cdcaba185052c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -404,7 +404,8 @@ enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_SDMA,
 	KFD_QUEUE_TYPE_HIQ,
 	KFD_QUEUE_TYPE_DIQ,
-	KFD_QUEUE_TYPE_SDMA_XGMI
+	KFD_QUEUE_TYPE_SDMA_XGMI,
+	KFD_QUEUE_TYPE_MAX,
 };
 
 enum kfd_queue_format {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index a15bf1e382767..7c85bb9e270e7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -829,6 +829,23 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 		goto exit;
 	}
 
+	pdd = kfd_process_device_data_by_id(p, q_data->gpu_id);
+	if (!pdd) {
+		pr_err("Failed to get pdd\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (q_data->type >= KFD_QUEUE_TYPE_MAX) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (q_data->mqd_size != mqd_size_from_queue_type(pdd->dev->dqm, q_data->type)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	*priv_data_offset += sizeof(*q_data);
 	q_extra_data_size = (uint64_t)q_data->ctl_stack_size + q_data->mqd_size;
 
@@ -851,13 +868,6 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 
 	*priv_data_offset += q_extra_data_size;
 
-	pdd = kfd_process_device_data_by_id(p, q_data->gpu_id);
-	if (!pdd) {
-		pr_err("Failed to get pdd\n");
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	if (!pdd->doorbell_index &&
 	    kfd_alloc_process_doorbells(pdd->dev, &pdd->doorbell_index) < 0) {
 		ret = -ENOMEM;
-- 
2.53.0



