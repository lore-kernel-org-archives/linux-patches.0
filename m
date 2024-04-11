Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4D12EAE5;
	Thu, 11 Apr 2024 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829717; cv=none; b=OIKYedp/CD3SWdaAhrSdfO1XYzJ4o/wZUkwBQN/X9ou0LvlsQqFkDc7yrb/tzHDXA09mgqlfoxg8Ch0bFN8dqEbRCSOJYZiGcKrSq1+nSzzbQeQzYn/kTIv0CM4yKOnbLg9rQT1PZSuLSDpOqfT0bnihAwIGu4e0Ja5/Kt99FnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829717; c=relaxed/simple;
	bh=LKDr26SzuVF6ZPv5PMlvSIxq4hnVh36FUB1uAiJq4CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1AuUeCpPy0vvuWSrc3jSBqvSF0Pad/dzspNdqaDR8ygvRbSww6qcOgjLCWc2AbiTOw+rgW36hMh8CvJK9traF6GnBWyfUICLBdW2jF5NmHDswq0lXQpxnNdidV2ZWeWMtCCFmz2lglu/U4VpQ3jYH3tAqji6G0cn/bGPaT1Y9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dx7eIL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dx7eIL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B7CC433C7;
	Thu, 11 Apr 2024 10:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829717;
	bh=LKDr26SzuVF6ZPv5PMlvSIxq4hnVh36FUB1uAiJq4CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Dx7eIL8a3IpxPWQcKChvd8bv0x1KBBdB9/4r3Q1mABJbNfzkN5lPRJ+3KYYEG0K4
	 zmPNrCeghfY87niA+6EOZk1HLTkuK4sEyib9IZLa5JNLGQc3eBpOE+V4Kf1VuLV4XN
	 ysQwNAzW0fMu+4hDmwzHRJKDiMGe9f3fsUw1D/X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/175] fuse: dont unhash root
Date: Thu, 11 Apr 2024 11:54:25 +0200
Message-ID: <20240411095420.827132716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1c754a02fb06b..aa0a5e3960909 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -706,7 +706,6 @@ static inline u64 get_node_id(struct inode *inode)
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3b51c881baf8c..a67769c357b2d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -324,8 +324,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
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
-- 
2.43.0



