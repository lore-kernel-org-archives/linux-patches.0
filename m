Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F040DFC6;
	Thu, 28 May 2026 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998711; cv=none; b=B200g+GXa0g7omzi1nFy1dzyox7VKNCTGxkRRocw/vgaICoDQMwkU1e8L91grqau++wtL24Rir9eoh6RU/FsDSRgo42Xd60igT7JIYfIdE25/fLohuJ7OJDP7r9cvRtrSZWPts37iiqZx4v9FsxvlUkdxlBmLFx87UO99xFiZMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998711; c=relaxed/simple;
	bh=2D+CXg+n3jI/DTE71YrMXEv871DCuskxojmse+QRYUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAJVhPNjrYgw1ZmiVzgmLWC1GF47MUKG9aEVYagQJhU0HebP04IhQ1NKtlODWEUeeSUj+56ckaoVLQgn1pBK38O++E9e3mVe1mSi2EfMkdC30irmRUUxngUnCLaybuyA32zUWRkxd/GsLuFZknQ6pqjVO5Xj0+l7UqQMRnlkUHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkPunZQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkPunZQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EF51F000E9;
	Thu, 28 May 2026 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998709;
	bh=yWeAELww2xxxdusmKrZdJB5nB9UIs3CCePDUrPLHgu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkPunZQW1bQPmDszNO59NvI786defRvvLxo/wPU7MKqMIfcoLzdHBSowpJwu4MhKt
	 eskaSq9ffcMgv2tfXFL9wWCRPoZZ1aznnscPGNXwB3optPWG8bRIBPo31iZubqq0Fr
	 tCBhnVBt9tjm/AfMBL40z4X4sttWQwUfZkZvLn+A=
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
Subject: [PATCH 7.0 269/461] netfs: Fix netfs_read_folio() to wait on writeback
Date: Thu, 28 May 2026 21:46:38 +0200
Message-ID: <20260528194654.955655689@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ded0c6f1606061148c202825f7e53d711f9f84cf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 83d0b8153e96e..76d0f6a29abab 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -503,6 +503,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
+	folio_wait_writeback(folio);
+
 	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
 
-- 
2.53.0



