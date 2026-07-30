Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0047A4432F2;
	Thu, 30 Jul 2026 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421280; cv=none; b=LuxQPSkzVHmHYNn4bDJqopwdeecfDxumZmn9y4TaXcESToiiA64/jIJRv9t37kGb56y1+IEFPKAJOro/FsJnhcnQT2nXXGfi4VW8uwFpNbKVXcOUdw0yde0qgqLthHZtI8DaXHjqAnmnEV82wZCWM/1r1c2t7FgbvQHCjeZO3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421280; c=relaxed/simple;
	bh=oDzZBnq0yiQ34VTvGMq34ZXQD0tMEKUXbdLaJxrGzuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Awpf84zt359x36hCjgS5mIrVf9cUPPTu0fEjaK+qwns3dWNswhUi48H+JJZjwiMbeR12zTkW/POoif6fVvkyO3W0n7q5dmJljUXuN57yzH32aaxNaPWOITHGMB9VcH5vS4o5XLkGHPzYMlV+MjoQV9vpyU4utNqyaMOGgmUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgCIEAeg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgCIEAeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B281F00A3D;
	Thu, 30 Jul 2026 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421275;
	bh=rrttdiGxTMdNkLBM7/5KD0BxuzZfc8tDKpcLwYc6PVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgCIEAegNlQ3t3x68weShBE5Hu6E4hjPJzFHBPSfRzMuPIDbJKxh65CNEMJ9c2NAq
	 h01XAmduN/Ak+BnEQn3zBr0pk0aiNN7DknsaG01CnVfmqKCxRBJ1y9TtjVtqHL5hzT
	 5nm586Jm8DI1Ec0Tqlf5BoU6mn1xlsVNGRDqUtdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Gerlitz <ogerlitz@ddn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 032/744] RDMA/cma: Fix hardware address comparison length in netevent callback
Date: Thu, 30 Jul 2026 16:05:05 +0200
Message-ID: <20260730141444.965990116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@ddn.com>

[ Upstream commit 18313833e2c6de222a4f6c072da759d0d5888528 ]

The cited commit hardcoded the hardware address comparison len to ETH_ALEN.

This breaks IPoIB, which uses 20-byte addresses. By truncating the
memcmp, the CMA may incorrectly assume the target address is
unchanged and fails to abort the stalled connection.

Fix this by replacing ETH_ALEN with the dynamic neigh->dev->addr_len
to correctly evaluate the full address regardless of the link layer.

Fixes: 925d046e7e52 ("RDMA/core: Add a netevent notifier to cma")
Signed-off-by: Or Gerlitz <ogerlitz@ddn.com>
Link: https://patch.msgid.link/20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9480d1a51c116e..e88d3efb967b3b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5270,7 +5270,7 @@ static int cma_netevent_callback(struct notifier_block *self,
 
 	list_for_each_entry(current_id, &ips_node->id_list, id_list_entry) {
 		if (!memcmp(current_id->id.route.addr.dev_addr.dst_dev_addr,
-			   neigh->ha, ETH_ALEN))
+			   neigh->ha, neigh->dev->addr_len))
 			continue;
 		cma_id_get(current_id);
 		if (!queue_work(cma_wq, &current_id->id.net_work))
-- 
2.53.0



