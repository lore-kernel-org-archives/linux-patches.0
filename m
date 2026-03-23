Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492233B3C1C;
	Mon, 23 Mar 2026 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274437; cv=none; b=MOlO0MIF75RYmGHv+Vv6DTK1FgLCKz0Od12lQUUF+1XR/36t6I1HSmGUzwRIqP054bCo7EeDgiVXw6YLwMD/Flku1LsLadQonSTf0MMtboSnKNGsYxX9+/9Wzsn+blNJHmOMnwKiyypNjKUCAUTRNxdwsEh83ACa7CBNxovJh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274437; c=relaxed/simple;
	bh=C+78jT9diNppmGDxbLeQw65UBBj28Iu7SpZxBWLQekM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFO7UGzUhGbYFT0eoMEzw1qePuTAm3aPM3I94Fq0bUYo4eG0U5+a92ZkrxEuvUvb++IbifoAVKaOxcg8FUZBZ1QRCyRmQ91f4TZvYTLbT69ws4AkSrHItCCtCLZpR4qLj7KMdwz84CRkdfSBaGSs+iHvgfUpn+tDuQGZx1OMYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9/XpN5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9/XpN5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A6C2BCB1;
	Mon, 23 Mar 2026 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274436;
	bh=C+78jT9diNppmGDxbLeQw65UBBj28Iu7SpZxBWLQekM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9/XpN5Azmk1/7wukOX9XDbcy3NA2/DIcZegArS5YndDI83IyadE3yzczY96EmzMn
	 XeXzEtKrspxcSLtRvySC8yoaII+XiZO1MAYcGlyGzg/GK6bZ39a97ueeiNAj8cW0AI
	 k62Mv6cghWZoEe6YG9G62sMO2SZy1lNxKuwUs9lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 173/220] netfilter: bpf: defer hook memory release until rcu readers are done
Date: Mon, 23 Mar 2026 14:45:50 +0100
Message-ID: <20260323134510.048442939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 24f90fa3994b992d1a09003a3db2599330a5232a ]

Yiming Qian reports UaF when concurrent process is dumping hooks via
nfnetlink_hooks:

BUG: KASAN: slab-use-after-free in nfnl_hook_dump_one.isra.0+0xe71/0x10f0
Read of size 8 at addr ffff888003edbf88 by task poc/79
Call Trace:
 <TASK>
 nfnl_hook_dump_one.isra.0+0xe71/0x10f0
 netlink_dump+0x554/0x12b0
 nfnl_hook_get+0x176/0x230
 [..]

Defer release until after concurrent readers have completed.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 46e667a50d988..248840dbca1b2 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -170,7 +170,7 @@ static int bpf_nf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
 
 static const struct bpf_link_ops bpf_nf_link_lops = {
 	.release = bpf_nf_link_release,
-	.dealloc = bpf_nf_link_dealloc,
+	.dealloc_deferred = bpf_nf_link_dealloc,
 	.detach = bpf_nf_link_detach,
 	.show_fdinfo = bpf_nf_link_show_info,
 	.fill_link_info = bpf_nf_link_fill_link_info,
-- 
2.51.0



