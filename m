Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7050129E;
	Thu, 17 Sep 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668157; cv=none; b=h8Z4XsQCkGOpPknb1SS1eWFqIhFPzvyq2XbHHmrLAJDLIMZNVjF2szJ/rH4G79VpFd+lblPMBusntrVe2nAVneLfoxcWPrbC5+XtWYZfYBlgCn1MtbmfjwqL3AgNKbEx6rpHTpoqG5k2wjXXvwrOFYPEW6t4ReaDVfZfcQWGktc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668157; c=relaxed/simple;
	bh=QMYIPmYBDpe6h+z0IRMfEp6PucDYSV3dlldINIFfVWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2ZJyQH5LmychUCSHuwqCNivJO/7I8yFUIATxmfjlVaEX6CwgA69PBL72hgp1CWw8ZhTIWSizj/zP9IRCmQncHZgHa67SF0+GuiAO28iWMr/b4+xr+PlJ/viEjzMtmz6pAB/hw6hg2S8jf2l8IzPzQPWAKyoQjYKcgfJTtqEUvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om+fzz0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om+fzz0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F259A1F000FF;
	Thu, 17 Sep 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668155;
	bh=K8RiO8sIBwmfMqBMRYvbMsjjywDYeY/HSwLn1SRq9y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=om+fzz0BkeGAd6C5TplSylEq/bSSzlQ0POReXsKR/8dq3kkC1g91ynqGBJ+07TJIG
	 hjD5CQ+AZLYmFcuJE7EMVQuQ3v7J1sGrg1bMYIRMQsdILsOEF+aGjrwbCbUZnRStyP
	 EhmSxhXeKi0wZtyfVbjOmrrfEr5+7NYWikyHI/tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0333/1102] drm/amdkfd: Properly acquire queue buffers in CRIU restore
Date: Thu, 17 Sep 2026 16:04:36 +0100
Message-ID: <20260917151547.993816441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 4ba100236abbf..be3f821dfd566 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -978,8 +978,8 @@ static void set_queue_properties_from_criu(struct queue_properties *qp,
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
@@ -1051,11 +1051,19 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 	memset(&qp, 0, sizeof(qp));
 	set_queue_properties_from_criu(&qp, q_data);
 
+	ret = kfd_queue_acquire_buffers(pdd, &qp);
+	if (ret) {
+		pr_debug("failed to acquire user queue buffers for CRIU\n");
+		goto exit;
+	}
+
 	print_queue_properties(&qp);
 
 	ret = pqm_create_queue(&p->pqm, pdd->dev, NULL, &qp, &queue_id, q_data, mqd, ctl_stack,
 				NULL);
 	if (ret) {
+		kfd_queue_unref_bo_vas(pdd, &qp);
+		kfd_queue_release_buffers(pdd, &qp);
 		pr_err("Failed to create new queue err:%d\n", ret);
 		goto exit;
 	}
-- 
2.53.0



