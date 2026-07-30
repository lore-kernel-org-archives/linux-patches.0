Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189653A254B;
	Thu, 30 Jul 2026 14:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422500; cv=none; b=AOm5eWFqxZ4ygtz3sEz5kGPJc2YcnNU86HPcc9nXEt3YGkzAishcoLlnfTk2S7ert5llUWJARjKI4CJSn+bHqUTht9RkHXwjRRI2L53C2wXqPKWSdr5+UwY9i1OtujTTzv6AlKRxG3fiZqqW8YOeD9xBmhKFFGuMKVqjFTaO9Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422500; c=relaxed/simple;
	bh=8Bm1cIrriWXxqram6vMPQWJgvJO46orHT8Lth9Bb7po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIsfC1BCEXByXORnZipCK4WZxx683abmVNxxNYtkGaWv1w3F5WFJvlwh+F9b9CRq/I9VqxccML7j/09kYrdM0NkqAGwKl/pOTOAqU+avzJSrITxfcgtWDf1G1Uv/yKDayF9Cxw6yjUHMZptVtDUmf5awlm83y4NMkKahWSfMqEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo+TgTcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo+TgTcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7493D1F000E9;
	Thu, 30 Jul 2026 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422499;
	bh=BJ3R6x8dNVXK0RyCH1hpqlxTuHKz1IQhAclELPbrOV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qo+TgTcbCcJjK1wkgNM34b7Y5jd67QFWDeqLZLaKsmuUTVgDiY6tQLZowszjWg7GW
	 j9aqFR2JbeO1307wu5j5k8b6+afrO3Mm+brWRiT2qXOWVlFzocThY0MCXSQ2NQQhKq
	 JUv7CB57yNS0RMzyjoaWApJkcKjb6EMxs3HJinSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yat Sin <david.yatsin@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 415/744] drm/amdkfd: Check bounds on CRIU restore queue type and mqd size
Date: Thu, 30 Jul 2026 16:11:28 +0200
Message-ID: <20260730141453.118421836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit 47ea05f246bebc81c7796f56265cffd812cf0601 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |    6 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |    2 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                  |    3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   24 ++++++++++++-----
 4 files changed, 27 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3649,6 +3649,12 @@ out:
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
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -329,6 +329,8 @@ int debug_refresh_runlist(struct device_
 bool kfd_dqm_is_queue_in_process(struct device_queue_manager *dqm,
 				 struct qcm_process_device *qpd,
 				 int doorbell_off, u32 *queue_format);
+size_t mqd_size_from_queue_type(struct device_queue_manager *dqm,
+				enum kfd_queue_type type);
 
 static inline unsigned int get_sh_mem_bases_32(struct kfd_process_device *pdd)
 {
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -436,7 +436,8 @@ enum kfd_queue_type  {
 	KFD_QUEUE_TYPE_SDMA,
 	KFD_QUEUE_TYPE_HIQ,
 	KFD_QUEUE_TYPE_SDMA_XGMI,
-	KFD_QUEUE_TYPE_SDMA_BY_ENG_ID
+	KFD_QUEUE_TYPE_SDMA_BY_ENG_ID,
+	KFD_QUEUE_TYPE_MAX,
 };
 
 enum kfd_queue_format {
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -1003,6 +1003,23 @@ int kfd_criu_restore_queue(struct kfd_pr
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
 
@@ -1025,13 +1042,6 @@ int kfd_criu_restore_queue(struct kfd_pr
 
 	*priv_data_offset += q_extra_data_size;
 
-	pdd = kfd_process_device_data_by_id(p, q_data->gpu_id);
-	if (!pdd) {
-		pr_err("Failed to get pdd\n");
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	/*
 	 * data stored in this order:
 	 * mqd[xcc0], mqd[xcc1],..., ctl_stack[xcc0], ctl_stack[xcc1]...


