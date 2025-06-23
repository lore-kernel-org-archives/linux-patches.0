Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89391ACEDA;
	Mon, 23 Jun 2025 21:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713828; cv=none; b=OyTSGVOJmYmwi58Je06uwTJy+UE+AndpVnNfHbKafcKS12oNzgsk9uAlf8ZPEZAE5DsxzIqgJhgELB+injpvt9+KAsoAW/jnmurbu9Nmi9cvq/z9rHc+yqia1CkNx4GL15BkNPxjnx84UiQqSBCIiGzTNFGUCaI7zx3ZQkIN99s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713828; c=relaxed/simple;
	bh=7rcjZ0z6wC9+XIiup5BoAsYw2sIBF8YwYvd6yDikqj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAzuYVzhfqPuYXZqrsez1slDEn1T6yZJ7bsGCGsW5zhU/0M+E977OWRpBdO3JKHbMwV1ZZl2TTtd4ZewTJ0M2ltWvUVeuRt9LEIAvAJKDaRD5pZQ7d2ElRueZMka2d21CPwW3QoG/N72Sv7f9HA+L2/FFwOUDswinuCe7J3zhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeWtC+rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeWtC+rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80385C4CEEA;
	Mon, 23 Jun 2025 21:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713827;
	bh=7rcjZ0z6wC9+XIiup5BoAsYw2sIBF8YwYvd6yDikqj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeWtC+rZJl8dhLNAGmBF2wEDUR2Ad46A/4HXqNqjxLDuElPuot7wTyJRiuAtJa11S
	 o+3KgNqD//UJRYlFlKm/S1+tLAQsS7mKfIftpkP5leLe7nNCPF+ZPqz0c/RZP4GZaG
	 /o8IBYPYxb4JrbFa2erDx5jGLv0N6xtkKTTjSQec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/508] nfs: ignore SB_RDONLY when remounting nfs
Date: Mon, 23 Jun 2025 15:03:14 +0200
Message-ID: <20250623130648.948756742@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 80c4de6ab44c14e910117a02f2f8241ffc6ec54a ]

In some scenarios, when mounting NFS, more than one superblock may be
created. The final superblock used is the last one created, but only the
first superblock carries the ro flag passed from user space. If a ro flag
is added to the superblock via remount, it will trigger the issue
described in Link[1].

Link[2] attempted to address this by marking the superblock as ro during
the initial mount. However, this introduced a new problem in scenarios
where multiple mount points share the same superblock:
[root@a ~]# mount /dev/sdb /mnt/sdb
[root@a ~]# echo "/mnt/sdb *(rw,no_root_squash)" > /etc/exports
[root@a ~]# echo "/mnt/sdb/test_dir2 *(ro,no_root_squash)" >> /etc/exports
[root@a ~]# systemctl restart nfs-server
[root@a ~]# mount -t nfs -o rw 127.0.0.1:/mnt/sdb/test_dir1 /mnt/test_mp1
[root@a ~]# mount | grep nfs4
127.0.0.1:/mnt/sdb/test_dir1 on /mnt/test_mp1 type nfs4 (rw,relatime,...
[root@a ~]# mount -t nfs -o ro 127.0.0.1:/mnt/sdb/test_dir2 /mnt/test_mp2
[root@a ~]# mount | grep nfs4
127.0.0.1:/mnt/sdb/test_dir1 on /mnt/test_mp1 type nfs4 (ro,relatime,...
127.0.0.1:/mnt/sdb/test_dir2 on /mnt/test_mp2 type nfs4 (ro,relatime,...
[root@a ~]#

When mounting the second NFS, the shared superblock is marked as ro,
causing the previous NFS mount to become read-only.

To resolve both issues, the ro flag is no longer applied to the superblock
during remount. Instead, the ro flag on the mount is used to control
whether the mount point is read-only.

Fixes: 281cad46b34d ("NFS: Create a submount rpc_op")
Link[1]: https://lore.kernel.org/all/20240604112636.236517-3-lilingfeng@huaweicloud.com/
Link[2]: https://lore.kernel.org/all/20241130035818.1459775-1-lilingfeng3@huawei.com/
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a4679cd75f70a..2dca011da034e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1017,6 +1017,16 @@ int nfs_reconfigure(struct fs_context *fc)
 
 	sync_filesystem(sb);
 
+	/*
+	 * The SB_RDONLY flag has been removed from the superblock during
+	 * mounts to prevent interference between different filesystems.
+	 * Similarly, it is also necessary to ignore the SB_RDONLY flag
+	 * during reconfiguration; otherwise, it may also result in the
+	 * creation of redundant superblocks when mounting a directory with
+	 * different rw and ro flags multiple times.
+	 */
+	fc->sb_flags_mask &= ~SB_RDONLY;
+
 	/*
 	 * Userspace mount programs that send binary options generally send
 	 * them populated with default values. We have no way to know which
-- 
2.39.5



