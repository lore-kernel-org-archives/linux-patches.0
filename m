Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B5B12E4D;
	Tue, 27 Aug 2024 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771457; cv=none; b=WDCkZ9gb4cGy5Y+o+cDKNIg7LIr/dRjGqc3Om0T+k0yEdLOmL0iQXvlP9cYbaTSmmqy4XvqUu4B9wzZLwh/stQhaSu5NmM0GDJqjNLVSliLOeKmyEx8F3iANTHKBw38s6hcc03LHKvvcE6dpjts+i7jWCKFP44AHZOQ0LXw0D8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771457; c=relaxed/simple;
	bh=nWcu2xGcmh8DYWsZ39T/L+9xqL1wD8o39s7GMa86Vdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV395s1/zGgD5FQ7cCwUjtJdVkYsxSjrCqrOgvBob+tzeOWv/C1vdr394oLaz3fhOW1oZc6AiZRIIJhCDDFlydeIz+36KPH+0Vj6a3RSmktDjwoXmQ9pnMAdaf/06E+oNfVIdhAjqaUX58HygP9O8JlrYU5prm9nUPb4ZJrfEF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSZcC2mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSZcC2mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B77C4DDE8;
	Tue, 27 Aug 2024 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771457;
	bh=nWcu2xGcmh8DYWsZ39T/L+9xqL1wD8o39s7GMa86Vdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSZcC2mHFPzjLVYzibvIV3J1AutvC3KtYa6bEIPWIvYGAtay+KJP48fJAzg9NCyt4
	 ThfBsTn8v+h1SwS9MHZjO61yaEMy1IgDq5pjA0QdM0HqGij6gSNZex5vlzauri3Wyj
	 2AZNwpLQ/pn6jIPM8xdXAC8oTTjOL48KXtEuPnlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/273] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Tue, 27 Aug 2024 16:38:10 +0200
Message-ID: <20240827143839.726975638@linuxfoundation.org>
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
index 16f40b503d379..eab0dc66bee6b 100644
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



