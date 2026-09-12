Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E4817DFFA;
	Sat, 12 Sep 2026 09:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207172; cv=none; b=g3mIBdhbFHcu0XiIgYW6XmZOm5CqwyaI9SYxuw2M7xnZgcuaQD+LiSOuhEkefjUIVHSnFeZm9U4dVlRMPUj9gdWXIJVC63L7h86nYB71ToMkpPF8KS9T83e3kQtPpZFx5eRU+ubdKZVqvIhszf0bREM/grhy8TEAF9aOaPPFe7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207172; c=relaxed/simple;
	bh=jgnpJBSeji+cc2uE2hYnxSnORjIMKfVE7/uh6Lb11G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJLzYcxmnCbk8/m630T3+rswQnZ/jCgwjzvpzqLF+CK69wFPAjtgXJ7cx+GFoTnqDHu/KtW5/egPeq46SMA1uVNyQJSsqVX3DZRQctO0HFm9X4Gn7btLmnxwdLalvDyi98Mvo8M2RLS2QR8o9Dv1/GK6/8ORS7EgqQX3HKBobnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5gj0Owv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5gj0Owv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857EC1F000FF;
	Sat, 12 Sep 2026 09:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207170;
	bh=aJsKcvjRNM3zEygGu0lANflz4G2P9oC6Z9CYnxfefhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5gj0OwvPsQ5UaGSiYS/dl6GnDd6tcjw5Au3/TcI/WWlB/CFspsCS2y1Adtlp/dzf
	 Vcsj7S5Rtiod0/Vr2enIO8rJcfnd9v6nL3nsMojRI4spFgfv2Q2tmIgkzlrC+kjsc7
	 iLh1nYmjN0Iasinq3Qx60KGOKrCoBNbdhqr/LV1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0357/1518] RDMA/hfi1: Stop flushing the global IB workqueue
Date: Sat, 12 Sep 2026 08:42:06 +0200
Message-ID: <20260912065631.548378849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d43b1c17f9e1b9d34a0d742f569c00d84147ebc0 ]

hfi1 does not queue work on ib_wq. QSFP and link work run on the per-port
link_wq, while the remaining device work uses hfi1_wq or dedicated queues.
The probe failure path destroys both per-port workqueues, and normal device
removal flushes them in shutdown_device() before destroying them.

Remove the flushes of the core-owned global workqueue. Waiting for
unrelated core or other device work is not part of hfi1 teardown.

Fixes: 71d47008ca1b ("IB/hfi1: Create workqueue for link events")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-10-b9e9641268a5@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 68e0aab49fb94..6253d8088abd6 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1660,7 +1660,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		msix_clean_up_interrupts(dd);
 		stop_timers(dd);
-		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
 			ppd = dd->pport + pidx;
@@ -1737,9 +1736,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	stop_timers(dd);
 
-	/* wait until all of our (qsfp) queue_work() calls complete */
-	flush_workqueue(ib_wq);
-
 	postinit_cleanup(dd);
 }
 
-- 
2.53.0



