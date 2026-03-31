Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D775425CD5;
	Tue, 31 Mar 2026 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976145; cv=none; b=L52W7m5fu7Gv4yJD9WxKxgtJ2qYUxkNV03cuX5Lq+aoAoOzKaX3pu9b1R/QsPqWDEH9/7LUj6J4F30R5DKMXId3GALFcuHy/ntSPOtu4ggHyjTd0rFFdz4dFkSeqDbUW4+c7Um7sMc0Bs38xe+LjNE0qpkT+LFyxiKlBoZ25xkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976145; c=relaxed/simple;
	bh=o2NbFhtMX/HyKsQ6XMzoLcFW3aXMTjSX/lSQmCKwfsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4+wl4tWLQyckI+6KpZXfzQbfXPlYWCecrRiBooMXVP63VGOGxUOyQkzjIG6Ls1N6ZLT7mtCFzvNlRkFtDvZg0E53nuNSYsCAu9dTtcWOxQm6PjUXPpyoWm5R2n5g2WAUzlpVPiURIPYFU+EWJcDPKgZ8/CaBrRX8uCBVIhYQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJN9aiQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJN9aiQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6B7C19423;
	Tue, 31 Mar 2026 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976145;
	bh=o2NbFhtMX/HyKsQ6XMzoLcFW3aXMTjSX/lSQmCKwfsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJN9aiQHztDi67WKrPyAauUTXqotNCXO8YzpYQiuAQoebthq7u5k3ZXrM1zTmlud+
	 IVtGpif2d2m8qr9r42CVHr98HujkufU74/tbnaByATHgAzfNbCc1pSRi86ONwzQ4rg
	 qBNL20pkEJ2ZWL8iYGYyhXqMx5VlYdC/fU0hGoRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/244] dmaengine: idxd: Fix memory leak when a wq is reset
Date: Tue, 31 Mar 2026 18:22:55 +0200
Message-ID: <20260331161750.077141691@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit d9cfb5193a047a92a4d3c0e91ea4cc87c8f7c478 ]

idxd_wq_disable_cleanup() which is called from the reset path for a
workqueue, sets the wq type to NONE, which for other parts of the
driver mean that the wq is empty (all its resources were released).

Only set the wq type to NONE after its resources are released.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-8-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index c41ef195eeb9f..d8e0a12f62ace 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -174,6 +174,7 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
 	free_descs(wq);
 	dma_free_coherent(dev, wq->compls_size, wq->compls, wq->compls_addr);
 	sbitmap_queue_free(&wq->sbq);
+	wq->type = IDXD_WQT_NONE;
 }
 EXPORT_SYMBOL_NS_GPL(idxd_wq_free_resources, IDXD);
 
@@ -367,7 +368,6 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	lockdep_assert_held(&wq->wq_lock);
 	wq->state = IDXD_WQ_DISABLED;
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
-	wq->type = IDXD_WQT_NONE;
 	wq->threshold = 0;
 	wq->priority = 0;
 	wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
@@ -1513,7 +1513,6 @@ void idxd_drv_disable_wq(struct idxd_wq *wq)
 	idxd_wq_reset(wq);
 	idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
-	wq->type = IDXD_WQT_NONE;
 	wq->client_count = 0;
 }
 EXPORT_SYMBOL_NS_GPL(idxd_drv_disable_wq, IDXD);
-- 
2.53.0



