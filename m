Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6972F2D;
	Tue, 27 Feb 2024 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041443; cv=none; b=Y9QYPz8h0P/Tf6z47k6ivGx3168Fc+zVyS17OMpu9Ky4hi2avF5n/Lj7Ur4bN+v5GVscBOnxHw8xELhK2uJm6LtblwTRyeL+JKudtmg8oiGEX9/KLLDUV3PIaJhZqKHVZNdASg4LRvNkVat7f+DcR8bK+ZNTA9Azx3esB9qEg6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041443; c=relaxed/simple;
	bh=Ch8Gak8IB6jpnxfPZTVziTRLtsmsDYYepi5m8P/pKDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx7BIg6dN3GKXNwT0cp2kvbzP3pJfEr4YOnOPx/b4J4VhTroVjVq0ytHGW8Cq+Av8E1R/Wh+xGaWSrFTBrQeXJcs+8sVSGrKmtMZCXXwnQ7MgTz3RSp8rNEK+aaJbXMdb9Ckt/8Ly+vf+KLGjMBB1WtidCAEPM1chDSTs2+aNuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyMwDttV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyMwDttV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D022C433F1;
	Tue, 27 Feb 2024 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041443;
	bh=Ch8Gak8IB6jpnxfPZTVziTRLtsmsDYYepi5m8P/pKDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyMwDttVFWER9pTQlIpo5H2PKs+zX1mlyiIU982i2AwLSgyOCbsyjwKMfp7nFWe90
	 7ZGds5npmJD/hiR777kJRxEsPEDlsgeItKC59qBWGkyYEmFG0MozPJAljyej//yxS6
	 AKjAkzV9mEtEgcWkl7x//5jvOH3fX6IyiBTnllwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 6.7 306/334] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:22:44 +0100
Message-ID: <20240227131640.933121095@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 04c5aa4debc74..dc26986fd4b93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1251,6 +1251,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



