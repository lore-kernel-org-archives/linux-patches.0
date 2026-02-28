Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F1F359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302388; cv=none; b=rjbdmIg5RvTLMb2nmjb4INAU+jCuGKMqWtYy8REE7gR+k8cObdS9juZStFAJjG0Eb8PQoiaxYoEqft33CM+DwVEjkCkLOWqwJVoi2vMP2yzOfAEZA42ZWDOt6qZ+F+b2hODnriGW4+LEC3DHKSqOlH2RLvw8/ldG1u1CAhd1oig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302388; c=relaxed/simple;
	bh=gChsSVYdvw2gELx2LPXAxLNd/alJq9G8YTsjwNelCDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngsCdv8LWELlU1nVxIKwRZywLaUBnoprviCCJ1Fa96WatOioM3zhHD3sWmNRwbgbMcCD3gml+87P3W5OcGaOykSAGCrG3TUpO3LuaCwhSenjKDG1yHqOjUsO7lbopt7rKCbFhOrqzD0WFjThKlUTuDRSMqrvJ3IsAGk/Ddj+6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0YMMCYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0YMMCYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845EDC116D0;
	Sat, 28 Feb 2026 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302388;
	bh=gChsSVYdvw2gELx2LPXAxLNd/alJq9G8YTsjwNelCDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0YMMCYKnfgs2PD9Vhr3m8NQzbQSv7ceEKgirHTr5Oon9IM9M0/+AFtmRhBFJvF+W
	 5Zm7ME/nTs0RQwLNqqtP9XJMQmMKVET/YnvZNlWLh6UzRPt+NBF+uAqun6A6W3gh+z
	 2ChBtm9QNOM42U0ELTmSU5fB/1Ou/oihgg5QDEVYht1ssUk3rfCroxvPenp3Zufz64
	 yKFk2Dw03Z0Ph6Q52rSYTB6wi5KL/crtO+zvVoQHTH7ghIbeGC9pEDDP0f1MM9qUpp
	 ls7Bptrze3e29zTySbiqS5idE+sSCRSi4qHx8Eq5b29M1svRMRc4lBlR6zKoipIzXT
	 wSHhI8tIKKLjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anders Grahn <anders.grahn@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/232] netfilter: nft_counter: fix reset of counters on 32bit archs
Date: Sat, 28 Feb 2026 13:09:30 -0500
Message-ID: <20260228181127.1592657-117-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 79c3bbaa7e13e..0a3f9416f8464 100644
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
index 8d19bd0012770..7411bba75d4cb 100644
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

