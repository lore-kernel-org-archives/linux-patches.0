Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7843E2E7654;
	Tue, 15 Jul 2025 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587583; cv=none; b=pBP3SE8JOZVI4aUC8nf2cUzqFv0yRy/yV/OwFA1LFtLYnJ7TfKwwxwMsf7piAGvFL7qEgRTLG1hoQ1vhDCRiMjMiAf3S8ZNtHvoVSr2cd/xVBaI5znHbcvuu4waIoYqHW2hxYTZRSFI8NRZGlpROucH+gUoPZmPcNkfiw9deQvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587583; c=relaxed/simple;
	bh=gpbU8NT66oLmbzW7LmSrCR7oZQVRqWErQQIAHT9sCWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlGS85QSTw/4t0k/lnsHoDz1ZR3mtI27tgvQ+Fxx4mqn9lOC/d2igIiMlQrnijpGl2rJcq63VbPcWrmP+QJ6LBAYy4p39ri35LNA+ekaYlifeIfRSgcGQnGV+fE2N4qAl8QohkWpvNq/g9VjRrRkGIw6d7OUJ5ybsIVCo14VDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNsOyeGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNsOyeGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BE9C4CEE3;
	Tue, 15 Jul 2025 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587583;
	bh=gpbU8NT66oLmbzW7LmSrCR7oZQVRqWErQQIAHT9sCWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNsOyeGZRCD4INN8pfC1ZOv6Ez8s2qF6QTiAXyB29VQODNT1DngTL5wxzq40wzK6C
	 8YefmtYWpwJz9L8NIil9XnWLJb6neXCX3uZKdyt0qdjfq6AQdFNj7R53fdzEKDubc4
	 nAuVbif+ktf9Aa4e2iB+wpnhheJH4xMkwvx22A14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/208] RDMA/core: Use refcount_t instead of atomic_t on refcount of iwcm_id_private
Date: Tue, 15 Jul 2025 15:12:24 +0200
Message-ID: <20250715130812.234766163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weihang Li <liweihang@huawei.com>

[ Upstream commit 60dff56d77292062789232f68354f567e1ccf1d2 ]

The refcount_t API will WARN on underflow and overflow of a reference
counter, and avoid use-after-free risks.

Link: https://lore.kernel.org/r/1622194663-2383-2-git-send-email-liweihang@huawei.com
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 6883b680e703 ("RDMA/iwcm: Fix use-after-free of work objects after cm_id destruction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/iwcm.c | 9 ++++-----
 drivers/infiniband/core/iwcm.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 44362f693df9f..3e4941754b48d 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -211,8 +211,7 @@ static void free_cm_id(struct iwcm_id_private *cm_id_priv)
  */
 static int iwcm_deref_id(struct iwcm_id_private *cm_id_priv)
 {
-	BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
-	if (atomic_dec_and_test(&cm_id_priv->refcount)) {
+	if (refcount_dec_and_test(&cm_id_priv->refcount)) {
 		BUG_ON(!list_empty(&cm_id_priv->work_list));
 		free_cm_id(cm_id_priv);
 		return 1;
@@ -225,7 +224,7 @@ static void add_ref(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 }
 
 static void rem_ref(struct iw_cm_id *cm_id)
@@ -257,7 +256,7 @@ struct iw_cm_id *iw_create_cm_id(struct ib_device *device,
 	cm_id_priv->id.add_ref = add_ref;
 	cm_id_priv->id.rem_ref = rem_ref;
 	spin_lock_init(&cm_id_priv->lock);
-	atomic_set(&cm_id_priv->refcount, 1);
+	refcount_set(&cm_id_priv->refcount, 1);
 	init_waitqueue_head(&cm_id_priv->connect_wait);
 	init_completion(&cm_id_priv->destroy_comp);
 	INIT_LIST_HEAD(&cm_id_priv->work_list);
@@ -1097,7 +1096,7 @@ static int cm_event_handler(struct iw_cm_id *cm_id,
 		}
 	}
 
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 	if (list_empty(&cm_id_priv->work_list)) {
 		list_add_tail(&work->list, &cm_id_priv->work_list);
 		queue_work(iwcm_wq, &work->work);
diff --git a/drivers/infiniband/core/iwcm.h b/drivers/infiniband/core/iwcm.h
index 82c2cd1b0a804..bf74639be1287 100644
--- a/drivers/infiniband/core/iwcm.h
+++ b/drivers/infiniband/core/iwcm.h
@@ -52,7 +52,7 @@ struct iwcm_id_private {
 	wait_queue_head_t connect_wait;
 	struct list_head work_list;
 	spinlock_t lock;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct list_head work_free_list;
 };
 
-- 
2.39.5



