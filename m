Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA9F23FC7D;
	Tue, 29 Apr 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945152; cv=none; b=lRxMZx8puIQXtCWaq+oEHST8le1U1lzqtdfikE1TcOqNcNXs17W6/PYap1pP+MN2h0oKuXTg5htQo9N/tRSdGrHWtahOUfj2yavxAB9jZs5j9NbmUmmDbW5cusQgtX0Cd8xixhWRfDRvLHo11rOLPcHJS3TmMDXTn/RRoOVXmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945152; c=relaxed/simple;
	bh=2KEZiZF3KNQCh00/tomlD+4EmvOVFQ5SLE85YDO9rlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NecZkEKE7uw8mpHyrCJGiNym6DPiKmHJkOvLlImIt4+2z15WjMT7GxsSAn8TD6XUA2+3aAKcsXBf7/GCUfOXF0NB0KDL3KvjFoBdA1uIL2Q2OM7QtL67aqeMUvs0CBlwXWssoAUdu2BhqlBmXI/twfcexAl+9OQ2FDHsETOq6VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z75DLbkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z75DLbkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCCCC4CEE3;
	Tue, 29 Apr 2025 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945152;
	bh=2KEZiZF3KNQCh00/tomlD+4EmvOVFQ5SLE85YDO9rlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z75DLbkVda8Ak6bvVOZjAPeHZRd/M2fm5CH4AHuz03ukNa+Zo+8QVB4nBT5gh6/Fw
	 QmVyOaPpcRMMTDl+yeMoFwABjs44+lfN+FNKNw5ajEThGMtcsQNnuRbxIHrNOT/rb9
	 Mt/ykwPOFjubP3S4whAmxIxmGMjz1TE4J7hpEulE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/179] tipc: fix memory leak in tipc_link_xmit
Date: Tue, 29 Apr 2025 18:39:03 +0200
Message-ID: <20250429161049.491821627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b653d16ab21f7..2052649fb537e 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -969,6 +969,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {
 			pr_warn("%s<%s>, link overflow", link_rst_msg, l->name);
+			__skb_queue_purge(list);
 			return -ENOBUFS;
 		}
 		rc = link_schedule_user(l, hdr);
-- 
2.39.5



