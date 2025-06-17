Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1740285076;
	Tue, 17 Jun 2025 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178780; cv=none; b=U7nwXy+d17jR6zE2UxUHmyk+kOo72jAY+sj1GY+pI3UG6ArgJ0qaf1WWnkm3DJJlzqv4hL/BgJ+QHLO9O0C9dnuFwLkca7C/F4win5R09FwRpph2IqFkllqDarC0pBrDRySA6gpNUHm1C+O1MkZf/4Dx9qCfgo4xqkH8EA+SfwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178780; c=relaxed/simple;
	bh=Y24XO4553cTtxEV4O+1mo+UJvnYvj9/zgASQjT/uaMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkizUkN3/Iy6EomQlq4HIqs5JOadFQZmyufuFskR+uaVtTpXXVRk4uOnPaRNBLvkOyDYgzra6ysjyPaoZNe0OIdiitkS0Mf5YLkYKzG/at76APkEwFs17b2KRNdDZ4D8F/OIK0jLSGXcfqy9gZR2aNN3Htp+yNle+hXdqcs9NRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezTIx5Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezTIx5Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AEDC4CEE7;
	Tue, 17 Jun 2025 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178779;
	bh=Y24XO4553cTtxEV4O+1mo+UJvnYvj9/zgASQjT/uaMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezTIx5Zhlarp/xlKi0IUNDfNpiNjCi4nWnVTxKM0XtpObcLIAP/DcBSe7QBl9ZRjl
	 NZcV9eVi1ohvK57q3yXXh7esKVDtI1CkD0eHe87IiF+a3JCENoOcru4xRxdXiwKW0L
	 522oXePuvzq/AxjQbU9vxchpTGTboHgsy1fSR93A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 552/780] accel/ivpu: Reorder Doorbell Unregister and Command Queue Destruction
Date: Tue, 17 Jun 2025 17:24:20 +0200
Message-ID: <20250617152513.983877159@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit 4557cc834712eca4eae7adbd9f0a06bdd8f79c99 ]

Refactor ivpu_cmdq_unregister() to ensure the doorbell is unregistered
before destroying the command queue. The NPU firmware requires doorbells
to be unregistered prior to command queue destruction.

If doorbell remains registered when command queue destroy command is sent
firmware will automatically unregister the doorbell, making subsequent
unregister attempts no-operations (NOPs).

Ensure compliance with firmware expectations by moving the doorbell
unregister call ahead of the command queue destruction logic,
thus preventing unnecessary NOP operation.

Fixes: 465a3914b254 ("accel/ivpu: Add API for command queue create/destroy/submit")
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250515094124.255141-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index b28da35c30b67..1c8e283ad9854 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -247,6 +247,10 @@ static int ivpu_cmdq_unregister(struct ivpu_file_priv *file_priv, struct ivpu_cm
 	if (!cmdq->db_id)
 		return 0;
 
+	ret = ivpu_jsm_unregister_db(vdev, cmdq->db_id);
+	if (!ret)
+		ivpu_dbg(vdev, JOB, "DB %d unregistered\n", cmdq->db_id);
+
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW) {
 		ret = ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->id);
 		if (!ret)
@@ -254,10 +258,6 @@ static int ivpu_cmdq_unregister(struct ivpu_file_priv *file_priv, struct ivpu_cm
 				 cmdq->id, file_priv->ctx.id);
 	}
 
-	ret = ivpu_jsm_unregister_db(vdev, cmdq->db_id);
-	if (!ret)
-		ivpu_dbg(vdev, JOB, "DB %d unregistered\n", cmdq->db_id);
-
 	xa_erase(&file_priv->vdev->db_xa, cmdq->db_id);
 	cmdq->db_id = 0;
 
-- 
2.39.5



