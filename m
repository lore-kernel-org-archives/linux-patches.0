Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3655129E81;
	Tue, 30 Apr 2024 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473726; cv=none; b=t0rs1TfOOb8i4Np6joy+pZP7Q1kf+Louz13SUWwUEM6h/irrsMiZFI2XED4M/oMJwu4yVOQ23dfCySqCp5ptM9mU39nIIVztJrO6xieLfoxygnsGIen453X4RG/nUbFVX2yq6DEkq/odJN9j9mQcWu923cCqLoqUMXZzGVNerP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473726; c=relaxed/simple;
	bh=5FnRqBDJdO8AaMfCVO0REKDgCVYZy1gDTS7WouthhQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHFUfrqi91JtXiJRCMhHkIzN8NMVP26CIP6dkrZLFGPjuHqYt+is1gJ81Cmhc1wveSAnF4Y4nr8/oBIyZLsU854WIPpM7Aa6UN76ghzidYG5pmZylJTKGvqEzvWAXOTiPYOo0mhj3gkMLh+vN2tHRYOJyV36TkJNsgtWZxGwW7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pNs/Q/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pNs/Q/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D6FC2BBFC;
	Tue, 30 Apr 2024 10:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473725;
	bh=5FnRqBDJdO8AaMfCVO0REKDgCVYZy1gDTS7WouthhQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pNs/Q/6acJR3JZ0sr4opgrX899rKbe0FfdLjk28yKsugId2iiQ7cOtY8tlD5a2ZL
	 7ATHDCuMoMRbyR1PniZb5QS+ZHiF0SnBHe51hyllEAP4bNqHfYgHQzKeTvoc7NSPr4
	 YxyyQj7HULsIfQYOTvxxBOwPw+Z7ADPG1LM6X5Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/77] ipv4/route: avoid unused-but-set-variable warning
Date: Tue, 30 Apr 2024 12:38:45 +0200
Message-ID: <20240430103041.306690929@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f4d41ceef9466..3014605105350 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -937,13 +937,11 @@ void ip_rt_send_redirect(struct sk_buff *skb)
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



