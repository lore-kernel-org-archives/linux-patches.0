Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFEE15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629A0C433C1;
	Mon,  5 Dec 2022 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267541;
	bh=IujyxWxKrFtKjPTVw/6DEKMPkl1/h2lXQc0CO1TROmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2AqNX7NruoW7X6dIiNVmEDKOIlVn6mIedDTnnt1tlIvRa/Ik0sPZIA97FmLelOZ8
	 f4MJs7WjRmsWgClWqcg/8iFaHoHEI2znAtqUL+c0v6wl0Hp21b8qK7o+3ZLWdbdZhp
	 rujd4ovs8RmsM8jEjx4xYc5WE16Dcuj8Nn5Zo4Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	syzbot+77e4f0...@syzkaller.appspotmail.com,
	Liu Shixin <liushixin2@huawei.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 24/62] nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date: Mon,  5 Dec 2022 20:09:21 +0100
Message-Id: <20221205190759.010603342@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

commit 512c5ca01a3610ab14ff6309db363de51f1c13a6 upstream.

When extending segments, nilfs_sufile_alloc() is called to get an
unassigned segment, then mark it as dirty to avoid accidentally allocating
the same segment in the future.

But for some special cases such as a corrupted image it can be unreliable.
If such corruption of the dirty state of the segment occurs, nilfs2 may
reallocate a segment that is in use and pick the same segment for writing
twice at the same time.

This will cause the problem reported by syzkaller:
https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

This case started with segbuf1.segnum = 3, nextnum = 4 when constructed.
It supposed segment 4 has already been allocated and marked as dirty.

However the dirty state was corrupted and segment 4 usage was not dirty.
For the first time nilfs_segctor_extend_segments() segment 4 was allocated
again, which made segbuf2 and next segbuf3 had same segment 4.

sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is added
to both buffer lists of two segbuf.  It makes the lists broken which
causes NULL pointer dereference.

Fix the problem by setting usage as dirty every time in
nilfs_sufile_mark_dirty(), which is called during constructing current
segment to be written out and before allocating next segment.

[chenzhongjin@huawei.com: add lock protection per Ryusuke]
  Link: https://lkml.kernel.org/r/20221121091141.214703-1-chenzhongjin@huawei.com
Link: https://lkml.kernel.org/r/20221118063304.140187-1-chenzhongjin@huawei.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reported-by: <syzbot+77e4f0...@syzkaller.appspotmail.com>
Reported-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/sufile.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -507,14 +507,22 @@ void nilfs_sufile_do_free(struct inode *
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+		nilfs_segment_usage_set_dirty(su);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
+	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
 


