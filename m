Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621603;
	b=xmSJx4PR8AYKwI5DOH+PP0ucFfzzzhelYli8pHFrOHi64H2P6zviFwCUOa8eZqFpN/Fs
	 HfWsS+T2uH39F4V/QsdjQDuGYJXOwneDXUavrwh+kS3qMVpgpAlsIV24E8VdSgvHVALlM
	 EZK9d5SnYliFwv5xgjeAWjBOkZI7F1+VbFBQW5KFbv4ysPqzLZXChwS1b89t554DPrPi/
	 k1wMAVYagOMgyaFnio8an0Csksnxgm0QuaaXaILWJmyn7oZGeos0LR0SX5CuNJmlSGJ5F
	 oYxgGuj97+gFUNw1aUFFrwShZQ7nRu1UT2kNlGtqSgWw8ph9fMCbHiCKPPWTH8MKtpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BxHpUAroO05Sa+AeaXaM6VGe1n+igWCPMa4hIUA66FQ=;
	b=DEWag/MJrl/13ufkJMmfcxmo3zMeRaiOuyRlLKG7l3ER3q/bR0aH0djSJnjTeh2TdH/s
	 YyKSK2aMalzEY0tAeaBNJ1G6cbWLn5xNYzdffP/IBZ+PIAmVPRH/hdecyxNXNCQkuDwZP
	 D1H9P+ETiRutVaOGGc8bKzM03X/DJSDYZKTL4VfmhChdZSS+ZNKgdfE0YvoZkg09ey7Rp
	 gyPBmAWWhn7WQ6Zn9YOyZw1BRVSly4z6v2MmvkJEHFFcdrFu5CZw08vSw7QkK9RaBCFao
	 ZyV7Y0iAaOgB1RHaRIcJJ40H8R7XWfTXZb0aMx47j8YxIiE1h3t+3h4ExG08iBVUfHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKa8XDwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB3D606A682;
	Wed, 25 Nov 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKa8XDwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531851F00AD4;
	Wed, 25 Nov 2026 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621602;
	bh=BxHpUAroO05Sa+AeaXaM6VGe1n+igWCPMa4hIUA66FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKa8XDwUSnkKsOMCoRyBlalkpPweFmpQWJCsCba2vpqIfbaLBgS7cfzhIWq1j5t5L
	 OacOjb4V2JgwvVz3xjkvCppgPdWK/T8eI4/sxdNqNJDgqLk5ql73ZAKyIyyNnTDxxO
	 ZZNMHOLeD31CQTUDojZrP5pU1NnigEf9UK/AEDjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/990] ip6mr: Serialize multicast router socket ownership
Date: Wed, 25 Nov 2026 15:27:25 +0100
Message-ID: <20261125143828.599283958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit c6b41de4dd9f2d6856d8d8d292348f7961034152 ]

MRT6_TABLE checks whether the socket owns its current table before
acquiring RTNL. MRT6_INIT also looks up its table before taking RTNL.
Consequently, concurrent TABLE and INIT calls can initialize the old
table and then change the socket's selected table. Another INIT can
register the same socket in the new table.

rawv6_close() calls ip6mr_sk_done(), which clears only the first table
owned by the socket. After the socket's RCU-delayed free, the other
table retains a dangling mroute_sk pointer. A subsequent multicast cache
report passes that pointer to sock_queue_rcv_skb_reason(). This produces
a KASAN slab-use-after-free in sk_filter_trim_cap().

Look up the selected table in ip6mr_sk_init() after acquiring RTNL.
Likewise, re-read the current table and check its owner under RTNL in
MRT6_TABLE before updating the selection. This preserves the single-table
ownership invariant shared with ip6mr_sk_done(), without changing the
locking of the other multicast socket options.

Fixes: d1db275dd3f6 ("ipv6: ip6mr: support multiple tables")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261030042221.73996-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index f61035619cac7..53837248498a6 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1580,12 +1580,20 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 	}
 }
 
-static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
+static int ip6mr_sk_init(struct sock *sk)
 {
-	int err = 0;
 	struct net *net = sock_net(sk);
+	struct mr_table *mrt;
+	int err = 0;
 
 	rtnl_lock();
+	mrt = __ip6mr_get_table(net,
+				raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
+	if (!mrt) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
 	spin_lock(&mrt_lock);
 	if (rtnl_dereference(mrt->mroute_sk)) {
 		err = -EADDRINUSE;
@@ -1601,6 +1609,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 					     NETCONFA_MC_FORWARDING,
 					     NETCONFA_IFINDEX_ALL,
 					     net->ipv6.devconf_all);
+out_unlock:
 	rtnl_unlock();
 
 	return err;
@@ -1699,7 +1708,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		if (optlen < sizeof(int))
 			return -EINVAL;
 
-		return ip6mr_sk_init(mrt, sk);
+		return ip6mr_sk_init(sk);
 
 	case MRT6_DONE:
 		return ip6mr_sk_done(sk);
@@ -1820,16 +1829,21 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		/* "pim6reg%u" should not exceed 16 bytes (IFNAMSIZ) */
 		if (v != RT_TABLE_DEFAULT && v >= 100000000)
 			return -EINVAL;
-		if (sk == rcu_access_pointer(mrt->mroute_sk))
-			return -EBUSY;
-
 		rtnl_lock();
 		ret = 0;
-		mrt = ip6mr_new_table(net, v);
-		if (IS_ERR(mrt))
-			ret = PTR_ERR(mrt);
-		else
-			raw6_sk(sk)->ip6mr_table = v;
+		mrt = __ip6mr_get_table(net,
+					raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
+		if (!mrt) {
+			ret = -ENOENT;
+		} else if (sk == rtnl_dereference(mrt->mroute_sk)) {
+			ret = -EBUSY;
+		} else {
+			mrt = ip6mr_new_table(net, v);
+			if (IS_ERR(mrt))
+				ret = PTR_ERR(mrt);
+			else
+				raw6_sk(sk)->ip6mr_table = v;
+		}
 		rtnl_unlock();
 		return ret;
 	}
-- 
2.53.0



