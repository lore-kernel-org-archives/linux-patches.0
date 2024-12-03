Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87B11F8904;
	Tue,  3 Dec 2024 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239995; cv=none; b=QVWSM9ksFYMqR2MWpcZ61vF3IVacIqVUM2vjyBMBcYsEzReKIXhGnL/GjsI0mxidtJmyQSr01sSEsVc2A/pImUnP+2BtiGUdcPaGpFfW4acZNBeXgdfNo9gvAQwnjrTgFLe7VE4Fj0zSUn3b38EfTp8rJ/a1Fu/EJi7XruFWifs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239995; c=relaxed/simple;
	bh=bfQBGnjRHQ6gxeqmP+liWzAQH76Gt3R9gCf71okeNhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5iufyRaa700bprm7lPR/4ihHJ7mzslbEXRblPHEcMNwEyONgOeXP9a6gMr2smRCHfkKM/pGcWbLubqQVALitWRfv2dus+/GoPKDpJ/htsEClnrjOk5M3SJ41AJbY234N7Ow7EMTxENkjeh4MGxPKOch/aKaQCZK5VJRLbzmt/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aSoV81C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aSoV81C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD330C4CECF;
	Tue,  3 Dec 2024 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239995;
	bh=bfQBGnjRHQ6gxeqmP+liWzAQH76Gt3R9gCf71okeNhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aSoV81CZR6hajtNtMaxs6R2qSesbOmmYZAL2G7TtQfryaOEL+yfoW+2yQuIaat+Z
	 I3mojNEB9Jo16O1ZkMHKQGQYP/JZwBWpEfXROXheLn9k/q6DijCOv28+5ldnKXe/dc
	 H1lOV74u/Vf6OOCE8Aj7vFouzpCRD5qj9zLF3XwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 805/817] nfs: ignore SB_RDONLY when mounting nfs
Date: Tue,  3 Dec 2024 15:46:17 +0100
Message-ID: <20241203144027.874385764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 52cb7f8f177878b4f22397b9c4d2c8f743766be3 ]

When exporting only one file system with fsid=0 on the server side, the
client alternately uses the ro/rw mount options to perform the mount
operation, and a new vfsmount is generated each time.

It can be reproduced as follows:
[root@localhost ~]# mount /dev/sda /mnt2
[root@localhost ~]# echo "/mnt2 *(rw,no_root_squash,fsid=0)" >/etc/exports
[root@localhost ~]# systemctl restart nfs-server
[root@localhost ~]# mount -t nfs -o ro,vers=4 127.0.0.1:/ /mnt/sdaa
[root@localhost ~]# mount -t nfs -o rw,vers=4 127.0.0.1:/ /mnt/sdaa
[root@localhost ~]# mount -t nfs -o ro,vers=4 127.0.0.1:/ /mnt/sdaa
[root@localhost ~]# mount -t nfs -o rw,vers=4 127.0.0.1:/ /mnt/sdaa
[root@localhost ~]# mount | grep nfs4
127.0.0.1:/ on /mnt/sdaa type nfs4 (ro,relatime,vers=4.2,rsize=1048576,...
127.0.0.1:/ on /mnt/sdaa type nfs4 (rw,relatime,vers=4.2,rsize=1048576,...
127.0.0.1:/ on /mnt/sdaa type nfs4 (ro,relatime,vers=4.2,rsize=1048576,...
127.0.0.1:/ on /mnt/sdaa type nfs4 (rw,relatime,vers=4.2,rsize=1048576,...
[root@localhost ~]#

We expected that after mounting with the ro option, using the rw option to
mount again would return EBUSY, but the actual situation was not the case.

As shown above, when mounting for the first time, a superblock with the ro
flag will be generated, and at the same time, in do_new_mount_fc -->
do_add_mount, it detects that the superblock corresponding to the current
target directory is inconsistent with the currently generated one
(path->mnt->mnt_sb != newmnt->mnt.mnt_sb), and a new vfsmount will be
generated.

When mounting with the rw option for the second time, since no matching
superblock can be found in the fs_supers list, a new superblock with the
rw flag will be generated again. The superblock in use (ro) is different
from the newly generated superblock (rw), and a new vfsmount will be
generated again.

When mounting with the ro option for the third time, the superblock (ro)
is found in fs_supers, the superblock in use (rw) is different from the
found superblock (ro), and a new vfsmount will be generated again.

We can switch between ro/rw through remount, and only one superblock needs
to be generated, thus avoiding the problem of repeated generation of
vfsmount caused by switching superblocks.

Furthermore, This can also resolve the issue described in the link.

Fixes: 275a5d24bf56 ("NFS: Error when mounting the same filesystem with different options")
Link: https://lore.kernel.org/all/20240604112636.236517-3-lilingfeng@huaweicloud.com/
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 5902a9beca1f3..080af26c14dce 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -11,7 +11,7 @@
 #include <linux/nfs_page.h>
 #include <linux/wait_bit.h>
 
-#define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
+#define NFS_SB_MASK (SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
 
 extern const struct export_operations nfs_export_ops;
 
-- 
2.43.0



