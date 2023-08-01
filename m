Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD51F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D1DC433C8;
	Tue,  1 Aug 2023 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881950;
	bh=6trlCTXDvEEdpebaUiJa+pdRHQ6IluKLrWb0CSgbe84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5A95E/i+thOTIq7CFb82CtP25AKek+6x5DVw2EQwr2oFmPwlym1UcVpNgx+l7VDM
	 3tbMX3E1WyBQXZhICVikT4mVqRJec9HhH3Rs/9BPccWyOUXMPNTHe9RbBJmIXN14bL
	 gvpUmgV4tbqUNM7qsSdGxuytpx1bOUrkj1zUge/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/155] tipc: check return value of pskb_trim()
Date: Tue,  1 Aug 2023 11:19:52 +0200
Message-ID: <20230801091913.004335608@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit e46e06ffc6d667a89b979701288e2264f45e6a7b ]

goto free_skb if an unexpected result is returned by pskb_tirm()
in tipc_crypto_rcv_complete().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/20230725064810.5820-1-ruc_gongyuanjun@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 4243d2ab8adfb..32447e8d94ac9 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1971,7 +1971,8 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 
 	skb_reset_network_header(*skb);
 	skb_pull(*skb, tipc_ehdr_size(ehdr));
-	pskb_trim(*skb, (*skb)->len - aead->authsize);
+	if (pskb_trim(*skb, (*skb)->len - aead->authsize))
+		goto free_skb;
 
 	/* Validate TIPCv2 message */
 	if (unlikely(!tipc_msg_validate(skb))) {
-- 
2.39.2



