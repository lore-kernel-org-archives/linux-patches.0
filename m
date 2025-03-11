Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9D25E83D;
	Tue, 11 Mar 2025 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707167; cv=none; b=CjTHQl+eFwS4kcEY1fcliRw77Girngo/QhIjyUKJSYa8OwlcPrgBEFaqMX4v8NZqAPSpA/8MSpGgLg9I3wD07vlExv3Hk/GLwLQWlftwc5s6ikh+Xpp44E9ssux/2AKQp342a6+/ejLbQ/eCitntxUODZSUq2q3kX6/Ev1jWkqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707167; c=relaxed/simple;
	bh=f40xovVfBbbhJAI3REqYX9yLuEQeQSYBIaa7Ul/GnJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvp/gzma2fn/jOrxkIb6jme+4XfltnxCs85KTnB1njxCFAcp/U+92QvBT8nP8J4kplk1RvQECu6Pty1oxjz9Oc6cxu3KquCm9aq5RN7jFnwOCPCpe1uEr1QHb1sPM7CKv7enyzTWbnY2RdvpwD940ZVU4XkspkWpFct5kQylz1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiogYcV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiogYcV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC75C4CEE9;
	Tue, 11 Mar 2025 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707167;
	bh=f40xovVfBbbhJAI3REqYX9yLuEQeQSYBIaa7Ul/GnJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiogYcV5H02lolBG8zPyLBFWupQVbyul4s81UgHaAQPpvX1drWgWgN5B7idKwJvgL
	 /jE1OM7K204e+twYJ6wlA7umQH/+f4HxXlHm3+G4Q3M4PYeoi4xefEIirVroFedJYL
	 0jljGjPhinGcMZMIi+zfV04qkOBKIBJUAOVE+nHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/462] net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()
Date: Tue, 11 Mar 2025 15:59:05 +0100
Message-ID: <20250311145809.390118783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2034d90ae41ae93e30d492ebcf1f06f97a9cfba6 ]

Make the net pointer stored in possible_net_t structure annotated as
an RCU pointer. Change the access helpers to treat it as such.
Introduce read_pnet_rcu() helper to allow caller to dereference
the net pointer under RCU read lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dd205fcc33d9 ("ipv4: use RCU protection in rt_is_expired()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index c41e922fdd97e..0dfcf2f0ef62a 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -320,21 +320,30 @@ static inline int check_net(const struct net *net)
 
 typedef struct {
 #ifdef CONFIG_NET_NS
-	struct net *net;
+	struct net __rcu *net;
 #endif
 } possible_net_t;
 
 static inline void write_pnet(possible_net_t *pnet, struct net *net)
 {
 #ifdef CONFIG_NET_NS
-	pnet->net = net;
+	rcu_assign_pointer(pnet->net, net);
 #endif
 }
 
 static inline struct net *read_pnet(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
-	return pnet->net;
+	return rcu_dereference_protected(pnet->net, true);
+#else
+	return &init_net;
+#endif
+}
+
+static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+{
+#ifdef CONFIG_NET_NS
+	return rcu_dereference(pnet->net);
 #else
 	return &init_net;
 #endif
-- 
2.39.5



