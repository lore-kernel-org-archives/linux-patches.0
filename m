Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF8B30BF69;
	Sat, 12 Sep 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223151; cv=none; b=p7LZ3jdHbcIGp44eXM4LU22SbqyCGsG+J6BtHytUTqeh0+1zAiBuFmFLmh7KUqfcbWF/px83JkN+LgUCFCcRn+oiu6xTrg1FAVcRKhWmuAsCMZ2WPlNzuo2/9QIZI3VRFSWCM0/d4seoTGaqqJR0o/RtDDnCGIvI9f/vHkEAoC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223151; c=relaxed/simple;
	bh=9D8DBdYbdc5Q7UORDtqKY/GY8ILzDYdablX7/s9k0E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4Iz5vvcsEo74x7O3/wOHTvHMJ0xlNlCVFxxMqFOegYNhU/BxlQP9L8lfd7IBP0U3jWbbBkgPKBF/F9QGGei4wOGXRt6UpGWIx73j90lMJOf6Grvfsf5suwi0y0BbLh40IrV81v2ybEOK9WCgg+O+g/nk+/AgAW6rQvm+/lXv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjDROIHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjDROIHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8311F000FF;
	Sat, 12 Sep 2026 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223149;
	bh=9ljw0Gz4LOD4+PEb6wB64638PL1v6Z53enbvhmUip38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjDROIHShK8ULW7MYf34efLXS8UxCwHvN1Y3ro3U/LPbqUYKNx/d/dHGS9D6GpVAq
	 TQzFpTqjNkvqe8qGEjcKZP53phjRthV5zOdQv1w2+JxbFUMrqK7cv55Wz4T+5oXXh1
	 SQArS8zygVlGnKww0kEniZLZp0WmR/fG9ubVckJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0732/1424] RDMA/hfi1: Stop flushing the global IB workqueue
Date: Sat, 12 Sep 2026 08:52:44 +0200
Message-ID: <20260912065623.686233656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6590b66260841..b0618e1b17ea8 100644
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



