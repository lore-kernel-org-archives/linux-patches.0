Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F24E12E4D;
	Tue, 27 Aug 2024 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771419; cv=none; b=qQBR7dnBmt20tDJm28wCKRXLgqVyQNdD+Jf7PsSHIuHanyhu/rWLe1ytaRz0koDnOrau8Nzu6UA1bYYjliijbPHQ+T4RqQASni65o4jZ2tldS2b7JzXWvNegXqMPwsckTzpsyId8lEfGW/Wh1JT0u2eZiGIAn9H8gyj3jluBAmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771419; c=relaxed/simple;
	bh=8mgRHOaylaIjTUK2w+aEds/9NWuiViKJAq1h0O/jSFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1NEosjBALgUZwuaikRlEX+423VZWx10XtoJjY9sWcuaZDvhbaOk9p2fmZnszAvqnluMNo6TNGXtwRtxF5/cV/It96W23VLtAD4klvkRy8vubegiWQw3JMueClUkNhRcLADF3YPjYZP4PF/B7fLPnJa59WeW6m1m7Ml8dtYOmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wsficfik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wsficfik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13395C4AF5F;
	Tue, 27 Aug 2024 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771419;
	bh=8mgRHOaylaIjTUK2w+aEds/9NWuiViKJAq1h0O/jSFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsficfikXQWVgqoQWqvpbF6CMc6auQ3+nFQUBt13s6n/2+KuuUFJ3vLFLWiUP81rR
	 T5MbzLBrHYhCR5a7YIHXRW6rIeYYAWwS9pqpNFYOOVBFYknL3Q4lt67gJVWG71i2ke
	 ot67MRBYjqghwSN28iwt1oKUT5KY9coWbYXGIyVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/273] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
Date: Tue, 27 Aug 2024 16:38:09 +0200
Message-ID: <20240827143839.688675993@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1eacdd71b3436b54d5fc8218c4bb0187d92a6892 ]

The sequence counter nft_counter_seq is a per-CPU counter. There is no
lock associated with it. nft_counter_do_eval() is using the same counter
and disables BH which suggest that it can be invoked from a softirq.
This in turn means that nft_counter_offload_stats(), which disables only
preemption, can be interrupted by nft_counter_do_eval() leading to two
writer for one seqcount_t.
This can lead to loosing stats or reading statistics while they are
updated.

Disable BH during stats update in nft_counter_offload_stats() to ensure
one writer at a time.

Fixes: b72920f6e4a9d ("netfilter: nftables: counter hardware offload support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 291ed2026367e..16f40b503d379 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -265,7 +265,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	struct nft_counter *this_cpu;
 	seqcount_t *myseq;
 
-	preempt_disable();
+	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
 	myseq = this_cpu_ptr(&nft_counter_seq);
 
@@ -273,7 +273,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	this_cpu->packets += stats->pkts;
 	this_cpu->bytes += stats->bytes;
 	write_seqcount_end(myseq);
-	preempt_enable();
+	local_bh_enable();
 }
 
 void nft_counter_init_seqcount(void)
-- 
2.43.0



