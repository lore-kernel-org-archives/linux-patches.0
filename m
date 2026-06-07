Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2F81E98EF;
	Sun,  7 Jun 2026 10:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827288; cv=none; b=CkfqEEBwLm0ZrUAQ4Fo3L5h9Y7yGYu6wpWvjDIlAKlf8CZ78EZ72zrQcNMR7AMmD9bSSvq7hZne2NO9YQ3IBcXVI9KZnSr7t4IqHKrrC/4k6hal23j6prKYDjxBOfiTMln9D9MIhQDF8koD8qWSO/RJeOS5jWrdDL3Z/TRJu5pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827288; c=relaxed/simple;
	bh=1KNDS1vG+xvpbauPv0T92mGmnrc6wA+BX3Xn4i55Vao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edjbFLbrkYs2sN+rMH0VFAxbNxx68Ctlf2WclTqACAMHegRMhB9gvOJ2xtCukhZjutZ52gDV/Ntcea5BEh8NYklsqtIuEHKeyR4P81UENQMNMpuUmRNdMvPwVoIr4NDx+75CslqiF+/925WPgfbACJP7++p4RAAGsy7jg6OUdG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9zkvZ85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9zkvZ85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC7E1F00893;
	Sun,  7 Jun 2026 10:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827287;
	bh=GwGyjztPGSyBhevnzdrtn8JXgh9cmybtOlhPpvcRIbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9zkvZ85Byw16Q8DqWpVfiUBkZ2mdylRe/sMn5XccpTR7q21fn/uTFt7aXPJwadQZ
	 15wyHPB6JA385B2AHXxYCF68mYqDOyUTrMzTrvf7e/x8FzxWkd+BRCXapOk4oueqN6
	 5Ismm7QyI4paeHLLVjbc4Nnnyacq11E/iU551OHQ=
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
Subject: [PATCH 6.12 042/307] ipv4: free net->ipv4.sysctl_local_reserved_ports after unregister_net_sysctl_table()
Date: Sun,  7 Jun 2026 11:57:19 +0200
Message-ID: <20260607095729.246158769@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d411cce0aedc1..35a6e7d8f52f7e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1630,10 +1630,10 @@ static __net_exit void ipv4_sysctl_exit_net(struct net *net)
 {
 	const struct ctl_table *table;
 
-	kfree(net->ipv4.sysctl_local_reserved_ports);
 	table = net->ipv4.ipv4_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv4.ipv4_hdr);
 	kfree(table);
+	kfree(net->ipv4.sysctl_local_reserved_ports);
 }
 
 static __net_initdata struct pernet_operations ipv4_sysctl_ops = {
-- 
2.53.0



