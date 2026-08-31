Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1926F585983;
	Mon, 31 Aug 2026 13:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184209; cv=none; b=XsYQW4xTB4hcB6FM7X3qllIYlzJivMC/qRG8/m/L1OlKgDoVynBnVWUCSL1JVBa/WrphvP/MLf+20AFo6tJdJGJv79e/j4N1kxEmKhsn5t5IEJtpYo/Lt5opU0M1+kYoVnhoXkAFhJntfcBgUH+EmMSM1dT0wDkxaCIu+tKGW0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184209; c=relaxed/simple;
	bh=ROi3oSR8Tj+f8NwyW42eSgsDpDGZceUrNZjxtAxEfqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxInP8xCM6Wux5aV/2F25jd2FPE98njkhSS9wcCs6K9vjadVTS0rWu6jsaHHOZodtTsG48Tv7UknMLvqGcSFm49rX50utDI31rLED8Sw5vnxe1MdtAvj2k7/jnk891Fob6UgkzVhheGJkuDQfjw7nSwwCt1wzbUvNhpOlMiKzuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpA8TPIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpA8TPIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601D71F00A3F;
	Mon, 31 Aug 2026 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184207;
	bh=n2RtWnI8klET3V5l+z5iXHnz+m2HkVAXIlQWv3U5QlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpA8TPIC19lMGYec0kiIy8Mx2/MvT52NfmPMMn6cGlj5eQzyoPPMTRqUuIIXjaXDo
	 y7w5F4n0QD7FgTmUPsUJFD9pWoNQhIEDngaLhrKinjThat6YCWqsQ8DLt+8q3TYVpo
	 vXUe8TQ85YcubdU77YEmuPflWRfipXSxldyg4GYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 28/99] smc: Use __sk_dst_get() and dst_dev_rcu() in in smc_clc_prfx_set().
Date: Mon, 31 Aug 2026 15:33:57 +0200
Message-ID: <20260831133401.386666728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
index c2b2b76a8f627..467bd33f44019 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -509,10 +509,10 @@ static bool smc_clc_msg_hdr_valid(struct smc_clc_msg_hdr *clcm, bool check_trl)
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
@@ -530,12 +530,12 @@ static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
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
 
@@ -564,41 +564,44 @@ static int smc_clc_prfx_set(struct socket *clcsock,
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



