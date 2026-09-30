Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149951C335;
	Wed, 30 Sep 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788423; cv=none; b=dAg8Rj9DC9t+9uLfHBIgf3xpjmRY3n10Co02t21bzkjJxKQcLQCsL8UHKZAsXQDGfSwFUbpWYxgobmgQupDYfsYHx9J5QKMBDjPVtlASf17Fm0goiEPHocm51VvnjFZ7sTufYoUcP2tEljHDFQ9/ORsH0e/dUfWNxKL1pNjpsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788423; c=relaxed/simple;
	bh=fd5wtt4huHLG5McZ1yQEJLNB2nnep8Q4+p0urn70+MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrjMbRglFYbGDYs4c7zXvoNf6xxWAIygcGX2aaDoTyt9h+/K64Q1mCGt6Q7isg94wzPl9D0PlWGWMJ/XqQgOe1cPn6aER39kkODk0qDqviuRUrhiYBwHHY5f0JbMNmKeEwSw0OKohm5NsHwYt8+ZWfAl5jBIq13pr5fRjqLERzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5qjO7u1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5qjO7u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF5C1F000FF;
	Wed, 30 Sep 2026 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788422;
	bh=sc+JR8r1yvOPSxDfnhOMhPz4tjGCiOxs5AiEjw6cc9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5qjO7u1cPPRS0yCNIWkBV4G2K6NveE6DT//o2Qhto2QiLs4gw7SY9SE/tg30FEOr
	 hAuYswmQf28RMZDOMolQKDLIpBi8JxqvIHlvi8nEDckwbiERHrPMc4VFQtTgtqvkY0
	 rpTWk339YLiD3y+saa/upxYojc3sQljuGri1JtWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/877] ipv4: icmp: reject RTN_UNREACHABLE input routes in icmp_route_lookup
Date: Wed, 30 Sep 2026 17:17:11 +0200
Message-ID: <20260930152417.327199652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 7e391c2bc5bc0..3b0475f658105 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -573,16 +573,19 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
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



