Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0DF254B1F;
	Thu, 28 May 2026 20:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999935; cv=none; b=pOXvyUgz1PlFIP7QOxyzhJQ4P4LBzioQuhW6nRjxqi14i9IJXOnT6JA196y/0jgqvCiagG9G9LnsHFV6gWtnFiB8+xDtVR3DM40XRuFEQPwWZmsfVRvw7EvxGkefRs4IbFau+Iq49Ul8RzWx7LXoe6EDf6bRIkmH/m3kDVjqLVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999935; c=relaxed/simple;
	bh=eS9Z5shYSOl++QwW3YllQfTdmMkqn9TulyEGu4SeEsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMdjhfN2PKuFH8OlqdtUXLRX9eowjSRDbidS/JqF1uDKdieH6bvMD3xqnznOI4eiSFxLTqEnrd64utDXdiF2Cy4wGBfKqPA2IMxdYOatcxn/xmBA/3nyOQRp6YhhjSiWUr7nJa1ekrhhpKF8DEEQR+FefrtWPw3IUqdxLQpgJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGemehbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGemehbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922431F000E9;
	Thu, 28 May 2026 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999934;
	bh=q4CMrm5u9Q8R/OCBnKRtBvDtnZIftc1WDvL6nzzM3bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGemehbtGdF6TwPYph8mN1cLjMryuhZN3kHWG7DQenbxV/mG6FvmuU9rvgmDrmwI3
	 /wfWO6qHYgn84PKK5BUWO7ftTWEgShMmBjDvBsrJ0FsxTUSua3sH/Pq62gY2nv0YFl
	 zejAG+ejWaIC8dvp+YivSXc3tkkFhNThK6iUqYuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/377] netfs: Fix leak of request in netfs_write_begin() error handling
Date: Thu, 28 May 2026 21:48:02 +0200
Message-ID: <20260528194645.447216446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5046a34f0643441f05b0253ea64e1a3af87efe14 ]

Fix netfs_write_begin() to not leak our ref on the request in the event
that we get an error from netfs_wait_for_read().

Fixes: 4090b31422a6 ("netfs: Add a function to consolidate beginning a read")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-19-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 762ff928bc878..085cd392bf5ac 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -686,9 +686,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	netfs_read_to_pagecache(rreq, NULL);
 	ret = netfs_wait_for_read(rreq);
+	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
 		goto error;
-	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 have_folio:
 	ret = folio_wait_private_2_killable(folio);
-- 
2.53.0



