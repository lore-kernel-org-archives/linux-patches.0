Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA501C5D72;
	Tue, 26 Aug 2025 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213664; cv=none; b=U7vCG/2DdnSOuQlmKecehH+rP54+dZQhTNNHTbJoGdOLHpRlBSEXq9Q+X4622tG2FySpGSBfYTE9ja4hVonb/UmiU2dKJvnS+uTSIlmYYggssJCohxENy00wnfgd+e3opviYz/c6iqeuSfMyRP1kzHZ28VQLjDtUdE2aSeXl6fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213664; c=relaxed/simple;
	bh=H+j0nAxqi3Abc2oZMLm//XWa4gFuL7byT6Q+rS/+WKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHwCIJuz+6b2Lw80LGn63TmRjYwFDW3DKS3dT0bbbJcZ1cFM4TQ6ga4Np9Ifo6l0fCU3D4QBE9M9TZnglZdwCproczTmJlsCnMxlio5QEsBKlStH9iHL24QktUnfBFv26JdUIDd8MJJzw3m8zDSDLSrJ/7tJlTbIpeFLQ56X2Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1neuiODV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1neuiODV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F6BC4CEF1;
	Tue, 26 Aug 2025 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213662;
	bh=H+j0nAxqi3Abc2oZMLm//XWa4gFuL7byT6Q+rS/+WKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1neuiODVo1nyXBOq8L6R2RnoysWPaevqK8FxKgq/wR67tiQarmHzX+TgJnnZVFElw
	 gKqV9bMfD5cWM6BCvaKs9ANMH7ZjBQBwL9eRW8BuJizvzxLgNxG4SYLiN+ABNcr89U
	 T3Fi4NO8G+a+FD+ilzagOec8K8JFpDSuRYI9KW0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 432/587] net: Add net_passive_inc() and net_passive_dec().
Date: Tue, 26 Aug 2025 13:09:41 +0200
Message-ID: <20250826111003.935147127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e57a6320215c3967f51ab0edeff87db2095440e4 ]

net_drop_ns() is NULL when CONFIG_NET_NS is disabled.

The next patch introduces a function that increments
and decrements net->passive.

As a prep, let's rename and export net_free() to
net_passive_dec() and add net_passive_inc().

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/CANn89i+oUCt2VGvrbrweniTendZFEh+nwS=uonc004-aPkWy-Q@mail.gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250217191129.19967-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 59b33fab4ca4 ("smb: client: fix netns refcount leak after net_passive changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/net_namespace.h |   16 ++++++++++++++++
 net/core/net_namespace.c    |    8 ++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -293,6 +293,7 @@ static inline int check_net(const struct
 }
 
 void net_drop_ns(void *);
+void net_passive_dec(struct net *net);
 
 #else
 
@@ -322,8 +323,23 @@ static inline int check_net(const struct
 }
 
 #define net_drop_ns NULL
+
+static inline void net_passive_dec(struct net *net)
+{
+	refcount_dec(&net->passive);
+}
 #endif
 
+static inline void net_passive_inc(struct net *net)
+{
+	refcount_inc(&net->passive);
+}
+
+/* Returns true if the netns initialization is completed successfully */
+static inline bool net_initialized(const struct net *net)
+{
+	return READ_ONCE(net->list.next);
+}
 
 static inline void __netns_tracker_alloc(struct net *net,
 					 netns_tracker *tracker,
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -467,7 +467,7 @@ static void net_complete_free(void)
 
 }
 
-static void net_free(struct net *net)
+void net_passive_dec(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
@@ -485,7 +485,7 @@ void net_drop_ns(void *p)
 	struct net *net = (struct net *)p;
 
 	if (net)
-		net_free(net);
+		net_passive_dec(net);
 }
 
 struct net *copy_net_ns(unsigned long flags,
@@ -527,7 +527,7 @@ put_userns:
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(user_ns);
-		net_free(net);
+		net_passive_dec(net);
 dec_ucounts:
 		dec_net_namespaces(ucounts);
 		return ERR_PTR(rv);
@@ -672,7 +672,7 @@ static void cleanup_net(struct work_stru
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(net->user_ns);
-		net_free(net);
+		net_passive_dec(net);
 	}
 }
 


