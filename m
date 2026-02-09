Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC425DB1C;
	Mon,  9 Feb 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648435; cv=none; b=nSvK6G6MlCOgrj+CetyaEv4dGjwUaO4QCJ6xmIJwz9VZ3L7JP/zyassUq4HNCZID9fbUAAEstdgMLZaUMXNnb6XKa9ZQyYV/ty7nFegkFDdEYIfVuDhDYgEIAkquwU+Oi2Ho38bT0rGB8OsDd2rg879OrM8fNZSSInB630oWlnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648435; c=relaxed/simple;
	bh=DbQwUXzhuolyVi8EfA46QNtL8gkJWjrOWiaH7l0hZ84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evQEUiU1IBxYl8Dtw4eX7nbPOiuKD9JJ1luOb1669VB/yhID03oTpLKPE1IcMIskLVeYpYYCDXDVD6yiGRUJmUAYm2aD9HdMse7WpTF0TiT4KxlxFiRGzZSrZs2b1Nay9GahXvBK4XLv1Zdgj7wBGOx2YSrFR+FUp1XYDJf7LYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtGsbLv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtGsbLv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500B3C19424;
	Mon,  9 Feb 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648434;
	bh=DbQwUXzhuolyVi8EfA46QNtL8gkJWjrOWiaH7l0hZ84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtGsbLv9tNpngCnFtjlsAOn/C86r3ToCuJzVyLLWs8+r8ugN8ptt+sNQyFdKIo4cM
	 bRsDNeo90vWzma1Njtac8Kgt1u8g8d7z/e5P05JuldAAz2J2ZZE4fEfiBK8TIvabto
	 RCC5qsrVWBPppUZl7eWseGVNe4+8/m6rJElrB/bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/86] netfilter: replace -EEXIST with -EBUSY
Date: Mon,  9 Feb 2026 15:24:00 +0100
Message-ID: <20260209142306.121754828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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
index e16f158388bbe..75c812f157e20 100644
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
index e50c23b9c9c41..d892afc9a1acc 100644
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



