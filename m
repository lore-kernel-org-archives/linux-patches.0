Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D13185A;
	Sat, 13 Jan 2024 09:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4xGmZHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD3DC433F1;
	Sat, 13 Jan 2024 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139850;
	bh=QLHevKnjLQFM5hKEcAfQfpInXOS/DeUnlPyUMZt/vRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4xGmZHgb1CbOU2vNF4/6I/btWKbdXPMYANYLtLKwGuvcBdkBd0BvKEbiBkYyrfb6
	 TAGyK09WwkWmlu0NrWGmNwulWZ0+9pAu5FAY6KHs5E2lpEBZT7W7xKY2kL0xkqdWD+
	 7HNXZWSD8hpy5iJrM9BtTfgPQmtvFr18eC5EMSJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/43] netfilter: nftables: add loop check helper function
Date: Sat, 13 Jan 2024 10:49:52 +0100
Message-ID: <20240113094207.343856033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6387aa6e59be8d1158c5703f34553c93d7743d8c ]

This patch adds nft_check_loops() to reuse it in the new catch-all
element codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b29be0ca8e81 ("netfilter: nft_immediate: drop chain reference counter on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f244a4323a43b..03189738a73b9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8994,26 +8994,38 @@ EXPORT_SYMBOL_GPL(nft_chain_validate_hooks);
 static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				 const struct nft_chain *chain);
 
+static int nft_check_loops(const struct nft_ctx *ctx,
+			   const struct nft_set_ext *ext)
+{
+	const struct nft_data *data;
+	int ret;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		ret = nf_tables_check_loops(ctx, data->verdict.chain);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
 static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
 					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	const struct nft_data *data;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
 		return 0;
 
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		return nf_tables_check_loops(ctx, data->verdict.chain);
-	default:
-		return 0;
-	}
+	return nft_check_loops(ctx, ext);
 }
 
 static int nf_tables_check_loops(const struct nft_ctx *ctx,
-- 
2.43.0



