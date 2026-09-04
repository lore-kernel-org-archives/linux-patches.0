Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70562415F22;
	Fri,  4 Sep 2026 06:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502390; cv=none; b=s7WU/xlqzyEZlC4U86wVmoEg/NhNRpKUuethqlmX32YOB2GcZ1mlfZuW/uwxtK/4ctX4wzNg5NEdlVKYw/qmXdLWiR277gl/ztdoG9SXmE1olJM5nZwoYHLsy+luOa9K5um5TvtEz/nAOZY+WHS7kxYVyyEfa3lc7uikV5Kxgs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502390; c=relaxed/simple;
	bh=OIoXNyfiyHWMLfh6TqTUHNurT2XuZetyYUlT+PLSNXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwgK2Qg9ndqq5lkV9EgEz7IbwXAxjJj1LbyGlHHqd10xxYQCfHwTtDNGS+r3g5Qn+VMt3G2hpaDJR5ifU0Mv59f6JCnkBHHu8FjGnIO5oTJL2jhT7omqDplvHx+yKJiSzp9UKwu0L7j4w4qP0NjX0Z9hktiA1Nfkk04c6Oq1qlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrSZfUFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrSZfUFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA5F1F00A3D;
	Fri,  4 Sep 2026 06:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502388;
	bh=6wCTJNAHFZ63t29urm+w2zDi6qKjADjqSFLWMEWN05w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrSZfUFk/Rd5fAjYYanO9d+2ep5J5oxuEMj9oCWe6l3OTUSq4GKJxxAhJdLA5927P
	 BVzVPQws+mHWh4eKkn0lLKF1BBkZSLr9Ou07J+UF1sCZ66fv/i9G8B5hCVaz8AfJbi
	 DU3tjsNcZkTSet7WhDFAidY1xFYnpwUmwgmuvjwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 191/403] ip6_gre: fix hardware header length for NBMA tunnels
Date: Fri,  4 Sep 2026 06:59:54 +0200
Message-ID: <20260904045739.200344303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 505b6d296c486ef7d1274f279d4c43a172f63224 upstream.

ip6gre_tnl_link_config_route() accumulates the lower device's hardware
header length into dev->hard_header_len whenever header_ops is set. This
is incorrect for both users of header_ops.

ip6gretap and ip6erspan have a fixed Ethernet hardware header length.
For an NBMA ip6gre tunnel, ip6gre_header() creates only the GRE header,
the optional FOU or GUE header, and the outer IPv6 header. The lower
device header is headroom needed later, not part of the tunnel device's
hardware header.

Keep the lower device header in needed_headroom. Set hard_header_len to
the tunnel header length only for ARPHRD_IP6GRE devices with header_ops,
and leave the fixed Ethernet header length unchanged for tap and erspan
devices.

Fixes: 832ba596494b ("net: ip6_gre: set dev->hard_header_len when using header_ops")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/64b46542bbe1701f07702aaa50273e2a87903db5.1786542637.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1165,13 +1165,8 @@ static void ip6gre_tnl_link_config_route
 			return;
 
 		if (rt->dst.dev) {
-			unsigned short dst_len = rt->dst.dev->hard_header_len +
-						 t_hlen;
-
-			if (t->dev->header_ops)
-				dev->hard_header_len = dst_len;
-			else
-				dev->needed_headroom = dst_len;
+			dev->needed_headroom = rt->dst.dev->hard_header_len +
+					       t_hlen;
 
 			if (set_mtu) {
 				int mtu = rt->dst.dev->mtu - t_hlen;
@@ -1199,8 +1194,8 @@ static int ip6gre_calc_hlen(struct ip6_t
 
 	t_hlen = tunnel->hlen + sizeof(struct ipv6hdr);
 
-	if (tunnel->dev->header_ops)
-		tunnel->dev->hard_header_len = LL_MAX_HEADER + t_hlen;
+	if (tunnel->dev->header_ops && tunnel->dev->type == ARPHRD_IP6GRE)
+		tunnel->dev->hard_header_len = t_hlen;
 	else
 		tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
 


