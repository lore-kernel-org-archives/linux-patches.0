Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F9E2B9C7;
	Sun,  1 Sep 2024 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208942; cv=none; b=D3rhuR4imNhULjRarrOlTwK2nsMU2t2MWBCpy10eBZOXHZHzBW2oUAKmkVZdrMFJu1Y+u19BiDpSG8KZRibjRyMMCJmYfxzeMhJ5knkCiBlplR6amYBchOpV6Czn1MGCaE3/nt+BKdg7UayAB4oydgxQQMZ4YzLW4yr12AqPW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208942; c=relaxed/simple;
	bh=80S/o+h9kNSKLp17q9mICVpzI7N1B506xYA036GPdwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzZwRDlyIxHjt+MuU5vW6k6e/oM34ellrEHYkZLUt37oMQEpR9vFowSocwzYkP55sIRJXYj5rTGs/LCRHpE94Jxgs3bUIWD7lZSROYd+/3VQI/T4Hk/2AmhDkKcS3HuDhSBmWykkj89oqpcCrcoP5I4rNIbx6bGFYHsdXtCGjYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4xtNah+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4xtNah+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87217C4CEC3;
	Sun,  1 Sep 2024 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208942;
	bh=80S/o+h9kNSKLp17q9mICVpzI7N1B506xYA036GPdwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4xtNah+wrwT61gxgtpP5tq4PLqWHf58wzk1WHVmnU1MPwLsT2yZfluoAKZhAmmy9
	 cIgTrvOZa03xxvkv6Xt4ASFKcahhM8y8Paj9TShl0Ppmt6zHYpBleszgNYBeFTPtSC
	 sHjL4zyAgy5UX/VjKC7gD7FLLYD2kPmyj1A8nat8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/134] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Sun,  1 Sep 2024 18:17:11 +0200
Message-ID: <20240901160813.301999160@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a0b39e2dc7017ac667b70bdeee5293e410fab2fb ]

nft_counter_reset() resets the counter by subtracting the previously
retrieved value from the counter. This is a write operation on the
counter and as such it requires to be performed with a write sequence of
nft_counter_seq to serialize against its possible reader.

Update the packets/ bytes within write-sequence of nft_counter_seq.

Fixes: d84701ecbcd6a ("netfilter: nft_counter: rework atomic dump and reset")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_counter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f6d4d0fa23a62..bf829fabf2785 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -105,11 +105,16 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 			      struct nft_counter *total)
 {
 	struct nft_counter *this_cpu;
+	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
+	myseq = this_cpu_ptr(&nft_counter_seq);
+
+	write_seqcount_begin(myseq);
 	this_cpu->packets -= total->packets;
 	this_cpu->bytes -= total->bytes;
+	write_seqcount_end(myseq);
 	local_bh_enable();
 }
 
-- 
2.43.0



