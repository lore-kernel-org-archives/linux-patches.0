Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D57C10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D896C433EF;
	Wed,  7 Jun 2023 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169729;
	bh=hALR7glcJ178nXk9fUj64vfY42R+x5At/pAp7tcrEQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkwakrJ7PTMYlWAciKf669xPomQsgSlO2gVBcSbdSOqFfkUwtuT3Q5YzyZ8bMfTPV
	 3LZ11mV4G9qxWWQpvKl6sphtzlLt85Mo01sjkcuP+07WhEPDSFuCR91IgCWNymbISQ
	 iz5PJKiz8JRbO7yjB23R3DLA/FshgSzfcDoz+Xgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 164/286] nvme-multipath: dont call blk_mark_disk_dead in nvme_mpath_remove_disk
Date: Wed,  7 Jun 2023 22:14:23 +0200
Message-ID: <20230607200928.478486294@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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
index 9171452e2f6d4..2bc159a318ff0 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -884,7 +884,6 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 	if (!head->disk)
 		return;
-	blk_mark_disk_dead(head->disk);
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
-- 
2.39.2



