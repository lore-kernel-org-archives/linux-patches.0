Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A18F1A189E;
	Thu,  6 Jun 2024 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683189; cv=none; b=pT0425tAW9VyRbMxmxZgxllVr9E7XpkLNrLyqmsS5pHgm8V1zmNHULUJnWCr5cw+zq0TceNgP0ytlI0En5oNy9LhX5TSzbcvdlaTRObSKHySP2d5iI1+PKS24evOf34DWGHHpCZpvvhh//TaEzNV0rMOAyEnfc0onp6x0b9AxKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683189; c=relaxed/simple;
	bh=/2GOWm3Toa2T2PU/VT9jsUxpBNRUadn7vMMV6RZ/8RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGTxzPZRPkrmDE15uuKgFMlE80d3ZnGrienpZgKa0uhVYIH+a/WJ3gTgjKw8czUxPoREeafYs6gUm0TwWyqLeVJuwKQFTN26xXKlirhf4au2bQB8l+MDH/MugE5IONBG5AIMfAwRixpKgN818Cahe9Kd399y4aGZGANJM2NdI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ja7W6C7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ja7W6C7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFF7C2BD10;
	Thu,  6 Jun 2024 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683189;
	bh=/2GOWm3Toa2T2PU/VT9jsUxpBNRUadn7vMMV6RZ/8RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja7W6C7HArPrP/T/l2laQb+TvmsaCkiuc90Wb+g6QVJJyXuw6RJ1m5p17twZE1SE9
	 Z5VAhs581skx5gKq/sOl7JsNxlHCAU3lmgd1uffOqela887f/ph7EtevBgrVYJKamr
	 1EFQKdIXrlu0PQ+LmEbggZK55Mr8Pj+Q8FU14YOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jirong Feng <jirong.feng@easystack.cn>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/473] nvmet: fix nvme status code when namespace is disabled
Date: Thu,  6 Jun 2024 15:59:52 +0200
Message-ID: <20240606131701.976032412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73ae16059a1cb..b1f5fa45bb4ac 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -615,6 +615,19 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
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
index 3235baf7cc6b1..7b74926c50f9b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -423,10 +423,13 @@ void nvmet_stop_keep_alive_timer(struct nvmet_ctrl *ctrl)
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
index 273cca49a040f..6aee0ce60a4ba 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -527,6 +527,7 @@ void nvmet_subsys_disc_changed(struct nvmet_subsys *subsys,
 		struct nvmet_host *host);
 void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 		u8 event_info, u8 log_page);
+bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid);
 
 #define NVMET_QUEUE_SIZE	1024
 #define NVMET_NR_QUEUES		128
-- 
2.43.0



