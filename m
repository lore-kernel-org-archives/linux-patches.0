Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEEF2DEA61;
	Sat, 17 Oct 2026 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253759; cv=none; b=JBnvcgi1VlKyEeR8o/N9nB2pjfpEAVheCKmNOnTnAAZ4jEuxP9IJ+fDL92lufdn9ZoBF+u2qMBvAW2FSpB2p+akdEP69K+tox0vdStvvuTu9qggJ0Cqs0PnJYjkDYSRszmLm1OoYz9Fu15odPyaQGrxaCuSfOe5D1cdDk95U6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253759; c=relaxed/simple;
	bh=QJgs3tqZYqZ+kEBc6qd+oodOu2EiJ9/OIxfDL3kOQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgUlBRCcwgUugoObUSJSo/paRo6uf6FXCI7phQqK1Tc7qUTLsXF9s7U5y0MPj+sgpjBMGy69HjfcpftLcdfm3VM7df58emXCZyU/OGnTbsb96HzUzAsZ6lJmJ/XBMP4nZV7TJXlyr1jb73c4b076FiVqjQkRYclLTlPbxQkH2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eb6vyWW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eb6vyWW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF741F000C4;
	Sat, 17 Oct 2026 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253758;
	bh=8Dk55o6F/M6nOrCNF7HtuJpiDMCGJtfbCMKvNtZPnh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eb6vyWW5vkTfT7X8O0VZhqvB91O1Hoksz8TBIujSDws2s/hZ6yrt8kDwNOsWut3UO
	 IrCm6m/owGJge2j8rWJqyXlB/OMaavqTv6st5yAtMMhFbLwo+kCR8zYBC5fMLO9+/J
	 90i1P1cy4gOYHWCwpHRUrOGtE3i3zy/vGC9zTS90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/869] mpls: Add mpls_route_input().
Date: Sat, 17 Oct 2026 17:51:04 +0200
Message-ID: <20261017160042.767222752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 73e40539399101667945ed8b8299d0fa67a4fca2 ]

mpls_route_input_rcu() is called from mpls_forward() and
mpls_getroute().

The former is under RCU, and the latter is under RTNL, so
mpls_route_input_rcu() uses rcu_dereference_rtnl().

Let's use rcu_dereference() in mpls_route_input_rcu() and
add an RTNL variant for mpls_getroute().

Later, we will remove rtnl_dereference() there.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-9-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 7181af81e4290..5e060d373d7db 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -75,16 +75,23 @@ static void rtmsg_lfib(int event, u32 label, struct mpls_route *rt,
 		       struct nlmsghdr *nlh, struct net *net, u32 portid,
 		       unsigned int nlm_flags);
 
-static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned index)
+static struct mpls_route *mpls_route_input(struct net *net, unsigned int index)
 {
-	struct mpls_route *rt = NULL;
+	struct mpls_route __rcu **platform_label;
 
-	if (index < net->mpls.platform_labels) {
-		struct mpls_route __rcu **platform_label =
-			rcu_dereference_rtnl(net->mpls.platform_label);
-		rt = rcu_dereference_rtnl(platform_label[index]);
-	}
-	return rt;
+	platform_label = rtnl_dereference(net->mpls.platform_label);
+	return rtnl_dereference(platform_label[index]);
+}
+
+static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned int index)
+{
+	struct mpls_route __rcu **platform_label;
+
+	if (index >= net->mpls.platform_labels)
+		return NULL;
+
+	platform_label = rcu_dereference(net->mpls.platform_label);
+	return rcu_dereference(platform_label[index]);
 }
 
 bool mpls_output_possible(const struct net_device *dev)
@@ -2378,12 +2385,12 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	u32 portid = NETLINK_CB(in_skb).portid;
 	u32 in_label = LABEL_NOT_SPECIFIED;
 	struct nlattr *tb[RTA_MAX + 1];
+	struct mpls_route *rt = NULL;
 	u32 labels[MAX_NEW_LABELS];
 	struct mpls_shim_hdr *hdr;
 	unsigned int hdr_size = 0;
 	const struct mpls_nh *nh;
 	struct net_device *dev;
-	struct mpls_route *rt;
 	struct rtmsg *rtm, *r;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
@@ -2411,7 +2418,8 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 		}
 	}
 
-	rt = mpls_route_input_rcu(net, in_label);
+	if (in_label < net->mpls.platform_labels)
+		rt = mpls_route_input(net, in_label);
 	if (!rt) {
 		err = -ENETUNREACH;
 		goto errout;
-- 
2.53.0



