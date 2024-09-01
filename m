Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F2B44C97;
	Sun,  1 Sep 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207814; cv=none; b=MR0pv3rzy12aWV2bjXeQffDXCZ8rUl+iMC8vpFiv5YVJqWJ5y87DFPAVZk3lv7krJqkzjXBolvUbDw1WSlqyNyX1TBS71LqDQk8wkTIB1vqmx8JhrWZ6pz1N7T69fEF0lGyp4oOuLMqi9XIvRWQJvXrNi3EVOpmPbQKphdT8DEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207814; c=relaxed/simple;
	bh=aX9ro6Kj+FbbynFSZ7Vh5a6xWfX0RDAMQS/QmLLNkgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS/G7tkFbGdZeYZp7x2Y7vnItxJom/ykz7Rp83oLgM3L1rUlTyJI0eaeYlFTAA4mQARWvV1knBJKAJduEjhkOxnOY6wViGgMiURSCE6wZUNNkihc36Fk0nH3oDmFKd7mcocauE/VR2R9y5hrQU3luGqfJcDS0AAm531nE43YKSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILzhf0h1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILzhf0h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A29C4CEC3;
	Sun,  1 Sep 2024 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207814;
	bh=aX9ro6Kj+FbbynFSZ7Vh5a6xWfX0RDAMQS/QmLLNkgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILzhf0h1nZcY6Y3/JL9Li3aY5KbNhhzxtrBm3bQEQQGHuEfeoenk/bHfW9FisGe4Y
	 YY5oR2gC2E65QdWyLZicxuxjo5PkUfYnSaKdp08AUV+nkXPYGPfmxjyHEc73Z0N2r1
	 f04GaLxp81I+JQzZ0DSLdhBouque6LPVa6FiFa/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/98] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Sun,  1 Sep 2024 18:16:28 +0200
Message-ID: <20240901160805.886523435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a61d7edfc290d..b4a4ed00506f1 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -108,11 +108,16 @@ static void nft_counter_reset(struct nft_counter_percpu_priv __percpu *priv,
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



