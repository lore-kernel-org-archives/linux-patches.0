Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45481E503C;
	Wed, 19 Feb 2025 08:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955269; cv=none; b=eyueo2klnDSFArXQ+jFrzGJGwbX7XFwSGvhKZVl1QBJdl/Iw/A1KrQrRZm4GGoqR3fY+HdCszf0adWsox0DLISirHok/UjKuO9Blr81B8TUunLMAL+PETTVTHn4vm2GBTApGbTZ4jbfxEqZkSzOqXnN0fLVUppnHEpFZ1krV4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955269; c=relaxed/simple;
	bh=QSn7woUF3uHlqNsyDO8lOCX/SXyRPMbVRUl7XbXeUnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrLItn8qzl5ZhKct5gRmYhAzU9X/WeV6hc7Cg3lDnSu3NcB3Wx53dDpupTk+OJcrQhY8MKu887wV1kHuK1noq46zyxLGJ0IbHGGv+bTuIeyeWCq413uiTRzRon7gTofhDy9HnU8XjZmMq7PArA7QNni2OiYxwkmUfF15IAghsII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWG2/ArH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWG2/ArH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361EBC4CED1;
	Wed, 19 Feb 2025 08:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955269;
	bh=QSn7woUF3uHlqNsyDO8lOCX/SXyRPMbVRUl7XbXeUnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWG2/ArHHMd5Owa/shADAOhwQE7Q7BmKlkUoPwDq59rFA82QArmfC6I1kYy24JiF3
	 L3TtgLgTah9HfP4jrifMyLw7wJ7WECpkzER81VTZ5PHivXGhHRexmK5q41H6YU+fEH
	 k75++EyO2sTaJiup7nlni0MPdD0jmlJa80sgh1sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/230] net: add dev_net_rcu() helper
Date: Wed, 19 Feb 2025 09:28:21 +0100
Message-ID: <20250219082608.898100879@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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
index 02d3bafebbe77..4f17b786828af 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2577,6 +2577,12 @@ struct net *dev_net(const struct net_device *dev)
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
index 9398c8f499536..da93873df4dbd 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -387,7 +387,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
-static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+static inline struct net *read_pnet_rcu(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
 	return rcu_dereference(pnet->net);
-- 
2.39.5



