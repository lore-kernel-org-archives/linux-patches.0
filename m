Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0132B116;
	Thu, 30 Jul 2026 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423453; cv=none; b=WnYl4RToCjzX8nnSkyEc2y3WWt3NvYZCUpP5Xk0K/yiwTReNcrfmZzDbrHCMcvHe6ndoaPiWd/osuyNyvXn/rrm0WLsVWQuTQxGh5x8eVs68Aw2CX9WucWs/HtdU6uzGUv5EGw58U/DTotRU/81Ycd6IB+GJ8LiyaWQkWIF88Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423453; c=relaxed/simple;
	bh=Q46145Ys0BXOVkgfT5D48WpfHFd05ROTi/esVQguS/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4IWLiyOV73+dYIRhbivEXlhUq38zq+7TO83svoNDeNvG+FhO+wm0124GAMc/+l0V7iQOSJY3uN6/KdeEFrQdJ03qzoyO0yZELxkQEUaVIOXEjSAeQxyn6rEUuvSc8Q4VR7qrfhcuweMQ1wKSk5/Y6xWOzGse5L13MaJLR+87DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMQ4hVdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMQ4hVdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262591F000E9;
	Thu, 30 Jul 2026 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423452;
	bh=4rSluEzpgoQMaLN27fdYV7xwlIiorn/CrYOo1KttVUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMQ4hVdPLhinhUN0pwf4IHpteuOfeNnpUJbktnBSuCfdheCwBC8sEsMr6+z5k21Pa
	 f/GYdy8C8F3POxbzU2aSUGzfqvQKsWCObAvNQoAP2GRir8xqDTlvoV7xq7De1wDEwS
	 YtkEe7ObrMz3GRm/vVZL10o1sg73AQK5dAlVTIdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Gerlitz <ogerlitz@ddn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/675] RDMA/cma: Fix hardware address comparison length in netevent callback
Date: Thu, 30 Jul 2026 16:06:19 +0200
Message-ID: <20260730141446.161443686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index ce511800b056cf..648acc2222cf54 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5237,7 +5237,7 @@ static int cma_netevent_callback(struct notifier_block *self,
 
 	list_for_each_entry(current_id, &ips_node->id_list, id_list_entry) {
 		if (!memcmp(current_id->id.route.addr.dev_addr.dst_dev_addr,
-			   neigh->ha, ETH_ALEN))
+			   neigh->ha, neigh->dev->addr_len))
 			continue;
 		cma_id_get(current_id);
 		if (!queue_work(cma_wq, &current_id->id.net_work))
-- 
2.53.0



