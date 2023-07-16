Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C788F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D031EC433C8;
	Sun, 16 Jul 2023 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540888;
	bh=cJqifwuERA06ApiVzWBz2gOclVrm/KcZ8A3XQemGKOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JdaENC3eH4HbJNdVZPTmSO78aI5Cx8EQg1mqas4ES2qkCF+LBu90xN7bsCBm+ZLu
	 /Xx0otoRUVlS+niWNXAWvrteaVA6zbz9W+zWbdER4AYVaVAUPBut6+hPCVBNkdJ86v
	 rJOVOzxccr8vL2KDb4v13cu4H15eD/ueH8BZynJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9fcea5ef6dc4dc72d334@syzkaller.appspotmail.com,
	Zeng Heng <zengheng4@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 496/591] ntfs: Fix panic about slab-out-of-bounds caused by ntfs_listxattr()
Date: Sun, 16 Jul 2023 21:50:35 +0200
Message-ID: <20230716194936.728986567@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index ea582b4fe1d9d..88866bcd1a218 100644
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



