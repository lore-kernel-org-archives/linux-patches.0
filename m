Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06CA25C715;
	Tue, 11 Mar 2025 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706007; cv=none; b=fNaxM3MOoSaUKgzR+4P4bQphbAiGkCPAxMakaYJFoB0VTERGGxJEGnMbEa3Tvtv69lL9cLDRddiO/hNRT9ynr8owQ5ifHT9cJMCcGJyqCcx2EJx0F5khiB7e85cru5iNkLRvzd5+ZP7sHDKaL1HoKu4IGO2b6lBsy1fKGqcT/js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706007; c=relaxed/simple;
	bh=doguaz9OUDOcmyJ4aLim7jlsPL7ZttvNhc66ZdF2hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2CTvhE/q11TY3fKbXEeR1MxOr7ab10sv2MYZiz4+U9U18QxHQbn7xUwdXoovpk7WYM8TjZhyK1pnwbZSfY4h/wjqSo5bgDvBe5D0Jam8SRen1DRMPU1WphuhDPUJDg5GoeRp6515+SuW4HPX1P9OpJcapDrF5NzYrrk1n5+78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmHny3kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmHny3kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CCFC4CEE9;
	Tue, 11 Mar 2025 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706007;
	bh=doguaz9OUDOcmyJ4aLim7jlsPL7ZttvNhc66ZdF2hmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmHny3kcBoxMoCDOjQwmvc063YR7uAYXOdQUJheyRjUa2i/7wMa7wK669g7L/yuZD
	 ShCmbiMnadEe7E8Wqzu/mZebqkyYqFmLeMhPBKZ0PkPw4r6S0shAtTrcW/P1ACPysq
	 caC8m87HNzt7bmUjCLUzaoKC9p9z+Uh7NuOgvVO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/328] net: add dev_net_rcu() helper
Date: Tue, 11 Mar 2025 15:59:32 +0100
Message-ID: <20250311145722.930511203@linuxfoundation.org>
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

[ Upstream commit 482ad2a4ace2740ca0ff1cbc8f3c7f862f3ab507 ]

dev->nd_net can change, readers should either
use rcu_read_lock() or RTNL.

We currently use a generic helper, dev_net() with
no debugging support. We probably have many hidden bugs.

Add dev_net_rcu() helper for callers using rcu_read_lock()
protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: dd205fcc33d9 ("ipv4: use RCU protection in rt_is_expired()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   | 6 ++++++
 include/net/net_namespace.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a6bb64dccb888..f5c1058f565c8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2216,6 +2216,12 @@ struct net *dev_net(const struct net_device *dev)
 	return read_pnet(&dev->nd_net);
 }
 
+static inline
+struct net *dev_net_rcu(const struct net_device *dev)
+{
+	return read_pnet_rcu(&dev->nd_net);
+}
+
 static inline
 void dev_net_set(struct net_device *dev, struct net *net)
 {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 6ce0ec2dd2032..334286b57994b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -330,7 +330,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
-static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+static inline struct net *read_pnet_rcu(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
 	return rcu_dereference(pnet->net);
-- 
2.39.5



