Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73436384CED;
	Sat, 17 Oct 2026 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254386; cv=none; b=RExQGdMnqWUllyPGu2rcygKpvCiD59yPGF0t2fubTL4fRuVnOF9dIpm6nVff2xmbis9S6PFo78/it5bFu3ncHJN/RN2s0xjEhAatwIw4xG/iHRjO3UkT4W2k8+Eb4O4em6KzvXCa0M7Ea/mh5MTochbRZdfN2EoM+8AzZDu4BYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254386; c=relaxed/simple;
	bh=2CniDHwygBb1iW3ETcvgkAuod34ibgbfSbz56JheIkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjM+J2Anp0PvYyJg/UcvdV30shJUy/um9oamMt4452M2JE5L6m/qLI7kBQaHG7u8yiSXeusmYM+T+iLbOKfr4mOHss4/bsaKdvHbUYYXtsHmYU/Qj3Qr3nSksZ92e3j9p5SZNZfbj86lt4O/ONlj1mLvYOVfr7qEdkdJuRuyxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNU7OkMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNU7OkMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FC41F000C4;
	Sat, 17 Oct 2026 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254385;
	bh=xufMphEWywQRYIkxUa5BycCn/ch/CA/mNQOI8hE7qS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNU7OkMmfJOFL8aOJTV2unFB08M90d2EyQQkf+cfpEeA08jTyLFNOTmOPXoeXlio1
	 WthQYwi6Cv+Mfyz+JS7S0ldyRaStqpvrkZl7USz7hb+MX96Uj+ZfkWGbQbyGLGVYep
	 Jdmf2C36RnzdDDyznb2beOCdpirHC0/oRb9JKxG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <david.yatsin@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/869] drm/amdkfd: Check bounds on CRIU restore queue type and mqd size
Date: Sat, 17 Oct 2026 17:53:48 +0200
Message-ID: <20261017160047.039210359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 .../drm/amd/amdkfd/kfd_device_queue_manager.c |  6 +++++
 .../drm/amd/amdkfd/kfd_device_queue_manager.h |  2 ++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |  3 ++-
 .../amd/amdkfd/kfd_process_queue_manager.c    | 24 +++++++++++++------
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index d03160a463d0f..8a6c59af4a4ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3575,6 +3575,12 @@ bool kfd_dqm_is_queue_in_process(struct device_queue_manager *dqm,
 	dqm_unlock(dqm);
 	return r;
 }
+
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm, enum kfd_queue_type type)
+{
+	return dqm->mqd_mgrs[get_mqd_type_from_queue_type(type)]->mqd_size;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 static void seq_reg_dump(struct seq_file *m,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index 09ab36f8e8c69..c03b6e6fb3688 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -327,6 +327,8 @@ int debug_refresh_runlist(struct device_queue_manager *dqm);
 bool kfd_dqm_is_queue_in_process(struct device_queue_manager *dqm,
 				 struct qcm_process_device *qpd,
 				 int doorbell_off, u32 *queue_format);
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm,
+				enum kfd_queue_type type);
 
 static inline unsigned int get_sh_mem_bases_32(struct kfd_process_device *pdd)
 {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 8f7e44afba635..939a6c92351b6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -440,7 +440,8 @@ enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_HIQ,
 	KFD_QUEUE_TYPE_DIQ,
 	KFD_QUEUE_TYPE_SDMA_XGMI,
-	KFD_QUEUE_TYPE_SDMA_BY_ENG_ID
+	KFD_QUEUE_TYPE_SDMA_BY_ENG_ID,
+	KFD_QUEUE_TYPE_MAX,
 };
 
 enum kfd_queue_format {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index be3f821dfd566..bf3c7d055fc33 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1015,6 +1015,23 @@ int kfd_criu_restore_queue(struct kfd_process *p,
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
 
@@ -1037,13 +1054,6 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 
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



