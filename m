Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041713B29C;
	Tue, 27 Feb 2024 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043091; cv=none; b=OPveKjYYT2dGO9WeMzNUQQwoRxXN/dgFKzwGcaqQVcb7TZkIkVgEyvR+2K4WQ6PJkmkqCLxWMpAHdfXJEkDbj5m8PmzD7zzJSllf+zlfjJNatXqosqKDnBalR8kDMovn0UjIzchnr+w8N7Npd9ymo9mkdNLglsxEGsxE6Te6F2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043091; c=relaxed/simple;
	bh=nm+Klt5uGxseDP3uwLVBw941tceUa8u6EQbflQyiLzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiTUKPaoeQ5j/YZBYM5lkSffRIKaqDFFcHQz5pp3lh3G3d8yNKEuVfrYlVTmnOIcxyHUvgvn5CtWQsqv0txYlzij8bVsiCCKWsmX5WSBoVHoq4K8J5i6X9F1mBFJOf8CTubtfE92zUsPUorkHuYR1Axx2+TQrgTbMAJ+xUOUwPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooYD3i5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooYD3i5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FA0C433F1;
	Tue, 27 Feb 2024 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043090;
	bh=nm+Klt5uGxseDP3uwLVBw941tceUa8u6EQbflQyiLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooYD3i5nyk9qx0mgLpr9M2xZFvY6AgtDvD33KO2EoYw0+QUd28ytoy6psATrIR9t5
	 +jo4acQpeoczFoEqcFLb0teUp2wZ8NAKc2UEZ+vfzukoXSIV7Su0hHjGfUCrm+8hYV
	 WBuJsZaO6hQjCWtl9EtOyU2wbK6lL+a/PwZ9sCwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Subject: [PATCH 5.15 231/245] netfilter: nf_tables: set dormant flag on hook register failure
Date: Tue, 27 Feb 2024 14:26:59 +0100
Message-ID: <20240227131622.689067738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 361fbbd430ad8..1a7bfd4be61d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1193,6 +1193,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.43.0



