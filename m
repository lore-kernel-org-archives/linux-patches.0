Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D095284690;
	Sat, 30 May 2026 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165033; cv=none; b=P+acv/q5ORTsodexY/siCjnt3kFfF1T+2+ObQyJnKtps9LRBsol2GWfylZNHZY+pksJRA2bKGcigadfVhFskTA8GJ3H/tJNHtjHdT1t4Jmt+q0a/u0tXoGSWheGdsdFRGAv3eVgYaEA0ERKnFlTgxaBscRgdyE5H8Fr3YHY3dUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165033; c=relaxed/simple;
	bh=c344TKKQT2U0WbEpIaKs86AxSrEspQpyRN/OqLEg7BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLJK8g2uOlVT3QbM60pgZ3HCGekq9ZRlObOTZxJlkQ4Biu0mMxBn1z81ZkxSpIKyAFbUvWHQL3Td7+4BognslMsjnvLolUEA4nmyEG5pRrHEOFEeqMSA9Mq/GBEau3vI/KmCaIiVwgQKWWg37649p0856+rtoJyVKNnkvTjUdLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dzo9rKkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dzo9rKkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8749F1F00893;
	Sat, 30 May 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165032;
	bh=9xb1rN7yoHA/4gaU8biZJBI25eNxCQZx0XrVX3NaGiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dzo9rKkXb+2ssHjReUkgJV4vAq3hmp2IHgTUi0eb3bL+WumCWnX5jlXwhhbGbAnKS
	 ux3XEg1NDLW+j7USYclR43W1FpsftVMkzMmvzi5c2hkE+JG8iK/dqJktQnqXakCjzV
	 dLnBZxhxNtN0XAQpQRKUkPtTm2VmXdqnvUPfbCYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 731/776] netfilter: arp_tables: allow use of arpt_do_table as hookfn
Date: Sat, 30 May 2026 18:07:25 +0200
Message-ID: <20260530160258.707703705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e8d225b6002673366abc2e40e30c991bdc8d62ca ]

This is possible now that the xt_table structure is passed in via *priv.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_arp/arp_tables.h |  5 ++---
 net/ipv4/netfilter/arp_tables.c          |  7 ++++---
 net/ipv4/netfilter/arptable_filter.c     | 10 +---------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 4f9a4b3c58926..a40aaf645fa47 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -54,9 +54,8 @@ int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
 void arpt_unregister_table_pre_exit(struct net *net, const char *name);
-extern unsigned int arpt_do_table(struct sk_buff *skb,
-				  const struct nf_hook_state *state,
-				  struct xt_table *table);
+extern unsigned int arpt_do_table(void *priv, struct sk_buff *skb,
+				  const struct nf_hook_state *state);
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 92bc90ee76748..564054123772a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -191,10 +191,11 @@ struct arpt_entry *arpt_next_entry(const struct arpt_entry *entry)
 	return (void *)entry + entry->next_offset;
 }
 
-unsigned int arpt_do_table(struct sk_buff *skb,
-			   const struct nf_hook_state *state,
-			   struct xt_table *table)
+unsigned int arpt_do_table(void *priv,
+			   struct sk_buff *skb,
+			   const struct nf_hook_state *state)
 {
+	const struct xt_table *table = priv;
 	unsigned int hook = state->hook;
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 771eec4629352..359d00d74095b 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -26,14 +26,6 @@ static const struct xt_table packet_filter = {
 	.priority	= NF_IP_PRI_FILTER,
 };
 
-/* The work comes in here from netfilter.c */
-static unsigned int
-arptable_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return arpt_do_table(skb, state, priv);
-}
-
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
 static int arptable_filter_table_init(struct net *net)
@@ -72,7 +64,7 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arptable_filter_hook);
+	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arpt_do_table);
 	if (IS_ERR(arpfilter_ops)) {
 		xt_unregister_template(&packet_filter);
 		return PTR_ERR(arpfilter_ops);
-- 
2.53.0



