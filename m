Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE221C6AB;
	Mon,  4 Mar 2024 21:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589272; cv=none; b=EJd2y6nf0A6Ort/YCD4GQ3IqIRLMC5rinUck3t7eup3RtWpAC3Plr7mgO5ipUVRTnaWCP5FnIFPiWD6mqKCYp8Kl2xdUiLzCP6/Z+Vm8hJMMUxcda9Ocey+Ei8Z6jvf1cszjyTBVGiENYriL4SCsnWUjVju+cSDGPhbdqs/ecTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589272; c=relaxed/simple;
	bh=/GXAYuuDJyFPyuMIP/gyKTtJlvPILWjlL236n/SCyN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLshYs416FDt3d7t+ep054xxuCvFlmP1xKLAZd4aUGjZwgoLegzaSYCLiaoNqNnruql591kZH9X6RzgDCpdZlJbupaeJYgeQPt73+0KeQEcsH9JcQ3JGRocG/GdRh4e3FjAU58WeMIAPHMt3bVw0ZVXh6foAzGi6q8D2ZlHJS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPCh62IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPCh62IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01989C433C7;
	Mon,  4 Mar 2024 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589272;
	bh=/GXAYuuDJyFPyuMIP/gyKTtJlvPILWjlL236n/SCyN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPCh62IQvAJLSUFDvelPz4ORREfzfvXiObMrrBAXGc8A5H0jVf3hrFxZgAO1yRICD
	 qBkUdrmUsHdH3kEdAKCtfsqlsdcgd7/+Ab4r6xz0GklCxX3LIGPg45wFIlSv6yyjIo
	 vY5NVZOkKaj2kbhvVbSeBHTov++tXjwpcS/V/DBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/84] netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
Date: Mon,  4 Mar 2024 21:23:54 +0000
Message-ID: <20240304211543.036981811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3fce16493dc1aa2c9af3d7e7bd360dfe203a3e6a ]

ip_ct_attach predates struct nf_ct_hook, we can place it there and
remove the exported symbol.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h         |  2 +-
 net/netfilter/core.c              | 19 ++++++++-----------
 net/netfilter/nf_conntrack_core.c |  4 +---
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e20c2db0f2c16..64acdf22eb4fa 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -435,7 +435,6 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
-extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
 struct nf_conntrack_tuple;
 bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
@@ -458,6 +457,7 @@ struct nf_ct_hook {
 	void (*destroy)(struct nf_conntrack *);
 	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
 			      const struct sk_buff *);
+	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 };
 extern struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index ffa84cafb746b..5396d27ba6a71 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -639,25 +639,22 @@ struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-/* This does not belong here, but locally generated errors need it if connection
-   tracking in use: without this, connection may not be in hash table, and hence
-   manufactured ICMP or RST packets will not be associated with it. */
-void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *)
-		__rcu __read_mostly;
-EXPORT_SYMBOL(ip_ct_attach);
-
 struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
+/* This does not belong here, but locally generated errors need it if connection
+ * tracking in use: without this, connection may not be in hash table, and hence
+ * manufactured ICMP or RST packets will not be associated with it.
+ */
 void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
 {
-	void (*attach)(struct sk_buff *, const struct sk_buff *);
+	const struct nf_ct_hook *ct_hook;
 
 	if (skb->_nfct) {
 		rcu_read_lock();
-		attach = rcu_dereference(ip_ct_attach);
-		if (attach)
-			attach(new, skb);
+		ct_hook = rcu_dereference(nf_ct_hook);
+		if (ct_hook)
+			ct_hook->attach(new, skb);
 		rcu_read_unlock();
 	}
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 10622760f894a..779e41d1afdce 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2518,7 +2518,6 @@ static int kill_all(struct nf_conn *i, void *data)
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
-	RCU_INIT_POINTER(ip_ct_attach, NULL);
 }
 
 void nf_conntrack_cleanup_end(void)
@@ -2838,12 +2837,11 @@ static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= nf_ct_destroy,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
+	.attach		= nf_conntrack_attach,
 };
 
 void nf_conntrack_init_end(void)
 {
-	/* For use by REJECT target */
-	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
 	RCU_INIT_POINTER(nf_ct_hook, &nf_conntrack_hook);
 }
 
-- 
2.43.0



