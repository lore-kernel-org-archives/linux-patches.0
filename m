Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BB83BE642;
	Wed, 30 Sep 2026 18:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792509; cv=none; b=W2fNUlUoAuMaQkzdtsPrKFwHvNXjCtoTXu+JxpcCg438BrdK/TdpHhLSDUqh/CSd8+XAOrKsw1E2du7is0LiRTGvZUG5lu3dCvyIhWTAAhV1sVP6pDBoHrjG3TocXwa8cGc+gb7dBmHWAeqx0xzO1Z/ZU+vOotATzPPgo6JHgWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792509; c=relaxed/simple;
	bh=rCyTEUZrcgvSwwjxXqHkPVAJxcZdDhBTF/jmTI0Ct+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqhOlltisDO+hqAIzV6MTMcqqCGsrh+DMrdE32k3hsATcljO4Ym+ji0XEXpoOGREbgy0MMJyiN/RCKcL10XzSExoYlzrqHWWWtuUs/eRlnUorILVoWiLpblh/GOnjmPbHCj5xRlL3oLy3J6reQa2YiPCK95bjjAoF0gTyFq4yVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4YRPcnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4YRPcnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD251F000FF;
	Wed, 30 Sep 2026 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792508;
	bh=SjJ9nhW6p0zLo/RUdgkq9oDe2lTfispz4lT24ddjTVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4YRPcnh1GFOUziHrrCnNCekPWTt2qC/LqxGk2w8rK3NzNyn2/tJCFsXNjUzoAC8w
	 3vX1UhPhIu49aLmDFd+bGDPSW7V+qNAwayiD4CnpthuBpiw/C/12XFtgWacmmS6wGP
	 z6CLCmb6kcu5Q5j15PqlQ7/hnzuXl4GgCAJ7AsZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: [PATCH 5.15 680/752] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Wed, 30 Sep 2026 17:29:10 +0200
Message-ID: <20260930152412.958983698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index c1b5b579ccd72..b5273255b7388 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9707,8 +9707,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



