Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D016481D5;
	Mon,  1 Apr 2024 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986804; cv=none; b=Z5YCsTFuSgvQed7YbPb13Xvx/G6BKTZdR5PSwUxHcqKzswXL6DVCpFHx2WCTY2KvHWePY7ey7Et0ZMun2CNxA72arXuDpf/irMDk83/9i/G2salonWi2Sp74UZhl7YzhaStjwYsv6/WwcwSqIa6BAy47llM5RBzLkPIXCDp018o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986804; c=relaxed/simple;
	bh=SVgBKYL1phqtrVI93NXBlaBtjn++6FMCbPo5azlHAvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfBHe1UMXUTArwA8rUfOFbVXU0snNmFOTDZzRU83GqnCCKMS/pA5soR8oiZZdaaJlBc2LUIUpyre7DUWgpyxn9km5jrQKGFzWLvjNPDfdr5HT+doq34HpcapFr/8GJCV8mMgSdLmOIJvflXfUhepD6oijvAd288XcevxGUJ8g5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKVtVLdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKVtVLdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCAEC433F1;
	Mon,  1 Apr 2024 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986804;
	bh=SVgBKYL1phqtrVI93NXBlaBtjn++6FMCbPo5azlHAvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKVtVLdWkGv5+bhJfKyIHI+sr9qJM9vFk4xJR60tO+zVfpMvhkO+cBc+2ka21NtdR
	 iLyRBx5c6wVRdAK1BGzd0hJFVbqJuJX1itXzcnc1K9M9I5AZEuCsXm9Et/UdZ5AixT
	 XOrpkW+kywLwvk8A5RYiwNfI2MTEyaH9clVik9mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 090/399] fuse: dont unhash root
Date: Mon,  1 Apr 2024 17:40:56 +0200
Message-ID: <20240401152551.866779994@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bcbe344888627..20924e799c9f5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -940,7 +940,6 @@ static inline bool fuse_stale_inode(const struct inode *inode, int generation,
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 516ea2979a90f..f73865751c732 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -469,8 +469,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
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



