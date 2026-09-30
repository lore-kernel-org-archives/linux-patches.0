Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E81936E467;
	Wed, 30 Sep 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785831; cv=none; b=L4qEWjtrm7Ws/4EgJU/Zlm5lW4G6+TMOnuN5SlZSQxa4rUG7DQ9qHFfRZaSg0WpLo115SVbJo9vGuz11TVU1nohth8tJQzwUmekWRLF/HFvS5TY5nbikrUN50BV/NZQ8a4CCufw0qkwSThRKYlXwS2GI2y+A6zwpCDXxgRXnHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785831; c=relaxed/simple;
	bh=fE/d9SAdc6ImBrPDANmtlWpY9CjNl12Meehxc9Mie3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUExAt31u6jiOyh3m68270CQzU/nx840O9wru3GVmA/RmQsLFtvaZCkkgPCP+A0zQ8zsTjtbdfMs7W3XbYgv6+ErHmeeCV4DqXqRC7zfbnA/GZMNHl5fW0y3TevdFz0wq+MpGWe7MrfpTYKXGTZqV5uw1ZsPAJTn7TjKobGg/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7zQoi60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7zQoi60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DEC1F00893;
	Wed, 30 Sep 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785830;
	bh=7vH76YAKJQ9NoviuzY2tX0VdhBNTFjiLCTC3tuDn3Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7zQoi609EaURrPwG0lqI3WNfHwErNZubiatV9CLX+89+oPmsZt8KVy1msoCDwunv
	 HQv9MCK0pcYrZGpC9OtBKqoPkmZQ5xrczKrHETgrO06iq8eEyRQW4NmN2wWLKS7STl
	 C0F69VeXljaxTpC0lGsWhFT8WqP3vW1EpISvU/YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 648/982] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 30 Sep 2026 17:23:04 +0200
Message-ID: <20260930152430.686591761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4b855c277f5cc..e1e2e46dbea74 100644
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



