Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4501D235358;
	Sat, 12 Sep 2026 07:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198390; cv=none; b=t3x+3dzSh5dxmOp+4rlcGt1wtjltWgsaG2bCMYH8MvhaV8rXsn4WQ1TGFlryiYlrqeBatqCJaJpdHcEOOMjzA5t3z76na5jXkmDZDHenH3mumv5kyCR8tH/o0g5RBON7+LIrD2yfoLj2FDbQtxHq0cixGGvUpllzxlauUtaR+A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198390; c=relaxed/simple;
	bh=3/EDE5z2jyHHyfWAxUc1SZ69LF90oX+iH6xsmI6Vdu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiuVrk0v9wdW78k+NBJx6b14xSsK6vTJmLrN6ruvlFzFssp46qMgYeXtbl6RnGE19NqJ8CfagY4FiGSXoRIduCfk5JikBVlCurJ+kXAzdKGC4xW1rO06uNODleVYiiq2AXkybP23GMwPmmF/+JdpPDZvFGfKKehunYFxdCMfYFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip4sXyGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip4sXyGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ADF1F000FF;
	Sat, 12 Sep 2026 07:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198389;
	bh=wJyzWaK2gp2K6ROQFTp1b+UmKAtjIUikrkwSRCfHIik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip4sXyGHPNPhNarCZ6nYYxGwEQo0Df196hDZXBFy8fK55OpJJBVhzxMLK7N5VJ46I
	 qh946K3xRu3LYr++3zlo6eaqycn0W5hHdYwMZkxJtBdgY8i6YDdNY7WoT7NaZpVeFA
	 tU6uHxLRuS9B/OJzsxfEQRh91P3aRzwHBKQgfzO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0363/1815] RDMA/hfi1: Stop flushing the global IB workqueue
Date: Sat, 12 Sep 2026 08:35:13 +0200
Message-ID: <20260912065657.426628296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 11141a1b950fd..0ec1d8123e180 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1669,7 +1669,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		msix_clean_up_interrupts(dd);
 		stop_timers(dd);
-		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
 			ppd = dd->pport + pidx;
@@ -1743,9 +1742,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	stop_timers(dd);
 
-	/* wait until all of our (qsfp) queue_work() calls complete */
-	flush_workqueue(ib_wq);
-
 	postinit_cleanup(dd);
 }
 
-- 
2.53.0



