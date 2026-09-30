Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47FF47A0DD;
	Wed, 30 Sep 2026 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785894; cv=none; b=d8r8M+KgCQ4ewpaPS0vtpuMN9auRkS3lI1RpqMQgbtN0OKUDA1f7nzpD2P1zr/wYM+ZLTw8ioVTp0qkJ0A4YFBbQeTgrpAP7a8b1PnMEvoE5T7c6A5vrPr5QITvj2AM9a2YF2tCy9KdnagHKaasNlquVdT5dS5p/83I2Twroekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785894; c=relaxed/simple;
	bh=B4BpZLVXCBsoXyKQ/sgqj63dBptiXe8lDdA/hIgIZnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzh9MH8OYMBlMCu/NUZzQWutwLUoC+sVcvKEUnaypTqkyiPCfo4SKJyrnqp1vQIm4BBsAk6+6UaBhSHN6qj7BQgOxxeKKvz+7Csb/cvqM7YpG8Ib7kh5CiRlboeYPOyZpiM0jqRYoQNwFEbfoPEMrkCReK/xe76YGlUStF6V0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xHHeClh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xHHeClh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497A31F000FF;
	Wed, 30 Sep 2026 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785892;
	bh=+d/SjG06IDqaK4L9SOxQeHgFuSIr0/mHupsGRC1y1Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xHHeClh707cBjQYt2ur3IFtrHWD3zSMmgtKp+/ZtstVi0YMd6YOek5BVIYcZ8U02
	 rnxGLZKCeGCS72fg2O3HkXrslauzO3CC/+/rtvjT8m09j0hcexr0dYRIWBNqncRaP/
	 +31PQiakwdxsSdpsOBnh4/jECao20NGNKgAQoYV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 668/982] ipv4: icmp: reject RTN_UNREACHABLE input routes in icmp_route_lookup
Date: Wed, 30 Sep 2026 17:23:24 +0200
Message-ID: <20260930152431.113619425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 2998147b59c9df0a51477c7a6b3d1f0ba3127dd4 ]

When the forward output route cannot be used in icmp_route_lookup(),
it enters the "reverse path" and calls ip_route_input() on fl4_dec.daddr,
the original packet's source address.

ip_route_input() only returns an error for truly invalid packets. For
unreachable addresses it will succeed and return an input route whose
dst.output is set to ip_rt_bug(). The existing check only rejects
RTN_LOCAL routes, so the RTN_UNREACHABLE route types can still be returned
and later used for output, syzkaller triggering a WARN_ON_ONCE()
in ip_rt_bug() as bellow:

 ------------[ cut here ]------------
 WARNING: net/ipv4/route.c:1273 at ip_rt_bug+0x14/0x20
 RIP: 0010:ip_rt_bug+0x14/0x20
 Call Trace:
  ip_push_pending_frames+0xfa/0x100
  __icmp_send+0x905/0xf10
  ip_options_compile+0xc0/0xd0
  ip_rcv_finish_core+0x321/0xae0
  ip_rcv+0x1de/0x260
  __netif_receive_skb_one_core+0x11a/0x130
  netif_receive_skb+0x7b/0x260
  tun_get_user+0x11bf/0x1c10
 ------------[ cut here ]------------

Reject input route that is RTN_UNREACHABLE to fix it. The net warning
is only printed for RTN_LOCAL, as RTN_UNREACHABLE is not the result of
a race condition.

Fixes: 8b7817f3a959 ("[IPSEC]: Add ICMP host relookup support")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Link: https://patch.msgid.link/20260910140042.1880242-1-dongchenchen2@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 5c38af80bc14e..28f0a10034e73 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -571,16 +571,19 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 		skb_dstref_restore(skb_in, orefdst);
 
 		/*
-		 * At this point, fl4_dec.daddr should NOT be local (we
-		 * checked fl4_dec.saddr above). However, a race condition
-		 * may occur if the address is added to the interface
-		 * concurrently. In that case, ip_route_input() returns a
-		 * LOCAL route with dst.output=ip_rt_bug, which must not
-		 * be used for output.
+		 * fl4_dec.daddr is not expected to be local here, but it can be
+		 * added to an interface concurrently, in which case
+		 * ip_route_input() returns a LOCAL route. It can also fail to
+		 * build a forwarding route towards fl4_dec.daddr, for example,
+		 * when forwarding is disabled, and return an UNREACHABLE route.
+		 * Both cases will result in a route with dst.output=ip_rt_bug,
+		 * which must not be used for output.
 		 */
-		if (!err && rt2 && rt2->rt_type == RTN_LOCAL) {
+		if (!err && rt2 && rt2->rt_type == RTN_LOCAL)
 			net_warn_ratelimited("detected local route for %pI4 during ICMP sending, src %pI4\n",
 					     &fl4_dec.daddr, &fl4_dec.saddr);
+		if (!err && rt2 &&
+		    (rt2->rt_type == RTN_LOCAL || rt2->rt_type == RTN_UNREACHABLE)) {
 			dst_release(&rt2->dst);
 			err = -EINVAL;
 		}
-- 
2.53.0



