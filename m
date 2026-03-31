Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB85C413258;
	Tue, 31 Mar 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975608; cv=none; b=e2nDElcytxOy2mndkqieGCbG1aLV91IYnVpLPVaQTwNL2s0M7IWaL1ZPFEs7ZaHFqUljPgHFv4Aed5IHgw95Nj2oDoi7LXfdiFV7dzW09n7E8UDbKf8QeWXtmBhdD7fiu/xyrQsxu61juVlAdINtTKt0la2HB5FQ2nDd68R2fMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975608; c=relaxed/simple;
	bh=VBB8FFEgUmuOeRD9Nf1HqQS74TrZmTFI5R1lMiewByI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1Xon1Qm4GdAnbsXwNvaTWQewe2V9ozR81V7AQnPWfLQXusU+UF2Sljfb60SeGMVpdsIEd+cfgkBYw2ofQ3yBYVitihhwEFf4KI8jA0f8NW3O/hmzvGHFZYO0n9niuN/bbHXcW6y0XXow/120HSVCxrJ5kUyQeJCzesoF5CJiIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12MgyfLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12MgyfLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154BFC19423;
	Tue, 31 Mar 2026 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975608;
	bh=VBB8FFEgUmuOeRD9Nf1HqQS74TrZmTFI5R1lMiewByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12MgyfLXqTsLVT+/RBAGi6MwDIjiTJZ6zkELMeOIg88O5LjmLrhCLY3nxaR8V/Jjd
	 OR76OENIeXyo6CgYM9o6tFuyGVMrOzLPjRF74eS76OO8cP0/iQm1n4AfI3YMkU/740
	 Kkh0+gEH/myUGI/xVQUjwNB9eEP03rXyyRG+sNKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/244] nvme-pci: ensure were polling a polled queue
Date: Tue, 31 Mar 2026 18:19:28 +0200
Message-ID: <20260331161742.377347197@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 166e31d7dbf6aa44829b98aa446bda5c9580f12a ]

A user can change the polled queue count at run time. There's a brief
window during a reset where a hipri task may try to poll that queue
before the block layer has updated the queue maps, which would race with
the now interrupt driven queue and may cause double completions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7a58ba05484bf..c04858da28eae 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1218,7 +1218,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



