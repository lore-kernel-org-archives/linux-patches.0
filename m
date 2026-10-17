Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F292E8DEB;
	Sat, 17 Oct 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256465; cv=none; b=apmsjRYK2mRa+L2tXnySLqabBlkGz+RpzTq+m939gTu1B5A8yqi1bO+S2vTP1yRLRAjyGBhv9K/Z8AihZssK+8/N4GfS/rjxkSCW7AuoQgEKqV+uAd+a4h7NksoAKrOJDXiNjD72H7a+foNpdaZpR/mH/DnhyDAvbJxwVuG9rqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256465; c=relaxed/simple;
	bh=+n3vYazIX71l213UUnA5q0kGcU3WQCvQH+Q9YgVbqmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZJANQHcOenC8bFiFtWyeSI7rDhNRZg7Aq/ZfLWnqHKhLf0khIMRADSoZ5p90Ltgk/DLs7xUnJiSP91RW8jc68PmNp6ebgHjawxf4IoubyGGtDc93wEVtgmo5+9lkJKwzWpa9hvZnFN3kpZtdm7Zmhf2/Fc7Gt9AvgQ9tHsgNm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS6jvhA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS6jvhA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119A61F000C4;
	Sat, 17 Oct 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256464;
	bh=8l5ZTKOoKSxCEPAziIMCgZs/bzNSb3iA2rbDrSd8w5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vS6jvhA6abqmCdzb1TYZd6efFPq53kdXCWDfJCAREaeiij0QzKQ+PA/Ly49LieLPF
	 UgsBE8zkq9Fhcb3BnkE982WX2LRabV/uDXmtCf9+FTAt3r2wCcPMV49haCiAvDPIB/
	 dMg5eweWXocJTiR1f1S8yKiLjky6Gmj1iI3NcBeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qishuai Liu <lqs@lqs.me>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0208/1674] ipv6: fix prefix route expiry in modify_prefix_route()
Date: Sat, 17 Oct 2026 17:41:20 +0200
Message-ID: <20261017160436.487336983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 24111053ebcea..47ea00e964439 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4837,7 +4837,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 			fib6_clean_expires(f6i);
 			fib6_may_remove_gc_list(net, f6i);
 		} else {
-			fib6_set_expires(f6i, expires);
+			fib6_set_expires(f6i, jiffies + clock_t_to_jiffies(expires));
 			fib6_add_gc_list(f6i);
 		}
 
-- 
2.53.0



