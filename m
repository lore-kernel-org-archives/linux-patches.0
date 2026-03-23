Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A53B4EA3;
	Mon, 23 Mar 2026 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279313; cv=none; b=nxaeopPPuBbwtvnnhnVRTFp1DZvlGXnslhK2jMwY+W/TQu+5qZAQ/+l6XvNRzRSJFp1LG7DRpw1fiQGYxa3NcF3WMRmpu3uUflcOW5jovID6IQ2GCMcNHP3adXyHhxzY1J+d7R/LBKNDpPF+ucd0L+qurQUSFXvvuYqOmhK/DEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279313; c=relaxed/simple;
	bh=nMtLkUqt1FDfx5h47k5gE3FHB/6zjmWK/PUD7+RMics=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNNH2bbNMcbgaNhsBt2v+KW/mV6A1ILFuh/KaBNorCVPqWeZ5yRCUKHcvDymt/cakcV04a5LUF25jMEkEwpFs1C8qZm0zHupS/A8MmZmqZsF5F8pa1Wv3zLHAi7Hx8iYSR14cbYatrYc3LEUq0YGE3VSEABJlzIyH6+ATeFonxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozcJFHjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozcJFHjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF5BC2BC9E;
	Mon, 23 Mar 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279312;
	bh=nMtLkUqt1FDfx5h47k5gE3FHB/6zjmWK/PUD7+RMics=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozcJFHjdyymBd8IBnWirejj7dbWnt9trmjHVQBs8pCG6xmtv6BGhJMwnbFZDFQUj6
	 9XudHQbPcjBcnvVjB+Zj+XieU1I+UrUUamqeyXeLAPTl7wBjqnOlK39fqH7w3+6Ot2
	 b1/FVket953UeA13QamaIdZCnHjd9eYsaq6dmhPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 543/567] netfilter: bpf: defer hook memory release until rcu readers are done
Date: Mon, 23 Mar 2026 14:47:43 +0100
Message-ID: <20260323134547.440628292@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 658e401b7937e..c65502aa12557 100644
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



