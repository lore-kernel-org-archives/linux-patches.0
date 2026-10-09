Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B53C416A;
	Fri,  9 Oct 2026 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555645; cv=none; b=Dx1jmGKwS7SIYWSSbUAoVMMmeU4Nnp806fPAR3cMnwwwFu18G9iAPqtbmDWsaSie3eoRZRdCTBrJO+MBhJeMg+8v9uJsfXVDiswKGXioEskAbMg9DUu7v4ZH6ZysIeIudbSgOvex/kj5kmcSBMCkIuvqFoqYa9pymfkA83uZZ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555645; c=relaxed/simple;
	bh=spXbC4lXgTI5vy3WmmjwGb5AIOM10ZluWotibzqLvWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxmDzKnNBfuB27i0kLCe56+X7w5yW6p3dSB6IEZ4gsfE/w8dTK5mDAyRDupmXMEMY2QBf2s8pdnrwo1n/luWfCHpaehLtpIf/Lf98+/YfCnfd3DNDW+0O0+xa8w/YTdIeEQ99BiykkL/zohkPTwzNYNfBq27ylsMPM/enf5cMhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpds4A5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpds4A5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7671F0089A;
	Fri,  9 Oct 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555640;
	bh=FfoCw/QzqZX2rcVHDOaozNQ8brzQvnNttp4LQHNXJOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpds4A5RNFqP7jXzdtzpxpUL9SolQD8wDXtencrNC9PCn0go7fS3q/gyLH/l5ZRbO
	 4NfqogQdtYiHDrXoQPEZxk2aWXpeKfF/TP0kLJVJS6YrOOUWZpyajRzjhY8KoD74IY
	 9JwQscedHWU1ii/HB8sykFVbzU6LQWBiJ2TTNBUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qishuai Liu <lqs@lqs.me>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/403] ipv6: fix prefix route expiry in modify_prefix_route()
Date: Fri,  9 Oct 2026 16:07:33 +0200
Message-ID: <20261009140954.242766004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qishuai Liu <lqs@lqs.me>

[ Upstream commit a7bfaba4823e3c165bb2004c74eff7c096672bc7 ]

modify_prefix_route() is given the lifetime in clock_t relative to now,
but fib6_set_expires() wants an absolute jiffies value. So when a
permanent address is changed to a finite valid_lft, the prefix route
ends up already expired and GC removes it.

Steps to reproduce:

  ip link add dummy9 type dummy
  ip link set dummy9 up
  ip -6 addr add 2001:db8:9::1/64 dev dummy9
  ip -6 addr change 2001:db8:9::1/64 dev dummy9 valid_lft 3600 preferred_lft 3600
  ip -6 route show dev dummy9    # expires is negative

Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Signed-off-by: Qishuai Liu <lqs@lqs.me>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260923132048.3272878-1-lqs@lqs.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 80706368a303c..81f5bda2a89fc 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4861,7 +4861,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 			fib6_clean_expires(f6i);
 			fib6_may_remove_gc_list(net, f6i);
 		} else {
-			fib6_set_expires(f6i, expires);
+			fib6_set_expires(f6i, jiffies + clock_t_to_jiffies(expires));
 			fib6_add_gc_list(f6i);
 		}
 
-- 
2.53.0



