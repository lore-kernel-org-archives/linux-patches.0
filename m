Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B863FE343;
	Wed, 20 May 2026 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302708; cv=none; b=SMVOr3lOlU9WQUaHnWIed8Irjhw7iCN+VZzQRsdFqDQwdWznvGgCW3aGOKXVF59M9qZo9TyEDz5xZpNl6Z7OVcOZlOTv8i10Yp278WfchvoACqxHCFOZCVCfojcW797NZqsd6R8pdhHgGDCQdrZvxMplCQLkzmWK1c879Z5ZkD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302708; c=relaxed/simple;
	bh=W6trpqwm6n1bT4MvgPFRR8Tww7hUkvQGDuUb2sMX6Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3notRa1RBn7dULSwkx7fgcSjnjXTUw3Yd3bo7X/GP/MPH2NCzyygQVbgwOfUGL8lC0it9D0LKOH3AXif+EypT2J87MQCItO2xytRoTJJ37UCH0F8jm+NDNvy+Q0VowJ9etSFSDm2jOPPCS0qITpaLFgZCl2crQZBhzqt4NFvs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnJuwHal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnJuwHal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5271F000E9;
	Wed, 20 May 2026 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302706;
	bh=3+lom519z0+6ZHhG7vP4TlqmRuDT8jleZpFxn2mFtxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnJuwHal/++n8jDSkNF6ZNzUVH9VbVDvTUhDQXPJfIFqqX5wY1qDOmwiD/IMdzeUI
	 Bn32j4R9biTa3N8Eo5jBUrojbQ0PVjYI3FD2epl1MMyHmXRqShPnRw8Ll67IT5kY8J
	 /YtnWVbqPjCBG35RWVZUdwkMqeC1BGwrMaNx3kBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/508] nvme-pci: fix missed admin queue sq doorbell write
Date: Wed, 20 May 2026 18:23:12 +0200
Message-ID: <20260520162106.622521445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

[ Upstream commit 1cc4cdae2a3b7730d462d69e30f213fd2efe7807 ]

We can batch admin commands submitted through io_uring_cmd passthrough,
which means bd->last may be false and skips the doorbell write to
aggregate multiple commands per write. If a subsequent command can't be
dispatched for whatever reason, we have to provide the blk-mq ops'
commit_rqs callback in order to ensure we properly update the doorbell.

Fixes: 58e5bdeb9c2b ("nvme: enable uring-passthrough for admin commands")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 40d9be6468b5e..87d30aaa35f10 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1715,6 +1715,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
+	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_admin_init_hctx,
 	.init_request	= nvme_pci_init_request,
 	.timeout	= nvme_timeout,
-- 
2.53.0



