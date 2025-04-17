Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13881CAA99;
	Thu, 17 Apr 2025 18:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915095; cv=none; b=fwTTcu2/IWsdxNu/YsMi4YUDaWQu6RVt+d6lEVliCIXKwEJG4z7xvdz3m8XNl3T4JUlPAquNdSNj1UV1W0ZNNYRmCVWZAds/UFJFnBv5m43JVMbJ8/dKe4ahQ82le9iucHCBSTmDbSlloLXjRRshGluxeeF6p68LLV4Ja/hDPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915095; c=relaxed/simple;
	bh=1pSGHsGXVSoRjbTPYVQpqfICOx2QSvIKi4GGA50XNdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B40ceg1px0RcK7b2Zx+1gIMsjjjNkCuKf2ndEC8iNyWgHuavePyEmYWI2yzsmzA9dfg0nmST2Gfb+1xvLwgh4rGEbeEPACc+zd9xSC13idCvPNARNnC0hwhiZvrixIZzGeJFdb46AJ4AOa2MgNAYc3RB6ujptBXheSUGBDI26AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMwQBrR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMwQBrR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09BBC4CEE4;
	Thu, 17 Apr 2025 18:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915094;
	bh=1pSGHsGXVSoRjbTPYVQpqfICOx2QSvIKi4GGA50XNdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMwQBrR18z2YSH1tKeZQUlS9mprpna43EsqcSRulk2XNm/eCJJlVSnIdWkooBiIGX
	 +y/t7U5/C7TQu40O44ZU0Zhgph8fiMxDSMN5iHYl2QtLXxZ5L9NfM07/JhcsJLzZzl
	 TY8BXkSpLYpKwqv3MtvXFUYEPghAILYaVfvRglsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/393] tipc: fix memory leak in tipc_link_xmit
Date: Thu, 17 Apr 2025 19:47:06 +0200
Message-ID: <20250417175108.289352184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit 69ae94725f4fc9e75219d2d69022029c5b24bc9a ]

In case the backlog transmit queue for system-importance messages is overloaded,
tipc_link_xmit() returns -ENOBUFS but the skb list is not purged. This leads to
memory leak and failure when a skb is allocated.

This commit fixes this issue by purging the skb list before tipc_link_xmit()
returns.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250403092431.514063-1-tung.quang.nguyen@est.tech
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 5c2088a469cea..5689e1f485479 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1046,6 +1046,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {
 			pr_warn("%s<%s>, link overflow", link_rst_msg, l->name);
+			__skb_queue_purge(list);
 			return -ENOBUFS;
 		}
 		rc = link_schedule_user(l, hdr);
-- 
2.39.5



