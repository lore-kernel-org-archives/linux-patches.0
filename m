Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE7200D4;
	Mon,  4 Mar 2024 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587604; cv=none; b=b/lyVgUg/k4PP2Yz+iT+qXUoH1kytjdR5odFJ2NEsnZZF/KJZ7VslglD5Ox9fITz678Y1UPiL/xusv6psrSm5GcMws600U4Sve8jbfg497qa8HoTtHPMoMjh0uC4oyLNuz2Ku6VeBkedmpDv5/vjhram+nB22uIdmshXRFXI4CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587604; c=relaxed/simple;
	bh=tRpIl2UMPoC2W9unTi5rY3ijblDsmacxkULzbpV9cQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y693/Ug34fDM6AJoBfNEgVaVGeaazI4PlwbM+JbjArpWUA4BhTIF/wUqm78USJHnNKx2xje6/ImxuNSxRdzH8GbP598cZx2aPV2m5HW5sYS6AFMWiNWC+ncLGSR63gwsP0uHS/tXovyRbIYVngtAr/P5RWCV2X4eS0twWVVKBMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfuKCQ8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfuKCQ8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4A0C433F1;
	Mon,  4 Mar 2024 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587604;
	bh=tRpIl2UMPoC2W9unTi5rY3ijblDsmacxkULzbpV9cQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfuKCQ8xWkJ4ZYTQ6xdxGEsFzKhmJkAZU2WmpiyomaHZQZSkFXlvvtmW7X1I42Uj8
	 wRcCJEWi5wKLZy8zKSvaOijT56UfRNpNwmdPcPkwmhW0585sipTcfFVCzbltZYJnMk
	 i07jj+ywuFLXx9B4IGBJPKda9VyxKHF9zTa7lzlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Miao Wang <shankerwangmiao@gmail.com>
Subject: [PATCH 6.7 020/162] veth: try harder when allocating queue memory
Date: Mon,  4 Mar 2024 21:21:25 +0000
Message-ID: <20240304211552.479177870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1ce7d306ea63f3e379557c79abd88052e0483813 ]

struct veth_rq is pretty large, 832B total without debug
options enabled. Since commit under Fixes we try to pre-allocate
enough queues for every possible CPU. Miao Wang reports that
this may lead to order-5 allocations which will fail in production.

Let the allocation fallback to vmalloc() and try harder.
These are the same flags we pass to netdev queue allocation.

Reported-and-tested-by: Miao Wang <shankerwangmiao@gmail.com>
Fixes: 9d3684c24a52 ("veth: create by default nr_possible_cpus queues")
Link: https://lore.kernel.org/all/5F52CAE2-2FB7-4712-95F1-3312FBBFA8DD@gmail.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240223235908.693010-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bf4da315ae01c..a2e80278eb2f9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1461,7 +1461,8 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
+	priv->rq = kvcalloc(dev->num_rx_queues, sizeof(*priv->rq),
+			    GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!priv->rq)
 		return -ENOMEM;
 
@@ -1477,7 +1478,7 @@ static void veth_free_queues(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 
-	kfree(priv->rq);
+	kvfree(priv->rq);
 }
 
 static int veth_dev_init(struct net_device *dev)
-- 
2.43.0



