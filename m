Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3C36F2FE;
	Thu, 12 Dec 2024 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025326; cv=none; b=IdYwzbS/BzLmrveS12VAIXUePM0Jw3M+Ki7dIyu0dJDVxQZqySLaIkYhiO3t4KGm7guNPDYMcRx8LtP9OpcWybksdTX9KfZ3zqUrlrPHm5qqpXLVFRbwBwt9lDwChLNx003z5VQZF50Y61Jxe81UbaBgxPaY+O7PeUYH85VXFws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025326; c=relaxed/simple;
	bh=siL1ryzAkhzKB5YjZs8svtoWTBdz9lfz/jasZcOsezs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRXPiBu/mOGt0pKFWyDEhhOSFy9fKBiS10fF1bz/ivJ0yRlydLP3bCAkYV1KwRPX6EAq096EXPn4kSXIT3/Satx+c8oW9Gx94x79qB2N8UAJ6RpF7W7WtAe1CXJXK3yCuTTa6RJmvOe3d8TdPvAhU+KvzEpqw1qbBO1SCZ+4Ijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKXuiTcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKXuiTcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6557C4CED3;
	Thu, 12 Dec 2024 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025326;
	bh=siL1ryzAkhzKB5YjZs8svtoWTBdz9lfz/jasZcOsezs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKXuiTcO+S4zRRs7N9hKni3UzH8ELHFFeJ4qCqodTQxeaFg7vb6jd/+xCVWeRQZgh
	 U5RV5zUtT5ijTSYc1IKWEE8cy4gjiz+NyR/IKgwT7t0bHflxoFMwJoOe+U3wkoQ2as
	 coEA/kxCBAlqVEr13Q4gM9TUDYoFugX396Yo09oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/321] ipmr: convert /proc handlers to rcu_read_lock()
Date: Thu, 12 Dec 2024 16:00:50 +0100
Message-ID: <20241212144235.191848295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b96ef16d2f837870daaea51c38cd50458b95ad5c ]

We can use standard rcu_read_lock(), to get rid
of last read_lock(&mrt_lock) call points.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fc9c273d6daa ("ipmr: fix tables suspicious RCU usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 8 ++++----
 net/ipv6/ip6mr.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2da6896080363..11f916646d34d 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2916,7 +2916,7 @@ static int ipmr_rtm_dumplink(struct sk_buff *skb, struct netlink_callback *cb)
  */
 
 static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -2928,14 +2928,14 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
 	iter->mrt = mrt;
 
-	read_lock(&mrt_lock);
+	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
 static void ipmr_vif_seq_stop(struct seq_file *seq, void *v)
-	__releases(mrt_lock)
+	__releases(RCU)
 {
-	read_unlock(&mrt_lock);
+	rcu_read_unlock();
 }
 
 static int ipmr_vif_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 6642bc7b9870f..33c5974d467dd 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -401,7 +401,7 @@ static void ip6mr_free_table(struct mr_table *mrt)
  */
 
 static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -413,14 +413,14 @@ static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
 	iter->mrt = mrt;
 
-	read_lock(&mrt_lock);
+	rcu_read_lock();
 	return mr_vif_seq_start(seq, pos);
 }
 
 static void ip6mr_vif_seq_stop(struct seq_file *seq, void *v)
-	__releases(mrt_lock)
+	__releases(RCU)
 {
-	read_unlock(&mrt_lock);
+	rcu_read_unlock();
 }
 
 static int ip6mr_vif_seq_show(struct seq_file *seq, void *v)
-- 
2.43.0



