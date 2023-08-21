Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5311703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C177C433C8;
	Mon, 21 Aug 2023 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647740;
	bh=tnBFERiDMdehr6/OoQYVHtfzTxsqVS14AlMfRlVCL5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9hIgFeqkFkJjn7v8Z303ND8NPCP6Lir3VnYHaiQLEbJhhF3nCd6NZdWBNQwgwCc1
	 U6vukRLV0TjeVjtX1D/7WgkB48g13BaS6pxEzXge/VkBJxsmFti8LezLtjfGUtTzKD
	 n/0JalRRfIQRL7eZwkYk+AiHPPVEZM+jbMXcDShc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/194] netfilter: nf_tables: deactivate catchall elements in next generation
Date: Mon, 21 Aug 2023 21:41:40 +0200
Message-ID: <20230821194128.028665833@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 90e5b3462efa37b8bba82d7c4e63683856e188af ]

When flushing, individual set elements are disabled in the next
generation via the ->flush callback.

Catchall elements are not disabled.  This is incorrect and may lead to
double-deactivations of catchall elements which then results in memory
leaks:

WARNING: CPU: 1 PID: 3300 at include/net/netfilter/nf_tables.h:1172 nft_map_deactivate+0x549/0x730
CPU: 1 PID: 3300 Comm: nft Not tainted 6.5.0-rc5+ #60
RIP: 0010:nft_map_deactivate+0x549/0x730
 [..]
 ? nft_map_deactivate+0x549/0x730
 nf_tables_delset+0xb66/0xeb0

(the warn is due to nft_use_dec() detecting underflow).

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f6e6273838859..4c2df7af73f76 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6874,6 +6874,7 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 		ret = __nft_set_catchall_flush(ctx, set, &elem);
 		if (ret < 0)
 			break;
+		nft_set_elem_change_active(ctx->net, set, ext);
 	}
 
 	return ret;
-- 
2.40.1



