Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6121ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1008C433CA;
	Fri, 21 Jul 2023 19:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966386;
	bh=Hu9a+FozfHuRNYpoMhn2nX+XoUA3yPpv+35xmXbD5aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb2zqvJlVOyOtcJP7BtMheaSOCuCL9r+QJfNWqbiO7vK5lithWUXTiz24t1hjeWgP
	 RSpcA3tqHVp8xBfZ1ot2vpuc8waYbYGp6+pkL43KsoJrjgehW2l5jXULwEDyoiwNZN
	 XJEUta7M+3SO0QwA8zMZVkiI0OB5IGf/52Kk+EkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com,
	Zeng Heng <zengheng4@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/532] ntfs: Fix panic about slab-out-of-bounds caused by ntfs_listxattr()
Date: Fri, 21 Jul 2023 18:03:50 +0200
Message-ID: <20230721160632.105389573@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 3c675ddffb17a8b1e32efad5c983254af18b12c2 ]

Here is a BUG report from syzbot:

BUG: KASAN: slab-out-of-bounds in ntfs_list_ea fs/ntfs3/xattr.c:191 [inline]
BUG: KASAN: slab-out-of-bounds in ntfs_listxattr+0x401/0x570 fs/ntfs3/xattr.c:710
Read of size 1 at addr ffff888021acaf3d by task syz-executor128/3632

Call Trace:
 ntfs_list_ea fs/ntfs3/xattr.c:191 [inline]
 ntfs_listxattr+0x401/0x570 fs/ntfs3/xattr.c:710
 vfs_listxattr fs/xattr.c:457 [inline]
 listxattr+0x293/0x2d0 fs/xattr.c:804

Fix the logic of ea_all iteration. When the ea->name_len is 0,
return immediately, or Add2Ptr() would visit invalid memory
in the next loop.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Reported-by: syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
[almaz.alexandrovich@paragon-software.com: lines of the patch have changed]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 8847db0159084..63250a5aae0aa 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -178,6 +178,9 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 	for (ret = 0, off = 0; off < size; off += unpacked_ea_size(ea)) {
 		ea = Add2Ptr(ea_all, off);
 
+		if (!ea->name_len)
+			break;
+
 		if (buffer) {
 			if (ret + ea->name_len + 1 > bytes_per_buffer) {
 				err = -ERANGE;
-- 
2.39.2



