Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05A1C701E;
	Wed, 19 Feb 2025 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955845; cv=none; b=sqedjEHLDF4YM1DpBI1B68UskZtJZrK509slWbIrO1Ku/5R9RQfY0ZCnBTrugALgwXEB1/Y8KaJpGHlQvQjUXFA6k1QBPlWZwvGEevUXsvoK2a4oNhk5CJaRMN9gstN1oudbcW4z0EGOp+fJaH3cfkljiyn/fTPaG/B2vu2AHf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955845; c=relaxed/simple;
	bh=mJcBgy63Z1X/vF6rYz+qkzZ2YPwKhJEN7ZPxnheDqqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHvzBGCqMd4yo24Vb0HHBGJzdEZJNVZUHdviW71Lu4TZ0ERYPPu91K0R9pcwrA0zmRMOQNPVYWjuOU1+iuBig+KCJlyJ9zXsYfd3xf6sK+P3mUok2jGgijzPx6MAt2pO5RMtIuPA6zxWC8OG1FxUppNI3vYkfnutDSRYxq3ntPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHnvCeFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHnvCeFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E92EC4CED1;
	Wed, 19 Feb 2025 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955845;
	bh=mJcBgy63Z1X/vF6rYz+qkzZ2YPwKhJEN7ZPxnheDqqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHnvCeFA3bWDhyTotnZ8ui/TqFUj0iBBjD/5bD0Cq6jgWrcc26LNInTrx2lIEFpAy
	 /jmTKJ40kpzeae5ppPn5J85XBEfjbQL8CiwHD8fZ/uSsswVAhtrrwMdO8FMfi5OYTh
	 Ar5eSZEWfM1gKCtAk0YCHrf9k/hGbi+tvhWYnEbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/152] net: add dev_net_rcu() helper
Date: Wed, 19 Feb 2025 09:28:34 +0100
Message-ID: <20250219082554.054298041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 482ad2a4ace2740ca0ff1cbc8f3c7f862f3ab507 ]

dev->nd_net can change, readers should either
use rcu_read_lock() or RTNL.

We currently use a generic helper, dev_net() with
no debugging support. We probably have many hidden bugs.

Add dev_net_rcu() helper for callers using rcu_read_lock()
protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 71b8471c93fa ("ipv4: use RCU protection in ipv4_default_advmss()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   | 6 ++++++
 include/net/net_namespace.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8b5121eb8757e..95ee88dfe0b9c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2593,6 +2593,12 @@ struct net *dev_net(const struct net_device *dev)
 	return read_pnet(&dev->nd_net);
 }
 
+static inline
+struct net *dev_net_rcu(const struct net_device *dev)
+{
+	return read_pnet_rcu(&dev->nd_net);
+}
+
 static inline
 void dev_net_set(struct net_device *dev, struct net *net)
 {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index b767bdcd9e122..ce3f84c6eb8eb 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -389,7 +389,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
-static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+static inline struct net *read_pnet_rcu(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
 	return rcu_dereference(pnet->net);
-- 
2.39.5



