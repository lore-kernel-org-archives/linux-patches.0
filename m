Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64114280CFB;
	Mon, 13 Apr 2026 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098609; cv=none; b=QGUXbtiXduUdMan03A5+LIwXZU1KHrU7ny//yuiaDelpMs12SI/9aZ4Z5lUwsu9SYyHTevPbfQ8yEWwL+c79BIPsrRf3oxfp0KVzMfiAtG08UL2ayNvkXWU/QwNYUrGy2vX7wuqG6YoAdoXPerVRk/+8N0jfltGiWNcSUBbHVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098609; c=relaxed/simple;
	bh=suMYbWd0nfbr/qlcHdb3j2W4U2BZQmJmYv0YoOOygiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1GqHg7cjWDJkwQeMveCnl0G6R7hW394O+EE2BWr21odrS4aU4Wabr88aoxnuhZLUGV2Y+/uNWT50bOdLYPo28Kna69VI+OcRjJEeIlWxjNjQ21gdF6Zl6P4O8LOIyfXbNEtTP+LHV78NmD16e0HpH0GxUabcPeXcQdeGiabcgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwVpS/y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwVpS/y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E10C2BCAF;
	Mon, 13 Apr 2026 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098609;
	bh=suMYbWd0nfbr/qlcHdb3j2W4U2BZQmJmYv0YoOOygiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwVpS/y5oIo7gqMM9+rGN7vFwcUmm7Nw4Btnecr7VpCzXWLzEadT1PyQfc73saUzT
	 1QfN6gUj68OgbN4r/Wn8+dYOe2GOmB1eZlj/TAld0W79XXea4AvoglWQn46aao7SLF
	 SHc1ngvupTqfNKyqZ7+URiG28t7VWFFxtLPvuyCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/491] ip6_tunnel: Fix usage of skb_vlan_inet_prepare()
Date: Mon, 13 Apr 2026 17:54:07 +0200
Message-ID: <20260413155819.141850594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Backports of commit 81c734dae203 "ip6_tunnel: use
skb_vlan_inet_prepare() in __ip6_tnl_rcv()" broke IPv6 tunnelling in
stable branches 5.10-6.12 inclusive.  This is because the return value
of skb_vlan_inet_prepare() had the opposite sense (0 for error rather
than for success) before commit 9990ddf47d416 "net: tunnel: make
skb_vlan_inet_prepare() return drop reasons".

For branches including commit c504e5c2f964 "net: skb: introduce
kfree_skb_reason()" etc. (i.e. 6.1 and newer) it was simple to
backport commit 9990ddf47d416, but for 5.10 and 5.15 that doesn't seem
to be practical.

So just reverse the sense of the return value test here.

Fixes: f9c5c5b791d3 ("ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()")
Fixes: 64c71d60a21a ("ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 855622a6a304f..e8c4e02e75d43 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -876,7 +876,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 
-	if (skb_vlan_inet_prepare(skb, true)) {
+	if (!skb_vlan_inet_prepare(skb, true)) {
 		DEV_STATS_INC(tunnel->dev, rx_length_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
-- 
2.51.0



