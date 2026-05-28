Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097A26B973;
	Thu, 28 May 2026 20:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998530; cv=none; b=bv03PhxmTJJEzWNRHnuEHWhSoJgl+Zpre9g+VBZPW1gwwZ+ORTx7lqid55Lb6Ej6XCK3dUousgz13MjrhNvEhzk3z2GgJaXUkAH7sLSRPWnNB2VV5SPpuOyqBAlpSoi4u0zY5bLz3HrtzjP0Wze58k/008IicT2VSKg+Gp2k/is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998530; c=relaxed/simple;
	bh=rnFovw2WYsqQPF1PRSd+1QDMqmLiz6ijcivm1hSugHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah/JnOUnklBdXwvYv1mKJOOMBRFMOHpyxfGAnXQjypxWcJJJXXZamYYlnwxhBcUyMHdBrAFk093fjCkbIlwZlr4AKOgzrgu1Z1sAkMJOIUpQE1wy1atoW1pnQIBMu6jvLgyxUVR9/bXjE9/m9E5XbAr4BeGcO0ZYcnzUFElfu/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXQN0+bs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXQN0+bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5B81F000E9;
	Thu, 28 May 2026 20:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998529;
	bh=uNXxKzzJQZ645uFfeDA9/T6gTRjouur3VQEB6xsqa+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXQN0+bsSuzuGpeP0FEPGsxDHnPHiZLNdigXpCM8IerfyUeWhCAK2sbSzZI/ZnDix
	 aEr3yaoflVh67ygMracbkgO4aY0dCi2tFUN7oRt8hV5AbkjZBtZ9HvhzxEmT3HIO7L
	 LwNj651ILvYVNp5n6ooCPsPzzISCfbbOX4AQs0JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 207/461] netfilter: x_tables: allow initial table replace without emitting audit log message
Date: Thu, 28 May 2026 21:45:36 +0200
Message-ID: <20260528194653.105328857@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8e72510db9fa2d41f2b06d5c01fe9020e076fee4 ]

At the moment we emit the audit log a bit too early, which makes it
necessary to also emit an unregister log in case we have to unwind
errors after possible hook register failure.

Followup patch will be slightly simpler if we can delay the
register message until after the hooks have been wired up.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b62eb8dcf2c4 ("netfilter: x_tables: allocate hook ops while under mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/x_tables.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b39017c805484..f694eb72e48db 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1405,11 +1405,9 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
+static struct xt_table_info *
+do_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo, int *error)
 {
 	struct xt_table_info *private;
 	unsigned int cpu;
@@ -1464,10 +1462,23 @@ xt_replace_table(struct xt_table *table,
 		}
 	}
 
-	audit_log_nfcfg(table->name, table->af, private->number,
-			!private->number ? AUDIT_XT_OP_REGISTER :
-					   AUDIT_XT_OP_REPLACE,
-			GFP_KERNEL);
+	return private;
+}
+
+struct xt_table_info *
+xt_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo,
+		 int *error)
+{
+	struct xt_table_info *private;
+
+	private = do_replace_table(table, num_counters, newinfo, error);
+	if (private)
+		audit_log_nfcfg(table->name, table->af, private->number,
+				!private->number ? AUDIT_XT_OP_REGISTER :
+				AUDIT_XT_OP_REPLACE,
+				GFP_KERNEL);
+
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
-- 
2.53.0



