Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDA2321445;
	Sat, 17 Oct 2026 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253768; cv=none; b=hHthhMbJp4HnBv0Ys4WhsPscMaS4E4SzMjJTfMDnX4+UUBvRps7Pf6CoKUJ7EtRU2epzURLJJUHz++emMQL2cvVyBITkMgNg4fbU00f9gWyWXLa297OdJtTZEFaLLq5DKxrlEX4sHaUSZjSFynLwxiPTv97rMhE5TbU5LianZEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253768; c=relaxed/simple;
	bh=oS6vSNIfErFNpCdF3Nb6ZyUPyNDhC2DnxqkDe1JdetQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p98ZW5yu5R0TahQTWtgzLAy27ZWQH8U29lLHT5utdx9WB9Dzj3evLAm8uZE5LHqOMTo8LgPzWMfczDoPDcPS8LMT9iOcYVQtN/+tE101PzFRG6T+iw2u6kDJ6JEAPvYd3CSZr9x1FFdOCESSq5XhOSH+dYc71kSb7QaqoVLA+2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dw+PTIGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dw+PTIGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC81F000C4;
	Sat, 17 Oct 2026 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253767;
	bh=MxqrfFQkUsDs2IZ7fVRESJ9K8V5IggFcxRKabkCiQVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dw+PTIGqVpTEwBAEclD4GftzBbxsSNePQRs0rJNInOaBpUCbDeoqsKL5KHJa9Qp3w
	 nYXouwjk1t4/TwtIMW3cIbKD6vfT7O8kmftFXQkUwcuXtQ3NJ4OoV9v9YAs6dAIBR/
	 jupky1s3cX3buN17MXuW2nwy4D98zOI5cucZuLpE=
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
Subject: [PATCH 6.12 226/869] mpls: add seqcount to protect the platform_label{,s} pair
Date: Sat, 17 Oct 2026 17:51:07 +0200
Message-ID: <20261017160042.843611035@linuxfoundation.org>
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
 include/net/netns/mpls.h |  1 +
 net/mpls/af_mpls.c       | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/net/netns/mpls.h b/include/net/netns/mpls.h
index 6682e51513efa..2073cbac2afb5 100644
--- a/include/net/netns/mpls.h
+++ b/include/net/netns/mpls.h
@@ -17,6 +17,7 @@ struct netns_mpls {
 	size_t platform_labels;
 	struct mpls_route __rcu * __rcu *platform_label;
 	struct mutex platform_mutex;
+	seqcount_mutex_t platform_label_seq;
 
 	struct ctl_table_header *ctl;
 };
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index c621ab55f3b82..5c293fa655d0d 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -83,14 +83,30 @@ static struct mpls_route *mpls_route_input(struct net *net, unsigned int index)
 	return mpls_dereference(net, platform_label[index]);
 }
 
+static struct mpls_route __rcu **mpls_platform_label_rcu(struct net *net, size_t *platform_labels)
+{
+	struct mpls_route __rcu **platform_label;
+	unsigned int sequence;
+
+	do {
+		sequence = read_seqcount_begin(&net->mpls.platform_label_seq);
+		platform_label = rcu_dereference(net->mpls.platform_label);
+		*platform_labels = net->mpls.platform_labels;
+	} while (read_seqcount_retry(&net->mpls.platform_label_seq, sequence));
+
+	return platform_label;
+}
+
 static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned int index)
 {
 	struct mpls_route __rcu **platform_label;
+	size_t platform_labels;
+
+	platform_label = mpls_platform_label_rcu(net, &platform_labels);
 
-	if (index >= net->mpls.platform_labels)
+	if (index >= platform_labels)
 		return NULL;
 
-	platform_label = rcu_dereference(net->mpls.platform_label);
 	return rcu_dereference(platform_label[index]);
 }
 
@@ -2235,8 +2251,7 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	if (index < MPLS_LABEL_FIRST_UNRESERVED)
 		index = MPLS_LABEL_FIRST_UNRESERVED;
 
-	platform_label = rcu_dereference(net->mpls.platform_label);
-	platform_labels = net->mpls.platform_labels;
+	platform_label = mpls_platform_label_rcu(net, &platform_labels);
 
 	if (filter.filter_set)
 		flags |= NLM_F_DUMP_FILTERED;
@@ -2641,8 +2656,12 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	}
 
 	/* Update the global pointers */
+	local_bh_disable();
+	write_seqcount_begin(&net->mpls.platform_label_seq);
 	net->mpls.platform_labels = limit;
 	rcu_assign_pointer(net->mpls.platform_label, labels);
+	write_seqcount_end(&net->mpls.platform_label_seq);
+	local_bh_enable();
 
 	mutex_unlock(&net->mpls.platform_mutex);
 
@@ -2724,6 +2743,8 @@ static __net_init int mpls_net_init(struct net *net)
 	int i;
 
 	mutex_init(&net->mpls.platform_mutex);
+	seqcount_mutex_init(&net->mpls.platform_label_seq, &net->mpls.platform_mutex);
+
 	net->mpls.platform_labels = 0;
 	net->mpls.platform_label = NULL;
 	net->mpls.ip_ttl_propagate = 1;
-- 
2.53.0



