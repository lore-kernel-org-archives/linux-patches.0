Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6963518DB2A;
	Wed, 25 Feb 2026 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983271; cv=none; b=AoBUK1dV/vSm/dubOyVLxM1cquUuw7XVWsqxZDruCgRyQljOyx720FKhVpK37oNAH7KH3geNGtkt2E9m8mWhNYBxDC86HYVy3ILD+ugEzjPboyiuuN3Wq9sTQ/F534QUCHt4eUdyjHVhrCvUMjdZITHZ4xiOODgfxvi0mk+ldg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983271; c=relaxed/simple;
	bh=O6KF9uL49E8HEqcKT0Zq8Sy+kzv7S0ZTKogxWECSaMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6Dkq0jgu4vptuL2Er5eyck7P/AJaLkQK/wE9xT9HwiGVeKHMP7bvcAYPVotlkSMONANndqdOGmYc0uCeQIB1GxsgXpu8z7fsfDqodSbwSJrfOq7N94J3sQQIyl/YuFi8NAQR6hZxFdTi20BFpxaKRbRwLNKzkheD7Mu5pdoXuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEG/S9BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEG/S9BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2703AC116D0;
	Wed, 25 Feb 2026 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983271;
	bh=O6KF9uL49E8HEqcKT0Zq8Sy+kzv7S0ZTKogxWECSaMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEG/S9BJeNNoVzGyWUolbNudue2yd+1LSK3F0TZySjuX8yr9pbeqzlSBcwkGKibRi
	 56orsdlhWqkH5drA/nk9hMZZfc2+QvbYZMKXnE7C3Nf/IePd5W1b2D33MGTybLHA56
	 89VOmnRmcrQayv1lL98QkT3AzvaQqNmfcR5doEK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Grahn <anders.grahn@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 411/781] netfilter: nft_counter: fix reset of counters on 32bit archs
Date: Tue, 24 Feb 2026 17:18:40 -0800
Message-ID: <20260225012409.782235014@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



