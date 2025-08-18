Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5821DED52;
	Mon, 18 Aug 2025 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522812; cv=none; b=VFU36Rn8w7ZDq4J0CUhv8N1s9ixo1aOigifGUdM06p8wVm3mjAk7bgkxRVSP8iKsZTkPqpDUd4bCPIGX1vXb5k295xiusyZQL7cPpDe7kRCetEm1+Q5F47uSuOrPz9pK1sySPkLbYUwdSPhwB6EgYIH7+pYpDgNBhFFoe0mawU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522812; c=relaxed/simple;
	bh=qhm8uwkUkCUumNgaHH94RwYFxdehaUbR8vsnrN39knc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gP5fkDMl31zdO05MXUjfamai+gfgUhVEEy95Uks4AkCzxjc+oiFvQDy+8+yKg4VUcittEYaUt8c9mOIQj41IlAUef4NiWyuf+IRvKA0B+yTbsatlDf4trzr9i9j5XX3ET7HWD9Jh2GGgKC+qd2xX07XFxy6j7ncSeCSgIFIKzWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJ4Yq2ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJ4Yq2ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD0DC4CEEB;
	Mon, 18 Aug 2025 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522811;
	bh=qhm8uwkUkCUumNgaHH94RwYFxdehaUbR8vsnrN39knc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJ4Yq2ovf22LowsCE5i+vWX/NhwA9L2XmEr0sf+q5gbxOm9L7aGapr3Nu61vy+gew
	 VuZNuzVSMGOtrokl0erfZaLoTk47CPVvWKRS7TSNQ6y1NTY6fa8OmfYfUNFjxNzGpT
	 UwNLNU6bpX7UqwEqb1hqGTZ9RYkoSkxPN/+vikE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/444] net: Add net_passive_inc() and net_passive_dec().
Date: Mon, 18 Aug 2025 14:47:33 +0200
Message-ID: <20250818124504.959779162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
@@ -291,6 +291,7 @@ static inline int check_net(const struct
 }
 
 void net_drop_ns(void *);
+void net_passive_dec(struct net *net);
 
 #else
 
@@ -320,8 +321,23 @@ static inline int check_net(const struct
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
@@ -458,7 +458,7 @@ static void net_complete_free(void)
 
 }
 
-static void net_free(struct net *net)
+void net_passive_dec(struct net *net)
 {
 	if (refcount_dec_and_test(&net->passive)) {
 		kfree(rcu_access_pointer(net->gen));
@@ -476,7 +476,7 @@ void net_drop_ns(void *p)
 	struct net *net = (struct net *)p;
 
 	if (net)
-		net_free(net);
+		net_passive_dec(net);
 }
 
 struct net *copy_net_ns(unsigned long flags,
@@ -517,7 +517,7 @@ put_userns:
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(user_ns);
-		net_free(net);
+		net_passive_dec(net);
 dec_ucounts:
 		dec_net_namespaces(ucounts);
 		return ERR_PTR(rv);
@@ -662,7 +662,7 @@ static void cleanup_net(struct work_stru
 		key_remove_domain(net->key_domain);
 #endif
 		put_user_ns(net->user_ns);
-		net_free(net);
+		net_passive_dec(net);
 	}
 }
 


