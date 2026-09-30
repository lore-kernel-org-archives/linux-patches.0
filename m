Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84462503BD0;
	Wed, 30 Sep 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783418; cv=none; b=OEmz3uCrISkCvC+cp7VYgH3cqARwobMPF1bB2Yd8HA7V+CSrY1Zi1gcpeTLKECPl2eGreWg7AcqZqqQ/6ymuWfRztIUFipAyMrAHUJdOcjA7wXU0b+h0q5YeXdjjszanP94DlQTZMpvXbG2W85O50heWpc+gQ0kXSoS3RLAajU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783418; c=relaxed/simple;
	bh=lqiC5HkeWKJ1GDM2kgKpu5BR6LCxCR8AeA42oZWmy/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHRUcmwe20yjeC0jbNg2X6tym1HKQsr6Ez4XbXRX/9uNFOklXl5s8/qwkbTciN5mzArcIHHkEHb1j517FO13opiQz0tbspBznWTdM7VhPwNf5+wVFNjZao4HZpbkMXLHcCKE8JDsWbxcvLQc/VMTqfRRO/Yx1gepXKFLd6Ilr04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3tGvpC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3tGvpC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DAE1F000FF;
	Wed, 30 Sep 2026 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783415;
	bh=l2fkJQQSVm017mDI8ldjKtR7FUCbXImQZTLrTkyBuYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3tGvpC6sScDIkYkRxmJWRgogCSDmvjZXa/z1nTIpJG9fBqdOo8ymTExU1PeB9gBz
	 bQ1fxQpDos/txcfKO3Vr86O8g/ixEuVdGNWYgI586o22pRabsA7TTcVVHDZvjZfy8B
	 dCPhRL7A+ZPo+Yrqqi7zQ7v3v9aJNDj+s+O7KUKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/595] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 30 Sep 2026 17:24:43 +0200
Message-ID: <20260930152356.063073054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>

[ Upstream commit d313499df66159b4b7971d760d16729598ab7e5a ]

nft_nat_setup_netmap() builds the mapped address in an on-stack
union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
member and the loop runs a single 32-bit iteration, but it then copies
the whole 16-byte union into range->min_addr and range->max_addr, so the
upper 12 bytes reach nf_nat_setup_info() uninitialised.

KMSAN reports an uninit-value in nf_nat_setup_info() reached from
nft_nat_eval(). The IPv6 path fills all 16 bytes and is not affected.

Zero-initialise new_addr.

Fixes: 3ff7ddb1353d ("netfilter: nft_nat: add netmap support")
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 2e1ee7d9d9c3c..2538f0c32f88c 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -64,8 +64,8 @@ static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
 				 const struct nft_pktinfo *pkt,
 				 const struct nft_nat *priv)
 {
+	union nf_inet_addr new_addr = {};
 	struct sk_buff *skb = pkt->skb;
-	union nf_inet_addr new_addr;
 	__be32 netmask;
 	int i, len = 0;
 
-- 
2.53.0



