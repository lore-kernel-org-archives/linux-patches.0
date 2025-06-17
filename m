Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9F28E8;
	Tue, 17 Jun 2025 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175857; cv=none; b=n6wNkzkoR2V9b13O046Q9Gc3yBYXNXAocY6pH2aA3pC24DP28/zt39jrew4LvywOSV0Nhpd2/cqtKVXymxxk5JCu4TXy4RxPX7qsbJdS0llOmjSBViHaakvokj97BogswPMM1NBKeW13ifPKlrWyKzWEZYLd8j7RrPhZcxxEdzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175857; c=relaxed/simple;
	bh=0q6TKhevpYccwViA+BeI7S5JdKBo2Z1e1upMkoXaFzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYRCDedYjTwK80X3owKqgUNAW1m+CbmYs39DMLMI72lB4EwLFlOZDfP3CmgBD+hBJ1dOpYzOQBQ4W2kmki0k/4u7fU8CrftXQBdo4ZuoLiXk3omZOAw0tLstCG9syWnIxhddfc8sNviy022FFvcQKHmu6BKJtpi07hzzh5Vq4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olWSVu/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olWSVu/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0B8C4CEE3;
	Tue, 17 Jun 2025 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175856;
	bh=0q6TKhevpYccwViA+BeI7S5JdKBo2Z1e1upMkoXaFzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olWSVu/gbE3yIJBtdIHphMA/leSvX3DeU5BToyMVoqSnyJso+L4fq0oAkt8FRZR36
	 YuklS1iFA3fzMLzMm+HlF24MD4RhD56s48EF55mRhQ3rZO6t/lWzHAwVbY0Macmte3
	 nuyq4Ta8v/jc/Wzg0YOI1xK4UJ714zm3Pvk18a8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/356] nfs: ignore SB_RDONLY when remounting nfs
Date: Tue, 17 Jun 2025 17:25:34 +0200
Message-ID: <20250617152347.017549458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 59bf4b2c0f86e..4e72ee57fc8fc 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1020,6 +1020,16 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



