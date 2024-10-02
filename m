Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6781CFEBA;
	Wed,  2 Oct 2024 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875321; cv=none; b=iY14Gk/fDTuDvCeAc3yDQIlZIbejIrjVoe1RxDmzklHW6BJ89Xl50BmdK1VI5FfkkHLss/1mKkwH3ThOzfkVT6fkYuvuJyqk0wXponPXxHFKRgvzPDM/vW0AlvaKgDB5fs6eX+kdzzLhNm6Cd13lPYyYSDkWzoi9ETEAfSqxiU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875321; c=relaxed/simple;
	bh=ZF/maBmHxzq/ihyHxgPCExkfv4J82NLuOTBJ8isc38w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MihHGYIFrp9A8LzEr6VKO3MWXhjdJ+A4L4C0SmRJT4lzbCMWQTlcjNxTeqduWOYLC/6J7InZTIBNeJeFTWz5rC7UO/T7L4RrRQs26OUJ5xWKemffl8bJju/0xY1c0XRkBnopR1LQ0Emc4iQucLr76ta2tuuSTAAgQNRyL0eKKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9wzGKcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9wzGKcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6ECC4CEC5;
	Wed,  2 Oct 2024 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875321;
	bh=ZF/maBmHxzq/ihyHxgPCExkfv4J82NLuOTBJ8isc38w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9wzGKcY0bCfukPQ3LghIqCA7GNNiYqw7a8xmsLaljCyD1b1LRlQlv8mgXQ44f3Tp
	 MLxpykSaGPU6yvSsAy9NbnAcpzyCEZVC4B1tlnvhg1XkGrGmcCYvPnzYehBmKAS4zo
	 hZqILtr2AeObSIwdFZnhdqEd0IFipgBGwkThCC8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/695] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Wed,  2 Oct 2024 14:51:01 +0200
Message-ID: <20241002125825.001077194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e0c47281723f301894c14e6f5cd5884fdfb813f9 ]

Element timeout that is below CONFIG_HZ never expires because the
timeout extension is not allocated given that nf_msecs_to_jiffies64()
returns 0. Set timeout to the minimum value to honor timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3ea5d01635107..95ef930d4fe9f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4592,7 +4592,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



