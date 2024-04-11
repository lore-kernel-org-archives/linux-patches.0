Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDE513F452;
	Thu, 11 Apr 2024 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830578; cv=none; b=DTgc6DCBrFdbKzgmjceU6is16r0Ibwf+R5Yp9jq1s1PfXGmCxtvUj/sAczG5z/oghYRvxYkH08mmdU9bmu/KFj6B2OTkJOTm/XYswRToRywV60u8tTVT0JwL1XoHx1LIKBr6GeAyyMsf2hGVn85/aQ1+LGvbhcf72J7UaTyMsWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830578; c=relaxed/simple;
	bh=nqU3y/XMWRMQviOBAfEesyJFS54I6Nqv7e9CBvD7Q5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksAinN3z+GvXruPpnq6nsdPUk7jYWQaSKZ1jrCAFmpe9mUtZuCjaBZ5azPj7UQQZRcm36LdhuvictE9IQbdjoQTiqZci7YQgDHIexCYnKAwpYiEui/+j4+li9Qk0mMGJ+9XF7xFKLpPFDrpZBOwgNx41f0nUixg+4Cl6wUamM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfs6QXxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfs6QXxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36E8C433C7;
	Thu, 11 Apr 2024 10:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830578;
	bh=nqU3y/XMWRMQviOBAfEesyJFS54I6Nqv7e9CBvD7Q5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfs6QXxMVsPpV102NNQrFW/rg7+zEeZwddcqmr4yI0d9p7ickwn2RgpqY0VonJDUl
	 MF2l+Ko0NubSLcMKlu6RBB+t4Jbi9LX1rqeQY3t6jvr+oW538GdQHUoMpRGHwXwvNP
	 dd/P+p8xmN5qvLkkGD5xn4/MtMMEtmtHSZfyt0Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/215] fuse: dont unhash root
Date: Thu, 11 Apr 2024 11:54:16 +0200
Message-ID: <20240411095426.308672590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b7bd2e623c3f3..676bc4a191afb 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -795,7 +795,6 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
 
 static inline void fuse_make_bad(struct inode *inode)
 {
-	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f3d712decb57c..287e850fbd644 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -313,8 +313,11 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
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



