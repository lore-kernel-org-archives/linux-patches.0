Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ED8FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA4C433D2;
	Mon, 15 May 2023 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169989;
	bh=Kra88e1xBRKhOzdO16W7/YyxQdwURgp/5mQpythfczo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6qGr+Y4BB/U06++fByVJN5hAC2OaJhrXmMucTUGmGrrNXzvWi99tyrAfLBzGfmL9
	 JKUj0PrX+kZmC91YSKvHFlXs4gvuKGr0FyvFG5pR1rsPTYcPWCxT4zHS+dBoiHnlSV
	 aoJ2UnhZAvAFvdxuHL+2UgD1m+xnbWw8n772Dvww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1966db24521e5f6e23f7@syzkaller.appspotmail.com,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.3 235/246] ext4: add bounds checking in get_max_inline_xattr_value_size()
Date: Mon, 15 May 2023 18:27:27 +0200
Message-Id: <20230515161729.688367348@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

commit 2220eaf90992c11d888fe771055d4de330385f01 upstream.

Normally the extended attributes in the inode body would have been
checked when the inode is first opened, but if someone is writing to
the block device while the file system is mounted, it's possible for
the inode table to get corrupted.  Add bounds checking to avoid
reading beyond the end of allocated memory if this happens.

Reported-by: syzbot+1966db24521e5f6e23f7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1966db24521e5f6e23f7
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -34,6 +34,7 @@ static int get_max_inline_xattr_value_si
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry;
 	struct ext4_inode *raw_inode;
+	void *end;
 	int free, min_offs;
 
 	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
@@ -57,14 +58,23 @@ static int get_max_inline_xattr_value_si
 	raw_inode = ext4_raw_inode(iloc);
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
+	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 
 	/* Compute min_offs. */
-	for (; !IS_LAST_ENTRY(entry); entry = EXT4_XATTR_NEXT(entry)) {
+	while (!IS_LAST_ENTRY(entry)) {
+		void *next = EXT4_XATTR_NEXT(entry);
+
+		if (next >= end) {
+			EXT4_ERROR_INODE(inode,
+					 "corrupt xattr in inline inode");
+			return 0;
+		}
 		if (!entry->e_value_inum && entry->e_value_size) {
 			size_t offs = le16_to_cpu(entry->e_value_offs);
 			if (offs < min_offs)
 				min_offs = offs;
 		}
+		entry = next;
 	}
 	free = min_offs -
 		((void *)entry - (void *)IFIRST(header)) - sizeof(__u32);


