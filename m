Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A2388E6E;
	Fri,  7 Aug 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113841; cv=none; b=dBdsMxkFeE0M+mUV9LxKGSV/lBFhIHzqZNzFvQc0vZu9iOJCVPgMtFQAsoNHxKUJej/NiPcN31sFE37KH7321BdWaZ/Ju6pKd40Hx99BPv8mZOaiIjI2eClAwjZPo+BGWCWLMyFTHZ8RqxoQkqM++npbgzvwJI8woxSqTj33wBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113841; c=relaxed/simple;
	bh=D25OIwsMzzYSG/XXzJubAxUgl/5AhWL7xpVv/m94UHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA8paA/LpaxjELY08osZ82LhGtfddTiQ3joel3q2PBHN7xvCHe5FCQjfn8CK/Hhou9wjwU+eTN3k+4w86h7s/zoqe8lOR/2518/NRUIoOkiNIwGymhlIO3uDLjohLeOBUO6dy78+BUe+gXZR8Lmorgsa3fBgovAHPa8nJzzq0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVIYBRg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVIYBRg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C0F1F000E9;
	Fri,  7 Aug 2026 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113837;
	bh=wxnjX5oOjSBIq+g1ZbLHHm9jrHGVy+NWUCty/F/JLQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVIYBRg+3ZNeQKxsTXVVHMuZcBQZKRVF83EVUCmg0QchWBLTWC9kyMZDmwtqa6OXF
	 MNDw0zRqNWXzQ2AQYjJU7XKvVQ4dUnpEZcGPNsX6MwG3BH/uGK7x+ecl7Pla9fkGkT
	 vsW9/K/GK3cK9g6fGkKvcyAv+2qFBHLDiTMzOBZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/337] rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()
Date: Fri,  7 Aug 2026 16:34:15 +0200
Message-ID: <20260807143419.645806886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 78f75d632f74b8de0f081a128588f7c37d0d1164 ]

rds_tcp_laddr_check() looks up a scoped IPv6 interface with
dev_get_by_index_rcu(), drops the RCU read-side lock, and only then
passes the bare struct net_device * into ipv6_chk_addr().

dev_get_by_index_rcu() only keeps the device alive within the same RCU
read-side section. After rcu_read_unlock(), a concurrent RTM_DELLINK can
free the net_device; ipv6_chk_addr() then dereferences the stale pointer
in __ipv6_chk_addr_and_flags() (e.g. l3mdev_master_dev_rcu(dev)), reading
freed memory.

Keep the RCU read-side lock held across the ipv6_chk_addr() call instead
of dropping it right after the lookup, so the device cannot be freed
while it is in use.

  BUG: KASAN: slab-use-after-free in __ipv6_chk_addr_and_flags (... net/ipv6/addrconf.c:1998)
  Read of size 8 at addr ffff8880106ec000 by task exploit/153
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   __ipv6_chk_addr_and_flags (... net/ipv6/addrconf.c:1998)
   ipv6_chk_addr (net/ipv6/addrconf.c:2031 net/ipv6/addrconf.c:1972)
   rds_tcp_laddr_check (net/rds/tcp.c:370)
   rds_bind (net/rds/bind.c:248)
   __sys_bind (net/socket.c:1920)
   __x64_sys_bind (net/socket.c:1956)
   do_syscall_64 (arch/x86/entry/syscall_64.c:63)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260722210203.565803-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 87e6ab0e93b71..1980a197034ba 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -331,23 +331,25 @@ int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
 	/* If the scope_id is specified, check only those addresses
 	 * hosted on the specified interface.
 	 */
+	rcu_read_lock();
 	if (scope_id != 0) {
-		rcu_read_lock();
 		dev = dev_get_by_index_rcu(net, scope_id);
 		/* scope_id is not valid... */
 		if (!dev) {
 			rcu_read_unlock();
 			return -EADDRNOTAVAIL;
 		}
-		rcu_read_unlock();
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (ipv6_mod_enabled()) {
 		ret = ipv6_chk_addr(net, addr, dev, 0);
-		if (ret)
+		if (ret) {
+			rcu_read_unlock();
 			return 0;
+		}
 	}
 #endif
+	rcu_read_unlock();
 	return -EADDRNOTAVAIL;
 }
 
-- 
2.53.0



