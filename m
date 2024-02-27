Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9811B145338;
	Tue, 27 Feb 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043276; cv=none; b=CepP0RrAoY4UA4ne3BayWzGHbNg8+NGg3tIzNlEaNqcfcJDVbOT/YvFADKu2uRwQqkiyVYCNXW/9e3zQkXUZKGzNj5CMoVZqRuC8DEGtXTlsxOkWhKlWcDmULigMCgArBswAxobwM34y04xPvAt5ilExQwPSCSIavpdlH/hxQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043276; c=relaxed/simple;
	bh=tWrNA/TRQ3VtYxKroofGnnJ2fe6ukZuqXV40tdCfpy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSUaUyE6x5TiIz0ISGtQuRzDqINZu0btj8MnGVE5FwDjV2cRV2FMZ7fo2MC1C05YHS9SiJ3UoG3PBg3iqLS3aXwpyprOR84UzlC7PHKn80lXP4QNByy5ebfHcOtpejn5+Rc6wHfTIg9gA50lcFGt72VezKxKLRl1kgCYtbwfWE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEY+/vcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEY+/vcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EAFC43390;
	Tue, 27 Feb 2024 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043276;
	bh=tWrNA/TRQ3VtYxKroofGnnJ2fe6ukZuqXV40tdCfpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEY+/vcZ4VkI2a0N6D+MtyqaCvl8lyHBDpCz39E17tPFmW0KF1UN9pPDoyqoLZP/k
	 ptHtturb4YfikGpzD4Ce4rcEpIhouYBxxcvry4R55YkCz60m/NjKb75wHOarXxIMqS
	 Zp4sUOmW/GrJbttKvoex4AaUc33OG0IISBuWJIfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/195] nvmet-fc: take ref count on tgtport before delete assoc
Date: Tue, 27 Feb 2024 14:25:11 +0100
Message-ID: <20240227131612.160271889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit fe506a74589326183297d5abdda02d0c76ae5a8b ]

We have to ensure that the tgtport is not going away
before be have remove all the associations.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 36cae038eb045..8a02ed63b1566 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1092,13 +1092,28 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 }
 
 static void
-nvmet_fc_delete_assoc(struct work_struct *work)
+nvmet_fc_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
+{
+	nvmet_fc_delete_target_assoc(assoc);
+	nvmet_fc_tgt_a_put(assoc);
+}
+
+static void
+nvmet_fc_delete_assoc_work(struct work_struct *work)
 {
 	struct nvmet_fc_tgt_assoc *assoc =
 		container_of(work, struct nvmet_fc_tgt_assoc, del_work);
+	struct nvmet_fc_tgtport *tgtport = assoc->tgtport;
 
-	nvmet_fc_delete_target_assoc(assoc);
-	nvmet_fc_tgt_a_put(assoc);
+	nvmet_fc_delete_assoc(assoc);
+	nvmet_fc_tgtport_put(tgtport);
+}
+
+static void
+nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
+{
+	nvmet_fc_tgtport_get(assoc->tgtport);
+	queue_work(nvmet_wq, &assoc->del_work);
 }
 
 static struct nvmet_fc_tgt_assoc *
@@ -1132,7 +1147,7 @@ nvmet_fc_alloc_target_assoc(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 	assoc->a_id = idx;
 	INIT_LIST_HEAD(&assoc->a_list);
 	kref_init(&assoc->ref);
-	INIT_WORK(&assoc->del_work, nvmet_fc_delete_assoc);
+	INIT_WORK(&assoc->del_work, nvmet_fc_delete_assoc_work);
 	atomic_set(&assoc->terminating, 0);
 
 	while (needrandom) {
@@ -1491,7 +1506,7 @@ __nvmet_fc_free_assocs(struct nvmet_fc_tgtport *tgtport)
 	list_for_each_entry_rcu(assoc, &tgtport->assoc_list, a_list) {
 		if (!nvmet_fc_tgt_a_get(assoc))
 			continue;
-		queue_work(nvmet_wq, &assoc->del_work);
+		nvmet_fc_schedule_delete_assoc(assoc);
 		nvmet_fc_tgt_a_put(assoc);
 	}
 	rcu_read_unlock();
@@ -1545,7 +1560,7 @@ nvmet_fc_invalidate_host(struct nvmet_fc_target_port *target_port,
 			continue;
 		assoc->hostport->invalid = 1;
 		noassoc = false;
-		queue_work(nvmet_wq, &assoc->del_work);
+		nvmet_fc_schedule_delete_assoc(assoc);
 		nvmet_fc_tgt_a_put(assoc);
 	}
 	spin_unlock_irqrestore(&tgtport->lock, flags);
@@ -1590,7 +1605,7 @@ nvmet_fc_delete_ctrl(struct nvmet_ctrl *ctrl)
 		nvmet_fc_tgtport_put(tgtport);
 
 		if (found_ctrl) {
-			queue_work(nvmet_wq, &assoc->del_work);
+			nvmet_fc_schedule_delete_assoc(assoc);
 			nvmet_fc_tgt_a_put(assoc);
 			return;
 		}
@@ -1897,7 +1912,7 @@ nvmet_fc_ls_disconnect(struct nvmet_fc_tgtport *tgtport,
 		nvmet_fc_xmt_ls_rsp(tgtport, oldls);
 	}
 
-	queue_work(nvmet_wq, &assoc->del_work);
+	nvmet_fc_schedule_delete_assoc(assoc);
 	nvmet_fc_tgt_a_put(assoc);
 
 	return false;
-- 
2.43.0



