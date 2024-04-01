Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFAE47F6F;
	Mon,  1 Apr 2024 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988113; cv=none; b=c8mU5JzCoCVAGKVgzVj6Jf+7h86/GuWnmQ5kofh9+QAak3B3ZiZFtPJ7sfUFRO3vQJ3v/VP2sHa+xHl85TTFu/tiCBfEive5uchSdsM40RnkF2JGJFAIoD/asqxSB6AWlT4IoNIWCgfnDMB2rFUiQiuwcbY7Jx6C1uia3B+hzkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988113; c=relaxed/simple;
	bh=UlwYq1W1thgK0LbJ5FQqrnUUEVpL0z9203XdCT6KZ5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5QpCMQRfjHsynJupSHmcgbp3x/RC9RjydhvjJpviD4xiqMO/vtN3i+4BD3nuV34ohRh0FMFbzAEVNkk0iyTIdwV/aQD8H33/X7viQKrg65FmdQcgon/8cMckDA3hdkbcLZZtnehm8W1c7TL4wkCS4tC3ePoD63e+zwj3nlPl2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LliCYBZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LliCYBZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62E1C433F1;
	Mon,  1 Apr 2024 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988112;
	bh=UlwYq1W1thgK0LbJ5FQqrnUUEVpL0z9203XdCT6KZ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LliCYBZW3bIbilZuZPMLGNlq7BXbpSMfPnjZ2KoGr1dm2uGeh0tUxLvsJix61gbsx
	 fIExzeFV0gUNDA5W2EVjGr8hB32zRUiaFDPA9Oiig0azabtI4YobqJc6q9l5NCfipc
	 uXiqyfPll5XZnr9KxJZCP3xArAnGm+nq7WgvROA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 088/432] fuse: dont unhash root
Date: Mon,  1 Apr 2024 17:41:15 +0200
Message-ID: <20240401152555.750205841@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1df83eebda927..b5c241e16964d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -939,7 +939,6 @@ static inline bool fuse_stale_inode(const struct inode *inode, int generation,
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2a6d44f91729b..b676c72c62adf 100644
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



