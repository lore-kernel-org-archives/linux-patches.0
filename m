Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC22F13B2B4;
	Tue, 27 Feb 2024 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043685; cv=none; b=ZMtsozW4HFw9M1SSaCqJWpJCqWQFSInKqc5JoPGF5VxYCQe6iS9UH7BKDDeJO3YguH6JMf2TxViMQk7QCRp3L/Gf/p1ZLbVx9jyGowSXvtL2G7spNRBdNpOnYHnoRC6/xR4kOwPY7HsfUrILLF9IpjOZZCE5es9W4ei+D+pKqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043685; c=relaxed/simple;
	bh=enELkqVk6zRg6YHOytDsHgF3jwu1x8ENQr1LxcT9ae8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yitu4Yyi55KiGfAZuQLxydbYEyB8MZccQfKERufaoi9j0+dZCnvKIOlWp7+visShVUKfZJVQqIkHRANNs3SzKSv8ptMwO0iIuoYEYLSdojLbQFdOgm2rkxVMnizOzIdYRTWdVwDfQ3tHMf1cBZ/04c9pgGKb+m/OJNhYMZlswKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSYS/jSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSYS/jSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ED6C433C7;
	Tue, 27 Feb 2024 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043685;
	bh=enELkqVk6zRg6YHOytDsHgF3jwu1x8ENQr1LxcT9ae8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSYS/jSnmbjCR8+ZIXC838XUI7Wf35m4pqts26T/JYFeIVNWA+ZXTUTzqoXgew8+6
	 xuNDq1uo7mOcGgM7RasOwq5uGmaRs/THZb9pMAbVJ4V9VfAujzlQTu3am5LcDFDmQH
	 oFZxW89RVRgxOzbv+MzroNSdvgbBf5erIyKCrIT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 6.1 169/195] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:27:10 +0100
Message-ID: <20240227131615.987753526@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49acb89ba9c56..f1a74b0949999 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1245,6 +1245,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



