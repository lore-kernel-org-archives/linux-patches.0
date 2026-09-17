Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CFE4D489A;
	Thu, 17 Sep 2026 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658730; cv=none; b=PRnRxDXGpK5EdcGz5C7fTRxadIFJmDaFGN8b23qAveku8qt9KMzw6cN17pX0tZ0/n/r6rXBJQKggl2btc+avU+ebz5O67eJftU9Vp+NBPDFvh2Uq0DYS714yk9yd51RfBXQTFDZ5igyDt8wa7PdOb8XDGVYjEi7+vD8QAgRttug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658730; c=relaxed/simple;
	bh=O5sasm9wHLpjDYxUY3zKUpYOPnmR5V6RjcgIQ11NrLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC8gLZjQ/pgDOpTJ8D0FQ5oSYPuQq0BwKBPs6MgWBU24Au+0+igTEfljOWT2gxuBzfnmkjXG96RTTjgVrPugqtP/c7D5AjqNEQt0dkWtHcZuoAfgHWXvJFrUAzxgpszx5s2FG6otvSTmhD38/m5BwzuGoSVYOVQTS956W3tPhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQhbF9up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQhbF9up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C461F0089B;
	Thu, 17 Sep 2026 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658722;
	bh=F3WvUJXFRcEQEL5OeIbGoJrSao/0J2inZRe09Dx37o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQhbF9upGaOJ/67MvYpNcyq+nxPVDziYuA01L98YMlmgfeAAx+YTPsursL27+fpUL
	 a7zPWSKpn2djUXe8uM8iECfws9W0dKjd5T1MHsuVrDcLbcGjQ70RwFl0dCC7inWcrI
	 SRcB7C2qugTBYdT1CKz1VnNFq7WloR4yyZ/TTDks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 018/733] nvme: fix racy access to FDP placement id array
Date: Thu, 17 Sep 2026 16:05:26 +0100
Message-ID: <20260917151351.133600329@linuxfoundation.org>
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

From: Kanchan Joshi <joshi.k@samsung.com>

[ Upstream commit 56e1c6bbe4bb084d7ecf61698afdf70be23dd35f ]

nvme_query_fdp_info() is called per-path and therefore prone to races.

It populates head->nr_plids/head->plids for fdp registration.
But nothing protects that pair from concurrent access - two paths scanning
the same namespace can race to populate it.

Avoid the race by moving this initialization work to nvme_alloc_ns_head()
which is called once per shared namespace.

Fixes: 30b5f20bb2dd ("nvme: register fdp parameters with the block layer")
Reported-by: Hari Mishal <harimishal1@gmail.com>
Link: https://lore.kernel.org/linux-nvme/20260725135111.14041-2-harimishal1@gmail.com/
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 30 +++++++++++-------------------
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e5051a6b33578..706df45b26e77 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2323,14 +2323,6 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	size_t size;
 	int i, ret;
 
-	/*
-	 * The FDP configuration is static for the lifetime of the namespace,
-	 * so return immediately if we've already registered this namespace's
-	 * streams.
-	 */
-	if (head->nr_plids)
-		return 0;
-
 	ret = nvme_get_features(ctrl, NVME_FEAT_FDP, info->endgid, NULL, 0,
 				&fdp);
 	if (ret) {
@@ -2377,6 +2369,7 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 
 	for (i = 0; i < head->nr_plids; i++)
 		head->plids[i] = le16_to_cpu(ruhs->ruhsd[i].pid);
+	head->write_stream_granularity = min(info->runs, U32_MAX);
 free:
 	kfree(ruhs);
 	return ret;
@@ -2424,12 +2417,6 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 			goto out;
 	}
 
-	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
-		ret = nvme_query_fdp_info(ns, info);
-		if (ret < 0)
-			goto out;
-	}
-
 	if (nvme_invalid_lba_sz(le64_to_cpu(id->nsze),
 			id->lbaf[lbaf].ds - SECTOR_SHIFT, &capacity)) {
 		dev_warn_once(ns->ctrl->device,
@@ -2489,10 +2476,7 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		capacity = 0;
 
 	lim.max_write_streams = ns->head->nr_plids;
-	if (lim.max_write_streams)
-		lim.write_stream_granularity = min(info->runs, U32_MAX);
-	else
-		lim.write_stream_granularity = 0;
+	lim.write_stream_granularity = ns->head->write_stream_granularity;
 
 	/*
 	 * Only set the DEAC bit if the device guarantees that reads from
@@ -4028,15 +4012,23 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ns *ns,
 	} else
 		head->effects = ctrl->effects;
 
+	if (ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret = nvme_query_fdp_info(ns, info);
+		if (ret < 0)
+			goto out_cleanup_srcu;
+	}
+
 	ret = nvme_mpath_alloc_disk(ctrl, head);
 	if (ret)
-		goto out_cleanup_srcu;
+		goto out_cleanup_fdp;
 
 	list_add_tail(&head->entry, &ctrl->subsys->nsheads);
 
 	kref_get(&ctrl->subsys->ref);
 
 	return head;
+out_cleanup_fdp:
+	kfree(head->plids);
 out_cleanup_srcu:
 	cleanup_srcu_struct(&head->srcu);
 out_ida_remove:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 5e2e45ef7dadf..cfdcf53db5abd 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -568,6 +568,7 @@ struct nvme_ns_head {
 
 	u16			nr_plids;
 	u16			*plids;
+	u32			write_stream_granularity;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
-- 
2.53.0



