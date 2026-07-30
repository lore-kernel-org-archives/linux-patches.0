Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0C140963F;
	Thu, 30 Jul 2026 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421923; cv=none; b=B3LbsflrOIlCgFYrU46ncAVenEooivJC4F13p7qCESgziZTzW7BKcIxWzj8FPykwj9cWeK1fIN2gyfGj7iA6ba2YxjbO7VjKA4USI0QlTiCMXzRtj2glXZZ9c5Um/md39TFeFIVufKtav5Yi2RhFo23l3fbqpOLsrgitwCacQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421923; c=relaxed/simple;
	bh=OZC/fvBMGcvEm5a5X6PTiU59Y+FkAuj7DLV0RaJPanw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RenMWFcl9JFning3MAylRpC3tYm7MpOt3ubyll2pq+MTVwZOmwSyVnQrwFPSqwBpw6pdX75ibHdD7M5BCk6nIcNTBd0SReygA6V6Kv3bl4UqSPJtNUqExj+tXyc6si+6GyYflspkNunEBjxr1rMDojagbkaRGsea3WHvbydDObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJkTUOzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJkTUOzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE21F00A3A;
	Thu, 30 Jul 2026 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421922;
	bh=M1jE3uFuUCIwPavIBzlA68BFZeT7wIDpuRqY8ORfbMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJkTUOzGbAZx72nkawLNfgrv+glLQr62KAbEiwBUI8yuhkmHY5R1tQGk/O9+gV2ec
	 IcS0QQFz0VU5O0uvzxvZZ3SeH+21/xDGL1QoztLf1K1713KlJB6OonLrM9uhKsSyx6
	 3mIU1bg4o/ZImRPFBjLGmY/vdAtzv7wY0WcjbTc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 263/744] rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled
Date: Thu, 30 Jul 2026 16:08:56 +0200
Message-ID: <20260730141449.885606505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit 9c805e592a29be9e4e61ff1bd567da04aa8fd6f9 ]

When booting with the 'ipv6.disable=1' parameter, inet6_addr_lst
is never initialized because inet6_init() exits before addrconf_init()
is called to initialize it. An attempt to bind an RDS socket to
an ipv6 address results in a crash in __ipv6_chk_addr_and_flags()

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:__ipv6_chk_addr_and_flags+0x1df/0x7e0
Call Trace:
 <TASK>
 ipv6_chk_addr+0x3b/0x50
 rds_tcp_laddr_check+0x155/0x3b0 [rds_tcp]
 rds_trans_get_preferred+0x15d/0x2d0 [rds]
 ? trace_hardirqs_on+0x2d/0x110
 rds_bind+0x1433/0x1d60 [rds]
 ? rds_remove_bound+0xd50/0xd50 [rds]
 ? aa_af_perm+0x250/0x250
 ? __might_fault+0xde/0x190
 ? __sys_bind+0x1dc/0x210
 __sys_bind+0x1dc/0x210
 ? __ia32_sys_socketpair+0x100/0x100
 ? restore_fpregs_from_fpstate+0x53/0x100
 __x64_sys_bind+0x73/0xb0
 ? syscall_enter_from_user_mode+0x1c/0x50
 do_syscall_64+0x34/0x80
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
RIP: 0033:0x7f47f8269ea9
 </TASK>

The following code reproduces the issue:

struct sockaddr_in6 addr;
s = socket(PF_RDS, SOCK_SEQPACKET, 0);

memset(&addr, 0, sizeof(addr));
inet_pton(AF_INET6, ADDRESS, &addr.sin6_addr);
addr.sin6_family = AF_INET6;
addr.sin6_port = htons(PORT);

bind(s, &addr, sizeof(addr));

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller.

Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260709162723.367523-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib.c    | 4 ++++
 net/rds/ib_cm.c | 4 ++++
 net/rds/tcp.c   | 8 +++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 39f87272e071bf..8f9cf491984f12 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -429,6 +429,10 @@ static int rds_ib_laddr_check_cm(struct net *net, const struct in6_addr *addr,
 		sa = (struct sockaddr *)&sin;
 	} else {
 #if IS_ENABLED(CONFIG_IPV6)
+		if (!ipv6_mod_enabled()) {
+			ret = -EADDRNOTAVAIL;
+			goto out;
+		}
 		memset(&sin6, 0, sizeof(sin6));
 		sin6.sin6_family = AF_INET6;
 		sin6.sin6_addr = *addr;
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 4001de0c495938..9b25486fde81c8 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -810,6 +810,10 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 	dp = event->param.conn.private_data;
 	if (isv6) {
 #if IS_ENABLED(CONFIG_IPV6)
+		if (!ipv6_mod_enabled()) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
 		dp_cmn = &dp->ricp_v6.dp_cmn;
 		saddr6 = &dp->ricp_v6.dp_saddr;
 		daddr6 = &dp->ricp_v6.dp_daddr;
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5830b31a1f37b3..d3acad60315ab0 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -347,9 +347,11 @@ int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
 		rcu_read_unlock();
 	}
 #if IS_ENABLED(CONFIG_IPV6)
-	ret = ipv6_chk_addr(net, addr, dev, 0);
-	if (ret)
-		return 0;
+	if (ipv6_mod_enabled()) {
+		ret = ipv6_chk_addr(net, addr, dev, 0);
+		if (ret)
+			return 0;
+	}
 #endif
 	return -EADDRNOTAVAIL;
 }
-- 
2.53.0



