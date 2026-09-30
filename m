Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD13E2777;
	Wed, 30 Sep 2026 19:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796537; cv=none; b=qscQNqTK42/MgH7uInZ7Dp35QBOvZ9k6vbj8O0pWpbSiENB5yfIkjNgVM6X4WG7Vcx37mVTWQiHYNwEEfvpTt8AbTYYJvU8AKyRp8QBqkO8mvmd6w4sVdrYN1mG/URpISOFmaprmzBOgHYL34unFGzV5qf8C8AYz+dP47KV2j9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796537; c=relaxed/simple;
	bh=3yJfZXJvbdG+kDVTYn/WtdR0KWy8XSBt7OApt+W5CFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGRgoOOsTR+9gfmtVuwjPZJRwy6FNlXh2/vjIJE76dct1aXR9fjeqckZfv5p/ThsgqZm3r0SOj/orJtXN6V6oY+eyXexUnZV9WxHHxAD+zm946+UiuxD5eNkiREOwkMjAiNj6MjiIICuSUtjZNdaxP/i4sHLSla4zdOvCGDjfrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUrRv2kY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUrRv2kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0121F000FF;
	Wed, 30 Sep 2026 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796536;
	bh=gsisfIf/rIGYfEj/3alPGRK8hcZulzM/zvFMvv7GV4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUrRv2kYo0LKLB7a7KPjxrD0uDThatY1i7XHIR21ow5exY3LJ+KA+tYLYkCptZecw
	 QL/y5XFeBGI0v0zvZmrAv9s1pbK/yp06fy+YVO7V9Zz39mR10NVyiFq/XRVbcOAsNe
	 MVmug6Iu+UBXDfbgqXd1ZzQIfBmIp//N3/0MPcXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0946/1193] ipv6: mcast: use copy-on-write RCU updates in ip6_mc_source()
Date: Wed, 30 Sep 2026 17:27:10 +0200
Message-ID: <20260930152455.257565452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c073d1b070f171d206b19c98d71739a97f15b3f1 ]

pmc->sflist is read locklessly under rcu_read_lock() by
inet6_mc_check() during packet reception in the UDP and RAW
multicast receive paths.

ip6_mc_source() mutated psl->sl_addr and psl->sl_count in-place
when adding or removing a source filter. Additionally, when expanding
the filter buffer, newpsl was published via rcu_assign_pointer()
before writing the new source into the array.

Because 16-byte struct in6_addr writes are not atomic and array
shifting is not synchronized with RCU readers, concurrent readers in
inet6_mc_check() could read torn IPv6 addresses or observe
duplicated/missed source entries.

Fix this by switching ip6_mc_source() to copy-on-write RCU updates:
allocate and fully populate newpsl before publishing it via
rcu_assign_pointer(), and reclaim the old filter via kfree_rcu(),
matching ip6_mc_msfilter().

Also remove the now unused IP6_SFBLOCK macro.

Fixes: 882ba1f73c06 ("mld: convert ipv6_mc_socklist->sflist to RCU")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828084531.1826790-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/if_inet6.h |  2 -
 net/ipv6/mcast.c       | 98 ++++++++++++++++++++++++------------------
 2 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 31bf475eca762..b657b916ddedd 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -88,8 +88,6 @@ struct ip6_sf_socklist {
 	struct in6_addr		sl_addr[];
 };
 
