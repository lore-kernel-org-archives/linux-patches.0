Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B7BA3F;
	Mon,  1 Apr 2024 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990792; cv=none; b=QlqF8qcaLnoPbk4oY2LWPoEyTqgT4zraX0C6aLsvOpzzey6K10wr8nHis66SmTH9zmSMJsc1MzqyxKfHiQE5EZw9ns5LWqPZQKItjrAYl2/MGI/eY7bEL1oBNoMBeHlLVpNT9epGgwnfMkf7+THDl2RokPmSJchec8Cned2U70Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990792; c=relaxed/simple;
	bh=cTCoFfwk3PwJ5fhDBB7LTYpp/sXGfZUy/ULUbIfCX98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0AsY9Fla2bAZfY1IKEg4uPvd/Jqn070RCPqcIYV9FQ/9QxFtWSVPO05L7e8tPzTD7qpE7uKW+yR7Q97kNrUXwh7je4XfMhSbEUpQQeIgoc1LFbkqHuCJb27hdWIC/nTEdVZvOXX1Qe0s3jTJaF01cdwwrT/p3F+5+R77Xqofhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFTtWmgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFTtWmgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A20C433C7;
	Mon,  1 Apr 2024 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990792;
	bh=cTCoFfwk3PwJ5fhDBB7LTYpp/sXGfZUy/ULUbIfCX98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFTtWmgZ6Iz7bWRkVWRl0H3RSQlq31wbdGZiNODzAMbxOCaXZMIJ0aZWDzCU1UEGr
	 2T+8waHTu66EohVB4jVamTQmObXmQjbkfUMTMRh9g7E/9iyYvcsZHtNoyhvetgNu8X
	 aFCGVPog+L0B5KzXUvEzWWLFj0+voGw81zYvZAVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/272] fuse: dont unhash root
Date: Mon,  1 Apr 2024 17:44:18 +0200
Message-ID: <20240401152532.687669777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit b1fe686a765e6c0d71811d825b5a1585a202b777 ]

The root inode is assumed to be always hashed.  Do not unhash the root
inode even if it is marked BAD.

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Cc: <stable@vger.kernel.org> # v5.11
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/fuse_i.h | 1 -
 fs/fuse/inode.c  | 7 +++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a9681fecbd91f..253b9b78d6f13 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -923,7 +923,6 @@ static inline bool fuse_stale_inode(const struct inode *inode, int generation,
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f81000d968875..367e3b276092f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -445,8 +445,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	} else if (fuse_stale_inode(inode, generation, attr)) {
 		/* nodeid was reused, any I/O on the old inode should fail */
 		fuse_make_bad(inode);
-		iput(inode);
-		goto retry;
+		if (inode != d_inode(sb->s_root)) {
+			remove_inode_hash(inode);
+			iput(inode);
+			goto retry;
+		}
 	}
 	fi = get_fuse_inode(inode);
 	spin_lock(&fi->lock);
-- 
2.43.0



