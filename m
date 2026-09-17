Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEB63976A0;
	Thu, 17 Sep 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658724; cv=none; b=UjH5kzJ3Ko1tDyKPCTWSeUtJmw/NI7wlTb5ORCeMYNyL2EX41+MnL9IWc9EkvTMB20AyaJZjPLqkavr6VYOLe81G9aJ5S7bEw459p9ZRc36DTgzDbNDmLk22Zm5RIXptmpngbRoUhW4wu8guoi+DXNa3cJnLs8E/tHQ+wUStfkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658724; c=relaxed/simple;
	bh=lmma7+ZVl4BKTDst3xAgE0wlSnH5/xq1JEWq+/tQkTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX0Aj/8sZDSBsNxI7jqZ9yU2c5pAU8dQKqonhGyiDCt8lPGxWfxWuuvcZT3FkNB5tUHlntqOHykUDgD2MSDupzCxaiL2AFTVAbjJQUYgpWXdQj5geZ+dXyxUYSocU+oUaqN0PbPM32JZvdFGtIBS+CQZ9DbsGzFcfOOcufSpVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ayc1KHPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ayc1KHPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A8F1F0089D;
	Thu, 17 Sep 2026 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658716;
	bh=XLp4zxZpz9f1dBpIjl3ScGvdAoYw+SYrPj4lhxYajPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ayc1KHPsRn+xci1p700n1kwlILuOCfjwIVoNGKSQb+nkCRWfqdnOg6z0d5r/44J+G
	 7jAaPoHoSVXIDCdCtpf/0OTstN92X8Z+uNkr46QT+ZyYV62BsCpiXnGLkJnoKbjjNp
	 RXsGNADrnD1bPiKlM6uljp9th/M9a9/wq9oBxX7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 016/733] nvme: add context annotations for nvme_subsystem::lock
Date: Thu, 17 Sep 2026 16:05:24 +0100
Message-ID: <20260917151351.077360215@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit d1fdf49b5f7fce5f65ae0d11d484bd7e31cedbb1 ]

Several helpers access or traverse data structures protected by
nvme_subsystem::lock and therefore require callers to hold the lock.
Annotate nvme_mpath_unfreeze(), nvme_mpath_wait_freeze(),
nvme_mpath_start_freeze(), nvme_find_ns_head(), nvme_alloc_ns_head()
and nvme_subsys_check_duplicate_ids() with __must_hold(&subsys->lock)
so that Clang's lock context analysis can validate the locking
requirements at compile time.

Also annotate nvme_subsystem::nsheads and
nvme_ns_head::delayed_removal_secs with __guarded_by(&subsys->lock),
as both are protected by the subsystem lock.

Annotate nvme_init_subsystem() with __context_unsafe(), as it
initializes these lock-protected members before the object is published,
suppressing a false positive from Clang's context analysis.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 56e1c6bbe4bb ("nvme: fix racy access to FDP placement id array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c |  4 ++++
 drivers/nvme/host/nvme.h | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0b80db7a0599f..0224b99317cdd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3292,6 +3292,7 @@ static bool nvme_validate_cntlid(struct nvme_subsystem *subsys,
 }
 
 static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
+	__context_unsafe(/* initialize unpublished/lock-guarded variables */)
 {
 	struct nvme_subsystem *subsys, *found;
 	int ret;
@@ -3863,6 +3864,7 @@ static const struct file_operations nvme_dev_fops = {
 
 static struct nvme_ns_head *nvme_find_ns_head(struct nvme_ctrl *ctrl,
 		unsigned nsid)
+	__must_hold(&ctrl->subsys->lock)
 {
 	struct nvme_ns_head *h;
 
@@ -3885,6 +3887,7 @@ static struct nvme_ns_head *nvme_find_ns_head(struct nvme_ctrl *ctrl,
 
 static int nvme_subsys_check_duplicate_ids(struct nvme_subsystem *subsys,
 		struct nvme_ns_ids *ids)
+	__must_hold(&subsys->lock)
 {
 	bool has_uuid = !uuid_is_null(&ids->uuid);
 	bool has_nguid = memchr_inv(ids->nguid, 0, sizeof(ids->nguid));
@@ -3986,6 +3989,7 @@ static void nvme_add_ns_cdev(struct nvme_ns *ns)
 
 static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 		struct nvme_ns_info *info)
+	__must_hold(&ctrl->subsys->lock)
 {
 	struct nvme_ns_head *head;
 	size_t size = sizeof(*head);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 957ded0c6f53b..5e2e45ef7dadf 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -503,7 +503,8 @@ struct nvme_subsystem {
 	struct list_head	entry;
 	struct mutex		lock;
 	struct list_head	ctrls;
-	struct list_head	nsheads;
+	struct list_head	nsheads
+		__guarded_by(&lock);
 	char			subnqn[NVMF_NQN_SIZE];
 	char			serial[20];
 	char			model[40];
@@ -575,7 +576,8 @@ struct nvme_ns_head {
 	struct mutex		lock;
 	unsigned long		flags;
 	struct delayed_work	remove_work;
-	unsigned int		delayed_removal_secs;
+	unsigned int		delayed_removal_secs
+		__guarded_by(&subsys->lock);
 	atomic_long_t		io_requeue_no_usable_path_count;
 	atomic_long_t		io_fail_no_available_path_count;
 #define NVME_NSHEAD_DISK_LIVE		0
@@ -1046,9 +1048,12 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 	return ctrl->ana_log_buf != NULL;
 }
 
-void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
-void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
-void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
+void nvme_mpath_unfreeze(struct nvme_subsystem *subsys)
+	__must_hold(&subsys->lock);
+void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
+	__must_hold(&subsys->lock);
+void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
+	__must_hold(&subsys->lock);
 void nvme_mpath_default_iopolicy(struct nvme_subsystem *subsys);
 void nvme_failover_req(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
-- 
2.53.0



