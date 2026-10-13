Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E05218E91;
	Tue, 13 Oct 2026 12:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894840; cv=none; b=gdFbEu2tS2qVHb3utNnfXMXb/76n27X1Q4hh/XrXlHT/TPd6BG3NBdFQWMabFGHTApqDx6YXIWChcANFDppb+FtR3wzhFGF8e6UctF+VInN8D2vnDUAkdp3d9QbJCSdw3zNs7cnm98owvHgIJ7t1LZYZPiZ93RN7VbSG+ffDcKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894840; c=relaxed/simple;
	bh=Gmk8ZHMRdPiXt/X/5KJzfxXqMiI4o40CFHhA1fgPPFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpPBEVemWykIBripHVhrSLGNs+NHOlshJMoqkoJ8x/xziM8qVpPaZ1b93qGDgHgyZ7Y27Q4KRFWQ2aY7olodD1ofLTBHRSn7vLCeNCupjiKNaVK/crK5A7NRo9nXJuZr83rqe5wlnCTtGL2CZpqbiaTpgSyn4rmWJhWxSxbmvo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcKsR5bZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcKsR5bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3671F00893;
	Tue, 13 Oct 2026 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894839;
	bh=VkChw3+wsRvHCC5+cqbevml0NhQR1cNW3wlUNLL6kq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcKsR5bZh6aTVHCYW89q67MAcnKMFfWwDtv3MiyuSyoY1wpRduObkg/2xh7cO3TQQ
	 1w2YWWIr1Nh2pVjr329+G45XB3hKkurcwDwEhJZA/Ro9l5uwsNmu/dchj7rxaZHc72
	 QbE2JKMps1YJC++gZFN2L/QWaAyiXXXCqLPDZUHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qishuai Liu <lqs@lqs.me>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/497] ipv6: fix prefix route expiry in modify_prefix_route()
Date: Tue, 13 Oct 2026 13:34:00 +0200
Message-ID: <20261013112909.619376740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index fb239e8f83593..33439672b071b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4873,7 +4873,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 			fib6_clean_expires(f6i);
 			fib6_may_remove_gc_list(net, f6i);
 		} else {
-			fib6_set_expires(f6i, expires);
+			fib6_set_expires(f6i, jiffies + clock_t_to_jiffies(expires));
 			fib6_add_gc_list(f6i);
 		}
 
-- 
2.53.0



