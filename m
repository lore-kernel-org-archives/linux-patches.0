Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65412CDB0;
	Tue, 23 Jan 2024 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968968; cv=none; b=nbNUGJZVLoNGO0sr89BqXfdU6p0VXr5sEpaQEmsYAjG5FVuVOYaYlfdbPi23I7UMzqQe2pdRjxeZLT/9JsazR+M3uE5GR1Vq/pWtCipq2Qg+CNmm0Km8RZAavi9O/YOkMjSr4mzJGJ3C1wphxHAS4+Bxob941+t9WL+tXzZRX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968968; c=relaxed/simple;
	bh=k0jeLEG+zxpCqtNcDHuiD7aO2P9q5Mwf7M/yhPFXRzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxe1rpMGHnFUjEVXcIS/4/cgNWYfSMp54IZypbcyRnxWRa3cDepVA1HCF0n4AGTgXa4G5aH2dJhRPuekxMmkmOE1WWWfO68n1h+CArLsM7Wu65Xt5I2wAwfE3tAH4GfnDtrphrdEAfOBQ/uxfJIr7T3E4YF/XGJElZh9M5iUM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8Wtxz4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8Wtxz4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB6DC43394;
	Tue, 23 Jan 2024 00:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968968;
	bh=k0jeLEG+zxpCqtNcDHuiD7aO2P9q5Mwf7M/yhPFXRzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8Wtxz4gpW6f2oh8SAWPUxAbstVuYaU/n/PoHp9LfYhkfKecpBOD6BKO5bbydqESP
	 2e2326JsBx2xyAOL9k1/rLCY7CoM7TDWoJK1qpb8Q+PZLatwYu1hmsGfhszLO350NI
	 s4yXXXFBTB4Y7riFhZ3zaEMlr+Jb19x+XBKrkOAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/194] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Mon, 22 Jan 2024 15:57:14 -0800
Message-ID: <20240122235723.701727693@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 915df77161e1..9bd8ed0b62f1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7604,6 +7604,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-- 
2.43.0



