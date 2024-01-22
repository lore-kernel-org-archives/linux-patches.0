Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA712BE95;
	Tue, 23 Jan 2024 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971359; cv=none; b=SJm1/rSsgrplUU0VhQ/PFAbe6bAjJmKCbh4ri8b/+Hc9pW1aEDy7CxMY8kF83O+TJIjEh/qa+htJirUxVFC3Ub8qXcm8B0rfOlEaW8xZVRvW0x1vrlOIHNLKGT5Vd6BbtynDze2Z6f3MJDxOsrOqaXYX1LvIv36/yOMZc6AtZVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971359; c=relaxed/simple;
	bh=fBlNP/b52ZxxI8+CZYUG6KWOjEXlW1chseacXGWvDmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmrh6K4CZHdteBhOQh/CX8BugviRHeTwsriNtgj5mK2Pz2KdrfcCBlqyWlrDEGTkaRFLJafIJs5K3h+tLoizGfWJiP2821z1WPqKVi5V1SZ6Nbakf0gDi4YECKmURQUlXJo60T73UU6UOVaX2f75GL29ePWV8Ji0dOzFDVpdI+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgSka64n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgSka64n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75BCC433F1;
	Tue, 23 Jan 2024 00:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971359;
	bh=fBlNP/b52ZxxI8+CZYUG6KWOjEXlW1chseacXGWvDmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgSka64nR2FovOsxZ33Wz6QKXgOtisdLNb+Ty7ZxKHEXmzWamscadwsSUpvk7sNq+
	 V3RMExfwCuEQG7GbL9KoUnRQj84Lca8b84rRtcS5n0X8cr++mVPQ/EEfqVvUJ1r5WY
	 M1ZZXCm3cOjtEfRgSuKjaIQzd67yH7cuTcRi1rtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/286] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235737.485818847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 4d1a009dab45..6e91c743a4d4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8840,6 +8840,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-- 
2.43.0



