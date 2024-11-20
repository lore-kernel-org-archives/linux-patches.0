Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3595F1B5338;
	Wed, 20 Nov 2024 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107620; cv=none; b=f++OR/grNje1I0ohok+2Fpjm5FiMOQLV0oN8t+zyJSNO3ixvpG20WTrQk3eGDdpTnxGJpMrOjoFN0zMNLGxRvNbJyW0HmsVRYEEkpzZLd6BVt1hWgcSoq214yLIq9KMhjOi2YyjPsGpnS60dyERGMNZ07hPKzDMXCd/6H851nnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107620; c=relaxed/simple;
	bh=OPom9EIxDtEiwnP7KMCLsGKI0pcJP3S7mH7NJf7a7os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os667dJ257OHoM4tusN6pHZrfhAkyOl8iyqQenF+pxDbG0F/7tmNVjdAeQfq1OUgFFd2Tjat8yjQkGPXeoIoB8LfLuWtrSFT2qSNrHtcMM4mpvBSOOk2YJKV17c2b77qKxfce6rv6K2CdeMc7i0LuoBDxRRojTCiiiylX81fh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUo1iZ3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUo1iZ3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB42C4CED1;
	Wed, 20 Nov 2024 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107620;
	bh=OPom9EIxDtEiwnP7KMCLsGKI0pcJP3S7mH7NJf7a7os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUo1iZ3po9I2hCxtgPQzC3I+CpQKrU52It8GJ0wSg7S80RbxXa/N/Qhgq4VDi0KW1
	 Fvwlhhzd9kdW0vnAYmy1gbQBJ7e120bsuh88romR0bjFKX/tkojYjwrIfJpgBE+7/H
	 8EJgXzQCz7dK/DVbpQZeiBBPku1FEwz5CSfwklBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	ericvh@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eb83fe1cce5833cd66a0@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 73/82] fs/9p: fix uninitialized values during inode evict
Date: Wed, 20 Nov 2024 13:57:23 +0100
Message-ID: <20241120125631.260352859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 6630036b7c228f57c7893ee0403e92c2db2cd21d ]

If an iget fails due to not being able to retrieve information
from the server then the inode structure is only partially
initialized.  When the inode gets evicted, references to
uninitialized structures (like fscache cookies) were being
made.

This patch checks for a bad_inode before doing anything other
than clearing the inode from the cache.  Since the inode is
bad, it shouldn't have any state associated with it that needs
to be written back (and there really isn't a way to complete
those anyways).

Reported-by: syzbot+eb83fe1cce5833cd66a0@syzkaller.appspotmail.com
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Xiangyu: CVE-2024-36923 Minor conflict resolution ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -374,20 +374,23 @@ void v9fs_evict_inode(struct inode *inod
 	struct v9fs_inode __maybe_unused *v9inode = V9FS_I(inode);
 	__le32 __maybe_unused version;
 
-	truncate_inode_pages_final(&inode->i_data);
+	if (!is_bad_inode(inode)) {
+		truncate_inode_pages_final(&inode->i_data);
 
 #ifdef CONFIG_9P_FSCACHE
-	version = cpu_to_le32(v9inode->qid.version);
-	fscache_clear_inode_writeback(v9fs_inode_cookie(v9inode), inode,
+		version = cpu_to_le32(v9inode->qid.version);
+		fscache_clear_inode_writeback(v9fs_inode_cookie(v9inode), inode,
 				      &version);
 #endif
-
-	clear_inode(inode);
-	filemap_fdatawrite(&inode->i_data);
+		clear_inode(inode);
+		filemap_fdatawrite(&inode->i_data);
 
 #ifdef CONFIG_9P_FSCACHE
-	fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
+		if (v9fs_inode_cookie(v9inode))
+			fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
 #endif
+	} else
+		clear_inode(inode);
 }
 
 static int v9fs_test_inode(struct inode *inode, void *data)


