Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8389A1773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FC1C433C7;
	Wed,  9 Aug 2023 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579996;
	bh=xYhHPQ3iL6z5/SWssyfOsobUPrjEgRc8UFKqW0taZCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDiYpLBoxaSzMShbKr0hOZnJGlBPbUvVetNM1JEppXX9Gmjne0wztpK8BffyUEFo6
	 GiL+1cBo4ZCVH6ASIJVLHWAjgerw6Aentqassouq8I0TfNCRTQfxeXB17PM4e8VsMZ
	 CqsP8yN+D9t3FfrL60EZMx8toktZ79MtI4iOPxxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Eric Whitney <enwlinux@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 190/323] ext4: correct inline offset when handling xattrs in inode body
Date: Wed,  9 Aug 2023 12:40:28 +0200
Message-ID: <20230809103706.873300213@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Whitney <enwlinux@gmail.com>

commit 6909cf5c4101214f4305a62d582a5b93c7e1eb9a upstream.

When run on a file system where the inline_data feature has been
enabled, xfstests generic/269, generic/270, and generic/476 cause ext4
to emit error messages indicating that inline directory entries are
corrupted.  This occurs because the inline offset used to locate
inline directory entries in the inode body is not updated when an
xattr in that shared region is deleted and the region is shifted in
memory to recover the space it occupied.  If the deleted xattr precedes
the system.data attribute, which points to the inline directory entries,
that attribute will be moved further up in the region.  The inline
offset continues to point to whatever is located in system.data's former
location, with unfortunate effects when used to access directory entries
or (presumably) inline data in the inode body.

Cc: stable@kernel.org
Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20230522181520.1570360-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1767,6 +1767,20 @@ static int ext4_xattr_set_entry(struct e
 		memmove(here, (void *)here + size,
 			(void *)last - (void *)here + sizeof(__u32));
 		memset(last, 0, size);
+
+		/*
+		 * Update i_inline_off - moved ibody region might contain
+		 * system.data attribute.  Handling a failure here won't
+		 * cause other complications for setting an xattr.
+		 */
+		if (!is_block && ext4_has_inline_data(inode)) {
+			ret = ext4_find_inline_data_nolock(inode);
+			if (ret) {
+				ext4_warning_inode(inode,
+					"unable to update i_inline_off");
+				goto out;
+			}
+		}
 	} else if (s->not_found) {
 		/* Insert new name. */
 		size_t size = EXT4_XATTR_LEN(name_len);


