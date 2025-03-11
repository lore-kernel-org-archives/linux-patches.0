Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5B225E80D;
	Tue, 11 Mar 2025 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705872; cv=none; b=Xdj6uF83pQSazjE4HwA9w+Io+zdesQqfiezBQTZuEbxWFiVnAqtCy5Mw1DHV2wjdzO0QQ/roVfyHPdQq5bjzoKMCl+5/GC2JB8PckrDtEnRlE1bYyfhvCm+OZmDiq3QZ4mPpfSNvDoCFfV/C3cR/l1wJe1RrZ8L8lTxPsQBseOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705872; c=relaxed/simple;
	bh=EhIP3ZAOHDJFO0zChVsZaBXpAWqWSZuv+AUdTQYnXJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBO5EJWaWOFNuJLBrPmQn+8S14LFH6PeE6q7pIbOazoSHCl9v3EbE9suRJUyD66k7et152d3zUWY0rfT9xKDr3twxadJqWN1BuxpqqXXni/DGAqgjT5QGWEqQwBPCVXPdBqRYLgFJ+jEmUQ3LAbGjqkSx1rLUX8cEjdwxCf/8XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8qiavP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8qiavP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B700CC4CEE9;
	Tue, 11 Mar 2025 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705872;
	bh=EhIP3ZAOHDJFO0zChVsZaBXpAWqWSZuv+AUdTQYnXJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8qiavP7NGWiwPmz8hK8zNo4lzxqBIp63d/wFbCWcf/Du4d7+7WwpMGleYne0D7mr
	 IPUr/1LJCb0VflPWc1aSp3L5ghglia9SVPrdf4mjq8s8P+V3muYndmY8sGr8OZfctq
	 ETM4kdRBXXA+3wt3z3TSdNRYYFFOOSIRxhglw9oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/328] vrf: use RCU protection in l3mdev_l3_out()
Date: Tue, 11 Mar 2025 15:58:54 +0100
Message-ID: <20250311145721.424274068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6d0ce46a93135d96b7fa075a94a88fe0da8e8773 ]

l3mdev_l3_out() can be called without RCU being held:

raw_sendmsg()
 ip_push_pending_frames()
  ip_send_skb()
   ip_local_out()
    __ip_local_out()
     l3mdev_ip_out()

Add rcu_read_lock() / rcu_read_unlock() pair to avoid
a potential UAF.

Fixes: a8e3e1a9f020 ("net: l3mdev: Add hook to output path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/l3mdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index e942372b077b5..062da1588be05 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -179,10 +179,12 @@ struct sk_buff *l3mdev_l3_out(struct sock *sk, struct sk_buff *skb, u16 proto)
 	if (netif_is_l3_slave(dev)) {
 		struct net_device *master;
 
+		rcu_read_lock();
 		master = netdev_master_upper_dev_get_rcu(dev);
 		if (master && master->l3mdev_ops->l3mdev_l3_out)
 			skb = master->l3mdev_ops->l3mdev_l3_out(master, sk,
 								skb, proto);
+		rcu_read_unlock();
 	}
 
 	return skb;
-- 
2.39.5



