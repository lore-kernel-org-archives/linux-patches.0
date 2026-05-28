Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9B2F260C;
	Thu, 28 May 2026 20:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998843; cv=none; b=fvFV2A86cICNrrSD/ZUkL1oXZG0ijIEYGEtOxw80eix+bBQONhhMtpL9If2Tf47pSBuW9yN8+GS0YEFqJXSQsxw7XP5tg64+IpPYKbrqWLm/s5zx66C/XZZGniuzs8ULhhQojE+3O4esTsb5h2o1FjSRCbJdAb1u7XOx8PUjhZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998843; c=relaxed/simple;
	bh=HzOYl2i3qavhChhJcbt66Q6nIh5LVwHTdoxQ+S+87zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG9/mtZ35NmrE2GUh3bzsrrEsWNny5dP/c2g5yezHHQTMkg0Aju1qXEuez0CyHN/y1XJQjbaDn4bCagC/KrjgWAxKvNqe7DGikrszXn9oeaA1OUejbIxg2KRGZMPIlwyPGCjtAnfCu77YFeu0APjlMWrTCRBfVHZkv3L735lD6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDzoxI5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDzoxI5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B01F00A3A;
	Thu, 28 May 2026 20:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998842;
	bh=uAbcs1SKuWqGEm6U0FlSCKn4DeYt8piHErwgnz6C6VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDzoxI5VxW6vWfFhgv4lPwUGqMGi08EJBVtdhaWkx3G7BvmrUgV+Fw1v4qdSIZYAO
	 cJPOKCg0TjWLkQyCQ2U/7ggKO0bKWglKkN0q09HLmGR1aiyKZzSgWfmMOGVAArrxgt
	 FfAIdDJGzRn3UJqlKyj7NLBAHZZ/2fpIDOqbdb0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 281/461] net: shaper: reject duplicate leaves in GROUP request
Date: Thu, 28 May 2026 21:46:50 +0200
Message-ID: <20260528194655.325166586@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a9a2fa1da619f276580b0d4c5d12efac89e8642b ]

net_shaper_nl_group_doit() does not deduplicate NET_SHAPER_A_LEAVES
entries. When userspace supplies the same leaf handle twice, the same
old-parent pointer lands twice in old_nodes[]. The cleanup loop double
frees the parent. Of course the same parent may still be in old_nodes[]
twice if we are moving multiple of its leaves.

Note that this patch also implicitly fixes the fact that the
i >= leaves_count path forgets to set ret.

Fixes: 5d5d4700e75d ("net-shapers: implement NL group operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-4-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 60 +++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 86319ddbf2905..c8960821cf236 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -941,6 +941,46 @@ static int net_shaper_handle_cmp(const struct net_shaper_handle *a,
 	return memcmp(a, b, sizeof(*a));
 }
 
+static int net_shaper_parse_leaves(struct net_shaper_binding *binding,
+				   struct genl_info *info,
+				   const struct net_shaper *node,
+				   struct net_shaper *leaves,
+				   int leaves_count)
+{
+	struct nlattr *attr;
+	int i, j, ret, rem;
+
+	i = 0;
+	nla_for_each_attr_type(attr, NET_SHAPER_A_LEAVES,
+			       genlmsg_data(info->genlhdr),
+			       genlmsg_len(info->genlhdr), rem) {
+		if (WARN_ON_ONCE(i >= leaves_count))
+			return -EINVAL;
+
+		ret = net_shaper_parse_leaf(binding, attr, info,
+					    node, &leaves[i]);
+		if (ret)
+			return ret;
+
+		/* Reject duplicates */
+		for (j = 0; j < i; j++) {
+			if (net_shaper_handle_cmp(&leaves[i].handle,
+						  &leaves[j].handle))
+				continue;
+
+			NL_SET_ERR_MSG_ATTR_FMT(info->extack, attr,
+						"Duplicate leaf shaper %d:%d",
+						leaves[i].handle.scope,
+						leaves[i].handle.id);
+			return -EINVAL;
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
 static int net_shaper_parent_from_leaves(int leaves_count,
 					 const struct net_shaper *leaves,
 					 struct net_shaper *node,
@@ -1197,10 +1237,9 @@ int net_shaper_nl_group_doit(struct sk_buff *skb, struct genl_info *info)
 	struct net_shaper **old_nodes, *leaves, node = {};
 	struct net_shaper_hierarchy *hierarchy;
 	struct net_shaper_binding *binding;
-	int i, ret, rem, leaves_count;
+	int i, ret, leaves_count;
 	int old_nodes_count = 0;
 	struct sk_buff *msg;
-	struct nlattr *attr;
 
 	if (GENL_REQ_ATTR_CHECK(info, NET_SHAPER_A_LEAVES))
 		return -EINVAL;
@@ -1228,19 +1267,10 @@ int net_shaper_nl_group_doit(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto free_leaves;
 
-	i = 0;
-	nla_for_each_attr_type(attr, NET_SHAPER_A_LEAVES,
-			       genlmsg_data(info->genlhdr),
-			       genlmsg_len(info->genlhdr), rem) {
-		if (WARN_ON_ONCE(i >= leaves_count))
-			goto free_leaves;
-
-		ret = net_shaper_parse_leaf(binding, attr, info,
-					    &node, &leaves[i]);
-		if (ret)
-			goto free_leaves;
-		i++;
-	}
+	ret = net_shaper_parse_leaves(binding, info, &node,
+				      leaves, leaves_count);
+	if (ret)
+		goto free_leaves;
 
 	/* Prepare the msg reply in advance, to avoid device operation
 	 * rollback on allocation failure.
-- 
2.53.0



