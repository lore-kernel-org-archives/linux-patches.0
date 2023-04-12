Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E922F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C34DC433EF;
	Wed, 12 Apr 2023 08:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289308;
	bh=I44o5K3/fVFmDAqmxZRhB37N9DMHiXe/wyi0gEi+8v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fnw7vppEgeLIHn1L6QhvcH5kBGW5hGmjZBNrj0i/Tmq1Z51y+tWZ4xf9dY3WuFv6x
	 EBFdqmPBQyLD2P2yRE44cBIyKsWaYBXujDm+EghMKvlsXNb+ngBhPHvnG8XOi3HFBU
	 vpBa8i9y7ru2hk8xuXsWDGGjAJm3psXPAua1EJW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 049/173] ping: Fix potentail NULL deref for /proc/net/icmp.
Date: Wed, 12 Apr 2023 10:32:55 +0200
Message-Id: <20230412082840.097638160@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit ab5fb73ffa01072b4d8031cc05801fa1cb653bee ]

After commit dbca1596bbb0 ("ping: convert to RCU lookups, get rid
of rwlock"), we use RCU for ping sockets, but we should use spinlock
for /proc/net/icmp to avoid a potential NULL deref mentioned in
the previous patch.

Let's go back to using spinlock there.

Note we can convert ping sockets to use hlist instead of hlist_nulls
because we do not use SLAB_TYPESAFE_BY_RCU for ping sockets.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 409ec2a1f95b0..5178a3f3cb537 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1089,13 +1089,13 @@ static struct sock *ping_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family)
-	__acquires(RCU)
+	__acquires(ping_table.lock)
 {
 	struct ping_iter_state *state = seq->private;
 	state->bucket = 0;
 	state->family = family;
 
-	rcu_read_lock();
+	spin_lock(&ping_table.lock);
 
 	return *pos ? ping_get_idx(seq, *pos-1) : SEQ_START_TOKEN;
 }
@@ -1121,9 +1121,9 @@ void *ping_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(ping_seq_next);
 
 void ping_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
+	__releases(ping_table.lock)
 {
-	rcu_read_unlock();
+	spin_unlock(&ping_table.lock);
 }
 EXPORT_SYMBOL_GPL(ping_seq_stop);
 
-- 
2.39.2



