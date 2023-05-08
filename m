Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ECA171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4ACC433D2;
	Mon,  8 May 2023 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545956;
	bh=TyhxN+SqkWM79BEvuLT0otfaCDF2Eusp0laIJOjmxmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+Gj8gvXWLExOfj2+QXe4iIVLEHrFZNIH+R8ibO562my21OWI8eF0I7dtj/S5Z3EX
	 13kvAJQM2YrIo/nBaCLMQydnC9CDtENKj7opWVcEnwU7erXQp3ECeRdlE9BufWuVoP
	 KenG2g3cln5YpZbI/tZeXhu6a6KTHMDVGC/Jpbu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels Dossche <dossche.niels@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/371] nvmet: move the call to nvmet_ns_changed out of nvmet_ns_revalidate
Date: Mon,  8 May 2023 11:46:33 +0200
Message-Id: <20230508094819.743205295@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit da7837339641601f202f27515771dc0646083938 ]

nvmet_ns_changed states via lockdep that the ns->subsys->lock must be
held. The only caller of nvmet_ns_changed which does not acquire that
lock is nvmet_ns_revalidate. nvmet_ns_revalidate has 3 callers,
of which 2 do not acquire that lock: nvmet_execute_identify_cns_cs_ns
and nvmet_execute_identify_ns. The other caller
nvmet_ns_revalidate_size_store does acquire the lock.

Move the call to nvmet_ns_changed from nvmet_ns_revalidate to the callers
so that they can perform the correct locking as needed.

This issue was found using a static type-based analyser and manually
verified.

Reported-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Stable-dep-of: ab76e7206b67 ("nvmet: fix error handling in nvmet_execute_identify_cns_cs_ns()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 6 +++++-
 drivers/nvme/target/configfs.c  | 3 ++-
 drivers/nvme/target/core.c      | 5 ++---
 drivers/nvme/target/nvmet.h     | 2 +-
 drivers/nvme/target/zns.c       | 6 +++++-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index bf78c58ed41d4..da873a7f8ff90 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -508,7 +508,11 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 		goto done;
 	}
 
-	nvmet_ns_revalidate(req->ns);
+	if (nvmet_ns_revalidate(req->ns)) {
+		mutex_lock(&req->ns->subsys->lock);
+		nvmet_ns_changed(req->ns->subsys, req->ns->nsid);
+		mutex_unlock(&req->ns->subsys->lock);
+	}
 
 	/*
 	 * nuse = ncap = nsze isn't always true, but we have no way to find
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 625038057a762..5bdc3ba51f7ef 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -586,7 +586,8 @@ static ssize_t nvmet_ns_revalidate_size_store(struct config_item *item,
 		mutex_unlock(&ns->subsys->lock);
 		return -EINVAL;
 	}
-	nvmet_ns_revalidate(ns);
+	if (nvmet_ns_revalidate(ns))
+		nvmet_ns_changed(ns->subsys, ns->nsid);
 	mutex_unlock(&ns->subsys->lock);
 	return count;
 }
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 4c6d56dd29adc..2c44d5a95c8d6 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -535,7 +535,7 @@ static void nvmet_p2pmem_ns_add_p2p(struct nvmet_ctrl *ctrl,
 		ns->nsid);
 }
 
-void nvmet_ns_revalidate(struct nvmet_ns *ns)
+bool nvmet_ns_revalidate(struct nvmet_ns *ns)
 {
 	loff_t oldsize = ns->size;
 
@@ -544,8 +544,7 @@ void nvmet_ns_revalidate(struct nvmet_ns *ns)
 	else
 		nvmet_file_ns_revalidate(ns);
 
-	if (oldsize != ns->size)
-		nvmet_ns_changed(ns->subsys, ns->nsid);
+	return oldsize != ns->size;
 }
 
 int nvmet_ns_enable(struct nvmet_ns *ns)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index f3e42d2c85c6c..abb5e78ab8919 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -543,7 +543,7 @@ u16 nvmet_file_flush(struct nvmet_req *req);
 void nvmet_ns_changed(struct nvmet_subsys *subsys, u32 nsid);
 void nvmet_bdev_ns_revalidate(struct nvmet_ns *ns);
 void nvmet_file_ns_revalidate(struct nvmet_ns *ns);
-void nvmet_ns_revalidate(struct nvmet_ns *ns);
+bool nvmet_ns_revalidate(struct nvmet_ns *ns);
 u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts);
 
 bool nvmet_bdev_zns_enable(struct nvmet_ns *ns);
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 1466698751c55..ad608bd6515a7 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -123,7 +123,11 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 		goto done;
 	}
 
-	nvmet_ns_revalidate(req->ns);
+	if (nvmet_ns_revalidate(req->ns)) {
+		mutex_lock(&req->ns->subsys->lock);
+		nvmet_ns_changed(req->ns->subsys, req->ns->nsid);
+		mutex_unlock(&req->ns->subsys->lock);
+	}
 	zsze = (bdev_zone_sectors(req->ns->bdev) << 9) >>
 					req->ns->blksize_shift;
 	id_zns->lbafe[0].zsze = cpu_to_le64(zsze);
-- 
2.39.2



