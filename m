Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0739914EC58;
	Tue, 23 Jul 2024 18:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759751; cv=none; b=T3C5UbLh2HtmWu3r13OoV6pFhhsLYJR5AIM8DDJFvf+ycnjlFCx9BiRLr+2Xi0ZWuEmRvM1QX/fyhBA6TeiDc99VU7w2fCdXGZVc7lMpFLKiMuZLYFKXsSQSQK6Lp6g7x+LdA/qcPFW+34EYrM4PqKN6HmFaWHvMeIyH6/rsHBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759751; c=relaxed/simple;
	bh=k5SBSaOukJOZOrhCD/7NaXCwoDAqvJYu8aWCviFQVas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0VIEJzBNHzgcMnDUj83aQehNz+j8fguWmS5EFlqC2VbxCooa6lzCECtQZ88VlnCUPDhBwn2IS5rN4RyuEQSFkMRnW2bd+yP6t/xcUJ/OSrG+GJOv9UUV5+aLsAX1fJMHbzWHMZjtONiuco+RrKR5WQkS1BBH3AFC3FbimdmdFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgAltcKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgAltcKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7022BC4AF09;
	Tue, 23 Jul 2024 18:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759750;
	bh=k5SBSaOukJOZOrhCD/7NaXCwoDAqvJYu8aWCviFQVas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgAltcKSIuZdrfOjcIEnHIeeCETyI+qPOQhjd419LHylsFUgNDEp0ixqKbnHwSKYQ
	 5w00wSMSDWmZRbiiZKIo2c5mya57u+rw4+kQn4ftScVmuX9bjabVEnALcL+psfTFT1
	 8+xNZMOBW0avfwnhlKy0tdIofgXhqPIum3R3I5/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+efde959319469ff8d4d7@syzkaller.appspotmail.com,
	syzbot+01ade747b16e9c8030e0@syzkaller.appspotmail.com
Subject: [PATCH 6.6 115/129] hfsplus: fix uninit-value in copy_name
Date: Tue, 23 Jul 2024 20:24:23 +0200
Message-ID: <20240723180409.233398470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 0570730c16307a72f8241df12363f76600baf57d ]

[syzbot reported]
BUG: KMSAN: uninit-value in sized_strscpy+0xc4/0x160
 sized_strscpy+0xc4/0x160
 copy_name+0x2af/0x320 fs/hfsplus/xattr.c:411
 hfsplus_listxattr+0x11e9/0x1a50 fs/hfsplus/xattr.c:750
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x1f3/0x6b0 fs/xattr.c:840
 path_listxattr fs/xattr.c:864 [inline]
 __do_sys_listxattr fs/xattr.c:876 [inline]
 __se_sys_listxattr fs/xattr.c:873 [inline]
 __x64_sys_listxattr+0x16b/0x2f0 fs/xattr.c:873
 x64_sys_call+0x2ba0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:195
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3877 [inline]
 slab_alloc_node mm/slub.c:3918 [inline]
 kmalloc_trace+0x57b/0xbe0 mm/slub.c:4065
 kmalloc include/linux/slab.h:628 [inline]
 hfsplus_listxattr+0x4cc/0x1a50 fs/hfsplus/xattr.c:699
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x1f3/0x6b0 fs/xattr.c:840
 path_listxattr fs/xattr.c:864 [inline]
 __do_sys_listxattr fs/xattr.c:876 [inline]
 __se_sys_listxattr fs/xattr.c:873 [inline]
 __x64_sys_listxattr+0x16b/0x2f0 fs/xattr.c:873
 x64_sys_call+0x2ba0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:195
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
[Fix]
When allocating memory to strbuf, initialize memory to 0.

Reported-and-tested-by: syzbot+efde959319469ff8d4d7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://lore.kernel.org/r/tencent_8BBB6433BC9E1C1B7B4BDF1BF52574BA8808@qq.com
Reported-and-tested-by: syzbot+01ade747b16e9c8030e0@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 58021e73c00bf..f7f9d0889df34 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -698,7 +698,7 @@ ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
 		return err;
 	}
 
-	strbuf = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN +
+	strbuf = kzalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN +
 			XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
 	if (!strbuf) {
 		res = -ENOMEM;
-- 
2.43.0



