Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6422DF126;
	Sat, 17 Oct 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257498; cv=none; b=sRYynIxn1qQmD22u5tJqnr5LoyQYtx5cnvXnDo/Zt9VQmUDCs5doJkeRzDKTexmQy0c5t/JVBYnS5ymGDqGa9PBUS3qRdYkwma76Aca2s0hUDnnvdRv33PQYbYvwEoGp9tOUf9w6cC6wk0W3cHyewIgnoIAjS/i2AFaA7uh9Hds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257498; c=relaxed/simple;
	bh=k2eZlrPLtJMYLDX8IGEh8uiq/wMWfCkzFBljN3ncnOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+icFSWKPFbi8rGTPrVpOvNsQ3yS40ONHV6/kyI4Wlum3n0+aB0IYTbFsiIMQBco6I8gLqhldri2bB7+fePqtLe5Op62dBHTQaqwYL3s9B66ikups3m+qTJijMPj5nFndXYxXXSm5UdTklEhrjyyDuM/OaF30t5BweYwO62fpkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/zdoQCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/zdoQCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA3E1F000C4;
	Sat, 17 Oct 2026 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257497;
	bh=VEbxXXDyzYPvI9xyE4nm1JNShvoCB9hJUWy/612VaFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/zdoQCDU3ig57FT1Wa1mbN+gJWIwCg/qbz1fluRi/2YOoD2AMXHfq1CIQVL+P8bu
	 RW2nEdn2/jDvustxCW9rTafwV+xpqU7ZE2czCBtdHz92IX4vovz3xgziOMOpSdj2An
	 h/RERJgD4/oZFyif89mJr4BBGfYGBd5QLJAn6ARY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0579/1674] netfilter: nf_tables: fix bidirectional offload regression
Date: Sat, 17 Oct 2026 17:47:31 +0200
Message-ID: <20261017160445.952664234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 84443741faab9045d53f022a9ac6a6633067a481 ]

Commit 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
made unidirectional flow offload possible, while completely ignoring (and
breaking) bidirectional flow offload for nftables.
Add the missing flag that was left out as an exercise for the reader :)

Cc: Vlad Buslov <vladbu@nvidia.com>
Fixes: 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 867429580e10c..eca4bfe05b849 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -374,6 +374,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
+	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0



