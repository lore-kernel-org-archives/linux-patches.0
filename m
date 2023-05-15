Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7286FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF52C433EF;
	Mon, 15 May 2023 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171931;
	bh=3/1ld0hUgRXvuDRzN5DzUKHJO25iBNe2U1tIbFBDt4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGXrcVNsYqFc0jz0FJ8dicS/7KPrdFt+sn50lIK9wLOolTVkbdgmtjkVjLSEM+bX1
	 SL/5ZEBMrKNNsxhnw4+eZXfIBat9GlZgeX+rX1e69froF5SC8znB/05DueFIzhuuCI
	 zosUAVOW7uFgbuvGikRNvDD5Ph211JOQKwPAtfZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+91dccab7c64e2850a4e5@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 125/134] ext4: fix deadlock when converting an inline directory in nojournal mode
Date: Mon, 15 May 2023 18:30:02 +0200
Message-Id: <20230515161707.322000100@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit f4ce24f54d9cca4f09a395f3eecce20d6bec4663 upstream.

In no journal mode, ext4_finish_convert_inline_dir() can self-deadlock
by calling ext4_handle_dirty_dirblock() when it already has taken the
directory lock.  There is a similar self-deadlock in
ext4_incvert_inline_data_nolock() for data files which we'll fix at
the same time.

A simple reproducer demonstrating the problem:

    mke2fs -Fq -t ext2 -O inline_data -b 4k /dev/vdc 64
    mount -t ext4 -o dirsync /dev/vdc /vdc
    cd /vdc
    mkdir file0
    cd file0
    touch file0
    touch file1
    attr -s BurnSpaceInEA -V abcde .
    touch supercalifragilisticexpialidocious

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230507021608.1290720-1-tytso@mit.edu
Reported-by: syzbot+91dccab7c64e2850a4e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=ba84cc80a9491d65416bc7877e1650c87530fe8a
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1185,6 +1185,7 @@ static int ext4_finish_convert_inline_di
 		ext4_initialize_dirent_tail(dir_block,
 					    inode->i_sb->s_blocksize);
 	set_buffer_uptodate(dir_block);
+	unlock_buffer(dir_block);
 	err = ext4_handle_dirty_dirblock(handle, inode, dir_block);
 	if (err)
 		return err;
@@ -1259,6 +1260,7 @@ static int ext4_convert_inline_data_nolo
 	if (!S_ISDIR(inode->i_mode)) {
 		memcpy(data_bh->b_data, buf, inline_size);
 		set_buffer_uptodate(data_bh);
+		unlock_buffer(data_bh);
 		error = ext4_handle_dirty_metadata(handle,
 						   inode, data_bh);
 	} else {
@@ -1266,7 +1268,6 @@ static int ext4_convert_inline_data_nolo
 						       buf, inline_size);
 	}
 
-	unlock_buffer(data_bh);
 out_restore:
 	if (error)
 		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);


