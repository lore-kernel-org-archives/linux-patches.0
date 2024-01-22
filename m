Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42375D8F2;
	Tue, 23 Jan 2024 01:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974385; cv=none; b=QkmT/d1OxsnNMMg2RlxQMv3duztLbmLVnJWAVdcFNSdMZUnD9edKHoIP/bc7xLnjuYUg394CJVwiCa9uBCtrcImWzblQvU+GX1FLmhSkBFRtil0j4Zxyw2+K90Df+WJu04XZY+QpKTwfjM+tFU2yWi0JgKcGALSFFq/mSxlLoqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974385; c=relaxed/simple;
	bh=EH39n6Fkwqz/0fAmIj+fkDhWl8bS+8YHQXYHKZdU+wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8HgwSLaPKbH6jD5L56RqTMJTrxPAbnr1TFdWGOq+goFuiZsxWqCWKgNzYlQKESIq2YfkA+Lbvptv9P3InryV3gmW9dRDvbPYz0fRkDsgnfzs9LC+WQP1iM5yWXtWWOOAcuBYwYXlZKbG4mFEvkj+2ZYzbD8QOy9l8wshSFU9jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar/kORWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar/kORWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC48C43390;
	Tue, 23 Jan 2024 01:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974385;
	bh=EH39n6Fkwqz/0fAmIj+fkDhWl8bS+8YHQXYHKZdU+wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ar/kORWocCPQnL9w1/fpGObHITSibngDhgmsTcsrnqXUB0ZWYs5Io/VK/dT8pQAPw
	 g0RD3PLNcr87DEq/HG7Q5vXPOJQDvYvVKLHkbILNLREccqotVq+cVUletOYl6dAWdV
	 S/ry+m8x1c97uI1MH5DUOLFNZk14KN1e9jP88akU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/583] SUNRPC: fix _xprt_switch_find_current_entry logic
Date: Mon, 22 Jan 2024 15:52:10 -0800
Message-ID: <20240122235814.574608063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 98b4e5137504a5bd9346562b1310cdc13486603b ]

Fix the logic for picking current transport entry.

Fixes: 95d0d30c66b8 ("SUNRPC create an iterator to list only OFFLINE xprts")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtmultipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtmultipath.c b/net/sunrpc/xprtmultipath.c
index 701250b305db..74ee2271251e 100644
--- a/net/sunrpc/xprtmultipath.c
+++ b/net/sunrpc/xprtmultipath.c
@@ -284,7 +284,7 @@ struct rpc_xprt *_xprt_switch_find_current_entry(struct list_head *head,
 		if (cur == pos)
 			found = true;
 		if (found && ((find_active && xprt_is_active(pos)) ||
-			      (!find_active && xprt_is_active(pos))))
+			      (!find_active && !xprt_is_active(pos))))
 			return pos;
 	}
 	return NULL;
-- 
2.43.0



