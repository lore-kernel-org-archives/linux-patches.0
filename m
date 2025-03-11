Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92825D8E8;
	Tue, 11 Mar 2025 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706002; cv=none; b=jPLSkAp9XegTcvkO0S1dl42UHi+yaZXq/9oVjTQRHXtUz2ZF9e1HIAihst2AnaumvR4HYpPNRugaDVT7BmaTQNl2g0i0DnzUEmYAmv7vzvHh2l2y6mt95t1TVskn/zReDTQZoP/G/pKXGqy//hpORmr6nsVHE43MbNpLGABze5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706002; c=relaxed/simple;
	bh=IfgKTd0jvau6TftmiFJQOav+Os1jt2rZjoKnkKFGhUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO5UK2rWBkybVp8gsdyM5w/ChPrXj856/XYxhTIxHz8GfsFbGERwADoyNj0wvi6J8StZ2uEb/mUXpFei5KPbdMvLfmZLg7IoI+suvhLT1j9GmNbAMbT2/BKRhEqnO0iTxYcge5ZJYGXJoc+w/zKpfA05ckFfswks8TWzqr01+uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aa3nA01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aa3nA01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637CAC4CEE9;
	Tue, 11 Mar 2025 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706001;
	bh=IfgKTd0jvau6TftmiFJQOav+Os1jt2rZjoKnkKFGhUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aa3nA01pxmpYS1vJWN+JKx/0qPYlhFubQrK4/VHEzWatBeFYBytsi61o5rjXNtbi
	 kSMqUYqAfCSVgVXscQU8ih2cmx+7/hVW6lh7eKw2HJHrzdzbbzrSW08vO9mMkKBGl0
	 PBkZN9EZbDRjsPvktofVQ7DwI8SN2BRlnGj7iA9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/328] openvswitch: use RCU protection in ovs_vport_cmd_fill_info()
Date: Tue, 11 Mar 2025 15:59:40 +0100
Message-ID: <20250311145723.250357871@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4c537e74b18c7..20a57a3dc2813 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1912,6 +1912,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct net *net_vport;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -1928,12 +1929,15 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
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
@@ -1951,6 +1955,8 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
+nla_put_failure_unlock:
+	rcu_read_unlock();
 nla_put_failure:
 	err = -EMSGSIZE;
 error:
-- 
2.39.5



