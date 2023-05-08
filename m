Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C870168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F364AC433D2;
	Mon,  8 May 2023 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542751;
	bh=mJBngOkGDYxboBQlyi79GCfB4L2gSFOz7WyVvDY2kbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0dZYCHgf+SH0FSDJtAL7VW8SQRAbkfU9do5QR7QNCUirr2J8hgvNSBbcL63WVla3
	 0GORk93jx625mGuWeF+VfhgLvxRP5a83oE1iejaOUrlK4C3WB24esnHbJRCJWKUD3d
	 ALX9vaMue16CNBqDb5LYqnbp0yFbo16Lkwhj962c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d882d57193079e379309@syzkaller.appspotmail.com,
	ZhangPeng <zhangpeng362@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 537/663] fs/ntfs3: Fix OOB read in indx_insert_into_buffer
Date: Mon,  8 May 2023 11:46:03 +0200
Message-Id: <20230508094446.383752048@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit b8c44949044e5f7f864525fdffe8e95135ce9ce5 ]

Syzbot reported a OOB read bug:

BUG: KASAN: slab-out-of-bounds in indx_insert_into_buffer+0xaa3/0x13b0
fs/ntfs3/index.c:1755
Read of size 17168 at addr ffff8880255e06c0 by task syz-executor308/3630

Call Trace:
 <TASK>
 memmove+0x25/0x60 mm/kasan/shadow.c:54
 indx_insert_into_buffer+0xaa3/0x13b0 fs/ntfs3/index.c:1755
 indx_insert_entry+0x446/0x6b0 fs/ntfs3/index.c:1863
 ntfs_create_inode+0x1d3f/0x35c0 fs/ntfs3/inode.c:1548
 ntfs_create+0x3e/0x60 fs/ntfs3/namei.c:100
 lookup_open fs/namei.c:3413 [inline]

If the member struct INDEX_BUFFER *index of struct indx_node is
incorrect, that is, the value of __le32 used is greater than the value
of __le32 total in struct INDEX_HDR. Therefore, OOB read occurs when
memmove is called in indx_insert_into_buffer().
Fix this by adding a check in hdr_find_e().

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: syzbot+d882d57193079e379309@syzkaller.appspotmail.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 51ab759546403..ae9616becec15 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -725,9 +725,13 @@ static struct NTFS_DE *hdr_find_e(const struct ntfs_index *indx,
 	u32 e_size, e_key_len;
 	u32 end = le32_to_cpu(hdr->used);
 	u32 off = le32_to_cpu(hdr->de_off);
+	u32 total = le32_to_cpu(hdr->total);
 	u16 offs[128];
 
 fill_table:
+	if (end > total)
+		return NULL;
+
 	if (off + sizeof(struct NTFS_DE) > end)
 		return NULL;
 
-- 
2.39.2



