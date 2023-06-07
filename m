Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0D534CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8621C433EF;
	Wed,  7 Jun 2023 20:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170622;
	bh=lbFJs7EsMCgMNxM7oZIy+eZ6GTedCsCMm64MSxVff7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHoBArKBrBKFjppW+bVC9asbDK69I3CywLRG0JlnTGclcD/DybapagcdAHNMazzXQ
	 FRcO1cKO5kVaISdP98tiqcdHDtwr+0G/Gy5br2mSaggwhhM/5XbvaKJkOlFAkj9jdn
	 0HEsxXfO9afuuuYe4g1Jh8+asSug2QFNYUoD+vAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/225] nvme-multipath: dont call blk_mark_disk_dead in nvme_mpath_remove_disk
Date: Wed,  7 Jun 2023 22:15:17 +0200
Message-ID: <20230607200918.437363117@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1743e5f6000901a11f4e1cd741bfa9136f3ec9b1 ]

nvme_mpath_remove_disk is called after del_gendisk, at which point a
blk_mark_disk_dead call doesn't make any sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d09ed00701743..f96d330d39641 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -858,7 +858,6 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 	if (!head->disk)
 		return;
-	blk_mark_disk_dead(head->disk);
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
-- 
2.39.2



