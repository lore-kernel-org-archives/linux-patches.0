Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF4813AA4C;
	Tue, 27 Feb 2024 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043151; cv=none; b=X9Ps11h1rDCzjf+XTb+0v14w5MRPL2HnYE5V3Kh1fYqzpYgfZeEclgD3nv5iLlycweEW2hNUY13YK5VcQii+LHXXTPScxjq7i8uwwtHtB1mo2WWKgRJKyByqcSiaIMdbUXOjVrY/QDx6Szy/930Pbn5vKFYbnMOUm9tt8kAnZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043151; c=relaxed/simple;
	bh=5HSQGs+808w0nUj7DnnTWxL5kVuueXngzgS+z5eZNBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0P8LFIjFShLKedNHqX6ObD1cQBnUm2Yucinxw/nsXnmDDxmH8/MQCNpmJDGaTPgtdx6V2XC4vE7ak1j8GD4rAQtWZzzZJRBfdBiUVQ3+O/AsHeMf6JuN84IA7INal79Fl7VvF4S0g6IXXXcr0bjhSoDc/pl+YSeV+Yd+/wGKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMT+q7Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMT+q7Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EADC43390;
	Tue, 27 Feb 2024 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043151;
	bh=5HSQGs+808w0nUj7DnnTWxL5kVuueXngzgS+z5eZNBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMT+q7YxhekluiQEHx7Ek4Gk+LUUNBD5YkcyvGFFolScchmKBYsfIgPv4dPmwfWcJ
	 9ikYJIps+b8ByqQhWl1Iw+vUjlTyhPYlulFeDzPCbtPydKbmaWkHsN8IyGZh3g1DyL
	 CMUVdOFnU5C3RkPOwPGtDl/oeo9cLiGpJk4YwoII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 245/245] netfilter: nf_tables: cant schedule in nft_chain_validate
Date: Tue, 27 Feb 2024 14:27:13 +0100
Message-ID: <20240227131623.115577535@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 314c82841602a111c04a7210c21dc77e0d560242 upstream.

Can be called via nft set element list iteration, which may acquire
rcu and/or bh read lock (depends on set type).

BUG: sleeping function called from invalid context at net/netfilter/nf_tables_api.c:3353
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1232, name: nft
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by nft/1232:
 #0: ffff8881180e3ea8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
 #1: ffffffff83f5f540 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire
Call Trace:
 nft_chain_validate
 nft_lookup_validate_setelem
 nft_pipapo_walk
 nft_lookup_validate
 nft_chain_validate
 nft_immediate_validate
 nft_chain_validate
 nf_tables_validate
 nf_tables_abort

No choice but to move it to nf_tables_validate().

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3443,8 +3443,6 @@ int nft_chain_validate(const struct nft_
 			if (err < 0)
 				return err;
 		}
-
-		cond_resched();
 	}
 
 	return 0;
@@ -3468,6 +3466,8 @@ static int nft_table_validate(struct net
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
 			return err;
+
+		cond_resched();
 	}
 
 	return 0;


