Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC8E176AA1;
	Thu, 12 Dec 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024232; cv=none; b=Ec2S4ZnHR5P0JaCZnG3BTvG3cT9X7iE9foLM/wlEkaSzjSFJ+nhcPBkbG2M7SLFCxoRz6qr94O0+PAVDmKAwwZYTiQUQdq4D8KgV92wECJEhHC/CqSktyKodAKE9rFtI4cVFjchDHVuwTO1UQop8k0MyiO+Ca38PoRDC6Asgshc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024232; c=relaxed/simple;
	bh=HYpZzqZ6CWivLGa+PvvEPonv8jJ8CV6GzOCOcLqMwho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTpmKM0sxKgj69P3H+GyhWTpn93BIFdVV+daKcSgNIOMByM9y4JgUMOtfgwrWwZV2Tmi2z5/h8f+dLszlGy6hlJjTCwDIYd+aPFIjyU0FNPwG8+uuoXuJR3Gzr8jYNQ+xJBYaA/JbVelqVykA/zkTQVpSIO0fzPFjXLhHyx+al0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuWWyVrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuWWyVrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FFFC4CED3;
	Thu, 12 Dec 2024 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024231;
	bh=HYpZzqZ6CWivLGa+PvvEPonv8jJ8CV6GzOCOcLqMwho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuWWyVrTUgDBj9cM8PlGPcIJYbc+jpVcabi4/rS72Ply827aiVegKRXqrXA42LH3P
	 M+i4W9IU0i9x/m7PGoZvPJw33ZsTi4nin/GEiyUyBQTGmYT+T2hrqHWZyEgCxtf34Q
	 JtCQ/HFcZ9OoNcrdjIzYXOB/LE6OJ6YmsFYg5+Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/459] ipmr: convert /proc handlers to rcu_read_lock()
Date: Thu, 12 Dec 2024 15:59:27 +0100
Message-ID: <20241212144302.615058767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index db184cb826b95..fe3d23611a297 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2896,7 +2896,7 @@ static int ipmr_rtm_dumplink(struct sk_buff *skb, struct netlink_callback *cb)
  */
 
 static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -2908,14 +2908,14 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
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
index c758d0cc6146d..926baaf8661cc 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -405,7 +405,7 @@ static void ip6mr_free_table(struct mr_table *mrt)
  */
 
 static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(mrt_lock)
+	__acquires(RCU)
 {
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
@@ -417,14 +417,14 @@ static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 
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



