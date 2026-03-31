Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA6426D07;
	Tue, 31 Mar 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974752; cv=none; b=q/hBIRBm9fBQf5JTNlU9m2zHRJ3dzHQvbOUQ9iLZnVPbOJaSFtBFzOd7Y7ooQW7VjsB8xVwIGatNFpqE2BTUGyobttXQ81fhi4NJYei21ne6trEB6uS0KfcIWJFXRz/mLyy38+QKs5ZL2841ChLz+mn4ImBcosSbkToKySTBs2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974752; c=relaxed/simple;
	bh=eP3mOXvlCvJ+OYZ1G2ODnLjmZnb9131UD+fZVY5wG7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8b/FEUjtLBRFXLD3BNwQGDZW0Y9xUKM8dtT0xCunw6Bho0EhxQiOo9O7zEyAPyIlwEcQ4SLbGoyhE876CQky8iW5deSde9YAoaTaNghZLMpFE1l1MjaE3bKUlAeLhhNOqu69HI7HhNwB99av4LolWpzOptuJ6me2sthAEy3YJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYzPUdVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYzPUdVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21773C19423;
	Tue, 31 Mar 2026 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974752;
	bh=eP3mOXvlCvJ+OYZ1G2ODnLjmZnb9131UD+fZVY5wG7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYzPUdVZxXwzk+2egj1KXwQpJHhVwlpEaYIfvrJkpTMUrFgQMYRXHpez2d3Aa16sE
	 ScWCnASjtQrvgzAXhCZwpJm1p9xnYWHvZDzNQCf3tmf8r3Z79aTINE5Bjxm4TATCye
	 NF/lRU9wU7sYAIU9hH43TzjjlTsVDhlvPm/fljMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 031/342] nvme-pci: ensure were polling a polled queue
Date: Tue, 31 Mar 2026 18:17:44 +0200
Message-ID: <20260331161800.054738343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a5eab31c1bb7a..f6d4f5910bdbc 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1501,7 +1501,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



