Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B66E47B413;
	Tue, 16 Jun 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630400; cv=none; b=ps2/UzhjhKsGhNp1Dcd64oDI4+hyycpjbOiIcOLe2YHdYUFy0FSKsrhPmad+pdWLmQoSslxiRrq0iZWNbKbD8NnlBvEKkenUva9OVEicORZ5TF5PJ57tnJjOWU54FC2z9tXAwZCogB+O20W/0EFEj5w4OOPcNZo/FpM91K19S8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630400; c=relaxed/simple;
	bh=Vy9qsmoNU4yRnPFefra+66EZc38OMl3rqv2TqC5kfUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLxrIdG3W87Ech07Ihy5MYhaSFRgl1nxeUBKpXrGuzdUthOQ8k8PR1AeP0M6JElhoNRBb+xIjLtQ/mNRXblg3Awi1Sm55HWpJtw+JZbeuOBEJ6qO9dvG59zTQcan+8ZPp+FWq+RLLh/KROzM4e+T6yHqn1nhvbcxeCfxAbx4gEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtJ4Wr96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtJ4Wr96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CB61F00A3A;
	Tue, 16 Jun 2026 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630399;
	bh=IPmZxVoUGCpgz1Hu0fH/yhXWI/W1catzJxJzW36z1hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtJ4Wr96lnVmC3CDuebgBTaMcEPpValrEpuO+t5aDuQ9m+bgOsNoJja2uDjIOgNnB
	 GOKwY8nrL/1jLhMtn/LzGThv7ZlAiXQWWIoxicQYV44r6EXg5L3xahsFdfr6BTR0KU
	 KS2V1W3YIG6zeCxN9k6wOXvJ2jp0iKfh0/uVo8vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/522] ipv4: free net->ipv4.sysctl_local_reserved_ports after unregister_net_sysctl_table()
Date: Tue, 16 Jun 2026 20:22:49 +0530
Message-ID: <20260616145126.613017281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 87a1e0fe7776da7ab411be332b4be58ac8840d10 ]

ipv4_sysctl_exit_net() is currently freeing net->ipv4.sysctl_local_reserved_ports
too soon.

Only after unregister_net_sysctl_table() we can be sure no threads can possibly
use the sysctls, including /proc/sys/net/ipv4/ip_local_reserved_ports.

Fixes: 122ff243f5f1 ("ipv4: make ip_local_reserved_ports per netns")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260521122147.3584624-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/sysctl_net_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6b4c9b0fc9abb7..ef17d0f95a9da5 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1449,10 +1449,10 @@ static __net_exit void ipv4_sysctl_exit_net(struct net *net)
 {
 	struct ctl_table *table;
 
-	kfree(net->ipv4.sysctl_local_reserved_ports);
 	table = net->ipv4.ipv4_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv4.ipv4_hdr);
 	kfree(table);
+	kfree(net->ipv4.sysctl_local_reserved_ports);
 }
 
 static __net_initdata struct pernet_operations ipv4_sysctl_ops = {
-- 
2.53.0



