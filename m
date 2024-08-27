Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CF41C57AB;
	Tue, 27 Aug 2024 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770581; cv=none; b=g/LcJPVYf18nKlRVX/WqCtDa/QidZyLu8fvSzNP4d/39y+Z/79BVOms/lb09nvOPZ51st1K/k9JzY+FBTtpioc57UANi/urVHiyU2x11x000UJypBcTEABNc5n2tuEgseKfCz5Yryxi8v8V1mvyVzg4bo/aOgfVxraZ9bWcwvwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770581; c=relaxed/simple;
	bh=EoGlUHIKDqUApWOTiUerancCUCcZ2MmNRlF604BE8U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc4jn5GCmU1+s8V41f8EFfQSLeqQblDy51zSnn+JuE/1Uks5c0UFbAi/QFCGDPm3SdNKHMHxA/ysUIyVY5TALeNye0rN1tosUxpLFE4ATfYCFRvEEXwL/20/g4KTeBIhupVBkYwBml8yN3oZhLenG/WlSs++GhQ7XbVy5Bfxo3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikYM7vcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikYM7vcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBD6C4E699;
	Tue, 27 Aug 2024 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770580;
	bh=EoGlUHIKDqUApWOTiUerancCUCcZ2MmNRlF604BE8U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikYM7vccubpqt9+WKEsCWS16NS8+V3zY2lxV8KX+dbC3HhYeYtv00u71QkgvpRX9T
	 cscHdwoXw/igob6ntgk5Wj835ejJPbqTFpTPfP2vDNXdPGuxNsEJAt1UuS3zDnnCYt
	 BYzROrBsQwNOt4Pwtq+s3x2vHarnzeCCX9X7FTno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/341] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Tue, 27 Aug 2024 16:38:05 +0200
Message-ID: <20240827143853.075091036@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 5a90c3c7268bf..b7aa4d2c8c22f 100644
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



