Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0665B24B28;
	Wed,  8 Apr 2026 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672307; cv=none; b=rXiFv+wPtHfnaqw8wCWIts0Zex7NLbSkO6fuOVvJHRNthmK4I+XQ9QJCUUCUmwvQHyy6NlV0qf6wZBwzOTqawZE46sSMzoorDtUKCeLZgIEQ57lIEyTAuJY96WFYXfq6flgwYzz7YaAvbRM7pQgURiP8VvWeGygC66ETMzEWQgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672307; c=relaxed/simple;
	bh=FyZhqV63Utl5ULtVItop9GUdkqrKgR2NLVXs5F5ll6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqxmUXvtkkxNn0RojOqkbns45yZDLcurACpChxHRMCUrnN7o4bG0LQfuPfsRxujMa+UmX9rYY9Sr2QrvJd6gY49jC9KVY2IFTydFOOET17q76Xqfy24NET0UJcVT/pd0Ggr2MIVR4SV5u9sP16+o5sQ6kccKwd81i8ugu3GtCnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nkew22Hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nkew22Hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A64C19421;
	Wed,  8 Apr 2026 18:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672306;
	bh=FyZhqV63Utl5ULtVItop9GUdkqrKgR2NLVXs5F5ll6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nkew22HsCCcMAoT+WvMUDwxQECCOimIIeGXTqPcgOWfVAEzorsCb/tFFoykM511wi
	 eEege2HYblZnAHrtiZwqBFE0VBl16LOgCE5dGC00+RypP//0DAMFMaEaZ65SMOgmcf
	 JgvRQjOLuUyOq3C9Ufi/Nn5HsFH/+mPlrICucCyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Maximilian Heyne <mheyne@amazon.de>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/312] nvme-pci: remove an extra queue reference
Date: Wed,  8 Apr 2026 20:02:59 +0200
Message-ID: <20260408175943.532532824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7dcebef90d35de13a326f765dd787538880566f9 ]

Now that blk_mq_destroy_queue does not release the queue reference, there
is no need for a second admin queue reference to be held by the nvme_dev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20221018135720.670094-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Tested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 27a4706bc9131..04f7db2ff9cc2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1783,7 +1783,6 @@ static void nvme_dev_remove_admin(struct nvme_dev *dev)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
-		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
@@ -1812,11 +1811,6 @@ static int nvme_pci_alloc_admin_tag_set(struct nvme_dev *dev)
 		dev->ctrl.admin_q = NULL;
 		return -ENOMEM;
 	}
-	if (!blk_get_queue(dev->ctrl.admin_q)) {
-		nvme_dev_remove_admin(dev);
-		dev->ctrl.admin_q = NULL;
-		return -ENODEV;
-	}
 	return 0;
 }
 
-- 
2.53.0



