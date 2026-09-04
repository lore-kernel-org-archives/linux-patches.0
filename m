Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F83B19BC;
	Fri,  4 Sep 2026 05:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499966; cv=none; b=R81SMdsLZNSGxG/TXEZt7KhqyQuaSesiCIEFTqrLQ9AcxACaj9O3dYh9c8q06zGEKh4FMlT6VasLtfKgLem9JdS8gUc4ooaMZ+Vlvkt0KRvJC2T5jujPdoZ+HFu7cwPIOdcRtWGRt3uKUnaW5NdXCVr22HsO+9hy5kM3L2S3gpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499966; c=relaxed/simple;
	bh=40RTMGN2aqmTC9nrLfOwk9KbYLHjvGrN4hPKQXPvnWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbsw11cupKItkCQruM2A4gdshPL78olBnRMgapmLKhUBwehZk4NhyJYAb4u4BFPzwAywgDDtGUfejLjHDDje9Nmgsd0mZ5znLaEHnizmnaIdSY/th1siXatlmvVjqXAnLAdhnEz62fst+i8KxW8/OI/3exdtDR5A7gBowjR27mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzQPTJob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzQPTJob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4459A1F00A3D;
	Fri,  4 Sep 2026 05:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499964;
	bh=69nbhcVqmTAaYc8ijzEgERJls3Sx9Bp4zGyt3znd++E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzQPTJobv9uD4T44OQsQQWprL1FLgQBhfGSdkxsEgCeqtXYHt8jO9EtLrWqgt0e3Y
	 CH2Jy8Nx+eQ+d6d0CeR5aqhABPWM6pxrow943PxGdez/Bl6GuvRgPdgV4eHjQW6Glm
	 QtWjF75I3xPrn/NcAgjShcf4NHohHxxo3B11Jwng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 604/713] net: mctp: hold a reference to the route device in mctp_route_lookup()
Date: Fri,  4 Sep 2026 06:59:32 +0200
Message-ID: <20260904045817.365980857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 408da1df18116c971c3392e21e50586688cd3fbf upstream.

mctp_route_lookup() uses rt->dev without holding a reference on it.
mctp_route_lookup_single() returns the route under RCU only, so the
route's device can be torn down concurrently: mctp_dev_put() drops the
last reference and synchronously kfree()s mdev->addrs.  mctp_dev_saddr()
then reads rt->dev->addrs[0], giving a use-after-free reachable by an
unprivileged local AF_MCTP user on the receive/forwarding path (no
CAP_NET_RAW required):

  BUG: KASAN: slab-use-after-free in mctp_route_lookup
  Read of size 1 at addr ... by task mctp_uaf/...
   mctp_route_lookup
   mctp_pkttype_receive
  Freed by task ...:
   kfree
   mctp_dev_put
   mctp_dev_notify

In the same window mctp_dst_from_route() -> mctp_dev_hold() also
increments a refcount that has already reached zero
("refcount_t: addition on 0 ... mctp_dev_hold").

This reintroduces the use-after-free class of CVE-2023-3439: the source
address lookup was moved ahead of the point where the destination takes
its device reference.

Take a reference with refcount_inc_not_zero() before touching rt->dev,
skip a device that is already dead, and drop the reference once the
destination has taken its own.

Fixes: 22cb45afd221 ("net: mctp: perform source address lookups when we populate our dst")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Link: https://patch.msgid.link/20260813022102.2792032-1-qwe.aldo@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/route.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -998,14 +998,29 @@ int mctp_route_lookup(struct net *net, u
 			mtu = mtu ?: rt->mtu;
 
 		if (rt->dst_type == MCTP_ROUTE_DIRECT) {
-			mctp_eid_t saddr = mctp_dev_saddr(rt->dev);
+			mctp_eid_t saddr;
+
+			/* rt->dev may be going away concurrently: its last
+			 * reference is dropped in mctp_dev_put(), which frees
+			 * mdev->addrs that mctp_dev_saddr() reads, and
+			 * mctp_dst_from_route() takes a reference on it.  Pin
+			 * it before use, and skip a device that is already
+			 * dead rather than resurrecting it.
+			 */
+			if (!refcount_inc_not_zero(&rt->dev->refs))
+				break;
+
+			saddr = mctp_dev_saddr(rt->dev);
 
 			/* cannot do gateway-ed routes without a src  */
-			if (saddr == MCTP_ADDR_NULL && depth != 0)
+			if (saddr == MCTP_ADDR_NULL && depth != 0) {
+				mctp_dev_put(rt->dev);
 				break;
+			}
 
 			if (dst)
 				mctp_dst_from_route(dst, daddr, saddr, mtu, rt);
+			mctp_dev_put(rt->dev);
 			rc = 0;
 			break;
 


