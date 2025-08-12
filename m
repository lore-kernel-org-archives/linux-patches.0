Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825E72FFDC1;
	Tue, 12 Aug 2025 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024943; cv=none; b=VRdkjHeoCqdK3n6JWw/kxbOsBeeltnKj0kY5tX6cYDFitknLZWfwVqeduEeO6icN2K9cPDj7+GcSefJqhJQUIRsUTTo7VG/WULXkwQP+ykgZsqND7bU/Cz0/lviIZMEFxBevqjV0cBADOGfVF3gYPtW7virUeEMbDNxs/cjf7ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024943; c=relaxed/simple;
	bh=YHazTvPZlCH15L9meXN9+mPvIomZLEmzlHV69pSxzrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArrYp0Hogis24OulMKWU/dEO34s8jQxnWK0edPIhVRaFONB6uSIlpF5OdZEiqX4YzvLmPSRNMA6+NoQ+NHo+cvZnSVKhG1x3RJRY6eKwqXXPxWFl3Kfkm7KAIat8t1RQxG0FeBsCj1DzfBqzc/8shWGUYl0tDH4Opfoj//h6GN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEEKxH86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEEKxH86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00699C4CEFA;
	Tue, 12 Aug 2025 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024943;
	bh=YHazTvPZlCH15L9meXN9+mPvIomZLEmzlHV69pSxzrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEEKxH86D92idQYAGr6OM4FFUpmf/OuUl8MAn72EcKZNs20IVLZHHf0iSXIXQCQHs
	 Y4Ap67tgE+NS0S7Auep52/WImtlzLGYmD3koJURw3ivYn7wssclu/GmN3YkmhI5iAc
	 HcpvyJHHVgUxxyxSwFUWAPSr+m2gjqXI/CfYe4es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 521/627] nvmet: initialize discovery subsys after debugfs is initialized
Date: Tue, 12 Aug 2025 19:33:36 +0200
Message-ID: <20250812173451.310325819@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 528589947c1802b9357c2a9b96d88cc4a11cd88b ]

During nvme target initialization discovery subsystem is initialized
before "nvmet" debugfs directory is created. This results in discovery
subsystem debugfs directory to be created in debugfs root directory.

nvmet_init() ->
  nvmet_init_discovery() ->
    nvmet_subsys_alloc() ->
      nvmet_debugfs_subsys_setup()

In other words, the codepath above is exeucted before nvmet_debugfs is
created. We get /sys/kernel/debug/nqn.2014-08.org.nvmexpress.discovery
instead of /sys/kernel/debug/nvmet/nqn.2014-08.org.nvmexpress.discovery.
Move nvmet_init_discovery() call after nvmet_init_debugfs() to fix it.

Fixes: 649fd41420a8 ("nvmet: add debugfs support")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 175c5b6d4dd5..b6247e4afc9c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1962,24 +1962,24 @@ static int __init nvmet_init(void)
 	if (!nvmet_wq)
 		goto out_free_buffered_work_queue;
 
-	error = nvmet_init_discovery();
+	error = nvmet_init_debugfs();
 	if (error)
 		goto out_free_nvmet_work_queue;
 
-	error = nvmet_init_debugfs();
+	error = nvmet_init_discovery();
 	if (error)
-		goto out_exit_discovery;
+		goto out_exit_debugfs;
 
 	error = nvmet_init_configfs();
 	if (error)
-		goto out_exit_debugfs;
+		goto out_exit_discovery;
 
 	return 0;
 
-out_exit_debugfs:
-	nvmet_exit_debugfs();
 out_exit_discovery:
 	nvmet_exit_discovery();
+out_exit_debugfs:
+	nvmet_exit_debugfs();
 out_free_nvmet_work_queue:
 	destroy_workqueue(nvmet_wq);
 out_free_buffered_work_queue:
-- 
2.39.5



