Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF6B154C05;
	Tue, 23 Jan 2024 00:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969400; cv=none; b=N6Dm0GdOQlP3kIcsrXXTxRyIGym+pdJooK6zWVuhTDQOZ/Ycs9a9HufmveS1aWoKQqaOw40XU3x5CDxCW557XWioKhS0CoKJ4yDP+FPyV+i2pDIdaszyX+QHuObRABM22/fJPrMBd8HRqSXMTSy+IuDYlHSsyk0X+cdovExeBmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969400; c=relaxed/simple;
	bh=kOhOY8KJqGM+w7yXvKBe3SFRA8x1BzFKCmoHfmiXWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rohshSfNww4Qp269ijLpzeppLdc+xpBjd9ldrLINw2TpXTxrjm+2FTKGaesqU7Ksmd7QvsttWp2xw0scqGk16ZmPodnIPU2hvxxIqT3ZkhHi+vhsdzLPMHIbuh8jU0E7QNVs95mfbmTpTEj3sKznpwsQ0ShRrueKWMwxTOiHAuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbxiKW3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbxiKW3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47BC43394;
	Tue, 23 Jan 2024 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969400;
	bh=kOhOY8KJqGM+w7yXvKBe3SFRA8x1BzFKCmoHfmiXWek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbxiKW3jMHkBvwkhzGGuWzd0UsPmI/0fg3UaP+TKpknQsJ75Ij9MMaBpwLBZUBbep
	 fE3FDt8C1FnBtxxnEZZQ2MJHTQRZ2A0fZ6mNID366klrauazzb+R4028Fp3EIZzHG5
	 nKFQeWhxmFumTmM16UfmDTHeeOv1/u5kexKtsfLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 221/641] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Mon, 22 Jan 2024 15:52:05 -0800
Message-ID: <20240122235824.857558492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08e4c8c5919fd405a4d709b4ba43d836894a26eb ]

If a transaction is aborted, we should mark the to-be-released NEWSET dead,
just like commit path does for DEL and DESTROYSET commands.

In both cases all remaining elements will be released via
set->ops->destroy().

The existing abort code does NOT post the actual release to the work queue.
Also the entire __nf_tables_abort() function is wrapped in gc_seq
begin/end pair.

Therefore, async gc worker will never try to release the pending set
elements, as gc sequence is always stale.

It might be possible to speed up transaction aborts via work queue too,
this would result in a race and a possible use-after-free.

So fix this before it becomes an issue.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be04af433988..bbb8d8533f77 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10383,6 +10383,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-- 
2.43.0



