Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245213E316C;
	Tue, 31 Mar 2026 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974258; cv=none; b=i3XQPk4V4tVlD9ywv5fNsTVqg8XFpI9nhqrVE9XSY/nTfh6yGgl0VjOfJ9YQaqyMZRutqVaXS6xDTdMLtPqq+aPT7qG2aSy4C2Ynt4NLv6o9hS4I4HDClkDEdUS4O8qu7JNRZm5lOF0MkJvjnOeYVQ8zLb16seB7PdUyVvHecYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974258; c=relaxed/simple;
	bh=U6JhT2uScj1XX5FW2zhUmbVyBIo5Ezop6u0MVX3Ik90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tad+oDYynicqv9VnRqIxz4ItUunfhM5yVAN6N9+vqCFUzVJIZtuDOQWk/VBGUp9898wJZqtw18l1Mbue2h8rrFZoXTZuXaNrfnersgcZnYuHTwD/oLTJsWEdIWoFSMEp00LoP4WWrXcq3SUBnmneQw4pqBRfolkxnnVwfex6368=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUu6Himq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUu6Himq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE8EC2BCB1;
	Tue, 31 Mar 2026 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974258;
	bh=U6JhT2uScj1XX5FW2zhUmbVyBIo5Ezop6u0MVX3Ik90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUu6Himq8Q/GDlr8DJpU+FifllDB5LQaEDDF9ObZkpcexaCPNXdGY+x9PC51YoLTm
	 bBEBo2iQ4RUs9Q9vuDkBlPHfAjSFncFMz65TeUA2TdYRT86C9bJ+ZY1cAShywCkaNC
	 YIfvoRsOaforHfOAVhG3Hk2eBlhFN57dCqRpAjBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/175] nvme-pci: ensure were polling a polled queue
Date: Tue, 31 Mar 2026 18:20:00 +0200
Message-ID: <20260331161730.378872133@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 820e211feded2..6f78577fb70da 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1120,7 +1120,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



