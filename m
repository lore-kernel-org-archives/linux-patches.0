Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8804CDDF7;
	Thu, 17 Sep 2026 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667502; cv=none; b=GghcwHToCxRJLyIQDjTOjmZ0NuaO0gA3ADO2D7Yu0S0SnCGkCzoEhJ/oBmx1MCaAW8hKSiRd2yduKDK82iAk0ofKxSmQ4zCLHJbaivqKSDerkTDWVjICDFYUHI6j8lR36f7BD0+jmpZTtstUDmXosmy+D019vyDl77EgBai9jNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667502; c=relaxed/simple;
	bh=JBhchY14g7YKd2pR9ilqaH8gYeNmu2XFFOGobPQW/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS1Xh8JMmE0h34aVuSUjaYmkz6a8ADZN6M7JD2qZbuBkaXPqPHcbjfCT07ejCZ69aa2gZdjNu8jCOD/mpzmc7eHX22uKoftDDijgGyY9GOw1TNNasXIPbGdMd0jGNDSWRMw/p03RyCucVe2ebyeQvrC6A520DDZGdg5BNUh1ltQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEQvE0RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEQvE0RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98FF1F000FF;
	Thu, 17 Sep 2026 17:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667500;
	bh=bpwhcT+TMQFaaQp4ktRIiRi1YVCc0EWAKGjQxkaRkww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEQvE0RFyU895Yq9kfHOtGH7IlQptUcnhTZHugBITzh+wRFKWtvaiVWCMOsZCsLdr
	 Xe2is1hEqbhCo2L63xnOglaNIORjlZ3wayAX0HrtAFVNGO6rPOyX6UdPXBV3EXFRNd
	 bOXFPMP+HIDaUhgH451bMGsmojfh/IMgKiMqnk7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <dwagner@suse.de>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0114/1102] nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl
Date: Thu, 17 Sep 2026 16:00:57 +0100
Message-ID: <20260917151542.367328295@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f702badaf7d31dc3dea6c66da92b5f35fadd89dc ]

Currently, the final reference for the fabrics admin queue (fabrics_q)
is dropped inside nvme_remove_admin_tag_set(). However, the primary admin
queue (admin_q) defers dropping its final reference until
nvme_free_ctrl().

Move the blk_put_queue() call for fabrics_q from
nvme_remove_admin_tag_set() to nvme_free_ctrl(). This aligns the
lifecycle management of both admin queues, ensuring they are freed
symmetrically when the controller is finally torn down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4b13427d0a8a4..cd1b1ae4930e9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4652,10 +4652,8 @@ void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 	 */
 	nvme_stop_keep_alive(ctrl);
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS) {
+	if (ctrl->fabrics_q)
 		blk_mq_destroy_queue(ctrl->fabrics_q);
-		blk_put_queue(ctrl->fabrics_q);
-	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -4798,6 +4796,8 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (ctrl->admin_q)
 		blk_put_queue(ctrl->admin_q);
+	if (ctrl->fabrics_q)
+		blk_put_queue(ctrl->fabrics_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 	nvme_free_cels(ctrl);
-- 
2.53.0