-#define IP6_SFBLOCK	10	/* allocate this many at once */
-
 struct ipv6_mc_socklist {
 	struct in6_addr		addr;
 	int			ifindex;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d61933dd107f8..30c8af655db1b 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -380,12 +380,12 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 {
 	struct ipv6_pinfo *inet6 = inet6_sk(sk);
 	struct in6_addr *source, *group;
+	struct ip6_sf_socklist *newpsl, *psl;
 	struct net *net = sock_net(sk);
 	struct ipv6_mc_socklist *pmc;
-	struct ip6_sf_socklist *psl;
 	struct inet6_dev *idev;
 	int leavegroup = 0;
-	int i, j, rv;
+	int i, j;
 	int err;
 
 	source = &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
@@ -434,13 +434,11 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
-		rv = !0;
 		for (i = 0; i < psl->sl_count; i++) {
-			rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
-			if (rv == 0)
+			if (ipv6_addr_equal(&psl->sl_addr[i], source))
 				break;
 		}
-		if (rv)		/* source not found */
+		if (i == psl->sl_count)		/* source not found */
 			goto done;	/* err = -EADDRNOTAVAIL */
 
 		/* special case - (INCLUDE, empty) == LEAVE_GROUP */
@@ -449,58 +447,74 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
 			goto done;
 		}
 
+		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+			   &sk->sk_omem_alloc);
+
+		if (psl->sl_count == 1) {
+			newpsl = NULL;
+		} else {
+			newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr,
+							      psl->sl_count - 1),
+					      GFP_KERNEL);
+			if (!newpsl) {
+				atomic_add(struct_size(psl, sl_addr, psl->sl_max),
+					   &sk->sk_omem_alloc);
+				err = -ENOBUFS;
+				goto done;
+			}
+			newpsl->sl_max = psl->sl_count - 1;
+			newpsl->sl_count = psl->sl_count - 1;
+			for (j = 0; j < i; j++)
+				newpsl->sl_addr[j] = psl->sl_addr[j];
+			for (j = i + 1; j < psl->sl_count; j++)
+				newpsl->sl_addr[j - 1] = psl->sl_addr[j];
+		}
+
 		/* update the interface filter */
 		ip6_mc_del_src(idev, group, omode, 1, source, 1);
 
-		for (j = i+1; j < psl->sl_count; j++)
-			psl->sl_addr[j-1] = psl->sl_addr[j];
-		psl->sl_count--;
+		rcu_assign_pointer(pmc->sflist, newpsl);
+		kfree_rcu(psl, rcu);
 		err = 0;
 		goto done;
 	}
 	/* else, add a new source to the filter */
 
-	if (psl && psl->sl_count >= sysctl_mld_max_msf) {
+	if (psl && psl->sl_count >= READ_ONCE(sysctl_mld_max_msf)) {
 		err = -ENOBUFS;
 		goto done;
 	}
-	if (!psl || psl->sl_count == psl->sl_max) {
-		struct ip6_sf_socklist *newpsl;
-		int count = IP6_SFBLOCK;
-
-		if (psl)
-			count += psl->sl_max;
-		newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr, count),
-				      GFP_KERNEL);
-		if (!newpsl) {
-			err = -ENOBUFS;
-			goto done;
-		}
-		newpsl->sl_max = count;
-		newpsl->sl_count = count - IP6_SFBLOCK;
-		if (psl) {
-			for (i = 0; i < psl->sl_count; i++)
-				newpsl->sl_addr[i] = psl->sl_addr[i];
-			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
-				   &sk->sk_omem_alloc);
+	if (psl) {
+		for (i = 0; i < psl->sl_count; i++) {
+			if (ipv6_addr_equal(&psl->sl_addr[i], source))
+				goto done; /* err = -EADDRNOTAVAIL */
 		}
-		rcu_assign_pointer(pmc->sflist, newpsl);
-		kfree_rcu(psl, rcu);
-		psl = newpsl;
 	}
-	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
-	for (i = 0; i < psl->sl_count; i++) {
-		rv = !ipv6_addr_equal(&psl->sl_addr[i], source);
-		if (rv == 0) /* There is an error in the address. */
-			goto done;
+
+	i = psl ? psl->sl_count + 1 : 1;
+	newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr, i),
+			      GFP_KERNEL);
+	if (!newpsl) {
+		err = -ENOBUFS;
+		goto done;
 	}
-	for (j = psl->sl_count-1; j >= i; j--)
-		psl->sl_addr[j+1] = psl->sl_addr[j];
-	psl->sl_addr[i] = *source;
-	psl->sl_count++;
-	err = 0;
+	newpsl->sl_max = i;
+	newpsl->sl_count = i;
+	if (psl) {
+		for (j = 0; j < psl->sl_count; j++)
+			newpsl->sl_addr[j] = psl->sl_addr[j];
+	}
+	newpsl->sl_addr[i - 1] = *source;
+
 	/* update the interface list */
 	ip6_mc_add_src(idev, group, omode, 1, source, 1);
+
+	if (psl)
+		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
+			   &sk->sk_omem_alloc);
+	rcu_assign_pointer(pmc->sflist, newpsl);
+	kfree_rcu(psl, rcu);
+	err = 0;
 done:
 	mutex_unlock(&idev->mc_lock);
 	in6_dev_put(idev);
-- 
2.53.0



