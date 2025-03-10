Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D122ACDC;
	Mon, 10 Mar 2025 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629568; cv=none; b=hCcNxqv8w4HvAuZyEtdBg7HQTm5YYVjA0AJx1slpOoe1JD3ern8eZsfuG/43RNq0LJEXKq81WtUVy+AILIsget7EVaInBCtLRWQL7rxY+u5SF/uyOG2F4ANhtykYA2hXSD/NCH3m9ZfJ8Du+WIdUrPlRStuWRMp1C9H6tD1PW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629568; c=relaxed/simple;
	bh=0/3mhM+dyviiI32YSc5E/bMnGVvO/VP9u1JsAv9/0PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIZ9NdkWx6TAvaj7WYrrI3Slbs0VbXJaOpljeYYQYBBBZiguQ581sMVipBfzzyQRHjTry9OcNYSUCI8tMVAN98OyEVV0dIvMcAJzsvegePaqCFCJf9Fs/rpUoPwIVCLT/G+KGWDd7vFTYtsFHZfvKhalLIX4h9UmLPy6uVisfbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2osNO5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2osNO5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E32DC4CEE5;
	Mon, 10 Mar 2025 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629568;
	bh=0/3mhM+dyviiI32YSc5E/bMnGVvO/VP9u1JsAv9/0PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2osNO5V0wSovkSQxWQ9SA1i5AtfiDEGdTmnE297Hc74hEs07mivpYeJUT/S2PvXj
	 ctAqnckcf8TriyaV8vWPt7cEnFqLQZ83ik5xJzjsEDup/LzkDNr7LNvg/k8XbEosbA
	 JFtKMkrmEqaVhvhwhRTmg8zmTxCOdRXMaoAut6RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/620] vrf: use RCU protection in l3mdev_l3_out()
Date: Mon, 10 Mar 2025 18:03:05 +0100
Message-ID: <20250310170558.994790671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 031c661aa14df..bdfa9d414360c 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -198,10 +198,12 @@ struct sk_buff *l3mdev_l3_out(struct sock *sk, struct sk_buff *skb, u16 proto)
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



