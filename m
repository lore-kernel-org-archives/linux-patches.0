Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BD82D23A6;
	Sat, 12 Sep 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222250; cv=none; b=fII+WEX9trXx7pEzxNjwsn9VHXpPBdU+eBj6C2tbC3LGyvwmxWzTRrpI7bcWvIzPZ2LfvEJ6E2bXigByadtimKoVbmziY4itdfKBuClwOSSvFRik7tqo5plxeJmmAu+R9Q+XU99hloQn+JuxElVAW/dyni/4RU3fZlUSjHBR2R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222250; c=relaxed/simple;
	bh=z54DqVasKdp03juifSSUoRbilA9SmDuYOVD3jvb8gZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noksS2mukqv+8Rfco8RTub/dH+C3mhuP86SOxZp/KYhko+v/EsLthaLLDBFCka6eV7cDF2SrBuST6O3xY4yPLc5+hwJ08ArIaA4aoQBXQqyKT0fTD/6APmp+bbiPWMxUnqY+tK+oUt5JVQlkPyEoBhUDtmc9vcBnSP02zrQ/Sgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsvdVZnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsvdVZnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67951F000FF;
	Sat, 12 Sep 2026 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222248;
	bh=z8vW3e4YXMtnS1lEkXLUdt+DHkNMQt3IFq38K6I+4y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsvdVZnNcnBQEixV4J7iHvGZuEjkq7OOZBMj9luEFZUU92K2jD6m+YHIKGMiwoAcB
	 uWX7xYWiSoGxXPs2hEIhRr3CVNSDu24pDsb9aZC2QH8P7rv0iLgwV25cHyLBNhUcnl
	 kOkeSmlScQP78cxZW4Ky8XaejoTF/QqnyQ1+RsEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Brian Witte <brianwitte@mailfence.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0549/1424] netfilter: nft_counter: serialize reset with spinlock
Date: Sat, 12 Sep 2026 08:49:41 +0200
Message-ID: <20260912065619.596696011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Brian Witte <brianwitte@mailfence.com>

[ Upstream commit 779c60a5190c42689534172f4b49e927c9959e4e ]

Add a global static spinlock to serialize counter fetch+reset
operations, preventing concurrent dump-and-reset from underrunning
values.

The lock is taken before fetching the total so that two parallel
resets cannot both read the same counter values and then both
subtract them.

A global lock is used for simplicity since resets are infrequent.
If this becomes a bottleneck, it can be replaced with a per-net
lock later.

Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_counter.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 813c75cd2c259..3fa6369790f4d 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -32,6 +32,9 @@ struct nft_counter_percpu_priv {
 
 static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
 
+/* control plane only: sync fetch+reset */
+static DEFINE_SPINLOCK(nft_counter_lock);
+
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
@@ -148,13 +151,25 @@ static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
 	}
 }
 
+static void nft_counter_fetch_and_reset(struct nft_counter_percpu_priv *priv,
+					struct nft_counter_tot *total)
+{
+	spin_lock(&nft_counter_lock);
+	nft_counter_fetch(priv, total);
+	nft_counter_reset(priv, total);
+	spin_unlock(&nft_counter_lock);
+}
+
 static int nft_counter_do_dump(struct sk_buff *skb,
 			       struct nft_counter_percpu_priv *priv,
 			       bool reset)
 {
 	struct nft_counter_tot total;
 
-	nft_counter_fetch(priv, &total);
+	if (unlikely(reset))
+		nft_counter_fetch_and_reset(priv, &total);
+	else
+		nft_counter_fetch(priv, &total);
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
 			 NFTA_COUNTER_PAD) ||
@@ -162,9 +177,6 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 			 NFTA_COUNTER_PAD))
 		goto nla_put_failure;
 
-	if (reset)
-		nft_counter_reset(priv, &total);
-
 	return 0;
 
 nla_put_failure:
-- 
2.53.0



