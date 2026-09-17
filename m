Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D85C4D1785;
	Thu, 17 Sep 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664754; cv=none; b=quU785zLWNzeIr2lpSKrEJ01tsBf+y9C7cWx/CGTmXWhqa7I3NU4hr/BAOP/dr4OCcK9h2knDg656T17toipWyDY68+Gk7HS4aRjAqaF21F8Syd8fa055ZCnBNyBN2T63rG0DHNr3V1tQPzY7ZBZUJ9xvsZxHCxwCOJnECOaWfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664754; c=relaxed/simple;
	bh=T8Xmwfkoc7ArDPo3yqTxJDWpxIVGmvSXRpNhSZ5c2Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imYF3xrwXDGHkJO2+ETxgd9P/QwARLlA3BEOdtXxQm+b2YIz1H5WXSziyFjMZo98+azfw9AxcpN3bRL3k478/1/GmhthwWPZ5OwgSIxiFR2AgWWCsPMFga9E0H149B42ZG5nbcWfEOmGTD6zRwn08ePWCpfDJtpJtAsENO7+ERU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHLdsX2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHLdsX2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B081F00898;
	Thu, 17 Sep 2026 17:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664752;
	bh=jqsUrguvVhkN6IOuSMZrjl5+tpj1mAMYRma4Uadz2M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHLdsX2O1GUq6fVgoF6/FCzYNRM+/AS/bDOG1L91FOqMLDOE/+jCUUN+Ysch619JH
	 Mr0GP4jiooAktKNjnm9INZzqi2dzfRR2XAAMzHl5ag9dsaS7M/e/ShrJj1N08/bh9f
	 1GNzPUAJ22SudCNHbtLqaAAvI5Vr0wEnHGsTPvTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0438/1250] drm/amdkfd: Properly acquire queue buffers in CRIU restore
Date: Thu, 17 Sep 2026 16:03:53 +0100
Message-ID: <20260917151603.883763329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit 20a5e7ffdfecddc34c60a6b4483f42acf3d8731d ]

When kfd_queue_acquire_buffers() was split off from
set_queue_properties_from_user(), set_queue_properties_from_criu()
was missed. Thus, set_queue_properties_from_criu() is not
filling out the buffer fields of queue_properties, which
can come up when subsequent code expects them to be non-null.

Add the proper call to kfd_queue_acquire_buffers(), and also
use the right cast types in set_queue_properties_from_criu()
(which were missed at the same time)

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 88ed96abbbe27b70193544fbc1ee06448c274714)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c   | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index e96488f6b02d2..912c4ebd30405 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -974,8 +974,8 @@ static void set_queue_properties_from_criu(struct queue_properties *qp,
 	qp->priority = q_data->priority;
 	qp->queue_address = q_data->q_address;
 	qp->queue_size = q_data->q_size;
-	qp->read_ptr = (uint32_t *) q_data->read_ptr_addr;
-	qp->write_ptr = (uint32_t *) q_data->write_ptr_addr;
+	qp->read_ptr = (void __user *)q_data->read_ptr_addr;
+	qp->write_ptr = (void __user *)q_data->write_ptr_addr;
 	qp->eop_ring_buffer_address = q_data->eop_ring_buffer_address;
 	qp->eop_ring_buffer_size = q_data->eop_ring_buffer_size;
 	qp->ctx_save_restore_area_address = q_data->ctx_save_restore_area_address;
@@ -1064,10 +1064,18 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	memset(&qp, 0, sizeof(qp));
 	set_queue_properties_from_criu(&qp, q_data, NUM_XCC(pdd->dev->adev->gfx.xcc_mask));
 
+	ret = kfd_queue_acquire_buffers(pdd, &qp);
+	if (ret) {
+		pr_debug("failed to acquire user queue buffers for CRIU\n");
+		goto exit;
+	}
+
 	print_queue_properties(&qp);
 
 	ret = pqm_create_queue(&p->pqm, pdd->dev, &qp, &queue_id, q_data, mqd, ctl_stack, NULL);
 	if (ret) {
+		kfd_queue_unref_bo_vas(pdd, &qp);
+		kfd_queue_release_buffers(pdd, &qp);
 		pr_err("Failed to create new queue err:%d\n", ret);
 		goto exit;
 	}
-- 
2.53.0



