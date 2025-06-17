Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B196A2ECEBF;
	Tue, 17 Jun 2025 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177145; cv=none; b=B4zW0YWb0IrY22BeE6IoltcheJ4tQD2voKxV0xjRjoCMepoAXGZ6PffJYTX/4gFh1m+Xuhplz4UQOTVYmQLTgJvUTG/v2fg/nAZVd4lKNHc/ua66I3ABC71DMOjtTjPzoCqDoTnkHXp6t4MqPCD0E8x1M0Ed1qKVKYh9U5BED/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177145; c=relaxed/simple;
	bh=Ek/cC7uPKWdJC5XpiSyY4TgISbpoH+pf7rG8SK7Z5Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq3v+VOMe6+8RYIvJonrWYtBGBe0kt4yV3Vdd6lCORJZMj/jmRkBO1jdp241h65PO5eMAtWHqtGy32S2l+v767yA1sYcIQXZ/62kfibGT9SDYE8XItAaNf/9P7mVDFNfQHFAQYskBHfnPat+PUPXOspz0I8wpNyj8SKO6F6z6lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lomWxWxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lomWxWxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E7BC4CEE3;
	Tue, 17 Jun 2025 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177145;
	bh=Ek/cC7uPKWdJC5XpiSyY4TgISbpoH+pf7rG8SK7Z5Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lomWxWxPUIz+/1imgQNRExox8IKO9IEJZKxb0z+goUAyngdJJXj/fHLk8x/Xiv5wr
	 i1m97BxPy0TGcc+2kbD+VrohTWXQ56bdgNwKFgzA2jOPIOZeiEq4qSnatnoW23ILyy
	 /U7ydqeGBo0q9wgZrzbEGh1ryX28oIeAt8YzU0R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/512] nfs: ignore SB_RDONLY when remounting nfs
Date: Tue, 17 Jun 2025 17:24:27 +0200
Message-ID: <20250617152431.792393831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44e5cb00e2ccf..da5286514d8c7 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1046,6 +1046,16 @@ int nfs_reconfigure(struct fs_context *fc)
 
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



