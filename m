Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E03365192;
	Wed, 30 Sep 2026 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791949; cv=none; b=vEbAexubJzVNccUzIETpoMmojCDPqCJWJZ6yUXirsXhdP57w5lIAL+vquSezj4GvFuwINgW5dPsU/G5ld9t1lG7wXGx6kRbjoCU+dEJUQcV8t238+2jrFFx2RTjxfTzBhD3N6zGmxeGgccMcJ034u6pDLfMyTS3LxhPRX40PfVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791949; c=relaxed/simple;
	bh=IZLmbRkUh7N62u7w2i/uwa/sl+9yslsMpIVmXY8hPHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmG8sqL+27ri37eLmdvCVxsJkvG+14xAMWW+2tqZrt3Afrmhqe9FXRyaXanCahqEF3xfc3zggcik5IHRV9j8/88+lfpGUKG+5nb2djyKII0aX8CPNgVJdtDgTg1kkH2qrcJ0ABfu9tftayxoV6muvE/O3JXpKGQE9zTu3lIBRJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw57a9OU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw57a9OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675491F000FF;
	Wed, 30 Sep 2026 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791947;
	bh=VOgvGP/f/+M073/2RnvqYk5mQ5kM4uc5CykkUtSn5yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw57a9OULjdKwZ4jw9DyUr5RZnymIEwVAIRyhP11OW/iihLDGEV7AiKVXck7yDuAA
	 sbjJLCq2Isd8pLLvS37fHB2q1qjPpEp2jDKtMqmrq8F3ucWIJNp8gbEua63b6Kp5cV
	 oTxWCHENeMZJ+Qq7Vk2WEAc9IOkdPtc/RBAIfjG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 482/752] netfilter: nft_nat: fully initialise new_addr in netmap setup
Date: Wed, 30 Sep 2026 17:25:52 +0200
Message-ID: <20260930152408.699673992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



