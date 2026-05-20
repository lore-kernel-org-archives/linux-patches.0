Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB763F23BF;
	Wed, 20 May 2026 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299378; cv=none; b=C7vRJ2yj1ZikV91WfOt1Wa42WYRfisayGK7qS/ypoPmayr3nEs6O1KXOhJ+TPZ64DmXpbSsrkPY0wEQoc5YmaQ07EhNQKYFGP8w7eH2Q68MGDoDWWrZLDoR7lk+2mz2cfDJX68hEW14/WatxnnLS238bgY8gwONPIEfzgdu6oBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299378; c=relaxed/simple;
	bh=y3fO4MaX/J861YGfNODgG5Bifw8qwvRVSmphWrViiRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2XdYoBzhFYh2pQnAM/1oDVJls+l5qF6uxPmlabn2VGEgI2NOJXw0hWONxTv7mLSk0liFEqTlXiCZTP9yGwUEfTqR40A84oCoscZhdXXavVJTWLII3P/QVtJ+BuJvdGigMnvN6//tVNTJW4qoLOGiK3kZFk4pLKNDo1PD20GZyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtfabWoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtfabWoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4791F000E9;
	Wed, 20 May 2026 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299376;
	bh=XDO4RfWNeqmp29jzfEeaY6fzRxchiFL+D1saMMB36j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtfabWoMdt1TYeh/DQHAp7rtQz2HyPgBFt7CkiEhxSGOhqOxgo04gs21SsadgiEjj
	 p4B5IzOjLO5yu6BcJD6XjzFhbQrmmTdpbx+4SHLhM6fqL93Uiu1SZvR6SOpeILH66j
	 4nN8MYDwPkrPR63yl3/xsMOvTe36L9D/P0UcB2zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 747/957] nvme-pci: fix missed admin queue sq doorbell write
Date: Wed, 20 May 2026 18:20:30 +0200
Message-ID: <20260520162150.762068202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8875855e45352..2e32242bed67c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2028,6 +2028,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
+	.commit_rqs	= nvme_commit_rqs,
 	.init_hctx	= nvme_admin_init_hctx,
 	.init_request	= nvme_pci_init_request,
 	.timeout	= nvme_timeout,
-- 
2.53.0



