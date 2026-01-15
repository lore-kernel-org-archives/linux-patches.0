Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E92C3BF2E7;
	Thu, 15 Jan 2026 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497333; cv=none; b=MZCJzXbfB3dR+PRKydnygGO+rtPYBCbrVWI9b7NMGIHau8xZXS4YepeFYlhwN9m3P1NZTL4qKUayAxgGiv+zs0eeyzgomU4glHCNELuLjRJCaEzQOFc+sXlwL+ydOaw+Q6pFY+Pe+mfCR3Jyv91L/a1UmDDN5P4SsqSApKHecbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497333; c=relaxed/simple;
	bh=HE7U/w4ruzCTDnx8KBpb4yguY+cLpj0fIDe02OhTbW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maMk+qhK92/rKGtc5qhYTj3Gv3rGB6mL7WfnE6BYi2fcH3nto34QjBa7DBExhcpHTC5eYx2Rf2g52p66uGWnJmh/pqIodC4SQuTwOrSfIXboTo11VIc6scQp3/auAyDoMLtkcL6GoooRm5I0xUmiiTkyUnXjCRdTKTYSj7nIgHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UaS5Swn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UaS5Swn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5E9C116D0;
	Thu, 15 Jan 2026 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497333;
	bh=HE7U/w4ruzCTDnx8KBpb4yguY+cLpj0fIDe02OhTbW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UaS5SwngdNuuMONdhkOGVZryxsXd0gU9xS5aotTBXgIZnGp6ks1KnSryZHYOMbrU
	 enl8AuB40032X6Co/tSwhzjmb5ev9WWIBtttyL68BuacoAXUSeoE2OKxK0w9mOx2I/
	 6/d4/yPn/I8u5+ZRIBHvJW8au94qjibkSWqZcNnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/554] inet: Avoid ehash lookup race in inet_ehash_insert()
Date: Thu, 15 Jan 2026 17:41:50 +0100
Message-ID: <20260115164247.842074549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 1532ed0d0753c83e72595f785f82b48c28bbe5dc ]

Since ehash lookups are lockless, if one CPU performs a lookup while
another concurrently deletes and inserts (removing reqsk and inserting sk),
the lookup may fail to find the socket, an RST may be sent.

The call trace map is drawn as follows:
   CPU 0                           CPU 1
   -----                           -----
				inet_ehash_insert()
                                spin_lock()
                                sk_nulls_del_node_init_rcu(osk)
__inet_lookup_established()
	(lookup failed)
                                __sk_nulls_add_node_rcu(sk, list)
                                spin_unlock()

As both deletion and insertion operate on the same ehash chain, this patch
introduces a new sk_nulls_replace_node_init_rcu() helper functions to
implement atomic replacement.

Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251015020236.431822-3-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h         | 13 +++++++++++++
 net/ipv4/inet_hashtables.c |  8 ++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b987074f80965..ee9c398dd8f25 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -785,6 +785,19 @@ static inline bool sk_nulls_del_node_init_rcu(struct sock *sk)
 	return rc;
 }
 
+static inline bool sk_nulls_replace_node_init_rcu(struct sock *old,
+						  struct sock *new)
+{
+	if (sk_hashed(old)) {
+		hlist_nulls_replace_init_rcu(&old->sk_nulls_node,
+					     &new->sk_nulls_node);
+		__sock_put(old);
+		return true;
+	}
+
+	return false;
+}
+
 static inline void __sk_add_node(struct sock *sk, struct hlist_head *list)
 {
 	hlist_add_head(&sk->sk_node, list);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7d2c21c3cfd4a..a7d11b82fe64d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -541,8 +541,11 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		ret = sk_nulls_replace_node_init_rcu(osk, sk);
+		goto unlock;
+	}
+
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -551,6 +554,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
-- 
2.51.0



