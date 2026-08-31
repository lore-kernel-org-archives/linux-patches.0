Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E715447A899;
	Mon, 31 Aug 2026 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184478; cv=none; b=sqTDjY0CWzaYIM47ZOLVBkBdUs8V6LqgpLL+9aoHpV25IatHg3MvUuTaN+vuSYQtOZtL7XHaCsj+bHWL4ag66w5xSAL+jiNFwvxCCAsHyjel3AhGMwVsIsQRQOYdj8nOxYvRBHsrT8d+IDOYLiM22McpR9FX/T07+hYSSw5I/gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184478; c=relaxed/simple;
	bh=YXuNeIw498ClQJKxtEENIOyCIv8jgP9YdKJm1nAwHtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKYYo7wzHhG9qqvUFGyCQGQUIYEfD1wGoHMNrJuD7JZ6iaTgUAkzEOlnDpOueGXqH/xgj9p4kn1q5tyjOI+D2l//7itTWlZPqUs0+tqacBc3nxsHhhHaVtEoNfnASPmCIE8h6ocujZ53ujCIvECQMD6MJWHo0hYvslkXTQyZ9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuOBTFwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuOBTFwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6E81F000E9;
	Mon, 31 Aug 2026 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184476;
	bh=yL/AWeMZRy5U03mQXZsecFE1OaAQQt51BIZ13CKYFNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuOBTFwIZnmL6O0HUU7roAoCf361qMD9UgGr7m2OU9kEFjGFaPZh2WikfKcLRooId
	 6s/+Nw7J1gGdkxbwXP+DmQxfcuy+Zfs8BLttHzhSQVW0bC7AF1KYO9Jcw2aDlPWfZZ
	 u4m6LoXMfzAyho5gS5lOuChg+cEy8lGTRcC4D3uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/91] smc: Use __sk_dst_get() and dst_dev_rcu() in in smc_clc_prfx_set().
Date: Mon, 31 Aug 2026 15:34:09 +0200
Message-ID: <20260831133400.729313493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 935d783e5de9b64587f3adb25641dd8385e64ddb ]

smc_clc_prfx_set() is called during connect() and not under RCU
nor RTNL.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dev_dst_rcu() under rcu_read_lock()
after kernel_getsockname().

Note that the returned value of smc_clc_prfx_set() is not used
in the caller.

While at it, we change the 1st arg of smc_clc_prfx_set[46]_rcu()
not to touch dst there.

Fixes: a046d57da19f ("smc: CLC handshake (incl. preparation steps)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 1bf6cd010f04a..1859682dfb1cd 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -508,10 +508,10 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
 }
 
 /* find ipv4 addr on device and get the prefix len, fill CLC proposal msg */
-static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
+static int smc_clc_prfx_set4_rcu(struct net_device *dev, __be32 ipv4,
 				 struct smc_clc_msg_proposal_prefix *prop)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(dst->dev);
+	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	const struct in_ifaddr *ifa;
 
 	if (!in_dev)
@@ -529,12 +529,12 @@ static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
 }
 
 /* fill CLC proposal msg with ipv6 prefixes from device */
-static int smc_clc_prfx_set6_rcu(struct dst_entry *dst,
+static int smc_clc_prfx_set6_rcu(struct net_device *dev,
 				 struct smc_clc_msg_proposal_prefix *prop,
 				 struct smc_clc_ipv6_prefix *ipv6_prfx)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct inet6_dev *in6_dev = __in6_dev_get(dst->dev);
+	struct inet6_dev *in6_dev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifa;
 	int cnt = 0;
 
@@ -563,41 +563,44 @@ static int smc_clc_prfx_set(struct socket *clcsock,
 			    struct smc_clc_msg_proposal_prefix *prop,
 			    struct smc_clc_ipv6_prefix *ipv6_prfx)
 {
-	struct dst_entry *dst = sk_dst_get(clcsock->sk);
 	struct sockaddr_storage addrs;
 	struct sockaddr_in6 *addr6;
 	struct sockaddr_in *addr;
+	struct net_device *dev;
+	struct dst_entry *dst;
 	int rc = -ENOENT;
 
-	if (!dst) {
-		rc = -ENOTCONN;
-		goto out;
-	}
-	if (!dst->dev) {
-		rc = -ENODEV;
-		goto out_rel;
-	}
 	/* get address to which the internal TCP socket is bound */
 	if (kernel_getsockname(clcsock, (struct sockaddr *)&addrs) < 0)
-		goto out_rel;
+		goto out;
+
 	/* analyze IP specific data of net_device belonging to TCP socket */
 	addr6 = (struct sockaddr_in6 *)&addrs;
+
 	rcu_read_lock();
+
+	dst = __sk_dst_get(clcsock->sk);
+	dev = dst ? dst_dev_rcu(dst) : NULL;
+	if (!dev) {
+		rc = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (addrs.ss_family == PF_INET) {
 		/* IPv4 */
 		addr = (struct sockaddr_in *)&addrs;
-		rc = smc_clc_prfx_set4_rcu(dst, addr->sin_addr.s_addr, prop);
+		rc = smc_clc_prfx_set4_rcu(dev, addr->sin_addr.s_addr, prop);
 	} else if (ipv6_addr_v4mapped(&addr6->sin6_addr)) {
 		/* mapped IPv4 address - peer is IPv4 only */
-		rc = smc_clc_prfx_set4_rcu(dst, addr6->sin6_addr.s6_addr32[3],
+		rc = smc_clc_prfx_set4_rcu(dev, addr6->sin6_addr.s6_addr32[3],
 					   prop);
 	} else {
 		/* IPv6 */
-		rc = smc_clc_prfx_set6_rcu(dst, prop, ipv6_prfx);
+		rc = smc_clc_prfx_set6_rcu(dev, prop, ipv6_prfx);
 	}
+
+out_unlock:
 	rcu_read_unlock();
-out_rel:
-	dst_release(dst);
 out:
 	return rc;
 }
-- 
2.53.0



