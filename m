Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D988F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F92C433C7;
	Sun, 16 Jul 2023 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537331;
	bh=/Vk+LKnKnjQMF3JvCB2Oyh/bkVLWZPSrIlbGMzOFrP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cBcroso+843r/+ZB88sgFAx65Ed02YoW8JnMY15hYh868+sp7C3sny9Y/99WfXBw
	 SEzHF2F9i/DFPdHIQCngcuaURpK/0DtmP3fOZnS2kerbvyfu31M8IPtsmpTlvZ+cYd
	 O/yI9GNpyn3R/pYWhim3iNMnili6jD4d8APwmUtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 030/800] nvme-core: fix memory leak in dhchap_ctrl_secret
Date: Sun, 16 Jul 2023 21:38:03 +0200
Message-ID: <20230716194949.798205505@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 99c2dcc8ffc24e210a3aa05c204d92f3ef460b05 ]

Free dhchap_secret in nvme_ctrl_dhchap_ctrl_secret_store() before we
return when nvme_auth_generate_key() returns error.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c2096f0d50537..a275e7e2969e9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3929,8 +3929,10 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 		int ret;
 
 		ret = nvme_auth_generate_key(dhchap_secret, &key);
-		if (ret)
+		if (ret) {
+			kfree(dhchap_secret);
 			return ret;
+		}
 		kfree(opts->dhchap_ctrl_secret);
 		opts->dhchap_ctrl_secret = dhchap_secret;
 		ctrl_key = ctrl->ctrl_key;
@@ -3938,7 +3940,8 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 		ctrl->ctrl_key = key;
 		mutex_unlock(&ctrl->dhchap_auth_mutex);
 		nvme_auth_free_key(ctrl_key);
-	}
+	} else
+		kfree(dhchap_secret);
 	/* Start re-authentication */
 	dev_info(ctrl->device, "re-authenticating controller\n");
 	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
-- 
2.39.2



