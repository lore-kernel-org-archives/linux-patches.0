Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626E1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC280C433CD;
	Tue,  1 Aug 2023 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882508;
	bh=OXYG/4/8EYhSl9aJlyWy7w/Q03QcE/r4l6+lwDCLK+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvmb4xJVRwS99t5LUE1cHFZ01gwWluEPpFvF7xZu2Vx6AeaFDEmQhgWCE29QNcC6C
	 xpjf2mCcmnkihI9zwoCBI6yg7Ewsv6LiyJ6jqkf+3QGWIOdsmBHioGaSLBZXYi8hnC
	 /uu8ve75P4KVSZLOb4pcbFycnlW8nw2HrHyIfa64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/228] tipc: check return value of pskb_trim()
Date: Tue,  1 Aug 2023 11:19:31 +0200
Message-ID: <20230801091926.868060457@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
index d67440de011e7..2b236d95a6469 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1960,7 +1960,8 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 
 	skb_reset_network_header(*skb);
 	skb_pull(*skb, tipc_ehdr_size(ehdr));
-	pskb_trim(*skb, (*skb)->len - aead->authsize);
+	if (pskb_trim(*skb, (*skb)->len - aead->authsize))
+		goto free_skb;
 
 	/* Validate TIPCv2 message */
 	if (unlikely(!tipc_msg_validate(skb))) {
-- 
2.39.2



