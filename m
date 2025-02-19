Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD71E3DC6;
	Wed, 19 Feb 2025 08:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955406; cv=none; b=cpPjpi6yjOZfWQNQ516wwC4Uf7FTIbj1vcX07FtJ381DWH3miITNyW1DGkHtUblM2w+YW9qtS2whnwUNEDz/3TgTyyrAqwOaCkENpM0zwYnRr/1L66BCqMLUcEIo3coy9TzmwImVln73hSb+GxE5D+KPpk7pnQO6UKVhNpuWaWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955406; c=relaxed/simple;
	bh=GzQmepPTzCXF2v1xd6soZbe9VKLtbjQgVO/gOpMpfWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imCzCqc44sHyvH7OhzYMhpwIhdu3IpJ9hKPq5oK2sw+ZLvsOXowf/GJ6vZJK1/Xq69JCLrfTtX+swrxA/54Gg1B6QP6ikrvoEkmGWFvmhkxNKfroVCjPgaB+6lWUFoT3FSil0PSRwqmakIA85OuRq2d1JYFmXE9XFv7InKhC778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+PbXs2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+PbXs2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04595C4CED1;
	Wed, 19 Feb 2025 08:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955406;
	bh=GzQmepPTzCXF2v1xd6soZbe9VKLtbjQgVO/gOpMpfWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+PbXs2Q7+VW1+4HmMDbvdIsZ+yyjwCLsDzirgKUDepXp+wd/kbH3vR4guH/IC1H2
	 KKTAfHDmUDSRw1Lleq1XVwL/ty7CAdxj+FSU6BZ2MRoDgG+4RD2jN6lOYppzWmThny
	 ffwPfPbkaFrmVZLvFITFcEuWVv8hYLT9EtN9uk0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/230] openvswitch: use RCU protection in ovs_vport_cmd_fill_info()
Date: Wed, 19 Feb 2025 09:28:36 +0100
Message-ID: <20250219082609.480351530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 90b2f49a502fa71090d9f4fe29a2f51fe5dff76d ]

ovs_vport_cmd_fill_info() can be called without RTNL or RCU.

Use RCU protection and dev_net_rcu() to avoid potential UAF.

Fixes: 9354d4520342 ("openvswitch: reliable interface indentification in port dumps")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 78d9961fcd446..8d3c01f0e2aa1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2102,6 +2102,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct net *net_vport;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -2118,12 +2119,15 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 	    nla_put_u32(skb, OVS_VPORT_ATTR_IFINDEX, vport->dev->ifindex))
 		goto nla_put_failure;
 
-	if (!net_eq(net, dev_net(vport->dev))) {
-		int id = peernet2id_alloc(net, dev_net(vport->dev), gfp);
+	rcu_read_lock();
+	net_vport = dev_net_rcu(vport->dev);
+	if (!net_eq(net, net_vport)) {
+		int id = peernet2id_alloc(net, net_vport, GFP_ATOMIC);
 
 		if (nla_put_s32(skb, OVS_VPORT_ATTR_NETNSID, id))
-			goto nla_put_failure;
+			goto nla_put_failure_unlock;
 	}
+	rcu_read_unlock();
 
 	ovs_vport_get_stats(vport, &vport_stats);
 	if (nla_put_64bit(skb, OVS_VPORT_ATTR_STATS,
@@ -2144,6 +2148,8 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
+nla_put_failure_unlock:
+	rcu_read_unlock();
 nla_put_failure:
 	err = -EMSGSIZE;
 error:
-- 
2.39.5



