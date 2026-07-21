Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96283358C6;
	Tue, 21 Jul 2026 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657652; cv=none; b=tsam4AOKeFbDzLRLkarwazSZuiJnNhoNv1QrjwJdF+9YVrfZ0zVP9DEOxHNINpXVCAP9aeVTdFtqXvImAyQFLxe4IN4RXLcOaKcCd/aAoCBXERQl4NkvCDZQ4/iyKWK9anF0p/aSieGYsKyvIVVwiGKFkXUkV3AO9IqI/q5oeBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657652; c=relaxed/simple;
	bh=wBhFPY9vKrPKDVw4XrPKKFPLtMABnkRqTl9y5G6pyEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFzpcUuiN+1R1sQTFlIa0l6Ttmqb3GOlpxCKdEzJC9i3jUa6T9QefLwk9+DKKE/p4IzJsyLBwuKp7vwygGX7+vXDL/jdzpJDBMhJuJhUyecNJlyX2K4HYkvAcb7MEbTU0jXtVAPo88lmLlUOPfa6nvTLfNKXNuXog2nNPEIkjvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmaF4jcl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmaF4jcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463301F000E9;
	Tue, 21 Jul 2026 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657650;
	bh=SD44OvV0BsOkAaR1sYjNWYJTREv8d1OD9kgvN6n9caY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmaF4jclpBUS+D4hOKdy91GFYrYOvh0EDu9VZfLor8jsmc2kmABLuTwylNY/wSJ2P
	 RbKPsYMHhB3CVnoo9Lg5mn1kCii2nVYMAwdN7gtYiTdZNYyqImGdUkOZzlJBwAhqqZ
	 UULbX/5I9k1dlw6lzauslV69g+KfNZUfid8PcSWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0846/1611] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:16:02 +0200
Message-ID: <20260721152534.414976125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 2e24696c33b3cd..a3d0c8a82d8656 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -44,7 +44,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
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



