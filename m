Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A3F17C;
	Sun,  1 Sep 2024 17:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210321; cv=none; b=EIk2hP6ImX1Jk5tFJaGJ8Y2zoYOL6pZnRtxzndS2lsJFmwW4UXH/BrbbEi8NG+NUc83WuPBORxl1tLy1EYeYVJ2s5guUurF07yFsW6tMQMjepmmib8ojznGbEp6P1RJ0eZnbjvfRWrAw88Zi12ULBnaFtjezPc7j/Q1HYFU3M/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210321; c=relaxed/simple;
	bh=Ko2kREj09U64pjIfUpZF4cDbg1rG5MifYOJ/ONSaFMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdvUU6nvURrT/4Yj/h0ZWagmtW9PojlmEZ5pt+5C+8+UucgQH4lq6pkXAAJEN+ThDK4izhhyPj+u3AP6PAz0Kou8ccczE9D11X+OYFX1fIG/udz+4iCP7CYdSpXd6CZkOZ3ektwtKDyMcFGTTwVhKcqQPEmRY8OxqUJAmW4uESw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEUohsL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEUohsL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4C4C4CEC3;
	Sun,  1 Sep 2024 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210321;
	bh=Ko2kREj09U64pjIfUpZF4cDbg1rG5MifYOJ/ONSaFMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEUohsL5ZJhKs484frLPdB6xqdpaOJJjo8Z8GGIKlR4qFbrFy1fPN8qQJuevRD9z6
	 hnQRVhCX+cqW8Lh+mo7wAHBN4eMC6hASoEOlm3ibs3gUv89J/ZNrLs+o6kja4H9KJ8
	 tsijOe/qFfVQAcem7W0ZJb3GHZjS+Tt0IvBZUNto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/215] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Sun,  1 Sep 2024 18:17:29 +0200
Message-ID: <20240901160828.544220441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index f10d36c693b13..30b24d002c3d8 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -106,11 +106,16 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
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



