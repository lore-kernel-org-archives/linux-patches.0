Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05246280037;
	Tue, 12 Aug 2025 18:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022894; cv=none; b=UQmgH+KsvDtS7WJRXc4vI6ggNTDUYjBkSQxtqpQ6/dda/GEUWhwk6iPYTvgFdA3ue7ECmGNThrwsldHLrMPMqkZ1wJIHMiJpV1NrC4BvNfmHTHO57s0CcNumsisRp1L90Co/xM31uaw2q+2HRGV7SsuJWYIBtR7s3vycs7XBIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022894; c=relaxed/simple;
	bh=/3aDhAy8kRBbEeTlBppajPawTC6Evnzs7i8vQduvSVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjKLOZ+s2aba4/gaO9A2n0L+mFiF0uNFNcJobMJdi9O07iQ2PUS6B9HxpF2tT8P89jTya0bJ75Fi4Tnoca7VYoX6q4StynMTmCPsD5qEX6OpzlPezvQ+l23kM55oEhCDOISESAyLkPfHFc+mvt7tcabZ9RaZ1G5ye4AJRvZGY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHTkuueS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHTkuueS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB41C4CEF0;
	Tue, 12 Aug 2025 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022893;
	bh=/3aDhAy8kRBbEeTlBppajPawTC6Evnzs7i8vQduvSVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHTkuueSssY4incSLjmB8L+RLBShiXrHv2lB2qUpEPIomu8TwBSaOgW+PdwVenhFG
	 8Z3UhubIOhmRCEvcsCSyBSH1YC/vhs2drrJx7ReLTsYsxLl+sVPqNrCu4aywUhL8GD
	 yCvm6FW+EX5ejrnBpLJjOj+kuAEYI3qD8prKvBuo=
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
Subject: [PATCH 6.12 291/369] nvmet: initialize discovery subsys after debugfs is initialized
Date: Tue, 12 Aug 2025 19:29:48 +0200
Message-ID: <20250812173027.679110519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4606c8813666..cfde5b018048 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1714,24 +1714,24 @@ static int __init nvmet_init(void)
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



