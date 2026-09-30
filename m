Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E59157A5A;
	Wed, 30 Sep 2026 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783970; cv=none; b=DkTrqYgw0EOabUm+m0Za9mHSVZBmKkZRTlrb0EhKBKEc3sXlxmfGXI2BjX6q1nYXHsIveg5071vmisoFFKoZTvcBPHtyyraKvmhzUg+upuczxOaoDkDR6828vUie4VjNz40fYWIvomBxAnwxfwr1bZtTk9MFtQgTLumQW47YP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783970; c=relaxed/simple;
	bh=xTdmb7I7n/cI3VFEkL7USgSUojMdQpYN7Yeg61CKHJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRYjb6cNTtA40e4ddisLqCivDEEHKXG3EApnZaiTPhqStUN6n+u6DYmkLu9A/qMwp9aJmM/icbRcz9CMctC9W7SY/dFmTC26Lnswi6QlOLNvGRE6bEEYLsr/fJ23l/GnXLx1jaSJEFwE8QqDSsN64sf1/LLTOQ3Lb9MMm8whCMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCYBlv5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCYBlv5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68A41F000FF;
	Wed, 30 Sep 2026 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783963;
	bh=wxeibSQeLY8S4WrXys/TVR3vMFOfHeRR/TW5Y4r93mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCYBlv5LYO9iYZhT1VNBy5RwNbk4O7DJJ44yLYaiOKO3/ZXUWWZpgSSrUo9EEImn2
	 53n26wUNT0koAeNipkIcEuE8umf73wj9PuISLEGh+8+3eGE63jIfoZMVWyuVfhelnY
	 wJrVKGcew90NzNKI/T85QKDkqpNUjhX46f3Onw+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 5.10 547/595] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Wed, 30 Sep 2026 17:27:20 +0200
Message-ID: <20260930152359.478483641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a6134e62dba2ea4f760b29d5226907f447c92400 ]

Publish new hooks in the list into the basechain/flowtable using
splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
while concurrent ruleset update is going on.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5e3f863c487f6..63592c73a7a17 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8797,8 +8797,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
-- 
2.53.0



