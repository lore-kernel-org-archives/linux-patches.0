Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C047868B;
	Mon, 15 Apr 2024 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191969; cv=none; b=Gyss+HI6ijht+SeDiB6ZRgQV//I/faGV2E72rst5SyChBzwZ1UznUaCUImEi36y+B8SuWrXJaE8THM108t4SC1v6yStJbnIoeslW7AjtZy4BX0EMOYIjr20IvMDa2u31PuUd5LUJR6Hqfrm2xxeZRjPsNGCmd+L8+LEXv6h6q5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191969; c=relaxed/simple;
	bh=RgkkVbWeoP+PuhWDUrLhgWkm6JbmEuzaYiqw5ufeV14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX3lbu3UZJLCW2VOKMFNMgtYyOatmgEezSWKQfJFow6u6cSwl0+MdUZIBIG2kGMcBSvNYSJDFeKQqYXv4mt+BQTWDTF1QoPIc8T3utTuQ9RToALLLkbg+vrRk9+jxm2lZZQub/O2O6wnDU1h44xOang7ICZequLEmJs7gXkrTes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp69olBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp69olBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A387C2BD10;
	Mon, 15 Apr 2024 14:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191968;
	bh=RgkkVbWeoP+PuhWDUrLhgWkm6JbmEuzaYiqw5ufeV14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp69olBOmA7KrDCb9n7EwocLAzZgZEG+TKTKdSAs9oJDUVlJj+PwxX8smBUyH5hft
	 bQTP6/AkG+aXz90AyTPQEPTkNF6ll+9NmDkogzETQNxvlFoicdlfGJGA71hjfveklj
	 ym6BLLT/4CgoprXK0uxOZ7dRJltfeLYsF6EokZxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/69] ipv4/route: avoid unused-but-set-variable warning
Date: Mon, 15 Apr 2024 16:20:55 +0200
Message-ID: <20240415141946.896506056@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 474f391fab35d..a0c687ff25987 100644
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



