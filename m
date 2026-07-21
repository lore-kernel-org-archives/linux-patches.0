Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC12E736D;
	Tue, 21 Jul 2026 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654464; cv=none; b=NrfknA5loGzw5Qv2AxOoLj4ZLx9EHLS1rPkwNNsiJ4qMxuqq6O+aBvEG62E+oUh6+4Qudh9k5Azumj9IE7BMS2omm/oSwrnHUt+56gRWzOZGaxk1fTx6Jk5KHj/TMfLzAIIam4zmAJzS46WuR1ZpsNLh8DJDuWZeXN2G8xDF9zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654464; c=relaxed/simple;
	bh=UvXZZNE3iREnSfTB8pI+PB1vyJp3r2y7qO+sQ981/cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usI+2nXhNWsK21MXlrtKM5Xisxc6QM5kbv4Iqg2gw9eKCg307lPHmk4ZgH+M2BAEckqNB7EHXHYAUY7yzoSkCArGzFo61QXWAoyEC5aVVXVzDMayHoUQ8c4K0suAnnNRPixiySOl9Npa7YnTtqMzpSzNKUxByzihNBzMVTJ7QjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNpw08mQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNpw08mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23541F000E9;
	Tue, 21 Jul 2026 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654463;
	bh=Oycrqih7w3CCg6GYz9x7f6aqxQXei4JQdiCe4XovSOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNpw08mQsAJ/colHax4InPjlKOMd5f4rQmvX/BR1PZaHrry6zbKwurHvBjt+BFH6U
	 dNmvLiIUFj0tuygqZ8QTWocqdIdrFtXcGMiyxGIDKHbcRr0H9dRmpXWH/Nw0QmDmTB
	 iUtYHSqHLqPXnQJDEG+YpMfkvcQiGC4ClaOmt+W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1715/2077] ntfs: avoid self-deadlock during inode eviction
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152633.207112089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 77dc384207d5fa63ba97c3bf3285fe1215a1cbf6 upstream.

An attribute-list update performed while allocating clusters can drop the
last reference to the temporary attribute inode. Evicting that inode
drops its reference to the base inode and can invoke ntfs_drop_big_inode()
for the base inode from within the base inode's own writeback path.

If the base inode is unlinked, ntfs_drop_big_inode() calls
truncate_setsize(), which waits for the inode's folio writeback to
complete. The same writeback worker is responsible for completing that
writeback, so it waits for itself indefinitely.

Prevent this self-deadlock by grabbing a reference to the base inode at the
beginning of ntfs_writepages() and releasing it at the end of the function.
This defers eviction until all bios have been submitted, allowing the wait
for folio writeback to complete safely.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/aops.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 1fbf832ad165..88e5b2def66c 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -251,6 +251,8 @@ static int ntfs_writepages(struct address_space *mapping,
 		.wbc		= wbc,
 		.ops		= &ntfs_writeback_ops,
 	};
+	bool need_iput = false;
+	int ret;
 
 	if (NVolShutdown(ni->vol))
 		return -EIO;
@@ -267,7 +269,20 @@ static int ntfs_writepages(struct address_space *mapping,
 		return -EOPNOTSUPP;
 	}
 
-	return iomap_writepages(&wpc);
+	/*
+	 * Prevent eviction in writeback to avoid deadlock in
+	 * ntfs_drop_big_inode().
+	 */
+	if ((ni->type == AT_DATA || ni->type == AT_INDEX_ALLOCATION) &&
+	    igrab(inode))
+		need_iput = true;
+
+	ret = iomap_writepages(&wpc);
+
+	if (need_iput)
+		iput(inode);
+
+	return ret;
 }
 
 static int ntfs_swap_activate(struct swap_info_struct *sis,
-- 
2.55.0



