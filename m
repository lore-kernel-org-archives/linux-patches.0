Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA049739E;
	Thu, 17 Sep 2026 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658730; cv=none; b=jjO4ia1PiqkXvhPsDap2Zws2pJNHwFaVm1yo0Av7QoBnUT8xKCoX8Oh/WJhtgVXnc6MQUAeacwBYa41ml/+k2SesSUab3BkcQDKfGANnBS0abwIUSj1FT+yWAVkTCJTnhLxlv1zu0CqvwdHISXkL49+XNp5lZOnGEb32ym2vBCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658730; c=relaxed/simple;
	bh=M9HDpUcCRPwgaYdCGcnyx8dioXd1hcKxw4bxbXMSss0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL6oJJxVmZHbDRnhe0wklkkatiirl57jyHr0qHgPMmKWnAugug/8Ugjy7qLIzQmgPPYxIkzXlwUy2n5bbfsuLr9NiPvTDogDfYyFodgk7Gx179+6AYDBdSD9cBzRhgNys/kJ3GadU0gvof3Lm77/SdCY7usqsIsGWQk8iTh96bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8vgz24/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8vgz24/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4421F00A12;
	Thu, 17 Sep 2026 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658719;
	bh=cadLnEeXsd+svXXCp6GR8rfD6130K0JfS6OeKQYTjKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8vgz24/toveoFHuSXU61UsTxnKv18bxjY9Hn9A+wtXoYBFxyF107lLY9PZ2FC/k7
	 xEAgQTDssHxkin3qvg7L+800pWyZpP9tmmZPfU5NlAGsDnQfWjZcGvroDeYP1CV0MV
	 63ZqcHoGMQ714uPV2tG1leua5ztv1DchXJF72pbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 017/733] nvme: set ns->head in nvme_alloc_ns_head
Date: Thu, 17 Sep 2026 16:05:25 +0100
Message-ID: <20260917151351.105124081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanchan Joshi <joshi.k@samsung.com>

[ Upstream commit c1888444dc28310222dcc6e5c301d60d0943787f ]

so that it becomes possible to submit non-admin commands.
This is a prep patch with no functional changes.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 56e1c6bbe4bb ("nvme: fix racy access to FDP placement id array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0224b99317cdd..e5051a6b33578 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3987,10 +3987,11 @@ static void nvme_add_ns_cdev(struct nvme_ns *ns)
 	set_bit(NVME_NS_CDEV_LIVE, &ns->flags);
 }
 
-static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
+static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
-	__must_hold(&ctrl->subsys->lock)
+	__must_hold(&ns->ctrl->subsys->lock)
 {
+	struct nvme_ctrl *ctrl = ns->ctrl;
 	struct nvme_ns_head *head;
 	size_t size = sizeof(*head);
 	int ret = -ENOMEM;
@@ -4018,6 +4019,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	ratelimit_state_init(&head->rs_nuse, 5 * HZ, 1);
 	ratelimit_set_flags(&head->rs_nuse, RATELIMIT_MSG_ON_RELEASE);
 	kref_init(&head->ref);
+	ns->head = head;
 
 	if (head->ids.csi) {
 		ret = nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
@@ -4041,6 +4043,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	ida_free(&ctrl->subsys->ns_ida, head->instance);
 out_free_head:
 	kfree(head);
+	ns->head = NULL;
 out:
 	if (ret > 0)
 		ret = blk_status_to_errno(nvme_error_status(ret));
@@ -4127,7 +4130,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 				info->nsid);
 			goto out_unlock;
 		}
-		head = nvme_alloc_ns_head(ctrl, info);
+		head = nvme_alloc_ns_head(ns, info);
 		if (IS_ERR(head)) {
 			ret = PTR_ERR(head);
 			goto out_unlock;
-- 
2.53.0



