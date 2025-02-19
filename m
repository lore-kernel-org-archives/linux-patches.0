Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8061EA7C0;
	Wed, 19 Feb 2025 09:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957520; cv=none; b=fmfZGCXZTWOHfE0mqf7wm29aKuLDDCly2sjdojGRjwahiHHaz/8WcmqAs9515WeOCFIn8OWjw8oyXC04oDVZa7F3WKn0LysT9pn9Yyg7kw3+I95I0VwN8ZWfnBx9O0VDCDmxIPhPBwYRH2cerWZ2//FdTUtfnNk8KHQ9hJI4YBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957520; c=relaxed/simple;
	bh=qqXOr94qfIf9sQfJUUxLuqysFtvNP+MsfgNhRUpf77k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb1gt//xoBl4QdVvSQ/xuzxlAcF49MIdpVR3J7QVQcaBblgT5Dz/CEz/wYATLkn0Bs+lS28k6s3TvTUOlIu7GFQLhihXMgl2V9XalmQ+owzMR17IaV2u2lyBXMn6Hwj/4nGZH0VYlquuYokGSdkYGmuVVDs2gDMgZ84N5fRLjrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm9YLArc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm9YLArc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58ACC4CED1;
	Wed, 19 Feb 2025 09:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957520;
	bh=qqXOr94qfIf9sQfJUUxLuqysFtvNP+MsfgNhRUpf77k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cm9YLArcuQO/7aV58sXNUd5nuzD1eTCpnbuYvxfAsJRutTXgBdFWzRvLOY7zYyRtZ
	 rYZ4NMyiWcf5WZ+Vz9uZ+eWwFsUxGkE8y+a3be6OaCKjNgUzBWLmOkE27Eym05bnYk
	 UQMKb14fSy3BthzNY1DW56kW9rRNyVh09ufxkB2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 553/578] openvswitch: use RCU protection in ovs_vport_cmd_fill_info()
Date: Wed, 19 Feb 2025 09:29:17 +0100
Message-ID: <20250219082714.712393236@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c7b245354096..a2d8b1b4c83e5 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2076,6 +2076,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
+	struct net *net_vport;
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_vport_genl_family,
@@ -2092,12 +2093,15 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
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
@@ -2115,6 +2119,8 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
+nla_put_failure_unlock:
+	rcu_read_unlock();
 nla_put_failure:
 	err = -EMSGSIZE;
 error:
-- 
2.39.5



