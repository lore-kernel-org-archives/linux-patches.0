Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2465171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC15C433D2;
	Mon,  8 May 2023 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545923;
	bh=RXod3Kex7x8kPIpIdidJx2dPmqspXj5HjTm/WpllcxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCrWulRFI9FBsvA0m625UVpJHh7sHx6BUNa2sZDnDuJ9q4/XJ+PHE/H2oRrfM82S0
	 FvGhP8EmKHwDQX8803g+DXOqnH4o3zamCKrRQshfOHC19ZYv79FChHbGFv5Xj/l2UB
	 s2g6Lvl9zX4a/K+CkOHZgEVcd0Q9eIg90uw6ZP/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/371] nvmet: use i_size_read() to set size for file-ns
Date: Mon,  8 May 2023 11:46:32 +0200
Message-Id: <20230508094819.705131363@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 2caecd62ea5160803b25d96cb1a14ce755c2c259 ]

Instead of calling vfs_getattr() use i_size_read() to read the size of
file so we can read the size of not only file type but also block type
with one call. This is needed to implement buffered_io support for the
NVMeOF block device backend.

We also change return type of function nvmet_file_ns_revalidate() from
int to void, since this function does not return any meaning value.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: ab76e7206b67 ("nvmet: fix error handling in nvmet_execute_identify_cns_cs_ns()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 17 ++++-------------
 drivers/nvme/target/nvmet.h       |  2 +-
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index eadba13b276de..098b6bf12cd0a 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -13,16 +13,9 @@
 
 #define NVMET_MIN_MPOOL_OBJ		16
 
-int nvmet_file_ns_revalidate(struct nvmet_ns *ns)
+void nvmet_file_ns_revalidate(struct nvmet_ns *ns)
 {
-	struct kstat stat;
-	int ret;
-
-	ret = vfs_getattr(&ns->file->f_path, &stat, STATX_SIZE,
-			  AT_STATX_FORCE_SYNC);
-	if (!ret)
-		ns->size = stat.size;
-	return ret;
+	ns->size = i_size_read(ns->file->f_mapping->host);
 }
 
 void nvmet_file_ns_disable(struct nvmet_ns *ns)
@@ -40,7 +33,7 @@ void nvmet_file_ns_disable(struct nvmet_ns *ns)
 int nvmet_file_ns_enable(struct nvmet_ns *ns)
 {
 	int flags = O_RDWR | O_LARGEFILE;
-	int ret;
+	int ret = 0;
 
 	if (!ns->buffered_io)
 		flags |= O_DIRECT;
@@ -54,9 +47,7 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
-	ret = nvmet_file_ns_revalidate(ns);
-	if (ret)
-		goto err;
+	nvmet_file_ns_revalidate(ns);
 
 	/*
 	 * i_blkbits can be greater than the universally accepted upper bound,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index fdb06a9d430d2..f3e42d2c85c6c 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -542,7 +542,7 @@ u16 nvmet_bdev_flush(struct nvmet_req *req);
 u16 nvmet_file_flush(struct nvmet_req *req);
 void nvmet_ns_changed(struct nvmet_subsys *subsys, u32 nsid);
 void nvmet_bdev_ns_revalidate(struct nvmet_ns *ns);
-int nvmet_file_ns_revalidate(struct nvmet_ns *ns);
+void nvmet_file_ns_revalidate(struct nvmet_ns *ns);
 void nvmet_ns_revalidate(struct nvmet_ns *ns);
 u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts);
 
-- 
2.39.2



