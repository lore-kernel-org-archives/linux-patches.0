Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F21219301;
	Tue,  8 Apr 2025 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111949; cv=none; b=DkVRCWl36DXWZr+AbPaGNsieo82sAXtnwlnVwa1FQ6ivlW7NQeuCIVKtacSPRVID/NZDjN8VxZZrn509CbS9nO45lK4aAyYZAhABlSU9mUPA+qKUHFVakX/8cFbXgbcAd4vFODSjtobatPd+N/jauZKhPyLJ1/QJxJjCBZTUMEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111949; c=relaxed/simple;
	bh=C60nrUv3qF6JKexenBsPo7I5bnw3A+U9kFUsP6K6mbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Llinq/qAeZAanGv1myHmjqRQwTo+/Ow17SvPXqnYb1Jq7kdfobcXnmgUCCzC9ifZz6fBwHj+eCmtGzWNkd66WvRQeUqcyELnDe7GbQBeedVzbXC4rCcv6zWA01T8n3l8fslKfkTFVpLdH/KqRHvf8mWFklooiQTXp+lR95rmGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfZWqqL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfZWqqL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD03C4CEE5;
	Tue,  8 Apr 2025 11:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111948;
	bh=C60nrUv3qF6JKexenBsPo7I5bnw3A+U9kFUsP6K6mbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfZWqqL2gnbomgAKtWLDH/EM6el0mrEcQ947vTMbgSsX5Gnpj3Oapkx/ORtXQ0sb9
	 xy4G2jA9ldfIi3OWECHVjBBWEkmkvFTleUheGWCNfwDojXFFDuU9iWm0DAPggtqUjx
	 PsHKZzXigpY/AT8B/noxkyEI3GZ4xkwhAO2Znz8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 619/731] netfilter: nf_tables: dont unregister hook when table is dormant
Date: Tue,  8 Apr 2025 12:48:36 +0200
Message-ID: <20250408104928.670702852@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 688c15017d5cd5aac882400782e7213d40dc3556 ]

When nf_tables_updchain encounters an error, hook registration needs to
be rolled back.

This should only be done if the hook has been registered, which won't
happen when the table is flagged as dormant (inactive).

Just move the assignment into the registration block.

Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e9505..a133e1c175ce9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2839,11 +2839,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			err = nft_netdev_register_hooks(ctx->net, &hook.list);
 			if (err < 0)
 				goto err_hooks;
+
+			unregister = true;
 		}
 	}
 
-	unregister = true;
-
 	if (nla[NFTA_CHAIN_COUNTERS]) {
 		if (!nft_is_base_chain(chain)) {
 			err = -EOPNOTSUPP;
-- 
2.39.5



