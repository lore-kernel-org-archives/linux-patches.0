Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B834CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2C2C433EF;
	Wed,  7 Jun 2023 20:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169203;
	bh=OpFoQomk0Xd+FdnFhiTvGzDQOZ0c5ekgtsgOCzVkqQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TciwnuGyI4plaXCwPuM3PZLHW/QbiP7wLhpQY98WGl2xsfzplqwGw50dGqU1b0eaa
	 HnDLzpmMo+aagk4La2zARW6LHaaDe7UF4isdeftg7g/vzIP6CMOTK+7TDKoPy5ygvd
	 Ag7gV5lSEpYe7t4uPmp0P+xMXjkOZMyOJ9RlxmgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+298c5d8fb4a128bc27b0@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 53/61] ext4: add lockdep annotations for i_data_sem for ea_inodes
Date: Wed,  7 Jun 2023 22:16:07 +0200
Message-ID: <20230607200853.470801877@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
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

commit aff3bea95388299eec63440389b4545c8041b357 upstream.

Treat i_data_sem for ea_inodes as being in their own lockdep class to
avoid lockdep complaints about ext4_setattr's use of inode_lock() on
normal inodes potentially causing lock ordering with i_data_sem on
ea_inodes in ext4_xattr_inode_write().  However, ea_inodes will be
operated on by ext4_setattr(), so this isn't a problem.

Cc: stable@kernel.org
Link: https://syzkaller.appspot.com/bug?extid=298c5d8fb4a128bc27b0
Reported-by: syzbot+298c5d8fb4a128bc27b0@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230524034951.779531-5-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/xattr.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -947,11 +947,13 @@ do {									       \
  *			  where the second inode has larger inode number
  *			  than the first
  *  I_DATA_SEM_QUOTA  - Used for quota inodes only
+ *  I_DATA_SEM_EA     - Used for ea_inodes only
  */
 enum {
 	I_DATA_SEM_NORMAL = 0,
 	I_DATA_SEM_OTHER,
 	I_DATA_SEM_QUOTA,
+	I_DATA_SEM_EA
 };
 
 
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -120,7 +120,11 @@ ext4_expand_inode_array(struct ext4_xatt
 #ifdef CONFIG_LOCKDEP
 void ext4_xattr_inode_set_class(struct inode *ea_inode)
 {
+	struct ext4_inode_info *ei = EXT4_I(ea_inode);
+
 	lockdep_set_subclass(&ea_inode->i_rwsem, 1);
+	(void) ei;	/* shut up clang warning if !CONFIG_LOCKDEP */
+	lockdep_set_subclass(&ei->i_data_sem, I_DATA_SEM_EA);
 }
 #endif
 


