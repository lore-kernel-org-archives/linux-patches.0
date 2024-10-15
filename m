Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307891C07DB;
	Tue, 15 Oct 2024 13:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997626; cv=none; b=uo9LPTp218wCoFFnMqpqh35jhRBeHUzhg029tNd9APc0d5laJ647YppOWT3UNZr+06sUDWMCsd/kuygVZgdTytiSPCA4hATi/16x+6xVocKVjdkHutg8OgQ0mcu+1ypNLtMVGOU8dnWXMSt9CxUUv/iLh9QNF4//SjlcE1z/MJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997626; c=relaxed/simple;
	bh=P5wYzo50UC8Tl8xexd+rBZG5EvbU1xUeyQ0VbiZl5U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0D29KsdGcZ+5aW6OcIawQpd/1eN9/s9gJu98LVXNOy5A8nxlIcjcj8eGRqYFp0ha80CLDwzhU+Oc1W9vhEbkOMvgiIFKK+c4kM/PiTwDHNA3wwKo/bjia4rlqVW2AScJaRmt6ZigO3r39R8HJvA/qaDbJN1yf6jcEc4CbaDgPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZmj84wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZmj84wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A087C4CED0;
	Tue, 15 Oct 2024 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997625;
	bh=P5wYzo50UC8Tl8xexd+rBZG5EvbU1xUeyQ0VbiZl5U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZmj84wKqBdOQykWA1NXR+VSNSm388TMJySdruPzQzsd6Y86fGr8kr3OPFtywmgKn
	 kuaoaGjVL3t6Iq2X4BPAR6k7MdnvEJlnJH7mjmOqbrpiSDgRxaNLb9cBIM26AuZIgc
	 HuLyRCGiXPkRCqpYGPW3UGhUsMRxf2xAeEGyOwgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/518] netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS
Date: Tue, 15 Oct 2024 14:41:51 +0200
Message-ID: <20241015123924.974064107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit e1f1ee0e9ad8cbe660f5c104e791c5f1a7cf4c31 ]

Only provide ctnetlink_label_size when it is used,
which is when CONFIG_NF_CONNTRACK_EVENTS is configured.

Flagged by clang-18 W=1 builds as:

.../nf_conntrack_netlink.c:385:19: warning: unused function 'ctnetlink_label_size' [-Wunused-function]
  385 | static inline int ctnetlink_label_size(const struct nf_conn *ct)
      |                   ^~~~~~~~~~~~~~~~~~~~

The condition on CONFIG_NF_CONNTRACK_LABELS being removed by
this patch guards compilation of non-trivial implementations
of ctnetlink_dump_labels() and ctnetlink_label_size().

However, this is not necessary as each of these functions
will always return 0 if CONFIG_NF_CONNTRACK_LABELS is not defined
as each function starts with the equivalent of:

	struct nf_conn_labels *labels = nf_ct_labels_find(ct);

	if (!labels)
		return 0;

And nf_ct_labels_find always returns NULL if CONFIG_NF_CONNTRACK_LABELS
is not enabled.  So I believe that the compiler optimises the code away
in such cases anyway.

Found by inspection.
Compile tested only.

Originally splitted in two patches, Pablo Neira Ayuso collapsed them and
added Fixes: tag.

Fixes: 0ceabd83875b ("netfilter: ctnetlink: deliver labels to userspace")
Link: https://lore.kernel.org/netfilter-devel/20240909151712.GZ2097826@kernel.org/
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b55e87143c2ce..8c9edad0826ef 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -365,7 +365,7 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
-#ifdef CONFIG_NF_CONNTRACK_LABELS
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
 	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
@@ -374,6 +374,7 @@ static inline int ctnetlink_label_size(const struct nf_conn *ct)
 		return 0;
 	return nla_total_size(sizeof(labels->bits));
 }
+#endif
 
 static int
 ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
@@ -394,10 +395,6 @@ ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
 
 	return 0;
 }
-#else
-#define ctnetlink_dump_labels(a, b) (0)
-#define ctnetlink_label_size(a)	(0)
-#endif
 
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 
-- 
2.43.0



