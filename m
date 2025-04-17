Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6422571B4;
	Thu, 17 Apr 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912457; cv=none; b=NHlLCBd22odhFQtPLcNYaVTwQJovKKbscFt7bVMkJTgz7pHAco7TWzZSDVP9S0miBFxwCFqXDE1kO/pcU7IfQPPhG0WKtHdSnfoZLEfkfDek9UQwmFt3iXEkyfuuBcjl3A2+hvVQo0az9TZy4RWV3pbml9qCSDUY13j0dPIrjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912457; c=relaxed/simple;
	bh=vK4bBqLqAk9Z28b9kZGQd7b1A+ZrMGm+mYfnfWKIMuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCEzWBILks8Da49msAmgSxESMdhwKCTBxTYL39sYZFJLB9FlNpjO5KZdmYw+iavv9H5ZcpBzS22CWrZBGWdcSOMtUmW1AloxIcorE1+Zwm+GzLPLqFiwIiQxjAwxpQrIoi3GlzPlV4VTN33GNiZQP560dg1Y4+m974doKF5DB5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdZejcox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdZejcox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73D4C4CEE4;
	Thu, 17 Apr 2025 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912456;
	bh=vK4bBqLqAk9Z28b9kZGQd7b1A+ZrMGm+mYfnfWKIMuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdZejcoxB9yTf+SNwzJn9if3XIznJsiuvux1YcXzqEjQn5kfDqhzZnSavabzxqT/5
	 iwSz+nui217kWDpcsu0ugJTtxn5AZiI75ucPz9x9iIhJrtlpRmJG13PSWclue3+X/6
	 yF1uYhR1KkOd+LfRttVCuahmdgZosVTmu5ornA1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/449] tipc: fix memory leak in tipc_link_xmit
Date: Thu, 17 Apr 2025 19:45:05 +0200
Message-ID: <20250417175118.684199963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



