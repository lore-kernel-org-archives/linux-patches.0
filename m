Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8315929D26C;
	Tue, 17 Mar 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767549; cv=none; b=BvIOMEAelf89kSew6GeicqtUtxdgZVGkxCgKd1o4U5gtfkdZiSjy70luOLfW9gLdsYH4rX63jIpyGeEQCk3lAgUqaRFSNcCpqEnkn2IjICHisaBTjr9PykHhUTY3RMvhv5gO+qQHoQ/al65Tosqd3pttBOBDkp9bhMkivC491JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767549; c=relaxed/simple;
	bh=Rb0uEowrt/SR8AHuhb66IyotDmYE6cLq9YTXXaKPj2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovVTy/Jg7LCHVhZ2Bsdk8B4xfs4jii5WI6F8uVRqucJZoRKeDJ2E0lD86y01bYrkZj9eRW9GQGL1s4kGJ+dt99JcUKrw1WU0uB9oyPRzsccKiBF96jlOZ3/xT88e2+xZ9uDKq0oJYJxBicOQ5WVaDsEy3k3349BN9MIX8Q7ikYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4ek63OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4ek63OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649C6C4CEF7;
	Tue, 17 Mar 2026 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767549;
	bh=Rb0uEowrt/SR8AHuhb66IyotDmYE6cLq9YTXXaKPj2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4ek63OT3oge4B1A/dZGWhb8A08PwVk4UAe7qL+oSmk9rIomk3QjrY+vnVdk3CTa0
	 akdgHot/5Ilj5ym60GZyPhBJXpy9hicY40KnqqvZqNq+pCnkEbSLG689aMwfyc+m8q
	 JOSe/BE7aDGAKmp/qELeBxB56PCyfcaZU8LIv18k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/333] netfilter: nf_tables: always walk all pending catchall elements
Date: Tue, 17 Mar 2026 17:31:36 +0100
Message-ID: <20260317163001.860959443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 ]

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed1d639fe34d7..b6a575ec33159 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -828,7 +828,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
@@ -5928,7 +5927,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 		nft_clear(ctx->net, ext);
 		nft_setelem_data_activate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
-- 
2.51.0



