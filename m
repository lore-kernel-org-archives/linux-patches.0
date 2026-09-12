Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93DB18DB35;
	Sat, 12 Sep 2026 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229734; cv=none; b=tH2nvGO2ybEYsYhJY1Z2sb1nb8D6uW3Ixg+KkfdDc0pPuuZ7nLZm3d3GU5R4W2AuSAEsQoYG0m2nIeqcKaPyhPQ7ZQDhOzItA+Gv5fgKqxieRVXX5jMPvAM7E42QD7s7gp79mymJaHGXny+GKO41/+YQM4qEqw10S7hy+vMRbbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229734; c=relaxed/simple;
	bh=atRRIufRLsVVmbxwa3cMWiI3rOR559wUsrmHNui8fwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8ZFRxP12hLphGM6Af9nbgPT7+8aCe28wULhnYCJiv36B19ipjbPn9u9icjBNmuxQQC3rvQbCl1w7U4Efm7VXi5LiobuG6W2nHgV5S393TCGA9zmn1uxA4dCPnyxjvmkYoRN/HRX9TEcyEAr8qKqx62RkpR7CKl6MLYVATSeWLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3zf8Lp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3zf8Lp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626621F000FF;
	Sat, 12 Sep 2026 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229733;
	bh=MD4EjouxPZUt3EMxOVc881AYoMYhDU0AEBA7XpQN7Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3zf8Lp7ePT21EqSUwno2MboaUaGytgtdq3PkWjNoRrfMThl5AWSEvL8wgPZsXzAN
	 wr2n+bM18c9l737V8sTLdXDNxOv7urYgPP8Q5mY6R2iEAJyiGvMuxXjpXv9A+klNNs
	 G+kat4grZwjBKpTdfqxR9UJObHhQZGI8lU4ZUBwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0607/1191] RDMA/hfi1: Stop flushing the global IB workqueue
Date: Sat, 12 Sep 2026 08:55:35 +0200
Message-ID: <20260912065601.882509448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 394abffc56b92..72ca8d6445dc3 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1651,7 +1651,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		msix_clean_up_interrupts(dd);
 		stop_timers(dd);
-		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
 			ppd = dd->pport + pidx;
@@ -1728,9 +1727,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	stop_timers(dd);
 
-	/* wait until all of our (qsfp) queue_work() calls complete */
-	flush_workqueue(ib_wq);
-
 	postinit_cleanup(dd);
 }
 
-- 
2.53.0



