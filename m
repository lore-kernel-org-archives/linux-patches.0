Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E07B2F617C;
	Sat, 12 Sep 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238679; cv=none; b=J2ZjyOw3vZIMutv9RKwgkvvihmOU+u38uvmtRzrvUmVlPAqanUS2HZKpPJ0ddhUVN/7JL6jX8UWj1uapv5OiGzpgbTb8AjeBCW4VdFuHIbbHJDliREEoNH59C6/FIGNtkxiPrvCsysE7tqhleZbV/aMP+yxJIZxVzdP1SS/dw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238679; c=relaxed/simple;
	bh=zz//4js9fjbJQ2ETGQ7xrnirQLrcp+bHtUjlbGHhj+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmfdOsolB7d0shdtuZ1KXeLx08w6LGAS2j8jxs/HoIf7N93owKkzC++jxj4p0X0qn674KRrSbPO6B9lpXf+0PXThjiqUWEHfp0RNp6kbxl6wJZUi3v5TqBwheoeRpMohSWAAqmJ6QiOVB/F7Ynhxg1WO1RnUj+14uF1ZBJMKRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2pywpO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2pywpO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306891F000FF;
	Sat, 12 Sep 2026 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238678;
	bh=aAXX5RWK3J6+t08o0mwF+lckn8ZafCHxqaRqgX5v+o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2pywpO6MbZJcBy7LPDm8sJtYOBcAveP5xa1VIRe5eMD3VM2t7vXYlhJ04SbvVvL9
	 nPnprYxa6xF+oAQPAg54bsEQoz8NA1gvVwbJ2rkkUgsRVtkr4n9f3AHK+PcdW6L+RJ
	 WCy7HwuJnbzxfdcpBrEajODHvAzbDFbQMrbjTER4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/935] RDMA/hfi1: Stop flushing the global IB workqueue
Date: Sat, 12 Sep 2026 08:59:01 +0200
Message-ID: <20260912065538.542717350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bcd8365f1b550..a3ad89f6b954a 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1650,7 +1650,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (initfail || ret) {
 		msix_clean_up_interrupts(dd);
 		stop_timers(dd);
-		flush_workqueue(ib_wq);
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			hfi1_quiet_serdes(dd->pport + pidx);
 			ppd = dd->pport + pidx;
@@ -1727,9 +1726,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	stop_timers(dd);
 
-	/* wait until all of our (qsfp) queue_work() calls complete */
-	flush_workqueue(ib_wq);
-
 	postinit_cleanup(dd);
 }
 
-- 
2.53.0



