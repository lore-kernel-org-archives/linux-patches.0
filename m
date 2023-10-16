Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F214288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k25zbEKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13D8C433C8;
	Mon, 16 Oct 2023 14:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467940;
	bh=q0VM/riT0s38dZGFBsSTNN6Xru6X+oiPOxiA2Nd7T3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k25zbEKJTQMJP9yzk0+02tw9HqtPp/WBM/kC40hdBCSkNpjBKi2q7xVH5c6fGOTUB
	 u6c4gc6MiuO8KYwqlYaONZVj3Z2G/w8iJWF3w7Rq2xBI9B4OF0g2cxdBEhzow6lRo3
	 ggXXiJCzwbFiApXcpUuMiy9Lu8UqmW0prkaXfoLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 084/191] net: tcp: fix crashes trying to free half-baked MTU probes
Date: Mon, 16 Oct 2023 10:41:09 +0200
Message-ID: <20231016084017.360802920@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 71c299c711d1f44f0bf04f1fea66baad565240f1 ]

tcp_stream_alloc_skb() initializes the skb to use tcp_tsorted_anchor
which is a union with the destructor. We need to clean that
TCP-iness up before freeing.

Fixes: 736013292e3c ("tcp: let tcp_mtu_probe() build headless packets")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20231010173651.3990234-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 37fd9537423f1..a8f58f5e99a77 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2441,6 +2441,7 @@ static int tcp_mtu_probe(struct sock *sk)
 
 	/* build the payload, and be prepared to abort if this fails. */
 	if (tcp_clone_payload(sk, nskb, probe_size)) {
+		tcp_skb_tsorted_anchor_cleanup(nskb);
 		consume_skb(nskb);
 		return -1;
 	}
-- 
2.40.1



