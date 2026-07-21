Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571283B6BF0;
	Tue, 21 Jul 2026 22:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672093; cv=none; b=VaZMz4OYXkfGf51JXvPEMcshQt+0xUQ2wd1D2fg67I+n8XuZHBjwpfMML/ipEopCZ6zgP9Bq8MYSA4QF9siv7tFFt9vXiyDYACwCwrSBJCLA81CRuhxvW7jGciXLyFdy1dU9UeW2LLLBNUpjdWaBK/drpWik5EXuwDx4qxhDJms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672093; c=relaxed/simple;
	bh=oZveMb6NnzU8o7oqJBoGTcM+jU1CkZC61gjGvJOrLgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEsuP1sqPx1+wCVz1Gm91VY5OUTQgpNDFtDPJQsXmWAbgDm04bCL/PPNa9ROfi1zM9ec0u/2VL20RFR9aupazr2rIqI6okbHGit844pYlgT8/AjAWo2OOcQsjqUDXGIgH2PQLII1gZNtB54DlVMLH1ZmE9ARW9w9Df6P8Uag3tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3Og5Q8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3Og5Q8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8471F00A3A;
	Tue, 21 Jul 2026 22:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672092;
	bh=6iRbkGJRaV7OYZUM6EL9DzcN/c6S9R7PB9auTaoxV10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3Og5Q8Hfsobq6TldqBrBNtdkkbCSuBB+AHnIBlIByOZV+pGMVnpSEdPl7BYva1x6
	 Fr93dXNKCWenPjn0dgv3+tJWEXfqXRppDgYvN9mjOkhvyugXIdkbOZNnpKIQus8FHI
	 mBux0EBEfCg+5iHRHu23d+1gsvKTBPKwg59U8e1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/843] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:21:27 +0200
Message-ID: <20260721152416.195568300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 27dd2997746d54ebc079bb13161cc1bdd401d4a6 ]

This needs to test for nonzero retval.

Fixes: c54c7c685494 ("netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support")
Closes: https://sashiko.dev/#/patchset/20260618061631.21919-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 1967fd063cfb7b..093fe9ec142e4a 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -41,7 +41,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev || !br_vlan_enabled(br_dev))
 			goto err;
 
-		br_vlan_get_pvid_rcu(in, &p_pvid);
+		if (br_vlan_get_pvid_rcu(in, &p_pvid))
+			goto err;
+
 		nft_reg_store16(dest, p_pvid);
 		return;
 	}
-- 
2.53.0



