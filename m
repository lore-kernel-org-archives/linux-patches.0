Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF255E4C;
	Tue,  9 Jul 2024 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524732; cv=none; b=V4oAYrGe4xoV9dxP3fvwS0qY3aFPMzkgIq1RafKgDOddgi/yDNUAy08VFW7ZzE27D9/UoLSH2MCnho9sqbPx8nrEoq8AoWa4ytKZO5RZtxNR+WI3MgiKHqjeRT8XtOXDG3XPKM1WBRS5cTkO7R9yS3iV6/31thvceqwd3t0igT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524732; c=relaxed/simple;
	bh=8dHdPGLsfraqqyUEMnoMyccIcZGAi0wA3GzDGhroP1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR5zvNWM3bC8RM5C+CCxTeOf7vpUDZh+RPxn74ByINf7QlLpV80MXwb8KkVXkhHtBHQBbFa8jU1s8XYhoxflcJ1CDSceDsNTfqmRMRAH7Fx2xfjVtEjU7tJn7FCVMr/V0UoAoW03T7sO96QXjWbv5WTFhn7x2ykhEDlaH1NR15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4c9RGSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4c9RGSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3425AC4AF0A;
	Tue,  9 Jul 2024 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524732;
	bh=8dHdPGLsfraqqyUEMnoMyccIcZGAi0wA3GzDGhroP1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4c9RGSBsIgLINsoMhl/Qw+6dleNI67plS/6ngJztReuhH4V6pzSQI0zlg0u2QBoR
	 y4764F6unG9zC/7X9Cfhh6LZrkloTESTUYrRvu5q5Mj78TmmjbEVBCKn+HHFOXldTO
	 PoR3m5XyiUFxcZwHjyFspU6pmVAEC8mL5Cuh18GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: [PATCH 6.1 055/102] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Tue,  9 Jul 2024 13:10:18 +0200
Message-ID: <20240709110653.523052314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

[ Upstream commit 9f6958ba2e902f9820c594869bd710ba74b7c4c0 ]

syzbot reports:

KASAN: slab-uaf in nft_ctx_update include/net/netfilter/nf_tables.h:1831
KASAN: slab-uaf in nft_commit_release net/netfilter/nf_tables_api.c:9530
KASAN: slab-uaf int nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45
[..]
Workqueue: events nf_tables_trans_destroy_work
Call Trace:
 nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
 nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
 nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597

Problem is that the notifier does a conditional flush, but its possible
that the table-to-be-removed is still referenced by transactions being
processed by the worker, so we need to flush unconditionally.

We could make the flush_work depend on whether we found a table to delete
in nf-next to avoid the flush for most cases.

AFAICS this problem is only exposed in nf-next, with
commit e169285f8c56 ("netfilter: nf_tables: do not store nft_ctx in transaction objects"),
with this commit applied there is an unconditional fetch of
table->family which is whats triggering the above splat.

Fixes: 2c9f0293280e ("netfilter: nf_tables: flush pending destroy work before netlink notifier")
Reported-and-tested-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4fd66a69358fc15ae2ad
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 97ea72d31bd35..d18b698139caf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10858,8 +10858,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nf_tables_destroy_list))
-		nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.43.0



