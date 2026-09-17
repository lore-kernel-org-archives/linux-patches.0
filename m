Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A5582B96;
	Thu, 17 Sep 2026 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659393; cv=none; b=a6UIkt6anOy/3NQgl12Eh+ljNkTaGt+SqySwCPfzbn2YMqXFzJGOwPv3MbDGQc0HVL5Uv+dMCOZ1Azj/t/MMcL3/gdGon2NIM9pkGqNxT62+KmCJLWt5hSly1AfVYxXUn5ixIw6tmbN0FKR+DbiXgD5osPJfi5geRGMnFAblD0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659393; c=relaxed/simple;
	bh=Zm5MNfTmPuXrO2e86890M8pPtAfi0qeI8+L50aBgFpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/Lu9YiBPuxZ/OSSOinaC8mFWdvbvG+Bm5zaBTxNyknqs3tmhAR9tnPQwpBmpnXS4yokt7bs+brlfe6i2YJGZMu14FN6Y7yiCt8RKS/smlIRvtxKaQLY0g12+DbaC+9eSGlvbQlcFsRA8pxeGUK1sbgAhdCRkO7A6y09nJdygu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tsynb3ZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tsynb3ZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920CE1F00899;
	Thu, 17 Sep 2026 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659383;
	bh=fmd3cb6wex4A/ZjQHWHvUb96oxzcpj6WAwhdLpYwQ7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tsynb3ZDRG6p0k9Vfo2A/pBwyeBZKs56dJLzuW23X9JblYxDD2CMK8i1oyU4ph3wd
	 q9QDNNd0mhmman770uojpS4VKYDtDh/BS1aUhbs3dYCoHLfycJl4eCkjxPYHXVXfV9
	 wne668sZ68yGzup1mFmPLQ/T7TSM8lZMMHcwt5GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 237/733] nvmet: print namespace IDs as unsigned 32bit value
Date: Thu, 17 Sep 2026 16:09:05 +0100
Message-ID: <20260917151357.151125155@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 59fe1cbc57235495a5f08dd53db176e3e3250356 ]

struct nvmet_ns.nsid is a u32, but a few messages print it with %d.
An NSID larger than 0x7fffffff is rendered as a negative number, which
is misleading in general and particularly so for the configfs messages
that echo back the NSID the user just asked for.

For example:
[  T200] nvmet: adding nsid -16 to subsystem mysubsystem

Print them with %u. The invalid-NSID error in nvmet_ns_make() keeps its
%#x because the two values it rejects, 0 and NVME_NSID_ALL, are more
readable in hex format. No functional change other than how the NSID is
formatted.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Fixes: c6925093d0b2 ("nvmet: Optionally use PCI P2P memory")
Fixes: 5a47c2080a73 ("nvmet: support reservation feature")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 4 ++--
 drivers/nvme/target/core.c     | 2 +-
 drivers/nvme/target/pr.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 413ee2d16d29c..6286e38436ddf 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -814,7 +814,7 @@ static ssize_t nvmet_ns_resv_enable_store(struct config_item *item,
 
 	mutex_lock(&ns->subsys->lock);
 	if (ns->enabled) {
-		pr_err("the ns:%d is already enabled.\n", ns->nsid);
+		pr_err("the ns:%u is already enabled.\n", ns->nsid);
 		mutex_unlock(&ns->subsys->lock);
 		return -EINVAL;
 	}
@@ -880,7 +880,7 @@ static struct config_group *nvmet_ns_make(struct config_group *group,
 		goto out;
 	config_group_init_type_name(&ns->group, name, &nvmet_ns_type);
 
-	pr_info("adding nsid %d to subsystem %s\n", nsid, subsys->subsysnqn);
+	pr_info("adding nsid %u to subsystem %s\n", nsid, subsys->subsysnqn);
 
 	return &ns->group;
 out:
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 23fa90ec3c00e..269daefb88854 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -558,7 +558,7 @@ static void nvmet_p2pmem_ns_add_p2p(struct nvmet_ctrl *ctrl,
 	if (ret < 0)
 		pci_dev_put(p2p_dev);
 
-	pr_info("using p2pmem on %s for nsid %d\n", pci_name(p2p_dev),
+	pr_info("using p2pmem on %s for nsid %u\n", pci_name(p2p_dev),
 		ns->nsid);
 }
 
diff --git a/drivers/nvme/target/pr.c b/drivers/nvme/target/pr.c
index 7d937093b2262..ad07f55e7f173 100644
--- a/drivers/nvme/target/pr.c
+++ b/drivers/nvme/target/pr.c
@@ -145,7 +145,7 @@ static void nvmet_pr_add_resv_log(struct nvmet_ctrl *ctrl, u8 log_type,
 	log.nsid = cpu_to_le32(nsid);
 
 	if (!kfifo_put(&log_mgr->log_queue, log)) {
-		pr_info("a reservation log lost, cntlid:%d, log_type:%d, nsid:%d\n",
+		pr_info("a reservation log lost, cntlid:%d, log_type:%d, nsid:%u\n",
 			ctrl->cntlid, log_type, nsid);
 		log_mgr->lost_count++;
 	}
-- 
2.53.0



