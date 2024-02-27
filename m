Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365A14690A;
	Tue, 27 Feb 2024 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044244; cv=none; b=S7bROImD+3SN3Yn22keeKMg6F9tTGb36EdYA8ve0IGdiJ/McOOxszyJQxODxdEcCAGHuHqj0Lm2AGTUsOe5vV+HjzEIc3hJi7vRdfGY+9jvBL3x6I8ONKfsm+TkzE53v83FVBjn+5p4OLSxP+r1m4bk1NFy45iGIcTkCw4SCFvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044244; c=relaxed/simple;
	bh=bMdqMXB/j5nesPrOyrQmRXHYukqM858/IHO4ns5xGPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2fcsMQmujtMJy9M7aq31ihTqLpG5Rgs4nh9JCI5DPww+7ou4hZ4fluzTF+aLk5AH4aJMNG1+7gn84rJwIjK9tgQdgJ8/LpCSG22pUFPmMmYt+nVtAa01FWMHrrnZDc8HBFfa7Afrs7NzHTsKECi0kivb6boV+1cK1vcEgH6pK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbzkv459; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbzkv459"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B6AC433F1;
	Tue, 27 Feb 2024 14:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044244;
	bh=bMdqMXB/j5nesPrOyrQmRXHYukqM858/IHO4ns5xGPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbzkv459hvMzEyMl5Oqicwx5T+oga2koDyPLRD/Bn3oreiI/vZTjbcUDv6edLPvKu
	 EtJt7itI3tcNmWz0G5stHVBBXmN+lfrJAamJJUnaCF3HB98oP25uwFPi1Ewk5+Z+RQ
	 mOaZoJy2WocGSY6rYnWzpYKAR++sUooixH9Rs3Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 5.10 115/122] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:27:56 +0100
Message-ID: <20240227131602.466379837@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

[ Upstream commit bccebf64701735533c8db37773eeacc6566cc8ec ]

We need to set the dormant flag again if we fail to register
the hooks.

During memory pressure hook registration can fail and we end up
with a table marked as active but no registered hooks.

On table/base chain deletion, nf_tables will attempt to unregister
the hook again which yields a warn splat from the nftables core.

Reported-and-tested-by: syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f586e8b3c6cfa..73b0a6925304c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1132,6 +1132,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



