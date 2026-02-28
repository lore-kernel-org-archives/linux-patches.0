Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A2342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301813; cv=none; b=G/mWrBKITy215Tyk9SxZD+rg565Ruc4HXfLqCFYhtKonNcx1h9Qocwc9zp+k6aYx6t5pjJgWIz8+T0pvaRsDbrQXk+4c8G6g+I7I7JFySWD7gP1Fl0FNJ7NUjJ2IznzmDvAnArsTO1271/l40xOwBqEs7UkFZ0Bj/xcH7OQDjSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301813; c=relaxed/simple;
	bh=IoVJKt8d0ZBIvaFm4KRkA66m+tHk/dXXJ3YWsJp109k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI4Fe4qlmZvoxVNvzPulxbfnfBRWSnvAPsSLH21ixztLjRuX5uEKfCC3pC5Q/BcEt42URFRhiQf+awCZSnZO078WJxmewEmpyQWWbcS3rZRLcnSz3PLOLxelL4+2lwDJL1wYZIixMbOawX1BWOAsal4thA54kPf3BWJN2mV/Ikw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asYlZRWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asYlZRWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1DBC2BC87;
	Sat, 28 Feb 2026 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301813;
	bh=IoVJKt8d0ZBIvaFm4KRkA66m+tHk/dXXJ3YWsJp109k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asYlZRWl5AymVHH1LupW2HQlWG8niAugPKjUgDDH5dtGtukSxbE2fbH8iMgo1M9bU
	 p3wb6HptZCuV5HPjRnuPwzv4P1U8CkWjDATlZcOmQbYvbkIfQK9vPgcY5jNMX5xLci
	 tpq/K4EfKgpRs5s5/YbEsJdRY9dAmifY6WzJ+D2EH53+qE4MqjsyPk9uimFkZXZsKp
	 gzyYHa+hX94w9hWk+nPMcw3BnABpbUbcbXWCcUPKGgjWN7Hho+78BXl6fNBp9u2HWu
	 JviZW+S3UjZ56/KTrd5I0GRPaZ8WfdBby4Rz0EDfLfGZ2qCuTCmBEWKGUAGf+5dU4m
	 lJoCRjEi2JcaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anders Grahn <anders.grahn@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/385] netfilter: nft_counter: fix reset of counters on 32bit archs
Date: Sat, 28 Feb 2026 12:57:29 -0500
Message-ID: <20260228180011.1568201-227-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anders Grahn <anders.grahn@gmail.com>

[ Upstream commit 1e13f27e0675552161ab1778be9a23a636dde8a7 ]

nft_counter_reset() calls u64_stats_add() with a negative value to reset
the counter. This will work on 64bit archs, hence the negative value
added will wrap as a 64bit value which then can wrap the stat counter as
well.

On 32bit archs, the added negative value will wrap as a 32bit value and
_not_ wrapping the stat counter properly. In most cases, this would just
lead to a very large 32bit value being added to the stat counter.

Fix by introducing u64_stats_sub().

Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic.")
Signed-off-by: Anders Grahn <anders.grahn@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/u64_stats_sync.h | 10 ++++++++++
 net/netfilter/nft_counter.c    |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 457879938fc19..3366090a86bd2 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -89,6 +89,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	local64_add(val, &p->v);
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	local64_sub(val, &p->v);
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	local64_inc(&p->v);
@@ -130,6 +135,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	p->v += val;
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	p->v -= val;
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc73253294963..0d70325280cc5 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -117,8 +117,8 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
 	u64_stats_update_begin(nft_sync);
-	u64_stats_add(&this_cpu->packets, -total->packets);
-	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_sub(&this_cpu->packets, total->packets);
+	u64_stats_sub(&this_cpu->bytes, total->bytes);
 	u64_stats_update_end(nft_sync);
 
 	local_bh_enable();
-- 
2.51.0

