Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B512A8D3;
	Mon, 15 Apr 2024 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191779; cv=none; b=bG/q/nJzwo1Xg/xKZmNx4+SiTMSa81OFyjEbAW1r6KnaO+zwb7NNIJLe8hB3cWIUQBHyp4ZOLwIZgLn2qFaEtMFcRZoeAAsqbCmiIEFFDSd31SV0byuVcJv3yj7zbCTZ6KJRvYGnWf/silnQIPF9W0XHZO6Bo5ZSH2ObKThRzbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191779; c=relaxed/simple;
	bh=QHUVOjXnxH1IoczCq5jyOvc6npmKxNQ+yhvzQ9njmlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQat0zEfIT3cydKUbPZhtxhuMFyiLayvgX9am6VYBOcoh48zgA+I4c5DL7hyfM8cPkhhWN557sLemz5VjVyl3cpRf0zIcbnsrowKtmAtVYWuhdOxH+rVxSAD1hpK6i6VdbRlObLjYG7uOJ97w9Y7lOyXIiRjT5NjyReAJWj/+t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiUT++fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiUT++fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C314AC113CC;
	Mon, 15 Apr 2024 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191779;
	bh=QHUVOjXnxH1IoczCq5jyOvc6npmKxNQ+yhvzQ9njmlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiUT++fOR1YaV4Nz174An4bQ+mBgZMTumUNmjr/KljPc/DqxLR/RgLZSknUpTiyov
	 fAzS6MujAPloV6oNpFiR9UoPbrU9QbYkG318GqFKnXFbor6FYlKAkUR4tOEmieZleY
	 HOEcBZLvEDHA00eeheZmDzkEtR/cQ/6/q77p1Iwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/122] ipv4/route: avoid unused-but-set-variable warning
Date: Mon, 15 Apr 2024 16:20:11 +0200
Message-ID: <20240415141954.747195786@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cf1b7201df59fb936f40f4a807433fe3f2ce310a ]

The log_martians variable is only used in an #ifdef, causing a 'make W=1'
warning with gcc:

net/ipv4/route.c: In function 'ip_rt_send_redirect':
net/ipv4/route.c:880:13: error: variable 'log_martians' set but not used [-Werror=unused-but-set-variable]

Change the #ifdef to an equivalent IS_ENABLED() to let the compiler
see where the variable is used.

Fixes: 30038fc61adf ("net: ip_rt_send_redirect() optimization")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240408074219.3030256-2-arnd@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3bad9aa066db3..e1e30c09a1753 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -926,13 +926,11 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last = jiffies;
 		++peer->n_redirects;
-#ifdef CONFIG_IP_ROUTE_VERBOSE
-		if (log_martians &&
+		if (IS_ENABLED(CONFIG_IP_ROUTE_VERBOSE) && log_martians &&
 		    peer->n_redirects == ip_rt_redirect_number)
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
 					     &ip_hdr(skb)->daddr, &gw);
-#endif
 	}
 out_put_peer:
 	inet_putpeer(peer);
-- 
2.43.0



