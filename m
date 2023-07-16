Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11ED8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D7FC433C7;
	Sun, 16 Jul 2023 20:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539540;
	bh=bCNechYPBTY3WYV23AYfgaHA73H58cJQPnPoqtlTqHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts+pZmeesMQCX4/yypAAR1gSfp/gwMfcT+XO5j3IE13O8d1G4p+n6XS2QBBwvEUm9
	 o6To44cyaYWqp6Zh3fxIudMsgQVbnmCHy/4eLgrJcxiYIvLVKnKOykdTMmPgd7lV3v
	 keWs1+tPluZ+FDaKiiMTryP/s7kguR4vrWwi6ssw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/591] nvme-auth: rename authentication work elements
Date: Sun, 16 Jul 2023 21:42:35 +0200
Message-ID: <20230716194924.285054808@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 0c999e69c40a87285f910c400b550fad866e99d0 ]

Use nvme_ctrl_auth_work and nvme_queue_auth_work for better
readability.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: a836ca33c5b0 ("nvme-core: fix memory leak in dhchap_secret_store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index d45333268fcf6..e3e801e2b78d5 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -691,7 +691,7 @@ static void nvme_auth_free_dhchap(struct nvme_dhchap_queue_context *chap)
 	kfree(chap);
 }
 
-static void __nvme_auth_work(struct work_struct *work)
+static void nvme_queue_auth_work(struct work_struct *work)
 {
 	struct nvme_dhchap_queue_context *chap =
 		container_of(work, struct nvme_dhchap_queue_context, auth_work);
@@ -893,7 +893,7 @@ int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
 		return -ENOMEM;
 	}
 
-	INIT_WORK(&chap->auth_work, __nvme_auth_work);
+	INIT_WORK(&chap->auth_work, nvme_queue_auth_work);
 	list_add(&chap->entry, &ctrl->dhchap_auth_list);
 	mutex_unlock(&ctrl->dhchap_auth_mutex);
 	queue_work(nvme_wq, &chap->auth_work);
@@ -934,7 +934,7 @@ void nvme_auth_reset(struct nvme_ctrl *ctrl)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_reset);
 
-static void nvme_dhchap_auth_work(struct work_struct *work)
+static void nvme_ctrl_auth_work(struct work_struct *work)
 {
 	struct nvme_ctrl *ctrl =
 		container_of(work, struct nvme_ctrl, dhchap_auth_work);
@@ -973,7 +973,7 @@ static void nvme_dhchap_auth_work(struct work_struct *work)
 void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
 {
 	INIT_LIST_HEAD(&ctrl->dhchap_auth_list);
-	INIT_WORK(&ctrl->dhchap_auth_work, nvme_dhchap_auth_work);
+	INIT_WORK(&ctrl->dhchap_auth_work, nvme_ctrl_auth_work);
 	mutex_init(&ctrl->dhchap_auth_mutex);
 	if (!ctrl->opts)
 		return;
-- 
2.39.2



