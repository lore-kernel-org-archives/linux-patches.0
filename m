Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A461F707A;
	Tue,  3 Dec 2024 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238819; cv=none; b=dbFpNbyOU1kOVgVx0Vt5W4yiaTA1UoLGrfk3uirVM0US4UaB3fs2n5dGy+iT71DdzVqr5ImcKtlKH0VKCEZeE6WAHapN/7AKAwRngkioK6oJ+/mGS2pOdlpZM2ICy8oUSeDrbaw8rr5OQgWw0Jr7s0qBUSGoQM4Pl212JeivfAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238819; c=relaxed/simple;
	bh=uQSN6PA3ugvKxf7Y2CzyGZ+e1W0l+BpJghtVCY2uW8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIeiyG1x3t/Fe4j5hzrjg1C40dPDRDFjsMb+n1mq+JxYT9HHwM7zhzlWd42AhyaONhKOVrIdt4YSFNZnelo/Ezd/NCC4qxE+Lfud9WauX6Mihh4e7nYmYGR9V12M/w4K0+qMT13Ilku94ITVLGbPQRW7/lqle1baTejKnuEv8DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh2N36Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh2N36Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD1AC4CECF;
	Tue,  3 Dec 2024 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238819;
	bh=uQSN6PA3ugvKxf7Y2CzyGZ+e1W0l+BpJghtVCY2uW8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh2N36YePJtjXKC88yIuPLxAv2FA5PxdQ40EtNqQhF2BxYxpgyVJ8mruyt3Dcqq4v
	 nA9/7gk0ZxCjwJ0JIVidAzE54X2a+JZOZAi6iLblndKBjV2+7s4G6tdD8J0ZX0Sqfk
	 JOVi8Tv5eLPNFlhDD0/HyiS7NUDwd7Sy9dqRJlTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 376/817] RDMA/core: Provide rdma_user_mmap_disassociate() to disassociate mmap pages
Date: Tue,  3 Dec 2024 15:39:08 +0100
Message-ID: <20241203144010.521497849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 51976c6cd786151b6a1bdf8b8b3334beac0ba99c ]

Provide a new api rdma_user_mmap_disassociate() for drivers to
disassociate mmap pages for a device.

Since drivers can now disassociate mmaps by calling this api,
introduce a new disassociation_lock to specifically prevent
races between this disassociation process and new mmaps. And
thus the old hw_destroy_rwsem is not needed in this api.

Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240927103323.1897094-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 615b94746a54 ("RDMA/hns: Disassociate mmap pages for all uctx when HW is being reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs.h      |  2 ++
 drivers/infiniband/core/uverbs_main.c | 43 +++++++++++++++++++++++++--
 include/rdma/ib_verbs.h               |  8 +++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 821d93c8f7123..dfd2e5a86e6fe 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -160,6 +160,8 @@ struct ib_uverbs_file {
 	struct page *disassociate_page;
 
 	struct xarray		idr;
+
+	struct mutex disassociation_lock;
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index bc099287de9a6..48b97e6c1fc6f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -76,6 +76,7 @@ static dev_t dynamic_uverbs_dev;
 static DEFINE_IDA(uverbs_ida);
 static int ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device, void *client_data);
+static struct ib_client uverbs_client;
 
 static char *uverbs_devnode(const struct device *dev, umode_t *mode)
 {
@@ -217,6 +218,7 @@ void ib_uverbs_release_file(struct kref *ref)
 
 	if (file->disassociate_page)
 		__free_pages(file->disassociate_page, 0);
+	mutex_destroy(&file->disassociation_lock);
 	mutex_destroy(&file->umap_lock);
 	mutex_destroy(&file->ucontext_lock);
 	kfree(file);
@@ -700,8 +702,13 @@ static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 		ret = PTR_ERR(ucontext);
 		goto out;
 	}
+
+	mutex_lock(&file->disassociation_lock);
+
 	vma->vm_ops = &rdma_umap_ops;
 	ret = ucontext->device->ops.mmap(ucontext, vma);
+
+	mutex_unlock(&file->disassociation_lock);
 out:
 	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
 	return ret;
@@ -723,6 +730,8 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	/* We are racing with disassociation */
 	if (!down_read_trylock(&ufile->hw_destroy_rwsem))
 		goto out_zap;
+	mutex_lock(&ufile->disassociation_lock);
+
 	/*
 	 * Disassociation already completed, the VMA should already be zapped.
 	 */
@@ -734,10 +743,12 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 		goto out_unlock;
 	rdma_umap_priv_init(priv, vma, opriv->entry);
 
+	mutex_unlock(&ufile->disassociation_lock);
 	up_read(&ufile->hw_destroy_rwsem);
 	return;
 
 out_unlock:
+	mutex_unlock(&ufile->disassociation_lock);
 	up_read(&ufile->hw_destroy_rwsem);
 out_zap:
 	/*
@@ -821,7 +832,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 {
 	struct rdma_umap_priv *priv, *next_priv;
 
-	lockdep_assert_held(&ufile->hw_destroy_rwsem);
+	mutex_lock(&ufile->disassociation_lock);
 
 	while (1) {
 		struct mm_struct *mm = NULL;
@@ -847,8 +858,10 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 			break;
 		}
 		mutex_unlock(&ufile->umap_lock);
-		if (!mm)
+		if (!mm) {
+			mutex_unlock(&ufile->disassociation_lock);
 			return;
+		}
 
 		/*
 		 * The umap_lock is nested under mmap_lock since it used within
@@ -878,7 +891,31 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 		mmap_read_unlock(mm);
 		mmput(mm);
 	}
+
+	mutex_unlock(&ufile->disassociation_lock);
+}
+
+/**
+ * rdma_user_mmap_disassociate() - Revoke mmaps for a device
+ * @device: device to revoke
+ *
+ * This function should be called by drivers that need to disable mmaps for the
+ * device, for instance because it is going to be reset.
+ */
+void rdma_user_mmap_disassociate(struct ib_device *device)
+{
+	struct ib_uverbs_device *uverbs_dev =
+		ib_get_client_data(device, &uverbs_client);
+	struct ib_uverbs_file *ufile;
+
+	mutex_lock(&uverbs_dev->lists_mutex);
+	list_for_each_entry(ufile, &uverbs_dev->uverbs_file_list, list) {
+		if (ufile->ucontext)
+			uverbs_user_mmap_disassociate(ufile);
+	}
+	mutex_unlock(&uverbs_dev->lists_mutex);
 }
+EXPORT_SYMBOL(rdma_user_mmap_disassociate);
 
 /*
  * ib_uverbs_open() does not need the BKL:
@@ -949,6 +986,8 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	mutex_init(&file->umap_lock);
 	INIT_LIST_HEAD(&file->umaps);
 
+	mutex_init(&file->disassociation_lock);
+
 	filp->private_data = file;
 	list_add_tail(&file->list, &dev->uverbs_file_list);
 	mutex_unlock(&dev->lists_mutex);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6c5712ae559d8..5acdf98b3e789 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2948,6 +2948,14 @@ int rdma_user_mmap_entry_insert_range(struct ib_ucontext *ucontext,
 				      size_t length, u32 min_pgoff,
 				      u32 max_pgoff);
 
+#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
+void rdma_user_mmap_disassociate(struct ib_device *device);
+#else
+static inline void rdma_user_mmap_disassociate(struct ib_device *device)
+{
+}
+#endif
+
 static inline int
 rdma_user_mmap_entry_insert_exact(struct ib_ucontext *ucontext,
 				  struct rdma_user_mmap_entry *entry,
-- 
2.43.0



