Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B53610954
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F05C433C0;
	Mon, 19 Jun 2023 10:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170658;
	bh=9fZRLWhnGQgFi9XA2dG7hAL9nO90gc2HWWvz1bl8Lb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+wtnf6vb6RDRKJLE5zCI+sv5nABeLu1QzIjOihNjeJXgy9dY1/baLXhyH6MtlstA
	 d25jeyoDNiiJaYnQmrTYp+kw3gPeFqGTLZCImd+zYMxrffvo1ip+CDZD15QMzCesE6
	 M8HPocqoZeSjkzdScPOWST0qVTWsRMT4txW2zK1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/32] netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
Date: Mon, 19 Jun 2023 12:29:06 +0200
Message-ID: <20230619102128.507478587@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a1a64a151dae8ac3581c1cbde44b672045cb658b ]

If caller reports ENOMEM, then stop iterating over the batch and send a
single netlink message to userspace to report OOM.

Fixes: cbb8125eb40b ("netfilter: nfnetlink: deliver netlink errors on batch completion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 2cee032af46d2..96ae1c4ad9a91 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -411,7 +411,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 * processed, this avoids that the same error is
 			 * reported several times when replaying the batch.
 			 */
-			if (nfnl_err_add(&err_list, nlh, err, &extack) < 0) {
+			if (err == -ENOMEM ||
+			    nfnl_err_add(&err_list, nlh, err, &extack) < 0) {
 				/* We failed to enqueue an error, reset the
 				 * list of errors and send OOM to userspace
 				 * pointing to the batch header.
-- 
2.39.2



