Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0F13B7A0;
	Tue, 27 Feb 2024 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042371; cv=none; b=KCIpY3X/ZKkMhqXzQhhAORHLiHhS5pCj+cyuXG2bTZ5g7cKxW8Vozy8caC3yTKpYHGbeJPhJ6sMm7zwMs04FP+p4EqEuzGealv88Zgw4LXiEr/ss4rjE/ixL1cMhZnwJQtx2i97CcwZ1JkhZJ2nnBO6clkZtiHFqhaqurfbaYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042371; c=relaxed/simple;
	bh=YpoeBysjYq7iW6Gv4b0A4LmQVQmMNBznlXz4CfP6gxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prB3ytDEjVN4VpJP+ffgb/movyioZmGz9c9K09XWrjcBdqtGfFCbONDNT/TKbgMXOJBvH7OQUTfC4tY2hTtAs7H+6p8YpZlCgwJiwyo/4Nwf8EwTQOiOHC/T7f1SZpm3d6XHoZvc8/Fx90Qk8W5+uupPPToI4rc/LSVg7mYm+YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MURjiYNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MURjiYNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF43C433C7;
	Tue, 27 Feb 2024 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042371;
	bh=YpoeBysjYq7iW6Gv4b0A4LmQVQmMNBznlXz4CfP6gxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MURjiYNNWqv4osuEXfjEqXNIQcPWs0wMJQ00fikKE+cVSANPDY0NEA/7GNHuEL8Tq
	 tuFsvuMlzUonH5VdaJ/KdqCxsjYzYo03wH0odFq9iPpmuXBHUviPEOX4TCkm0K3KSH
	 kYigiS+FEjPhLycRhj7gCXIXRAFVgNewupw0jZ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 6.6 271/299] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:26:22 +0100
Message-ID: <20240227131634.405853804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb7d42a3faab3..40e8aa8343cc7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1253,6 +1253,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



