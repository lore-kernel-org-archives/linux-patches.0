Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D0F1CCEEA;
	Tue, 27 Aug 2024 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772567; cv=none; b=L+44/zwUmeFwJGgN7MvmYOxOr1ucn53a7HKtepUFKJfxZdISS8Pd1YC0JjXdyqQrbRP2Z80bk3tz19/d9G3/1nM9O6H3RtrJk8JqDkjjmzf5c9qn0nKHYAJk81xriJuwzIHAowXUWLP7RRfM2VF6PO5FtMG9QN/17isi8mafhhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772567; c=relaxed/simple;
	bh=5ayV9ITLpgUWcgCrHVvZHffXpkuSsAQV3JunGCfhCNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM5VJIRBu9G2D4nCAp1LoGJKQaA4EGLxhW2cDDtl8qmDXPmp39I4d3j79NWXLEcTZTehOcorHimA0Xeb+ZMuscgFzgLDReq+S8ov43GEYG8Go4TC99SQLPvmBerQ6puDEdZqZsrUpBbJXgR+dOOlHPZargrfUJpPB2q8uRBTrHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR33gG4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR33gG4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A57EC6107E;
	Tue, 27 Aug 2024 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772567;
	bh=5ayV9ITLpgUWcgCrHVvZHffXpkuSsAQV3JunGCfhCNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR33gG4c5hQval4W14k91Q1+hkFtoIczyJQWWeZ5B7FdwHwninrYXGFNv/CMsxgLi
	 y9v6Hz+J/vhdI7khFfWWsdijstElcMYZSzBay9nedEMx90h26hjGPVmNrf9pBk/v1x
	 UOZIh7eG0F8bRv9qIfyVx7QM8KQ1K5/yfB7ZKHdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/321] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Tue, 27 Aug 2024 16:39:04 +0200
Message-ID: <20240827143847.220190255@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73e4d278d6c13..781d3a26f5df7 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -107,11 +107,16 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
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



