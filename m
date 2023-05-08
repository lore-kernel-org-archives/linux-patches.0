Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC0C168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEEAC4339B;
	Mon,  8 May 2023 10:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542741;
	bh=mU76oOlq0YKZD6w2eST7BbQppQ3ukQDiTjdiKw+cAlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ6xf0+kvQzg79WeQthpoLkVHvQL09ReIGGe09ehycbe5d1Wjtsn7DNhCh/QnQsSg
	 YQCvwoQn3SDwYp5ZgyT0zbVjpXNHTxQGh7YsQdFaIWGqhgyF02sV61CrLej8iF4Exn
	 DseT9kAD51RhDUx77kTYV3qv9tsRpEt59zcr5C+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 534/663] fs/ntfs3: Fix memory leak if ntfs_read_mft failed
Date: Mon,  8 May 2023 11:46:00 +0200
Message-Id: <20230508094446.252697101@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit bfa434c60157c9793e9b12c9b68ade02aff9f803 ]

Label ATTR_ROOT in ntfs_read_mft() sets is_root = true and
ni->ni_flags |= NI_FLAG_DIR, then next attr will goto label ATTR_ALLOC
and alloc ni->dir.alloc_run. However two states are not always
consistent and can make memory leak.

 1) attr_name in ATTR_ROOT does not fit the condition it will set
 is_root = true but NI_FLAG_DIR is not set.
 2) next attr_name in ATTR_ALLOC fits the condition and alloc
 ni->dir.alloc_run
 3) in cleanup function ni_clear(), when NI_FLAG_DIR is set, it frees
 ni->dir.alloc_run, otherwise it frees ni->file.run
 4) because NI_FLAG_DIR is not set in this case, ni->dir.alloc_run is
 leaked as kmemleak reported:

unreferenced object 0xffff888003bc5480 (size 64):
  backtrace:
    [<000000003d42e6b0>] __kmalloc_node+0x4e/0x1c0
    [<00000000d8e19b8a>] kvmalloc_node+0x39/0x1f0
    [<00000000fc3eb5b8>] run_add_entry+0x18a/0xa40 [ntfs3]
    [<0000000011c9f978>] run_unpack+0x75d/0x8e0 [ntfs3]
    [<00000000e7cf1819>] run_unpack_ex+0xbc/0x500 [ntfs3]
    [<00000000bbf0a43d>] ntfs_iget5+0xb25/0x2dd0 [ntfs3]
    [<00000000a6e50693>] ntfs_fill_super+0x218d/0x3580 [ntfs3]
    [<00000000b9170608>] get_tree_bdev+0x3fb/0x710
    [<000000004833798a>] vfs_get_tree+0x8e/0x280
    [<000000006e20b8e6>] path_mount+0xf3c/0x1930
    [<000000007bf15a5f>] do_mount+0xf3/0x110
    ...

Fix this by always setting is_root and NI_FLAG_DIR together.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 20b953871574b..33494a67bf063 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -259,7 +259,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 			goto out;
 
 		root = Add2Ptr(attr, roff);
-		is_root = true;
 
 		if (attr->name_len != ARRAY_SIZE(I30_NAME) ||
 		    memcmp(attr_name(attr), I30_NAME, sizeof(I30_NAME)))
@@ -272,6 +271,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		if (!is_dir)
 			goto next_attr;
 
+		is_root = true;
 		ni->ni_flags |= NI_FLAG_DIR;
 
 		err = indx_init(&ni->dir, sbi, attr, INDEX_MUTEX_I30);
-- 
2.39.2



