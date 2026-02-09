Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5236BCE2;
	Mon,  9 Feb 2026 14:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648186; cv=none; b=l95Oll/k0EaUk0e2IGY/FxlKhvcs6zLhdLQKwvPy50AkizoVipFvTmDhAa5xBOfBBVYkvaB++4zg1gUPs8FQrDvxcFIrg5xeRVnHtECpGv7SEVBfxfwDnAVIYQwU0ngKk7IsFKKIhLO2AMeXVd3N9IQC+Bbbl+UY/gM4dqvPb7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648186; c=relaxed/simple;
	bh=fTQ7PdFKLEAeAYllhEAEngyzAq+x0/gJrw+JDPyi0Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZIIZwvlQiEF2wStgLCiVs8/42/DvNhHBLoOngxw4M5jl5HHob5cTRKz/H+onM3kKTblJSKQLVzwrc2LzkXZgujdelvzTr/ty1pQph/+49CxcGPahBkm0VUQgEtuh0GKzwTU/4Vovydgx8Gs/11kUxMe9q4ULLQI3tqRRbKrHGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYdz85vc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYdz85vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16527C116C6;
	Mon,  9 Feb 2026 14:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648186;
	bh=fTQ7PdFKLEAeAYllhEAEngyzAq+x0/gJrw+JDPyi0Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYdz85vcWKxlUNTk3xH4KUrarfpBZJIcb54hoaIVgj6YqpcmxHNXuXe0H2NdiyvOx
	 MjOApyUYQUO+HiICAxb5hkgw6ZRXunrybk6TP7aZUfpABYhIZ4yAYA2jBd38G+hgBB
	 xDF+XtS61VEPmh0B2Qa/Xk8dR0CXqL6egTi0Px04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/69] netfilter: replace -EEXIST with -EBUSY
Date: Mon,  9 Feb 2026 15:23:59 +0100
Message-ID: <20260209142303.046710430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed62c1026fe93..f99e348c8f37f 100644
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
index be93a02497d6c..016e31452cbc4 100644
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
index e8cc8eef0ab65..c842ec693dad4 100644
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



