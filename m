Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B4A1EEE6;
	Sat, 13 Jan 2024 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npsftw09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD435C433C7;
	Sat, 13 Jan 2024 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140088;
	bh=6y4ZXcG9VZNLFKLcMggpeKEcGLB/y742OZM0OW01WRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npsftw09VhTmyyYz9FftrpODone1J1WDavR5YcCyle5seShvdm7I6VdAAH5C5NIps
	 Eo6iOyw00e95ZKlzSnOPpkkwuF+j3a8DzyBNyajSKily6+ItY3tpKebktOU9V3/Pzd
	 t4IAx1zuzmJ/wY1fIvYiXVNfxBDD7XztF6mDqKkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/59] netfilter: nft_immediate: drop chain reference counter on error
Date: Sat, 13 Jan 2024 10:49:56 +0100
Message-ID: <20240113094210.081805524@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b29be0ca8e816119ccdf95cc7d7c7be9bde005f1 ]

In the init path, nft_data_init() bumps the chain reference counter,
decrement it on error by following the error path which calls
nft_data_release() to restore it.

Fixes: 4bedf9eee016 ("netfilter: nf_tables: fix chain binding transaction logic")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_immediate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 7d5b63c5a30af..d154fe67ca8a6 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -78,7 +78,7 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 		case NFT_GOTO:
 			err = nf_tables_bind_chain(ctx, chain);
 			if (err < 0)
-				return err;
+				goto err1;
 			break;
 		default:
 			break;
-- 
2.43.0



