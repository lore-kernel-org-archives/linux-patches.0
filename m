Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171551D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C451C433C9;
	Wed,  4 Oct 2023 18:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442701;
	bh=z+dc6jfqZMBNzCItdnMPkGlvlb8oHP0B1o/OSZknElA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcjeRfS3d0RCpzzn0W0/zfv+odQJpTzZZmqGidJnXLk+ZexEXxWs+GHddpIMSCojA
	 kYj80iYN9t7b1aU2H2ltCkD/1x/KNvr3V+WoBR6KkjWga7lrnyd03HNqm9uRpa8xWP
	 RZYGNJUyfICXouZvkpbSXIsPV9SaoUwk0AjhL0Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lee, Cherie-Anne" <cherie.lee@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	info@starlabs.sg,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/183] netfilter: nf_tables: disable toggling dormant table state more than once
Date: Wed,  4 Oct 2023 19:54:52 +0200
Message-ID: <20231004175206.447092155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 ]

nft -f -<<EOF
add table ip t
add table ip t { flags dormant; }
add chain ip t c { type filter hook input priority 0; }
add table ip t
EOF

Triggers a splat from nf core on next table delete because we lose
track of right hook register state:

WARNING: CPU: 2 PID: 1597 at net/netfilter/core.c:501 __nf_unregister_net_hook
RIP: 0010:__nf_unregister_net_hook+0x41b/0x570
 nf_unregister_net_hook+0xb4/0xf0
 __nf_tables_unregister_hook+0x160/0x1d0
[..]

The above should have table in *active* state, but in fact no
hooks were registered.

Reject on/off/on games rather than attempting to fix this.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Reported-by: "Lee, Cherie-Anne" <cherie.lee@starlabs.sg>
Cc: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Cc: info@starlabs.sg
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 56098859d5b44..2f7d8e0e47de8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1159,6 +1159,10 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	     flags & NFT_TABLE_F_OWNER))
 		return -EOPNOTSUPP;
 
+	/* No dormant off/on/off/on games in single transaction */
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EINVAL;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)
-- 
2.40.1



