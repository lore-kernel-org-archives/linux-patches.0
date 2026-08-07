Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74E7280331;
	Fri,  7 Aug 2026 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116773; cv=none; b=qDy1fylCiofnj4cLMTUXt9TZ5GavVfkfLcSfFECMJUkj+kijzaXScteoW3WKeLRZthCyhjuHHxrRgHhksRWE61/86wZyup+WEUwa2n+VNVNAX2bkXFsQ843AonBSApG56b61I59G8kch07W+IE3hOJD+BdCFXLcDL3rswxMu+Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116773; c=relaxed/simple;
	bh=LjJZFETQsyCR8sQNOX0EPjObPnjBif3YT96ebIjpu7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUXXsxcZryk4GIe2OXTVz1QtkF2383dySKDf6xpLp+7F3VW7r4WDHNnGZLXUOi/8RudYEOI0Hnn+DTtUxAm8ZqPgt8gGyPtrzM186dSf6PTDeSRGLDmPR3kmV+674kROAzuhwwAUxi0iEpw9KFuAqzqfGZcnzflorD7TgjE+zKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBkM6dmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBkM6dmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAEF1F000E9;
	Fri,  7 Aug 2026 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116771;
	bh=/x3RBQhCq+CVqib4fNymPrxSCMb5bdzDUCoh9eHyplI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBkM6dmWcyhkEkpkM8zQVEQsw072EcVJIZnChnYVnkXPYCVSXJFb1Dwr33Dg5xFYx
	 zr0rJQus0lLROCSt5tSnADtmdesFOwfKbdcoJQSl4vaarRGmisJkIAW5q6AUNhfvg2
	 PmGW7CF26d4/G0p04u7Ksj1nxHmEPvcb/QSZvBN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 068/438] rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()
Date: Fri,  7 Aug 2026 16:34:24 +0200
Message-ID: <20260807143429.437490632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 76f441cbf50e6..c20dc6d5ca65d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -336,23 +336,25 @@ int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
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



