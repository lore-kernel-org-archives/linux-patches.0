Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5490B1E86C;
	Mon,  1 Apr 2024 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989561; cv=none; b=J9IQmUstgGdaTWWLsWcvxRuB0nA2/DbHgL1PufpIi+NYaIxclpi6u9A+H0rwwRppNEE/GQAwrTPkaRYIovBJuqWt1hKeXqhMn2t0+2h4mG+IbLin4Np7EHnhlI25U4lvWOOAvrQjgygY49xDtcwlWSjq7VCx75+6tBhhnZ+CGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989561; c=relaxed/simple;
	bh=NezcCKqy1TCuCAgPCtNBE1/a/OJRnfesqLUOiqdF5OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYxwdaal4qSNBudT4sYq7zTGYE5QVmI2qfBWDnTWlebv3dZbRZDH8MFwlzG4hVoYHklJI/2APv0h9GQw9xmck8chXkNRb5n1QdwiFwg2qF2wIE0V6YwplnnYa2+iC196hHaa1FNjQl29dP09bsd6z93hx8U6pgDEXGX6aCJM27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10EyTt7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10EyTt7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94FCC433C7;
	Mon,  1 Apr 2024 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989561;
	bh=NezcCKqy1TCuCAgPCtNBE1/a/OJRnfesqLUOiqdF5OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10EyTt7fxTc0LLTN+/QjvuRzmUEWJd5YbNcCuAq9Zb0dFCQ9f+4l3q3XLkZ6gm0CN
	 9LpVpihzfW9ackqSm5bMsmcvReCwR7CUoF/HnOgO970IxXEInv86kIXelBceVjIFyc
	 t7TPxjv3zUeIRsFVrthEJ2AZzs6+yri6TO1IFMx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/396] fuse: dont unhash root
Date: Mon,  1 Apr 2024 17:42:13 +0200
Message-ID: <20240401152550.421911372@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
index 9377c46f14c4a..3e65cdc946316 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -939,7 +939,6 @@ static inline bool fuse_stale_inode(const struct inode *inode, int generation,
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 59743813563e5..23ab31b967a13 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -472,8 +472,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
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



