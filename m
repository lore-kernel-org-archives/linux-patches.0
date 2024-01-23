Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FB07E760;
	Tue, 23 Jan 2024 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975780; cv=none; b=RVhEp94DUnt6ijsHA4wsecrUMOHDPVCqUxntCOuoJqfg9Svm/GijoNloK/M7yzC0r7wGpHjHn97LSlpZ8OKEjvvOvB0nTeWXsPrFCdUzcl3iqlWNcnKWWbPsKTkMWjk4a4Fu2ykja9u//GOz2ITlAWo4gyj0E7g1D4T6X44EnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975780; c=relaxed/simple;
	bh=EQ8lO3G4fnQYH4h+FgOsD5wJQdG5O57dQnQOzDrlNvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqPzjTlFl4FU6AVZmbuamOPbB7W5J/emJ6wq2lE//ZoDq5GJh2Tb7R1W9R21SWzrPF9DrZpvOkhLJbD9gQt2O78IrCelMHZNkr3yDMYi7bD+UMJ8flPqawjsa+yCbE+SAFHua+3rHyRE0quPn2m8Bixcvd/JpOz4aYUoahwzpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd7H/AN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd7H/AN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B0C433A6;
	Tue, 23 Jan 2024 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975780;
	bh=EQ8lO3G4fnQYH4h+FgOsD5wJQdG5O57dQnQOzDrlNvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd7H/AN7O8XFF1yEE8u0wBXzQR/2FSLj4wiDgC0cv1GFjUQKsMrWSD8SWddZblLdJ
	 DK2M/SDWgVBKf6O0wmQOR8pybWzzbWar62455gzxNbrKwQZM3nocBVxt5Tm8qJ020D
	 qoXVTh0gaTvDTimLULvm05ju3tZFq8JUaLMbKCFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 563/583] netfilter: nf_queue: remove excess nf_bridge variable
Date: Mon, 22 Jan 2024 16:00:14 -0800
Message-ID: <20240122235829.394489813@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

[ Upstream commit aeaa44075f8e49e2e0ad4507d925e690b7950145 ]

We don't really need nf_bridge variable here. And nf_bridge_info_exists
is better replacement for nf_bridge_info_get in case we are only
checking for existence.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 9874808878d9 ("netfilter: bridge: replace physindev with physinif in nf_bridge_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 63d1516816b1..3dfcb3ac5cb4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -82,10 +82,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
-	struct nf_bridge_info *nf_bridge;
 
-	nf_bridge = nf_bridge_info_get(skb);
-	if (nf_bridge) {
+	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb);
 		entry->physout = nf_bridge_get_physoutdev(skb);
 	} else {
-- 
2.43.0



