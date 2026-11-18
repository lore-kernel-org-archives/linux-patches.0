Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054233;
	b=EzGHtnihEnUqgWVvK92LHm3N4/GVGB0ey4mSI6s0AW9ri8VHh8JUvFlij+RkNljcdIjN
	 1bjNY2g1RgCOxYE7lcGyYUqiyf+YAqDxsFxXh2XnfbGCcUP4Sdu+gG6tMU/shaBZAvhaB
	 hyDXPaLuv9itJ0iQqJqiwG1Bom25U150kOr2NQwdZ2Zan+fDyMN9VEJCSgDKlSWfPoc5x
	 o0D06F0134i5gaiL8txgvl8kAGb/1GNham8Gbprp1K3HLSa7ISv+UFGOeKPrb8ogHUn+V
	 GeSTeUM5x8GxVV+dTXzJLCDnnqSxXSeIknrZ2DswuSA82pfeYaTsLwuxw/Rl2VEXoFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpfdRGtS/aEYCkIL0qOcOsn8AHA21Uyk2xlT4wk+aVg=;
	b=QVlM5qCxknFvzV7D6gqAtCGX6yJtjU3ooavpf/mTXbLP4NgWWJtdPvsKDJrb/jx4LOs/
	 kaS2KwnyFN3HDt7WUbZeD9GUJ9mR+xSAuRz1dt6i87iApMcgXRU0x+Oy8jGZRWusH+FS/
	 AG9Ka5GAutoNngD7UFhcZkCmuQ8TZ4Xehuh3ti8SJ5nGqVUGWR4/xSSiPgcsa1FMiWQPP
	 PhfldrqVPna6ff3nZC0y6zqJI/wS8ZNJxF9meaqf5G5X+6WbDcjttq7uaM3u3UZshV3vQ
	 wSDVJRDdrplR8iKyn/xPw/HQSh7RwnsIvf0LG8VV1KjuecKp5meIhawsuEQsycmk7LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4EZBoiA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5D9606A31C;
	Thu, 19 Nov 2026 02:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4EZBoiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6F51F000C5;
	Thu, 19 Nov 2026 02:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054233;
	bh=wpfdRGtS/aEYCkIL0qOcOsn8AHA21Uyk2xlT4wk+aVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4EZBoiAltTRj7JXADSsqYzPul1htOLdRlMaZWuJgqHdM9A7aj6RY25ysy+mPOiBQ
	 00C0SFyNU2XEeLR2/KvNmPT+AVoFcd7cDlhk4dyw1t4pYISarKz7P2sekYfeMOGtsy
	 v/dsO8YeZTFquU/MLBPAqrJtxh4vDhGLIg67FlbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1160/2214] ip6mr: ip6mr_sk_done() can exit early in common cases
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118150058.445519286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f2f2325ec79970807012dfc9e716cdbb02d9b574 ]

In many cases, ip6mr_sk_done() is called while no ipmr socket
has been registered.

This removes 4 rtnl acquisitions per netns dismantle,
with following callers:

igmp6_net_exit(), tcpv6_net_exit(), ndisc_net_exit()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ace56ed7b13 ("ipv6: remove ifaddr from hash during ifdown list cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 1781287fb5aed..224bb385ef80d 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1581,6 +1581,9 @@ int ip6mr_sk_done(struct sock *sk)
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
 		return err;
 
+	if (!atomic_read(&net->ipv6.devconf_all->mc_forwarding))
+		return err;
+
 	rtnl_lock();
 	ip6mr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
-- 
2.53.0



