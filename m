Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811A1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D892C433D2;
	Wed, 28 Dec 2022 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246257;
	bh=peGOiY9UJyxc+ENCrALAYeUcywYnLBAiyUrKaKSKKD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0zVfCAgHb6YErn19a95Hi2LD1eg3R486dFqP/cQOPVUUvDrJW5zFG3NQMBLgV+W9
	 k1/P1kBgvHBWFQwQ5hI3hq0MiTY793pQtdvwIRdI1sTaXZlFym4d9fjqJ4P2chXffL
	 DaOUaZhPjc4K5tX2Q4JEIatUaJCojnOHYuIsajRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1011/1146] nvme-auth: dont override ctrl keys before validation
Date: Wed, 28 Dec 2022 15:42:30 +0100
Message-Id: <20221228144357.827735626@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 01604350e14560d4d69323eb1ba12a257a643ea8 ]

Replace ctrl ctrl_key/host_key only after nvme_auth_generate_key is successful.
Also, this fixes a bug where the keys are leaked.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 95b73b386719..108b5022cead 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3745,13 +3745,17 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
+		struct nvme_dhchap_key *key, *host_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->host_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_secret);
 		opts->dhchap_secret = dhchap_secret;
+		host_key = ctrl->host_key;
+		ctrl->host_key = key;
+		nvme_auth_free_key(host_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
@@ -3795,13 +3799,17 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
+		struct nvme_dhchap_key *key, *ctrl_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->ctrl_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_ctrl_secret);
 		opts->dhchap_ctrl_secret = dhchap_secret;
+		ctrl_key = ctrl->ctrl_key;
+		ctrl->ctrl_key = key;
+		nvme_auth_free_key(ctrl_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
-- 
2.35.1



