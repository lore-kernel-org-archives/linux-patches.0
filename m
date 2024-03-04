Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5631C6AB;
	Mon,  4 Mar 2024 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588203; cv=none; b=ECKe8IYSCRJzv0tFbwq8OAoEi/D0WgjVf+mZ2h2m5YkIELED+DE1raR7wH5WRzRt2hc6PafyoKVoovDrv3SCEF3kXVRKE9tJAYuj1KyKnkYIF+RpLnVJrzFfSR1i7QqjpfYmP96mqUl+hTMRj/WYxO/hcGzTn4Wj3Pxguk/zaD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588203; c=relaxed/simple;
	bh=hP3mDjQ2Mc7EY5MQT5scT/U8YQ0ACpq0HGXENBEOjGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMGmzBiG3XJpHlRNbmr21/nnXcpEpWQyg3J5KTORr3hPyhZ5PPxqktUYncPsp8yF0Pv2VZUd4G/fSTbBf/byT9QN1y6AdAbzG+ukWD3ZWp/tuIgnBrmo2h1cN5KM5yqrB50yuUjvyS454BVBkI4FXZFKumAf7m8LeqWHFBS2pwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh02cHOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh02cHOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA5BC433C7;
	Mon,  4 Mar 2024 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588203;
	bh=hP3mDjQ2Mc7EY5MQT5scT/U8YQ0ACpq0HGXENBEOjGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh02cHOSS2sip+0KAIei6VeT+zT6sa17V4dajJUSUBh7iUt8cs9kgRzgrmNK13JgA
	 ko7pbhZWA9qGDd+YliGfKvMUVJ9z882bMl0XUR4k3J1CTHY3FnidQfZbXxb6K4AMUt
	 erSEyxKFa3pE1mByMR/8eCIve9eTaUWJh7y37ZRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Miao Wang <shankerwangmiao@gmail.com>
Subject: [PATCH 6.6 018/143] veth: try harder when allocating queue memory
Date: Mon,  4 Mar 2024 21:22:18 +0000
Message-ID: <20240304211550.518950738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b32b0ff829ed5..0ae90702e7f84 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1453,7 +1453,8 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
+	priv->rq = kvcalloc(dev->num_rx_queues, sizeof(*priv->rq),
+			    GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!priv->rq)
 		return -ENOMEM;
 
@@ -1469,7 +1470,7 @@ static void veth_free_queues(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 
-	kfree(priv->rq);
+	kvfree(priv->rq);
 }
 
 static int veth_dev_init(struct net_device *dev)
-- 
2.43.0



