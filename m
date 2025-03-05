Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032BB25332F;
	Wed,  5 Mar 2025 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198443; cv=none; b=TW3EHerOAq4D+UzY+hj1ktzmFqgnOKjEF6QwGdqj3HZazLsXZv8vCZ/51BDh417Dfa7gVs+r+MQN1yJ8ylare3ZZhWTwDf5G6yVq7q6Eul3ZgaMWj7Pf/MI4R9vVyGC6q1q5Gh+ZTm+GDOdIGy6unDkl0t8L9sQ0fOpzQJdWe04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198443; c=relaxed/simple;
	bh=RIZD4ikEr7FTYH2WTOnS3VSF5oZG1rx2aDw9UA1A3e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go/mllgDkPh5x5OMkAijvDMug3SkNy/vdZJN2lJk9P3pGNCl7NxzKxFUA+mJwO2OLtBAKJ0/iPOjDRsjTlqM8ift4Z1FzcT2ZSDxE3GAOiwiECL8qScsUKuehP9CKbuU8EazQyn2BHswPevjgKej4b1Vcw9pZyFdr3QY2QKSu0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJzG+asH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJzG+asH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE54C4CEE0;
	Wed,  5 Mar 2025 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198442;
	bh=RIZD4ikEr7FTYH2WTOnS3VSF5oZG1rx2aDw9UA1A3e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJzG+asHHt3HKmwzu5K73+OvtdbuVipMlBxnL2nKgn2SgDzYrU1aWxsyHazoPPSHV
	 rL50sVMzxd+t1zDGJ05cid9SGu9J0pk3SnQBqLerB1RTvrysoVL2+HCIyliCmiJhwe
	 QZ02AC3K37zUfH+QyBhKe3PRnNDYu3sqtaepIV0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/157] net: Add net_passive_inc() and net_passive_dec().
Date: Wed,  5 Mar 2025 18:47:46 +0100
Message-ID: <20250305174506.504389748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 5c70eb5c593d ("net: better track kernel sockets lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h | 11 +++++++++++
 net/core/net_namespace.c    |  8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 44be742cf4d60..47181fd749b25 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -295,6 +295,7 @@ static inline int check_net(const struct net *net)
 }
 
 void net_drop_ns(void *);
+void net_passive_dec(struct net *net);
 
 #else
 
@@ -324,8 +325,18 @@ static inline int check_net(const struct net *net)
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
 /* Returns true if the netns initialization is completed successfully */
 static inline bool net_initialized(const struct net *net)
 {
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b5cd3ae4f04cf..b71aa96eeee23 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -464,7 +464,7 @@ static void net_complete_free(void)
 
 }
 
-static void net_free(struct net *net)
+void net_passive_dec(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
@@ -482,7 +482,7 @@ void net_drop_ns(void *p)
 	struct net *net = (struct net *)p;
 
 	if (net)
-		net_free(net);
+		net_passive_dec(net);
 }
 
 struct net *copy_net_ns(unsigned long flags,
@@ -523,7 +523,7 @@ struct net *copy_net_ns(unsigned long flags,
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(user_ns);
-		net_free(net);
+		net_passive_dec(net);
 dec_ucounts:
 		dec_net_namespaces(ucounts);
 		return ERR_PTR(rv);
@@ -668,7 +668,7 @@ static void cleanup_net(struct work_struct *work)
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(net->user_ns);
-		net_free(net);
+		net_passive_dec(net);
 	}
 }
 
-- 
2.39.5



