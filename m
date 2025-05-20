Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621D242D79;
	Tue, 20 May 2025 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750538; cv=none; b=b9dNA4SjuCzrHlreqnRgng6MPhBaCcSgtUo3lQBqSQd9bqKVXuSPobIKdjZ8dHN09AJIbgaAwEVngGNPYE/0jBYmwruTujNwAulZu6Cho3sFICNna7hv8qMjShYnzeRezVGw15Qt9ECKHCDIDTcSAaD1syWRU0cuqwwCbAoEm+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750538; c=relaxed/simple;
	bh=6WOQfei03eqs6iVpkDMt+a86L4ahhc3ZlPTI3jUMsfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o72JG6aomGiJEHX49Ts/PUWiDpns1eEAWvcoSg/eOt21Vp217RYe+9PibWaQmmfcqnqaswW2+u4D3DX96uc2H6kphApvQ/2/AfGp+0F0p4PeXZsK324oKrZe5JDHbCS+yS57TQHN1vaoaoh+7j2ZD+jprudY3EFKEuRipzxahYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvrK3NFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvrK3NFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDFDC4CEE9;
	Tue, 20 May 2025 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750537;
	bh=6WOQfei03eqs6iVpkDMt+a86L4ahhc3ZlPTI3jUMsfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvrK3NFqJ8hV8y+UbE9BxS9AygbFAYbz0uiYlDSsZm5GXg9e1W0fHhOGS51zTsN/g
	 Zkx6DAJd6fjhTc+m6D4u610BBYji6boVvagwXeF7zEBqbexHZCwGflt/XUfdnWffjD
	 SD0iwVcEv3nxlRXkKGH8c+GC09Bcznzdi/AacL/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 039/145] nvme-pci: acquire cq_poll_lock in nvme_poll_irqdisable
Date: Tue, 20 May 2025 15:50:09 +0200
Message-ID: <20250520125812.096530765@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7fdf7f24d46e6..00bd21b5c641e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1205,7 +1205,9 @@ static void nvme_poll_irqdisable(struct nvme_queue *nvmeq)
 	WARN_ON_ONCE(test_bit(NVMEQ_POLLED, &nvmeq->flags));
 
 	disable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+	spin_lock(&nvmeq->cq_poll_lock);
 	nvme_poll_cq(nvmeq, NULL);
+	spin_unlock(&nvmeq->cq_poll_lock);
 	enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
 }
 
-- 
2.39.5



