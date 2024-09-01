Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581411DFD1;
	Sun,  1 Sep 2024 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209615; cv=none; b=MiQ9GjFY3CNhKtOGaBlF0BSgMdPHjsJ/yaWBih8otBUoQrbWkGpYkVshIU+K+JpV4HFA1LdoxDlEnjRmfqGkaktzd+Wx1SJq1qrwy7BK/LBZQtT53u17K1qmeFyKzHtHlbD4aLBGlkr4y6AtmI1uqcLaWMm7b7MsViV88D8szyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209615; c=relaxed/simple;
	bh=/1x2SCRcQdwx+KL6FtwOVCTQc2YvOShc4n3a+FAJSXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLp4CTVbEFhkWlo32TAhkmyfcv3J7afZqvUkQHqolo5E37RjQICnlLLS7DStFl5+QmCIXtw5CqN8uHZmr93yYzGft4Rdk4i+nH1pkHjUUAm2tzq+mRtEi8G8YfCPJIsDohoJCzM4G6V4j18OlQ2EMxR1JDu1MS8OyKZ1JywT7q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQGtoPGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQGtoPGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E56C4CEC3;
	Sun,  1 Sep 2024 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209615;
	bh=/1x2SCRcQdwx+KL6FtwOVCTQc2YvOShc4n3a+FAJSXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQGtoPGGUyFUtPhRW2Zlmr+hffXqJZIfij8yW4zN2BiqdWRE8bvvTnGCDjX2XjMIJ
	 91tRmAlIYqgW0BUw1L53eHmw/sgVgxd8rdFJICHDehUieWQgwASELQ90rApFhgpN+U
	 zjAkOgjw7NubytudCy3rSif/qGqRGKEzq6sCHqFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/151] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
Date: Sun,  1 Sep 2024 18:17:30 +0200
Message-ID: <20240901160817.502471404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 75fa6fcd6cd6c..ea102b9a168b8 100644
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



