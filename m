Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7328F58;
	Mon,  4 Mar 2024 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588633; cv=none; b=WPs703vn4ugJOKjyj+cqHDK1l+haCAWzAZITwIWqcUufuCK1sThSYypAiEyhXfR0iPVL8cyKVUzRVzSB1Vw9XYOmYInCHZGJDSu97MttAyMSQhi85ObuxWwas3gLxdiu04GLEx7puyeWHQyn4ZezZfYyO4+WJMAUd/ZB/tWlTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588633; c=relaxed/simple;
	bh=VqZoIDudaLGZAIEp6XEONv5O5RJv/07zQKYVe+KEJl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDvMyUAR8l9g0nkMX+lFx4JKmmpWv0+Q4EaeggMnJQ2Txl8jjFAxb5tO6L6sJZQ4NeWDiWTmltzYlPPkgjXJiy+xCD03k7u9CGj1pIjCnzjrZOXlemoWejtI2srd7xTcxZ7tH68a4X2Xb+jLpqyJ8I8p4VrwVQEuTfZDP1RWJeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qodqHZ6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qodqHZ6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC5AC433C7;
	Mon,  4 Mar 2024 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588633;
	bh=VqZoIDudaLGZAIEp6XEONv5O5RJv/07zQKYVe+KEJl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qodqHZ6Du9drJarmNSl8mHpB7yLLAl8iKkmsgHW6rrv1OsSql7VGjGMbWbjOXm29j
	 4qt+4+3++IqhstG3PpJC1hTXspm7MuxMB/tpfdpeckH1E1zx7DMGCDU5Qp4G+XeNQP
	 gbTmowALGXEyDm2xmUW4nCAuSmBjZYRGPMqznPg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Miao Wang <shankerwangmiao@gmail.com>
Subject: [PATCH 6.1 037/215] veth: try harder when allocating queue memory
Date: Mon,  4 Mar 2024 21:21:40 +0000
Message-ID: <20240304211558.182557057@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dea9cc8c39f7a..dd9f5f1461921 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1359,7 +1359,8 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
+	priv->rq = kvcalloc(dev->num_rx_queues, sizeof(*priv->rq),
+			    GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!priv->rq)
 		return -ENOMEM;
 
@@ -1375,7 +1376,7 @@ static void veth_free_queues(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 
-	kfree(priv->rq);
+	kvfree(priv->rq);
 }
 
 static int veth_dev_init(struct net_device *dev)
-- 
2.43.0



