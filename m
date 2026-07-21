Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86983449B1C;
	Tue, 21 Jul 2026 19:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663016; cv=none; b=NUTWA6VUl09t/6E5TgJ8cPmdVWdTJeR1xbor9xLRqn2+uqKg40L9iQEHqU1tKftgYAP0Et1yNzvUMt85zGoJHYLlDq287zAfG9MH0Ar+mTAL7UTVjBbqsWMXV9oCNy2E4U4WSll+ManbC1Q/I9MrN2Ocost5/JmvcExk1K7rns4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663016; c=relaxed/simple;
	bh=wK9CCPzxuOML3v1/0abziLSSt1ECi8bX5H+SWFxBze8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulKN6axp+3CYzUKSkogVU/fsavTNyYthSaS1c0RPdNiOZJ1HTkP8bMYRk5rARcDW2ExtWRs8/Rr6DtS9LigxKfWmVYkncrwzz0FxRqP27+Cw94AXkxW1LObsuv2G+CRKf8Y/0xPwA0FWc5R6Wc5EqwtgHWKloMuRJWJYl7i0tLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kH9heF8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kH9heF8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFBF1F000E9;
	Tue, 21 Jul 2026 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663014;
	bh=FrU6SNEMhARrkArcxvOB66kYMGlUze47iebd5ekAT/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kH9heF8XZH9PysWSJlT1KIqiJFNZfzc5UUPL363tJrvlZgUHrrGb5iNtT2eDzEx22
	 rhrUO0ugMGuOzPT93lyT3xUubRBV1CDAOV2Fiw6vy9wHSj9VnYCFxFiiyIBNo3j0B2
	 uV94Q/vUc63Cr9D+VULBvxIxAmweOJGwgGOQKXKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0663/1276] rtnetlink: Define rtnl_net_trylock().
Date: Tue, 21 Jul 2026 17:18:26 +0200
Message-ID: <20260721152500.942407757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d1c81818aa227b37d65b40f9883109c5256b9bfb ]

We will need the per-netns version of rtnl_trylock().

rtnl_net_trylock() calls __rtnl_net_lock() only when rtnl_trylock()
successfully holds RTNL.

When RTNL is removed, we will use mutex_trylock() for per-netns RTNL.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 17dc3b245de4 ("ipv6: fix missing notification for ignore_routes_with_linkdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h |  6 ++++++
 net/core/rtnetlink.c      | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 465ea34c9210de..ce7dba157e0128 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -104,6 +104,7 @@ void __rtnl_net_lock(struct net *net);
 void __rtnl_net_unlock(struct net *net);
 void rtnl_net_lock(struct net *net);
 void rtnl_net_unlock(struct net *net);
+int rtnl_net_trylock(struct net *net);
 int rtnl_net_lock_cmp_fn(const struct lockdep_map *a, const struct lockdep_map *b);
 
 bool rtnl_net_is_locked(struct net *net);
@@ -135,6 +136,11 @@ static inline void rtnl_net_unlock(struct net *net)
 	rtnl_unlock();
 }
 
+static inline int rtnl_net_trylock(struct net *net)
+{
+	return rtnl_trylock();
+}
+
 static inline void ASSERT_RTNL_NET(struct net *net)
 {
 	ASSERT_RTNL();
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4df35e2d988f53..625f273aeeedc5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -210,6 +210,17 @@ void rtnl_net_unlock(struct net *net)
 }
 EXPORT_SYMBOL(rtnl_net_unlock);
 
+int rtnl_net_trylock(struct net *net)
+{
+	int ret = rtnl_trylock();
+
+	if (ret)
+		__rtnl_net_lock(net);
+
+	return ret;
+}
+EXPORT_SYMBOL(rtnl_net_trylock);
+
 static int rtnl_net_cmp_locks(const struct net *net_a, const struct net *net_b)
 {
 	if (net_eq(net_a, net_b))
-- 
2.53.0



