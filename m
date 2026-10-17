Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA43B19BA;
	Sat, 17 Oct 2026 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259043; cv=none; b=p4/EKjUQ1pl5F1dY1CgYQcJJGs/Zbz5dobWeb3wS73Q3LvFGQDaJ2U2uNIM7sgcoc4r5t7BoyTN54uMvI6+/hWKKdQOxSWbMlGUMVvZb3fxqsfto/RPCMDZjKIrt0Ty9HmKiYg0KH5iOZrtewUecZbDl2HBwGR4dOm2ckm/HLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259043; c=relaxed/simple;
	bh=OUdxmrlZJYZ2D8VrY+laE8NNHB0NCjxWMURDaPJI6EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwHXPo018wDKP2gGpHeJHWo4O/GrxvQjVpHvFpnyjLXDQbTdp9DjQ8jpMAtSavIHTChjwhpGylDWzNSv+EGaDRzDL2zodfwNck95PGwz4b3y0wkOd6T7W6EIgc8Z2xmRpdEkqjkf6k8WrDOxx94lD3UaIsz1yxcJIalvXI5VsIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk49kBlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk49kBlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E621F000C4;
	Sat, 17 Oct 2026 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259042;
	bh=CaBajhjC209ZfKb886Sim8fpQqX7xOyED+/rpX9IG3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk49kBlSziOdDM90T98MZROlSwDzu4e/Cr/RKdEvLCqXrd27LeR7gFnRdR9WJl5X3
	 YPerbnI29i34EWav+D4t9+qaPCUeTb1ZCjXg3wqOT8fp7a11AfQatlNdPIgV35IYol
	 PtqnliBYOBt2jlJNO48E5N5VyBZVmndaWISgpevQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <david.yatsin@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1083/1674] drm/amdkfd: Check bounds on CRIU restore queue type and mqd size
Date: Sat, 17 Oct 2026 17:55:55 +0200
Message-ID: <20261017160458.926937274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 773a95851ecb9..6b274e4f0af35 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3137,6 +3137,11 @@ int debug_refresh_runlist(struct device_queue_manager *dqm)
 	return debug_map_and_unlock(dqm);
 }
 
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm, enum kfd_queue_type type)
+{
+	return dqm->mqd_mgrs[get_mqd_type_from_queue_type(type)]->mqd_size;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 static void seq_reg_dump(struct seq_file *m,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index cf7e182588f80..d6220d77a06cc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -302,6 +302,8 @@ void set_queue_snapshot_entry(struct queue *q,
 int debug_lock_and_unmap(struct device_queue_manager *dqm);
 int debug_map_and_unlock(struct device_queue_manager *dqm);
 int debug_refresh_runlist(struct device_queue_manager *dqm);
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm,
+				enum kfd_queue_type type);
 
 static inline unsigned int get_sh_mem_bases_32(struct kfd_process_device *pdd)
 {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 4904ca5a4932a..8f6fe5312b26e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -433,7 +433,8 @@ enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_SDMA,
 	KFD_QUEUE_TYPE_HIQ,
 	KFD_QUEUE_TYPE_DIQ,
-	KFD_QUEUE_TYPE_SDMA_XGMI
+	KFD_QUEUE_TYPE_SDMA_XGMI,
+	KFD_QUEUE_TYPE_MAX,
 };
 
 enum kfd_queue_format {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 3f6fc8d0984d1..430a79efa0bc5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -946,6 +946,23 @@ int kfd_criu_restore_queue(struct kfd_process *p,
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
 
@@ -968,13 +985,6 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 
 	*priv_data_offset += q_extra_data_size;
 
-	pdd = kfd_process_device_data_by_id(p, q_data->gpu_id);
-	if (!pdd) {
-		pr_err("Failed to get pdd\n");
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	/* data stored in this order: mqd, ctl_stack */
 	mqd = q_extra_data;
 	ctl_stack = mqd + q_data->mqd_size;
-- 
2.53.0



