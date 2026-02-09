Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353B28312F;
	Mon,  9 Feb 2026 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648846; cv=none; b=BucMxBYGoteEb7YjOclY4lOrYPlL/MckvDd0kyUs6+pYN8kdayqe5y7uvaDo/MG5hI4hkdmFscEzaNovOIjaBGlFYPBMywPeDTEsEabbGdThN05T6VTwHDEdUBPveBTzWiyMJmJkEMn+cVDd77JdEw0IFpd3QcnGs/+o9SgyZ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648846; c=relaxed/simple;
	bh=VFw5haTtysWc2U2SKTXKHOk08OtY2bfUZcvgQaQvGgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVHF9+NufTEAxCWfxUIr7AcTGSxGbfMINtuZistn4IRJXiWvAk1zze+Bl+afVEANT26X+jJobT4FFIdfwy0ryYa72TgzkzXVml3ONPKJq8puxf+Law2ekQkjfrdK7GWa4QgfpKslumkcD6hHu9RQwDQgoNG0JdW3QYCjHrHs8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW38Whfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW38Whfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ABAC116C6;
	Mon,  9 Feb 2026 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648845;
	bh=VFw5haTtysWc2U2SKTXKHOk08OtY2bfUZcvgQaQvGgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW38WhfdnrE7mTsSiGKoFmHEyk/yJ8ftD16oxfl6b+alYTtQ4ya05z1+TERb5x3Il
	 2OYa7t0XliUls0U/KrH/QFxgZLaNhU0zAhl/L9kzNYdo+ZiQhoswAjY8JINdA+/Fur
	 Ifaw+jW6xT6L0HnRs37jev/GfR4pxXlr8Trro3MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/75] netfilter: replace -EEXIST with -EBUSY
Date: Mon,  9 Feb 2026 15:24:30 +0100
Message-ID: <20260209142303.039559903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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
index 2f3ea11785ad4..c74efcc2b4996 100644
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
index 8f5362a19b151..d15d2911a67e3 100644
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
index 9a579217763df..6303ba7a62a2f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1761,7 +1761,7 @@ EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 int xt_register_template(const struct xt_table *table,
 			 int (*table_init)(struct net *net))
 {
-	int ret = -EEXIST, af = table->af;
+	int ret = -EBUSY, af = table->af;
 	struct xt_template *t;
 
 	mutex_lock(&xt[af].mutex);
-- 
2.51.0



