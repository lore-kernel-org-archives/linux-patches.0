Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCFD3BE155;
	Tue, 21 Jul 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648269; cv=none; b=u0O2N5+Avxx+irP8c9Kc9ajQ+Yw9RN7yPwfBC52LJhEJ4UvTXJqAf/YxVi/Jp0mnOYPB2O1NDdN16WayyPaewS0tWzsmlpGH8EaLGom3D4dE9nxAFECT3tOKaxKrKH/FfamRnIXww/gYJ6Qo1Qy7hEMrWCxamR2cVqcf6Ik5f+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648269; c=relaxed/simple;
	bh=eykXP2aP1Qnp5K8ft73aFFbt5Cmgz7dO6Tu2eBGWSao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIu5MyGjEg4BbAerBGOYDxucWY6WHc90bD3Je7hTcJ+lYCzgaFvWyLRAhRynUQCKS4cpuV/qDTL/QC64h/L3eYmK8wfscJQWEvDRmzc1yIHAdDo3pqkkrXvXG6dsErEZk7JkEqjWRZ7B8adtpkqLbuOlNNRYRsO2j3miCco/7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1XYZEOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1XYZEOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508261F000E9;
	Tue, 21 Jul 2026 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648264;
	bh=yLF1xIIWpE+OsV5HjpQEfgQMq8P7vsQddKn25U2C1Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1XYZEOO8rjtgHLfUGaXpQVthkXIUiedeGkEt1CxLOQ33+DQfCyiHr8p1iMIRCgUZ
	 siLfHy3jhUz9/ZS1Fr/jn7eZxutQtbxcgnMjNw2ZSPgJJy++dbmCmJNditw2ad0ina
	 YoYVv3trL0qtwmM6NWqtHKB+cr5NvV9Fqy2CQ0v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc70a12e438dadba4fb4@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0091/2077] hfsplus: Remove the duplicate attr inode dirty marking action
Date: Tue, 21 Jul 2026 16:56:04 +0200
Message-ID: <20260721152554.839424937@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 7a41fd2b32e5908f19a68732008d581c167279dd ]

Syzbot reported a null-ptr-deref in [1].
If the attributes file is not loaded during system mount, a trigger
occurs [1] when setxattr is executed in userspace.

Remove the first mark attr inode dirty operation.

[1]
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
Call Trace:
 hfsplus_setxattr+0x124/0x340 fs/hfsplus/xattr.c:555
 hfsplus_trusted_setxattr+0x40/0x60 fs/hfsplus/xattr_trusted.c:30
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:252
 vfs_setxattr+0x163/0x360 fs/xattr.c:339
 do_setxattr fs/xattr.c:654 [inline]

Reported-by: syzbot+bc70a12e438dadba4fb4@syzkaller.appspotmail.com
Fixes: ee8422d00b7c ("hfsplus: fix potential Allocation File corruption after fsync")
Closes: https://syzkaller.appspot.com/bug?extid=bc70a12e438dadba4fb4
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/tencent_A8D47429765566CC3C8B378496D036664A09@qq.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/xattr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 452a1f9becb2d1..21a1c196c71f2e 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -317,7 +317,6 @@ static int hfsplus_create_attributes_file(struct super_block *sb)
 		next_node++;
 	}
 
-	hfsplus_mark_inode_dirty(HFSPLUS_ATTR_TREE_I(sb), HFSPLUS_I_ATTR_DIRTY);
 	hfsplus_mark_inode_dirty(attr_file, HFSPLUS_I_ATTR_DIRTY);
 
 	sbi->attr_tree = hfs_btree_open(sb, HFSPLUS_ATTR_CNID);
-- 
2.53.0



