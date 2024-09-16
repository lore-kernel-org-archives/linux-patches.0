Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A0E146A79;
	Mon, 16 Sep 2024 12:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488607; cv=none; b=E9+pGqjEHW6CrXV4YiyT3B9ABvXcYNsbcDP6qbYoUDdUbRAZp/hT2LkMvKX6x+IvP3vNbAi1HlfdxN0ML2OVuBTMO6xnL7OYQm+TlfJ2fydDDMOayoRv3HUs7kQdxKwaLPUcOgp1WUoH2ZDTwt+moUC4+VgNewYrqnMPeR7H4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488607; c=relaxed/simple;
	bh=JS6nRDVGiu9r30IqHyzfAoRiyR/UAju3rpfNkyF8Mvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3BWFKlehi5A/KPE8rnItDdCE1FDzR8rGgRQGujJHVAnbE2lxlSWO3CFHW/QMgRWALNYNHNtAwbdh/md5uTGRpl9vBzziJA3xaxT9WggAVpRdloSr3+dn6LRmHl2QCeR0ahnIxgO9rrOpSvAy4ORsI+ua6zXboPt15JmRBHgRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifSp+Ymz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifSp+Ymz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D71C4CEC4;
	Mon, 16 Sep 2024 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488607;
	bh=JS6nRDVGiu9r30IqHyzfAoRiyR/UAju3rpfNkyF8Mvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifSp+YmzpQnkt0EEabLFIOYG7umz+PPbjCZFyhFgWZO5niJRPUamk4V87SG0eaqAK
	 8X5q+aPu5CfN09s/njZWVNhZhOs22xDmdhEZs661xAl0x7Iz4HMiKa9ttfi/mVH0ZP
	 clt5aK+Mfp/Nut8N3B1CDZrZ9Su86Y+2oqBfvOSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/91] btrfs: update target inodes ctime on unlink
Date: Mon, 16 Sep 2024 13:43:59 +0200
Message-ID: <20240916114225.281261888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3bc2ac2f8f0b78a13140fc72022771efe0c9b778 ]

Unlink changes the link count on the target inode. POSIX mandates that
the ctime must also change when this occurs.

According to https://pubs.opengroup.org/onlinepubs/9699919799/functions/unlink.html:

"Upon successful completion, unlink() shall mark for update the last data
 modification and last file status change timestamps of the parent
 directory. Also, if the file's link count is not 0, the last file status
 change timestamp of the file shall be marked for update."

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add link to the opengroup docs ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a42238211887..ee04185d8e0f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4148,6 +4148,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	dir->vfs_inode.i_mtime = inode_set_ctime_current(&dir->vfs_inode);
-- 
2.43.0



