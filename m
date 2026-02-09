Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A556A28150F;
	Mon,  9 Feb 2026 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647860; cv=none; b=tRwJOcvXryoXJ9aVlXrT6AjoQNNRROv6hdTlMZd0TIIdkpywtOMkxsbYbHi7os6pOv7yARqrc7CqPX8CgO24sU8cFId+5vHb1NLO1uGQzHlXpzC6v/uUcpR0PrbeKdLL1JLSvUuaJjiedilUNj5/Pny25VdvhEGTDT7RG8iAg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647860; c=relaxed/simple;
	bh=EGxneIW2BtBHKKZ36pFhJNpjtOo0I25FJ5z8EGKnoHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vkd2x/ZW8f7jSr+oDZTfibcSPBE9lJVH6QIt3YnAwJMyfbcvWizPzinZ0jPEin38UWvB68HdNdVErEZq1zLtSW7ViJgh3HrADVBeSDRxBWnAEXsl9+g5nZIltOgEx3pniCR0Rk7V/E5NLLKZSsFEp8LVmjdWjTdBeHRrTc+jUGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj8vIals; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj8vIals"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C47C116C6;
	Mon,  9 Feb 2026 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647860;
	bh=EGxneIW2BtBHKKZ36pFhJNpjtOo0I25FJ5z8EGKnoHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj8vIalsRPS7BWISOYYqmPUteiDM24g+G0JsYRW4s0SwOP4vfVB/og7PatZZF/drR
	 4nQY1FewXdcnBXuZQH2CZgfGn3TTLhgFHSUGVEHc2n2acfBEYlj4oqQgpG22syGBwH
	 d7TkALbemw2QQ5RdpOydaSKIQa2eFqH63Zed4BIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/113] netfilter: replace -EEXIST with -EBUSY
Date: Mon,  9 Feb 2026 15:23:18 +0100
Message-ID: <20260209142311.964030592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit 2bafeb8d2f380c3a81d98bd7b78b854b564f9cd4 ]

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

Replace -EEXIST with -EBUSY to ensure correct error reporting in the module
initialization path.

Affected modules:
  * ebtable_broute ebtable_filter ebtable_nat arptable_filter
  * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
  * ip6table_security iptable_filter iptable_mangle iptable_nat
  * iptable_raw iptable_security

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 net/netfilter/nf_log.c          | 4 ++--
 net/netfilter/x_tables.c        | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3e67d4aff419b..a461c59ad2859 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1299,7 +1299,7 @@ int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct ne
 	list_for_each_entry(tmpl, &template_tables, list) {
 		if (WARN_ON_ONCE(strcmp(t->name, tmpl->name) == 0)) {
 			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
+			return -EBUSY;
 		}
 	}
 
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6dd0de33eebd8..e684ab7198c72 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -89,7 +89,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	if (pf == NFPROTO_UNSPEC) {
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
 			if (rcu_access_pointer(loggers[i][logger->type])) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto unlock;
 			}
 		}
@@ -97,7 +97,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 			rcu_assign_pointer(loggers[i][logger->type], logger);
 	} else {
 		if (rcu_access_pointer(loggers[pf][logger->type])) {
-			ret = -EEXIST;
+			ret = -EBUSY;
 			goto unlock;
 		}
 		rcu_assign_pointer(loggers[pf][logger->type], logger);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0df..ada27e24f7021 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1762,7 +1762,7 @@ EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 int xt_register_template(const struct xt_table *table,
 			 int (*table_init)(struct net *net))
 {
-	int ret = -EEXIST, af = table->af;
+	int ret = -EBUSY, af = table->af;
 	struct xt_template *t;
 
 	mutex_lock(&xt[af].mutex);
-- 
2.51.0



