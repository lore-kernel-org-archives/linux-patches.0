Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F73CA4B2;
	Sat, 17 Oct 2026 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258495; cv=none; b=C8Ph/7Zk1su5zeMqt0o5JQIhG2SqxgU525hmavupLn/y4s5UgRNUJM2QsHIRdfdhI370izbJVPFdpX81NzpQr0TYgS2zZC06iQSuBxY4mqZCAitP3WxgN0w/Tlkec6wLADG/qJHe41EPaMAn7kw6DRjXV4zJ0DKgD+WvWE/9994=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258495; c=relaxed/simple;
	bh=qfvPqiuOiOyfiw8ku5XNkeiV5kxNJSNt2HT93XQk/Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUfM8+QAGMHuh3u6+/rGso3P+ZA1GZNlJkedV59bdgXIqzzD5r//pyzDN8pHVCBcYoTPcjOILYylm9iPKXcr7MRN/TxpSfylViIgp2OvYRWOMlg0pgm3WHgb5mKgARzsE/IBgZTQLmhaMIdJViGZvRcuVG7cpHMeDKOO+trbMxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXIdQpMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXIdQpMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672011F000C4;
	Sat, 17 Oct 2026 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258493;
	bh=8WGR+jL6uf4BglVi074FMk7+SaU3bxFaCJQzihbICn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXIdQpMgDKT3Q0VoHhXeVCX/klbgXUu1/atIswxAUDpKGDwCX+zjFp+6eY1iFv8b+
	 hySQIwwpcZICRZmmVi2OOtr9Tbaq45+gM3/4CBZzhWbRa6FYkTsyDYC/2ZEF+skv4o
	 2ksCHum+JX4Y36xT/IAzRQUo6pn7hRKo0+6DwiXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <tanyuan98@outlook.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0903/1674] mpls: add seqcount to protect the platform_label{,s} pair
Date: Sat, 17 Oct 2026 17:52:55 +0200
Message-ID: <20261017160454.306441990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 629ec78ef8608d955ce217880cdc3e1873af3a15 ]

The RCU-protected codepaths (mpls_forward, mpls_dump_routes) can have
an inconsistent view of platform_labels vs platform_label in case of a
concurrent resize (resize_platform_label_table, under
platform_mutex). This can lead to OOB accesses.

This patch adds a seqcount, so that we get a consistent snapshot.

Note that mpls_label_ok is also susceptible to this, so the check
against RTA_DST in rtm_to_route_config, done outside platform_mutex,
is not sufficient. This value gets passed to mpls_label_ok once more
in both mpls_route_add and mpls_route_del, so there is no issue, but
that additional check must not be removed.

Reported-by: Yuan Tan <tanyuan98@outlook.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Fixes: 7720c01f3f590 ("mpls: Add a sysctl to control the size of the mpls label table")
Fixes: dde1b38e873c ("mpls: Convert mpls_dump_routes() to RCU.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/cd8fca15e3eb7e212b094064cd83652e20fd9d31.1774284088.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/mpls.h |  2 ++
 net/mpls/af_mpls.c       | 35 ++++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/mpls.h b/include/net/netns/mpls.h
index 19ad2574b267c..9b83b7f43d83b 100644
--- a/include/net/netns/mpls.h
+++ b/include/net/netns/mpls.h
@@ -7,6 +7,7 @@
 #define __NETNS_MPLS_H__
 
 #include <linux/types.h>
+#include <linux/seqlock.h>
 
 struct mpls_route;
 struct ctl_table_header;
@@ -16,6 +17,7 @@ struct netns_mpls {
 	int default_ttl;
 	size_t platform_labels;
 	struct mpls_route __rcu * __rcu *platform_label;
+	seqcount_t platform_label_seq;
 
 	struct ctl_table_header *ctl;
 };
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 9685405d744b9..b94ea43b965d1 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -75,16 +75,31 @@ static void rtmsg_lfib(int event, u32 label, struct mpls_route *rt,
 		       struct nlmsghdr *nlh, struct net *net, u32 portid,
 		       unsigned int nlm_flags);
 
+static struct mpls_route __rcu **mpls_platform_label_rcu(struct net *net, size_t *platform_labels)
+{
+	struct mpls_route __rcu **platform_label;
+	unsigned int sequence;
+
+	do {
+		sequence = read_seqcount_begin(&net->mpls.platform_label_seq);
+		platform_label = rcu_dereference_rtnl(net->mpls.platform_label);
+		*platform_labels = net->mpls.platform_labels;
+	} while (read_seqcount_retry(&net->mpls.platform_label_seq, sequence));
+
+	return platform_label;
+}
+
 static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned index)
 {
-	struct mpls_route *rt = NULL;
+	struct mpls_route __rcu **platform_label;
+	size_t platform_labels;
 
-	if (index < net->mpls.platform_labels) {
-		struct mpls_route __rcu **platform_label =
-			rcu_dereference_rtnl(net->mpls.platform_label);
-		rt = rcu_dereference_rtnl(platform_label[index]);
-	}
-	return rt;
+	platform_label = mpls_platform_label_rcu(net, &platform_labels);
+
+	if (index >= platform_labels)
+		return NULL;
+
+	return rcu_dereference_rtnl(platform_label[index]);
 }
 
 bool mpls_output_possible(const struct net_device *dev)
@@ -2583,8 +2598,12 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	}
 
 	/* Update the global pointers */
+	local_bh_disable();
+	write_seqcount_begin(&net->mpls.platform_label_seq);
 	net->mpls.platform_labels = limit;
 	rcu_assign_pointer(net->mpls.platform_label, labels);
+	write_seqcount_end(&net->mpls.platform_label_seq);
+	local_bh_enable();
 
 	rtnl_unlock();
 
@@ -2665,6 +2684,8 @@ static int mpls_net_init(struct net *net)
 	struct ctl_table *table;
 	int i;
 
+	seqcount_init(&net->mpls.platform_label_seq);
+
 	net->mpls.platform_labels = 0;
 	net->mpls.platform_label = NULL;
 	net->mpls.ip_ttl_propagate = 1;
-- 
2.53.0



