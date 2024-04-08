Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D8762F7;
	Mon,  8 Apr 2024 13:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581483; cv=none; b=g3jvr3lmunVGLhgwXsw2pm9hIb3TuSA68IhbunFRBXKDBS+rlQsVP69zC7R+xWyLpMPhhrfTU732j9CaZxvOErc/86tRx0qTL9/G2h6OvuFVGDvLgmGC43DyUwhLeIfe/QgccbFCFwqyFHNWjwfkNpI6k3fQyk7HHTYVDLOf9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581483; c=relaxed/simple;
	bh=5HmHJt8b2EPSFvcGq3FKShe4V0TOWiBirckMFBkqTTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CG4rfFmq1xiSXPkvUW6rWd0qBpFru29kJR366nVutRIq+ebAIqyXIT+MeQurNLBLfbkuNuUZLma/gknuk2MG5ZFS8QzyfYfXkWhmiPPqgRdyyvb3PzQFLGFQa6MRDWauRaP1scTj6TQeDUWuTgPxUkhh7c6rssknN9adwr2Q08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/lR6cf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/lR6cf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17853C433A6;
	Mon,  8 Apr 2024 13:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581483;
	bh=5HmHJt8b2EPSFvcGq3FKShe4V0TOWiBirckMFBkqTTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/lR6cf8Hsblo9Pg4p1HFWQx1SMU1lPVA246+fFmm0/cTIBsmbMaRwt41lzhBeWxb
	 I6CjGCUbZ9ufmdhW8qIrepFnFCmeA2uN5eupk0guEldKl+euz5UlB0ET98nn0gZP5p
	 Zw53N4+/9ZgH5rAuY5pJF+SalFl90ChTuqC7At9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/690] fuse: dont unhash root
Date: Mon,  8 Apr 2024 14:48:41 +0200
Message-ID: <20240408125401.515452835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4b8f094345e12..55b7ca26fb8ab 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -899,7 +899,6 @@ static inline bool fuse_stale_inode(const struct inode *inode, int generation,
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 97dc24557bf24..62b4143ccf26c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -413,8 +413,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
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



