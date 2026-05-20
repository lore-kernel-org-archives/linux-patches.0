Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ED83F20FF;
	Wed, 20 May 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300178; cv=none; b=Gr9NJFsx9dupjTAP7JbrDVRiNUElnFJJ651nn7gII3oQODbekRkP0GLxOOrUCIOTThSmEM29xYhYaCFMqr2JOQC0pzlF9fzSpUbO4U3ZhPu+82dOmeKStJQHv64ZG9BYLdQNDLOVbygaYc9LQP+l55znFY85Aq9sdZzUMcy7joo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300178; c=relaxed/simple;
	bh=9qn+iEoaI1KlNRT1XxSgNlJz+zupfTAPzir26N2ANQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DliFS1Q6R1w1b4iucjiqkf2GQIW4sNmMhJ9kHKrKxFELRW8LSCKysnnhV6kSddCYwidRdnoDBpudUzt4nAtnE0LNnUkqbrCq1aO09OktxAHVKvVsL9B2ODvFsNyfKO7s4ed6vBHXq/SCKGnCNwxohfdQ3E6BNuqQVFSYwwILJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHnxwp1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHnxwp1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFC61F000E9;
	Wed, 20 May 2026 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300176;
	bh=JMeBGSVUTC6HaIFWHA0S9WNnGUjMBQEXMhna45qiGeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHnxwp1a9qheXKYFb87Ng4KHPzO06EBqjWVbUyGXrQQuDJuMo674Fvp4+actC/dtK
	 hYYVgfKTWEEm0ZV6Y4Eb41hD9MGYbBEYYaNQEnMJG42QbO5j8yU7Kwyme0jKVVZS4B
	 UtEMeBoAFF0OuxDdd8UkyUTh6mR88YAZwpQQfAOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/666] wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()
Date: Wed, 20 May 2026 18:14:05 +0200
Message-ID: <20260520162111.973123228@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 990a73dec3fdc145fef6c827c29205437d533ece ]

In mwifiex_11n_aggregate_pkt(), skb_aggr is allocated via
mwifiex_alloc_dma_align_buf(). If mwifiex_is_ralist_valid() returns false,
the function currently returns -1 immediately without freeing the
previously allocated skb_aggr, causing a memory leak.

Since skb_aggr has not yet been queued via skb_queue_tail(), no other
references to this memory exist. Therefore, it has to be freed locally
before returning the error.

Fix this by calling mwifiex_write_data_complete() to free skb_aggr before
returning the error status.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20260119092625.1349934-1-zilin@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index 34b4b34276d6d..042b1fe5f0d67 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -203,6 +203,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_bh(&priv->wmm.ra_list_spinlock);
+			mwifiex_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -1;
 		}
 
-- 
2.53.0



