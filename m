Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2084F85CA;
	Wed, 30 Sep 2026 16:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786612; cv=none; b=n4BcgtUrBbHdgvTyWIQ8ivaQc7TgCtZah/NV77QbQUNUvkk3G+CuQM/YJwerRPBRxxaHNRqOveBiEkE+p4Qo5NuDuFBFOdndIt2XxHfDeaUxVjbM1hiVgZAcdz6gAg0FAW1miXibQCOryfr2ps2FGtn/6yR+g+kJIxJxT7Uahog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786612; c=relaxed/simple;
	bh=M5jslpU3ioOlmAyxkgBd3myrGvYoyhwraWsWWDEH6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPMSw68O8QTzFPwatLTW+2NXpEJ9qgfccoZa2BJU+NftLBldFCqvo2MqT7p/9cDQ/xOpzHhe/EYiSypIPXm2cemnTZtH6gM6natel7b03b108bXIr8iAWnzRA+CxJEcxKlTmpr1AT11IdeFq0liKl+aFHCzjThMk4/4JzL8jAjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyjq3V5O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyjq3V5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF031F000FF;
	Wed, 30 Sep 2026 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786611;
	bh=uJchV06so6bQ/fkd0wjAZgzeT5CQoQg0GliiEypBoV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyjq3V5OrbdFsEZTcnKqbY/S2zrkEW1GtkNx5GccRxuck7AN//V7GgfYIfwPIYndj
	 OXZIzLGEsWa4ByCuwzaDr2cYtVSrWWXnWSMVfHGHD5TVfqDdAdfU0HMAkOqBR9sXGz
	 aeIwyj7NZwvVU1o1RMETUmx34GvWZdrtweQiGHQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 6.1 921/982] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Wed, 30 Sep 2026 17:27:37 +0200
Message-ID: <20260930152436.524009078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96b0638c220a7..a373a0969e994 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9995,8 +9995,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



