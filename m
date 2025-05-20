Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D224C07A;
	Tue, 20 May 2025 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750122; cv=none; b=FuW+Mnt1lGyIYydHyqFagyeao22rDwQpRCi5G/FaEwkL940+eTWjx+Cd/3AlzMRcGlOX6TYS1hDXlxBO7BuJJlRgmQQfJKwgjl6k8ZjRCWAEaM1BOyu2HOWVOi7S/0hij6tXw6ni2pYlkZKHvh7RlkMAvLLA4psVZkeeYawaroQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750122; c=relaxed/simple;
	bh=pQk8ESl1g63Hj+rwQMm8HeI+unosXHImS2LDOMQt51o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7dGCIJIqtpTIKxwSR88WSwcMrcTNtLkE5QUTZhvbG0UjlUSb+gZyHdf0pWe15WcvPnirPJs63r44SX1/KVNRznjvJPGk1VNRN6a6g63dp7eWYgi5UNAay9dF5SZU5dKpMKcf0885vWRKC+VFqiJlmB4tPAy00MzpxlWnhjqiqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNwrEl2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNwrEl2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2E6C4CEE9;
	Tue, 20 May 2025 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750122;
	bh=pQk8ESl1g63Hj+rwQMm8HeI+unosXHImS2LDOMQt51o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNwrEl2w2gWCR/GDVRjUY7joUnnlEv8TGD3fRBRJTBvzAL4TFAeQ/kqXVz7A9yCr2
	 qcOk14LN/4LeKSet4TqT4nBFTeukjLnJOUtzzV0aSXzoIMyrS4UGWyyLb4J+SEYfiz
	 oW9Zx3r5TUB/0EfbrsqqrtM8j/hLgnlanPSEt5Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/143] nvme-pci: acquire cq_poll_lock in nvme_poll_irqdisable
Date: Tue, 20 May 2025 15:50:05 +0200
Message-ID: <20250520125812.015206782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 3d8932133dcecbd9bef1559533c1089601006f45 ]

We need to lock this queue for that condition because the timeout work
executes per-namespace and can poll the poll CQ.

Reported-by: Hannes Reinecke <hare@kernel.org>
Closes: https://lore.kernel.org/all/20240902130728.1999-1-hare@kernel.org/
Fixes: a0fa9647a54e ("NVMe: add blk polling support")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 504dc05380350..265b3608ae26e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1202,7 +1202,9 @@ static void nvme_poll_irqdisable(struct nvme_queue *nvmeq)
 	WARN_ON_ONCE(test_bit(NVMEQ_POLLED, &nvmeq->flags));
 
 	disable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+	spin_lock(&nvmeq->cq_poll_lock);
 	nvme_poll_cq(nvmeq, NULL);
+	spin_unlock(&nvmeq->cq_poll_lock);
 	enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
 }
 
-- 
2.39.5



