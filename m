Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D82145B01;
	Tue, 27 Feb 2024 14:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043911; cv=none; b=rDds/R/ISZ4h9svmGawrcZo2L5wXeq4A5LUFlRO6kfa0SeUl/k2+/rlCzI9J5Qi+MWqBJMDG14HgYvc/2XOmOhGe9JWeCpbEeWKZpOlg/P8KdwyADtd13GgJu5bHcmydw2OEPKhb2PnCjv5uEW/OYJ+QXcmqiFT4zvX2FRFQyqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043911; c=relaxed/simple;
	bh=k51IVfxT+GSuS7rhQYB1USjmaNfxeb36Vn6f6g/7pMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHdp/YN29724c14w6+d3v+SSJRx7tXYXBMBlIVQvY+3fZipIYfWfz4py0AV83QdeYprws9e0PeyEisqw0HGNZO6EyK2TLkJAAQ/ArIYwsciVA3yYjZVNDngFSAsgtwm7L5P+6ptiqDzmIEcpGRMospvclgWC/OrMctfevibn1QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aZRgJou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aZRgJou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0FFC43394;
	Tue, 27 Feb 2024 14:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043911;
	bh=k51IVfxT+GSuS7rhQYB1USjmaNfxeb36Vn6f6g/7pMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aZRgJouaFvSR8XQ4cUy1hAnWVNBjj8yUc10zoN5Q45pO2bXNXADcjlEVM9gIu2Jj
	 yv/A4eM9ie2quJSuXeyp/ZNo/aNViZyqgo2XkbkBzNl8EE87DDFDTt0GxqEFjUm4dd
	 0HxbWLNlWj71+ogz5gadS6GCC4QnVWdsqqFgNoqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 5.4 80/84] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:27:47 +0100
Message-ID: <20240227131555.477222132@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6c83d3e169c9c..c5dbb950822fd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -951,6 +951,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



