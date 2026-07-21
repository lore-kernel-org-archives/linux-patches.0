Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6D46A5EC;
	Tue, 21 Jul 2026 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648551; cv=none; b=TeQlHg7xOCa1gvE8Ko5tz1XaZYXGwExlNapqkuIrYihHMgNa40hB8Rnx0GGpHOfrRDWNV/iJmwi7ukD/ri7lTQ5JXmjyGV2jft0WuPWLgp5gh/n2QGKaAtnEzS315GGMAn9DVbMB22i3YEcejcWkGpL9nmPz27sMF17yqJ5XMd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648551; c=relaxed/simple;
	bh=mB1g09z201HmsVqxYDylfIE8wBPdLitegnFfyknTSQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxySt/V3xL+thWOe+loFXOR/saoYPPC/T2c2/MNNxK+LNwvnBOJxcvM//Tddlqqb4Bn6Hl70oxbFmdwbvrfhIkvl//sfe839EBBMZriIHx1+rBayZppYfLinvubHdX4AFVPGr1UP0J1z7b6+Z/r1WOrOMjkUlFWDtjYeSGJIfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky6noqpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky6noqpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48261F000E9;
	Tue, 21 Jul 2026 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648550;
	bh=mwo3knpogUhMuY+CiRiwubGJRODI+fCOmm5KXzJHmtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky6noqpnwhZ070uzXCCADpqXqIi3CNSLWpaN4sv86AirnUBVl1fKukWcphighccvp
	 uNRJ2usutaroPkzkaN5h+OCFATY1Fzk6Jarj9caLudfh6A8EigjaDxtyDuU7NGgF5u
	 nsve98TMM/sPYw8BvxpNqT6fsG0ESBKTt9NhYzCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0242/2077] hfs: fix incorrect inode ID assignment in hfs_new_inode()
Date: Tue, 21 Jul 2026 16:58:35 +0200
Message-ID: <20260721152558.384462794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 6592287869bffee91f59363e51de5f971ec2bd9d ]

The xfstests' test-case generic/003 reveals the HFS volume
corruption:

sudo ./check generic/003
FSTYP -- hfs
PLATFORM -- Linux/x86_64 hfsplus-testing-0001 7.0.0-rc1+ #18 SMP PREEMPT_DYNAMIC Fri Mar 13 17:54:19 PDT 2026
MKFS_OPTIONS -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/003 51s ... _check_generic_filesystem: filesystem on /dev/loop51 is inconsistent

sudo fsck.hfs -d /dev/loop51
** /dev/loop51
Using cacheBlockSize=32K cacheTotalBlock=1024 cacheSize=32768K.
Executing fsck_hfs (version 540.1-Linux).
** Checking HFS volume.
The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
** Checking catalog hierarchy.
** Checking volume bitmap.
** Checking volume information.
invalid MDB drNxtCNID
Master Directory Block needs minor repair
(1, 0)
Verify Status: VIStat = 0x8000, ABTStat = 0x0000 EBTStat = 0x0000
CBTStat = 0x0000 CatStat = 0x00000000
** Repairing volume.
** Rechecking volume.
** Checking HFS volume.
The volume name is untitled
** Checking extents overflow file.
** Checking catalog file.
** Checking catalog hierarchy.
** Checking volume bitmap.
** Checking volume information.
** The volume untitled was repaired successfully.

The reason of corruption is incorrect value of drNxtCNID (next
CNID) in the MDB or superblock. The generic/003 test-case
creates several new inodes:

kernel: run fstests generic/003
hfs: hfs_mdb_get():179 next_id 16
hfs: hfs_mdb_get():179 next_id 16
hfs: hfs_new_inode():208 next_id 17
hfs: hfs_new_inode():208 next_id 18
hfs: hfs_mdb_commit():307 next_id 18
hfs: hfs_mdb_get():179 next_id 18
hfs: hfs_new_inode():208 next_id 19
hfs: hfs_new_inode():208 next_id 20
hfs_mdb_commit():307 next_id 20
hfs: hfs_mdb_get():179 next_id 20
hfs: hfs_new_inode():208 next_id 21
hfs: hfs_mdb_commit():307 next_id 21
hfs: hfs_mdb_get():179 next_id 21

The final assigned CNID was 21 but fsck correct it on 22.
It is possible to see that the reason of the issue is
incrementing the next_id value at first and assigning
already incremented value to the inode->i_ino:

struct inode *hfs_new_inode(...)
{
<skipped>

    next_id = atomic64_inc_return(&HFS_SB(sb)->next_id);
<skipped>
    inode->i_ino = (u32)next_id;

<skipped>
}

This patch fixes the issue by assigning the decremented
value to inode->i_ino.

Fixes: a06ec283e125 ("hfs: add logic of correcting a next unused CNID")
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260514195518.354108-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 89b33a9d46d5c0..1cbba734503896 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -204,7 +204,7 @@ struct inode *hfs_new_inode(struct inode *dir, const struct qstr *name, umode_t
 		pr_err("cannot create new inode: next CNID exceeds limit\n");
 		goto out_discard;
 	}
-	inode->i_ino = (u32)next_id;
+	inode->i_ino = (u32)next_id - 1;
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-- 
2.53.0



