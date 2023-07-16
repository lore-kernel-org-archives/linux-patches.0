Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26A68F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB0EC433C7;
	Sun, 16 Jul 2023 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539551;
	bh=bxGBglsZFCSNUeocjjAVBXGapGI7nLrjZlcG5rrIPyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKtOl9jIVESbcAh8J19UCZyUhrV01tkYf75NeKelqJktha3mQHbS1okPQUGAlhDf8
	 vw6dCYCp9X5MbNAWvo7xlUd9RiAK0yzEfeq472erwEkHwtNQfxXkjfsxDYt7pbhupa
	 iudw0W6hIydJifdFB/QZWWuYxP0+Adv0+nR8ilnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/591] nvme-core: fix memory leak in dhchap_ctrl_secret
Date: Sun, 16 Jul 2023 21:42:39 +0200
Message-ID: <20230716194924.386769450@linuxfoundation.org>
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
index 3956164272253..2b07a67958b46 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3880,14 +3880,17 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
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
 		ctrl->ctrl_key = key;
 		nvme_auth_free_key(ctrl_key);
-	}
+	} else
+		kfree(dhchap_secret);
 	/* Start re-authentication */
 	dev_info(ctrl->device, "re-authenticating controller\n");
 	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
-- 
2.39.2



