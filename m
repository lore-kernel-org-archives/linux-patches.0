Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4D3AA1BC;
	Tue, 13 Oct 2026 11:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892123; cv=none; b=JcpgvmKVFbwsjn/BcFHq1JwusYY4/RPRxiItn8nepCyeLyCytjRmVTUt/QdpfRf5QbEaUSQW1jvnJDWT+ECXpV1ZxRF/JPVuF8+qQ5U0VOtUnYxT3F9iKp/Uf/FV9FKPMXIltt7j4+U3tORJJEtnHcFIcwVOs9ezg1lGJ2ZxHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892123; c=relaxed/simple;
	bh=Ie4JpirbupD17n7FHvej96gV+6/DwYR5Ytg1OyJgzg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm3JBN87baKZax5AQolV3kM7QacRBP6/9ek5ssqmRKYesyJ+niZ0iEpqytsIgx10uQnzLGT0sH/m3jf1Qvjiz1JLTBfo54wNMpVW3cRPcuTyKSQ8brfrUd0Tn7Y/N+ar8uMxirEYpDkXt9yXbQLyB/jgvfl+p28A/XqEKYcqfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQh7Y7jj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQh7Y7jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029041F000FF;
	Tue, 13 Oct 2026 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892120;
	bh=Q+qjKic9Tg4+bt03i8vncEWgdoxGFtUjDSFGvfuz+0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQh7Y7jj1TmN3LHhQCBSBvCe/TVYNiMC3Xb0AbmEqO/jnqS8jwZBGfmQ8m7WWenEb
	 qphG83N1FdUnd4YKignYtswXbyicLL1tVLU9PfsyXvMwcTo/ledD7Y8P6EoWBJknX1
	 js1R95w0bOKXS6BbyH4NogdSOfTJY9XorwPglWnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 066/281] ip6_gre: remove obsolete ERSPAN PMTU update
Date: Tue, 13 Oct 2026 13:36:22 +0200
Message-ID: <20261013112856.732606826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 8bc60db48e8cba35488bbd6e1f94aa990afa275a upstream.

A tc tunnel_key action can attach a METADATA_IP_TUNNEL dst to an skb,
and mirred can redirect it to a native ip6erspan device. The legacy PMTU
update in ip6erspan_tunnel_xmit() treats that metadata dst as a route.
Since it has no output device, dst_dev(dst)->mtu dereferences NULL.

On v7.2 with KASAN, an initial UID/GID 65534 process with CapEff 0 used
self-created user and network namespaces to trigger:

  KASAN: null-ptr-deref
  RIP: ip6erspan_tunnel_xmit+0x10fc/0x2cc0
  Kernel panic - not syncing: Fatal exception in interrupt

The update is obsolete. Commit fe1a4ca0a2b7 ("ip6_gre: process toobig
in a better way") changed IPv6 GRE Too Big handling to update the
underlay route and removed the equivalent block from __gre6_xmit().
ip6_tnl_xmit() then propagates the underlay PMTU to the overlay route.

Remove the stale ERSPAN copy and its now-unused dst variable. This
eliminates the metadata-dst dereference and keeps ERSPAN aligned with
IPv6 GRE PMTU handling.

Fixes: 5a963eb61b7c ("ip6_gre: Add ERSPAN native tunnel support")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261002033058.358137-1-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -923,7 +923,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 {
 	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct dst_entry *dst = skb_dst(skb);
 	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	bool truncate = false;
 	int encap_limit = -1;
@@ -1059,12 +1058,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 	gre_build_header(skb, 8, flags, proto, 0,
 			 htonl(atomic_fetch_inc(&t->o_seqno)));
 
-	/* TooBig packet may have updated dst->dev's mtu */
-	if (!t->parms.collect_md && dst) {
-		mtu = READ_ONCE(dst_dev(dst)->mtu);
-		if (dst_mtu(dst) > mtu)
-			dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
-	}
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
 	if (err != 0) {


