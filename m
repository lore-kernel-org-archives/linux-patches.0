Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30A27CB12;
	Wed, 23 Apr 2025 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419559; cv=none; b=VeltbYtY0C+ykozpmbTWya7yRxL63hhVjVBgZXaw/dwIcKZJkZS+5RoS/5UXQHUobnpdaE/Fka22znA6Jp1BbpDZpkfp20jNbcnGHBsh/vnxjcjPpK7H2hg3y5XoU4vtT5lFwFBkvuuJr5zNyohUaXT7FY4a3HcuUqeRIcFhm9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419559; c=relaxed/simple;
	bh=tJ6xMqH/0uPkZckafKJXR9aY5Scui95suLGLxdQS4xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmMTfuLFBQoCSf0+gJAqvL3CjaXDsnyz4eIW+d8l86JJHBFYlshrgoJCCc8/zu1FKna8Or8ODdfVFGlsSPio1ZosX+g2VRy7u2S1gU0zSXPmAFAWsJ7hiWgi07T1s7U1zM6GNNiPyqrfLTA8a+AwwYXzW5pz52QJ5HjAqd9upV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXULMPi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXULMPi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120D1C4CEE2;
	Wed, 23 Apr 2025 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419558;
	bh=tJ6xMqH/0uPkZckafKJXR9aY5Scui95suLGLxdQS4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXULMPi7FAxdcd5bqLYityKN+MOzhrGeqMj6tnK2Ex2FQ+iFSpHmqvLEmS9RmdVIA
	 c92CzvwnHj7i1IHsnXO7CbJxXYMTdLPTys0HPkFSxpy9uQHEJD7uPO1Jw/H8TWjkDq
	 n3y35s+xFyIN5t6fKdW+7AfTJwc+9dP7EVU7Qgj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/291] tipc: fix memory leak in tipc_link_xmit
Date: Wed, 23 Apr 2025 16:39:52 +0200
Message-ID: <20250423142624.553617758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8715c9b05f90d..d6a8f0aa531bd 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1068,6 +1068,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {
 			pr_warn("%s<%s>, link overflow", link_rst_msg, l->name);
+			__skb_queue_purge(list);
 			return -ENOBUFS;
 		}
 		rc = link_schedule_user(l, hdr);
-- 
2.39.5



