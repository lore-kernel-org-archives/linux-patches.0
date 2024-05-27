Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B5B168C4;
	Mon, 27 May 2024 19:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837689; cv=none; b=hUEkSH0SypW3liZhyPt3WIrg5sPG65BEV4gE6zSkc7Z4DEbP3H1JHo730h6BwZDiO92swdnUEwyz+nbdid6BP557KtrBUayTQB8k8MclaZYQ6xcguqas+QIoAkzqZkbZZi+nK4lhFnOU6combRpEfedzOVe6mElOIntGUu0bAdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837689; c=relaxed/simple;
	bh=ksb1+XYD5RL/yPuZo/0tEGFnvAc8DC6p2zdi+39JPV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq6phZWE2wthHALg59NxvZU4BUl6X68NWA/9aEawIYXuxPCfyY2cjwwzAzj1oThLPilPg+BoHjdqEDHxQaX0qvmW7e2+F5Pf94ZOF+ufPLZUaxCJK5rQiDO3IH9IjhZm3cf8XuntE746M4abDiOiAmwFLWMYuMusUmCEDgWpjOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2KGu2Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2KGu2Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF13C2BBFC;
	Mon, 27 May 2024 19:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837689;
	bh=ksb1+XYD5RL/yPuZo/0tEGFnvAc8DC6p2zdi+39JPV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2KGu2VdSsXnOZtI/Ut+s3C/y10AsyMW3ZYfm3bxVhbucUmlCnNwZSkcu7bqtYGTp
	 ajar1oDuglFM61dcpDKU8OY2KbXMrkWbZ5I4OZmzm8ioRrT6lsuyXC5YZVe1lkN1MC
	 6IXa5m68R4ieV4vK5Hb6VJd2hnXjICNEAbWeg/eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jirong Feng <jirong.feng@easystack.cn>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 106/493] nvmet: fix nvme status code when namespace is disabled
Date: Mon, 27 May 2024 20:51:48 +0200
Message-ID: <20240527185633.988247114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 505363957fad35f7aed9a2b0d8dad73451a80fb5 ]

If the user disabled a nvmet namespace, it is removed from the subsystem
namespaces list. When nvmet processes a command directed to an nsid that
was disabled, it cannot differentiate between a nsid that is disabled
vs. a non-existent namespace, and resorts to return NVME_SC_INVALID_NS
with the dnr bit set.

This translates to a non-retryable status for the host, which translates
to a user error. We should expect disabled namespaces to not cause an
I/O error in a multipath environment.

Address this by searching a configfs item for the namespace nvmet failed
to find, and if we found one, conclude that the namespace is disabled
(perhaps temporarily). Return NVME_SC_INTERNAL_PATH_ERROR in this case
and keep DNR bit cleared.

Reported-by: Jirong Feng <jirong.feng@easystack.cn>
Tested-by: Jirong Feng <jirong.feng@easystack.cn>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 13 +++++++++++++
 drivers/nvme/target/core.c     |  5 ++++-
 drivers/nvme/target/nvmet.h    |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2482a0db25043..b7bfee4b77a84 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -728,6 +728,19 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
 	NULL,
 };
 
+bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid)
+{
+	struct config_item *ns_item;
+	char name[4] = {};
+
+	if (sprintf(name, "%u", nsid) <= 0)
+		return false;
+	mutex_lock(&subsys->namespaces_group.cg_subsys->su_mutex);
+	ns_item = config_group_find_item(&subsys->namespaces_group, name);
+	mutex_unlock(&subsys->namespaces_group.cg_subsys->su_mutex);
+	return ns_item != NULL;
+}
+
 static void nvmet_ns_release(struct config_item *item)
 {
 	struct nvmet_ns *ns = to_nvmet_ns(item);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 8658e9c08534d..7a6b3d37cca70 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -425,10 +425,13 @@ void nvmet_stop_keep_alive_timer(struct nvmet_ctrl *ctrl)
 u16 nvmet_req_find_ns(struct nvmet_req *req)
 {
 	u32 nsid = le32_to_cpu(req->cmd->common.nsid);
+	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
 
-	req->ns = xa_load(&nvmet_req_subsys(req)->namespaces, nsid);
+	req->ns = xa_load(&subsys->namespaces, nsid);
 	if (unlikely(!req->ns)) {
 		req->error_loc = offsetof(struct nvme_common_command, nsid);
+		if (nvmet_subsys_nsid_exists(subsys, nsid))
+			return NVME_SC_INTERNAL_PATH_ERROR;
 		return NVME_SC_INVALID_NS | NVME_SC_DNR;
 	}
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 6c8acebe1a1a6..477416abf85ab 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -542,6 +542,7 @@ void nvmet_subsys_disc_changed(struct nvmet_subsys *subsys,
 		struct nvmet_host *host);
 void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 		u8 event_info, u8 log_page);
+bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid);
 
 #define NVMET_QUEUE_SIZE	1024
 #define NVMET_NR_QUEUES		128
-- 
2.43.0



