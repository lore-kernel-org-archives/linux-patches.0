Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158F812B176;
	Tue, 30 Apr 2024 10:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474707; cv=none; b=oFGyxtFn33mLsXbSOJ5EgVrr8gUxQ2Ml5WpLPVIgDSisfTboatcgj1qpLFd06By+NAbxVfdEeELF1+wD7mB0x5GA7bh8z47puxh8+dBWASlaV0u9bIJzK96TfyrFxXZBpdLZs0//Cppo/EvVF32evw6/gOQouPbDMRUQXQTGio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474707; c=relaxed/simple;
	bh=Lka3uClTZnsxW2gccXUJgPmIvxsTq4HE4NGrpSFh1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX4RWy4Z6gRNIKfVmCvfwRe4cY/mPLEoQ7ROTSbFgXLocWSjGHuaog1g/wXoW8H65+N4ijUhIIyYchyWZDnAxJdAVzLW4qHurut8PhX9yPIZvZI5rZ0ZQxk/v3FI50I5rZ/9DGoUWKSLIQKxkK5/M5NStJI1TpX+F1Pgdv+U8Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOsLjy/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOsLjy/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D19C2BBFC;
	Tue, 30 Apr 2024 10:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474707;
	bh=Lka3uClTZnsxW2gccXUJgPmIvxsTq4HE4NGrpSFh1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOsLjy/AAfTbcJ9XlTSa9N8Arz7TMY0bYZCSy9PFn5gtVnfyPGfOID+G8jIzpJRLv
	 ulhYiMyIWQ69S/ox0m6UippYU5qSxB2QjbRpCYvmsNLV2jfZhGsKaDGQjdr5aaoycn
	 DACrKydC1xVrDlS9p3Fs6fIqf2iuN4oGucmV5hAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/138] ipv4/route: avoid unused-but-set-variable warning
Date: Tue, 30 Apr 2024 12:38:16 +0200
Message-ID: <20240430103049.758296235@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
index d360c7d70e8a2..b7cba4bdc5786 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -955,13 +955,11 @@ void ip_rt_send_redirect(struct sk_buff *skb)
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



