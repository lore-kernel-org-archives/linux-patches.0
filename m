Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAAF2EBB8C;
	Mon, 13 Apr 2026 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097122; cv=none; b=tYA5zKwJDHDipjTiGDvlFg4jKOBT8I/pl6OyFjqNOAhR+Pj2oUEk5u8j0bPIZD+atiKUNiXCKj3eYwEJ677v+WjRdxGtLU0iGgcNPNcbeOmAE87veiTUWNml+impQq0pkq9tFVwgKZOpzciXJEQVjJ8XVmvTgi9T6tZY6m59R+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097122; c=relaxed/simple;
	bh=6miaLofPnDD1qTEq355a15aHcbZXjmJZwag8e75OzAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Va94GNHyyA0YQhtIsmxLm4UHwodHLHab+icqp3HN8pkqa9EXme6vuBK4KUiaup4DAHtDcQ07KrGwYhTEWBLr391vTQpNTz8OI4Mw5BRzgYRYkMGke9kmCb/RFv1LI97+ieeWIWSfuF2RMMkVxOOcQ8k4FQP6NvcVlM6gdroCRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBEaVGBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBEaVGBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7492FC2BCAF;
	Mon, 13 Apr 2026 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097122;
	bh=6miaLofPnDD1qTEq355a15aHcbZXjmJZwag8e75OzAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBEaVGBRm+IOoR28kYRTX0SNufVaQzJI49u/kQyzGbkJnqunixZm0lRdCS9A9n3vn
	 DoufqoX50oGahlHMAYIQGsh0PG6pZHFbIwnOID9sN254iAB1UIq2k/+bKxG8/btCuY
	 qDttyVoSI/DRBrXEtUqk9LxIAsIlE0l/qKaeaKNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/570] ip6_tunnel: Fix usage of skb_vlan_inet_prepare()
Date: Mon, 13 Apr 2026 17:52:13 +0200
Message-ID: <20260413155830.485087556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 553851e3aca14..7c1b5d01f8203 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -846,7 +846,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 
-	if (skb_vlan_inet_prepare(skb, true)) {
+	if (!skb_vlan_inet_prepare(skb, true)) {
 		DEV_STATS_INC(tunnel->dev, rx_length_errors);
 		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
-- 
2.51.0



