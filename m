Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3885D2E3701;
	Tue,  8 Jul 2025 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992259; cv=none; b=BKb7Jox3wNuKKlvanq+6wILhnpRgeRVzF+vspY1HfZWkdknbF2vVc9lClflJ0vDyzO98QGWYanRWaq1HdMc+TyafPd5tqTAf3OWZwFDCEB+9CLESKD2APV7ZSnG887zmNslyRRNTcHzY+PEkqFAqaHfwyd0H8AlKvnfl9oxkOls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992259; c=relaxed/simple;
	bh=djvJisH2C6/akxM6Nu7Sg8Ds4DY10CEqzA9eAzNN+6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm7LivnZ1ZbwsJBIdOXz8bnt55Nd7b64yemC2T5gq1CSYZcWJoRpc8/BNCkdCw1VCXLRsv8G7gCJXso7wVi9egcs5sVL6XQk8c5D93TKcGT7SYoBYTDOQSWMiOyauEAddeOBaLV/WBiSQrPkrWRUFBcoOkfP7Dp9DMplsIwYAgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anJ8YudY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anJ8YudY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B701AC4CEED;
	Tue,  8 Jul 2025 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992259;
	bh=djvJisH2C6/akxM6Nu7Sg8Ds4DY10CEqzA9eAzNN+6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anJ8YudY6OiBIVI5Ym7p6upZSTld3nn1sTdGOvSsrB4SYwru4wyyNuhD7mFHR71on
	 SHYhCBngudjbAGJBJz2EoqC6yv/Qdu/Yy/eVlB5snnw9Bsqus1XMxHVvzlDRZZVNEh
	 kFsTDx3uULjjSZB08ICNOhhGZfOfaJgyq+hnq69k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/132] btrfs: fix missing error handling when searching for inode refs during log replay
Date: Tue,  8 Jul 2025 18:22:22 +0200
Message-ID: <20250708162231.618524669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6561a40ceced9082f50c374a22d5966cf9fc5f5c ]

During log replay, at __add_inode_ref(), when we are searching for inode
ref keys we totally ignore if btrfs_search_slot() returns an error. This
may make a log replay succeed when there was an actual error and leave
some metadata inconsistency in a subvolume tree. Fix this by checking if
an error was returned from btrfs_search_slot() and if so, return it to
the caller.

Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cc9a2f8a4ae3b..6dbb62f83f8c8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1087,7 +1087,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	search_key.type = BTRFS_INODE_REF_KEY;
 	search_key.offset = parent_objectid;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
-	if (ret == 0) {
+	if (ret < 0) {
+		return ret;
+	} else if (ret == 0) {
 		struct btrfs_inode_ref *victim_ref;
 		unsigned long ptr;
 		unsigned long ptr_end;
-- 
2.39.5



