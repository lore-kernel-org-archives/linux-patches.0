Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9403037F313;
	Sat, 12 Sep 2026 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213077; cv=none; b=mP2ZCLMIbjy7Vezeci4GtXtPjSecccGhuSOoXTYgyAGCI2dFDcPnwYvj8pENYoCZmh8qERtofBG+CJlzilqiwHhAlg/sGPrZmw4SxtMtc05Ao4+kSR7kqLM6nGnjwObLz+P52eE+OwkDc1QWACReF/gBJaCzoZLYKh2eYA5GL4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213077; c=relaxed/simple;
	bh=eVeZsdtcrFesqx6L7/vZlPo+qlWVFLJ1CPYpGxAQY0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVWth5Z2msCFqM+EHzyjG1eQOp9HVSgQQwhOt76MxDYsCe1pCZNFvU3AHIfne0tPoh461/hHn56IxmUu8PDhsJ1hvn+G+mCtSUs5s/WYPoX05pSh10qzQQPBSHLMu/8OxuuUT2Rg85qVO1I8i0ywmCWRQKq3Bm8wjNASbMfuR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJv7T2WR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJv7T2WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986131F000FF;
	Sat, 12 Sep 2026 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213076;
	bh=NjxA6IhOdDxwuibK7RNjn58kJgDNzlpX48ByqsTlrBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJv7T2WRlAeyqUKh/LtgwUm1LOat4mcCJerh+5ArWTHVeRRqsF9NHkye/FNDKNNtl
	 tqdafj5xBba2B3xIfFdYd+CixTSIiOGZPM3UmVbQ7nVvlxiA2g4nneH7cBnLd+X1LE
	 rh7rvEamwTdgKf/cOf+O4gizOZMgwOY3/MELCM4k=
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
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0006/1376] netfs: Fix netfs_read_folio() to wait on writeback
Date: Sat, 12 Sep 2026 08:40:32 +0200
Message-ID: <20260912065607.689814190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit ded0c6f1606061148c202825f7e53d711f9f84cf upstream.

Fix netfs_read_folio() to wait for an ongoing writeback to complete so that
it can trust the dirty flag and whatever is attached to folio->private
(folio->private may get cleaned up by the collector before it clears the
writeback flag).

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-23-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index d99284e35126c..fd41e38aedb75 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -565,6 +565,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
+	folio_wait_writeback(folio);
+
 	if (folio_test_dirty(folio)) {
 		trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
 		return netfs_read_gaps(file, folio);
-- 
2.53.0



