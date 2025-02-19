Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AB51E503C;
	Wed, 19 Feb 2025 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957482; cv=none; b=X9kzbl4i2g6Gjr1GxfI6lD36pTod9brF5S9SKiEDt97Z72FeuwJ1y2gwgCCc3k3iajxaolCcX/J9ODZXSmiv6YT+5MOHYFzwxhfZuSz9Zaw3F1bC+SQwShnqUGHpKIYHmxLhkQV51zzxKPD5oCsbfA8M5v9Z0+TeWsn87194sMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957482; c=relaxed/simple;
	bh=xsqB1GbDQM1p8Us4Tn5FAfkG/0kj3xjrvsTmRe5Gwes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS+Tl46s7syYbvkl9Li8jKb0dUqTwvL9faLguSLHpC66OVgX/VbU2KiV842a7rHKGFPGUFu0kVnVvEnL8ffuofJ6RhjqQFuo7aLmLLNipYeVLN3uVdO+pNaEDZNYCuvOx21OUz1+X9vewnRmOXYwsEjxVKZ6ujtSjHfaFVvAlGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+yWyfGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+yWyfGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31188C4CED1;
	Wed, 19 Feb 2025 09:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957482;
	bh=xsqB1GbDQM1p8Us4Tn5FAfkG/0kj3xjrvsTmRe5Gwes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+yWyfGddQ/VPcEFY3NbitZR5zR3q6x2gemPyxx4Pa5BIpU3o2wL3cqpZ2MbsHyEw
	 Vk0Mob4rroapKanIphbOPsKc21kH2fdU7VlXktxHhW9IH9NQMKd4mUmqNkho8Vy/rb
	 iiloCzxzkl/sWIj+eY9wkcuYZtEWMNZsBWGtgYGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 541/578] ipv4: use RCU protection in ipv4_default_advmss()
Date: Wed, 19 Feb 2025 09:29:05 +0100
Message-ID: <20250219082714.251549267@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 71b8471c93fa0bcab911fcb65da1eb6c4f5f735f ]

ipv4_default_advmss() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: 2e9589ff809e ("ipv4: Namespaceify min_adv_mss sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f877a96fd1eb5..5f18520d054c0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1306,10 +1306,15 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
 static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 {
-	struct net *net = dev_net(dst->dev);
 	unsigned int header_size = sizeof(struct tcphdr) + sizeof(struct iphdr);
-	unsigned int advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				    net->ipv4.ip_rt_min_advmss);
+	unsigned int advmss;
+	struct net *net;
+
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
+	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
+				   net->ipv4.ip_rt_min_advmss);
+	rcu_read_unlock();
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
-- 
2.39.5



