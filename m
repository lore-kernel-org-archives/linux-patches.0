Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB571DF73C;
	Tue, 29 Apr 2025 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946635; cv=none; b=KAFGZxjd6TkeTLVeTLVyfHiOxa42ex39KPUBgvBGIeLBzn0o1T0vfMCsnQnepTZdZ0io7uaIlzVSxno9/utu6LEelsBmg/M4wBjgBY8U5kXRk3CxHpxhZtm0PuRfmUTNQLJlxpTIPOz3i2ZmKDD7Ezu56a4VO7G1Wzm9i0zAdfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946635; c=relaxed/simple;
	bh=TjIyiah6TcqO69Pv9fEa7SzqzzcFI1kCQbVDsb++DP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urG/Mif8EnIyeqUP4AF3VC9OxoepHKIrQ5SsrlVUmwVBgdM0BV9dKInNt9vTG6Z882o1lk7VwqJhmS5vi4sdJX3YZEPUETl3mNa7BCnYNFSVe28CeI2blUliGnnxq9Cfpw81PSoV6jxmYTJwgL9/O+Zbu5sMJX1jvJZsQ4B8WJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1gpnyl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1gpnyl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688B3C4CEE3;
	Tue, 29 Apr 2025 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946635;
	bh=TjIyiah6TcqO69Pv9fEa7SzqzzcFI1kCQbVDsb++DP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1gpnyl8qm0PeSrrbK4U5nwF/2yo+8nnG1GmtfQrCT7yfO9TbFCDk/t6q/ZPnsL+Z
	 LQhYDbv5NZGNPdUKb82bcmMHl/CFoYuGSaA29MgeDvD/71Gn8R7AZaCVUHzUAMKpqE
	 DT/f/4jSyFxtK8tTaP/VA6E9tgNiyYy4MAMcYpUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/286] tipc: fix memory leak in tipc_link_xmit
Date: Tue, 29 Apr 2025 18:38:26 +0200
Message-ID: <20250429161107.955470497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f849c7300283..336d1bb2cf6a3 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1033,6 +1033,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {
 			pr_warn("%s<%s>, link overflow", link_rst_msg, l->name);
+			__skb_queue_purge(list);
 			return -ENOBUFS;
 		}
 		rc = link_schedule_user(l, hdr);
-- 
2.39.5



