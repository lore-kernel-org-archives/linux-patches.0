Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A649D5A5;
	Thu, 17 Sep 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667858; cv=none; b=j8GufCqAoXfvR8qlOkM+KpwSmfGLb8uedvzZpfh8XVqSeiY3/hFoTPuYHZKQHwwVkbEyZ8bOGd+N9TdX3942ujsnnqYJh2ZassOC4ttl05lMEDCB/6exftl8xV3ZdoeuarnBJmmCzRB3s7eg2t7W0mhfNVd6iFZLXC3PzgBbRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667858; c=relaxed/simple;
	bh=7NzibjCj9cPr68/4U+svY47F1cnr2wNI+4u0uBjfnzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiOMTIFj5+l+h6CGhBoRDC9hMLK8eMWhQgJSflXS3T9erRSf7U/pkoi/EiiLiigxBPSY8H8RA10az9+KT3ZZMF62Pwp/PfN+ECwpEW2eZZfxL2h6GZd3s9XNYul0bdUSPxMw0cwRVk+ujleP9FnwPw2zSQjzELvK+wzNekcU8gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXkivtgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXkivtgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F61E1F000FF;
	Thu, 17 Sep 2026 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667857;
	bh=zaKV3LMsYlH8xlRfEe5j0zDN8iz4EIqqgXsqmSldW4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXkivtgAvAjpUhMDUlQSRn3mc2lzWs2ZkvihXi8EwmqppNYFnoGAssAcOJdlfXKjl
	 SnWJ9Cz9R4QxNTqGHJs/4koMJ44ejnR8Lm4CgD13MwkE+aW0J8Usm5FQ6MmmwGO02L
	 2FVNRLwkd2KopZBDSZcQvGmuD3gEPkcL4EyBuDtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0232/1102] ipv6: use READ_ONCE() for bindv6only default in inet6_create()
Date: Thu, 17 Sep 2026 16:02:55 +0100
Message-ID: <20260917151545.410992039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 7a20eb54224ab7481c1f5a1619a6a5677be93eed ]

inet6_create() reads net->ipv6.sysctl.bindv6only locklessly.

Use READ_ONCE() for this sysctl access.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260602002414.1504106-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0786155715249..0fb93bb4c0adf 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	inet6_assign_bit(REPFLOW, sk, READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
 				      FLOWLABEL_REFLECT_ESTABLISHED);
-	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_ipv6only	= READ_ONCE(net->ipv6.sysctl.bindv6only);
 	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
-- 
2.53.0



