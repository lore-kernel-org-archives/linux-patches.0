Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC03B9DBF;
	Wed, 30 Sep 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794058; cv=none; b=t+xDnBb21b5UTi2ZiBMtq/AoVaPlsklGMVSlhKEE9Rbw7Ojgu9HDopUGYtcUjNPOjjJ0p83Xb35wcJ4a+jhCLZeFiEly2Ndn5dPdIIFluMdr8frynABpXRNmNxM/5pO0AGyGWZ0F87+JJV2jCpmP+AAtefdeo/apSRb/lHpu27M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794058; c=relaxed/simple;
	bh=sGy2v7j8vKZrl0ogEhPWWDN0jqdYVXGUJ3rw7qkFQ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH+Nv/WNA1fwchjIOq9ul+5i5nILutzvj4hN8zdud/J/q+JGSPxr5HucxPIlcuyS7uu8AGElBSCsJkWK0pD1ZX74LVN1EqkRhvEMCf9X5mbNk0Rr1f9ZN1MtkqnKt+sxLw+lGvomwbw392uNs7T0U39O8bPYKlEWd5JcQQ8USxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6yHJihq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6yHJihq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8751F00899;
	Wed, 30 Sep 2026 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794057;
	bh=vtbwjQT8KDX14zCs5nINJIrDx1OASfI2cRtUOz0nQ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6yHJihq8VM6Jc4w1K+zAX6qMef7KKU5cvMcsVkzAY34bz0Scv1rQN6V5DmcBILj7
	 XklrRtw8C8JnctrhXjS2/fx7U6ldb70HyzWcSpJwGfXxMXqSpaJT9N9rSS7VfiDCrl
	 bcn4MYZLLVPwbJTQkdS+6AsVv9z9V9/+068H31HU=
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
Subject: [PATCH 6.6 0077/1193] nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl
Date: Wed, 30 Sep 2026 17:12:41 +0200
Message-ID: <20260930152435.968572340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 7b8de361046d8..d02ca033db439 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4325,10 +4325,8 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS) {
+	if (ctrl->fabrics_q)
 		blk_mq_destroy_queue(ctrl->fabrics_q);
-		blk_put_queue(ctrl->fabrics_q);
-	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -4471,6 +4469,8 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (ctrl->admin_q)
 		blk_put_queue(ctrl->admin_q);
+	if (ctrl->fabrics_q)
+		blk_put_queue(ctrl->fabrics_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 
-- 
2.53.0



