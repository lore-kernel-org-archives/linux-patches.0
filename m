Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E413A155A26;
	Tue,  9 Jul 2024 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523734; cv=none; b=DodhlQHnV6+r1UP4FoW0Zx/VmQiklX75va1//VWlIN04OxGep3uTG8/4uDMXu105g5cdi11sMVqYJrwGdAWH8GLzfRd9dh+zQnBt9Xka6a9Uxtf0F3trbWTTyq88Z+rBAPxr7LiFEi+ldiOPbDZYcD6ZuJ4L6+9kd/nTX/mxAko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523734; c=relaxed/simple;
	bh=5GTwNyO22b1l5cUx5eBXcixgjT/YzgHmQWuaLTsU0LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frry2JtYnd+cUf083QEPDE8BXd2UDv/9YFVBv6VofNx5cnoFff8JIxTmJ9KIW/fRmgK5BPheoKD1tyuIm9+V80YX6TiLNsmH4Qa8E63EM0cZv8Z+rtxargf/K92+mYZ+r6dR2auF5+Lrf2jLDz1pVb6HkXZonE8mRmVS2jmM+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0oNEpku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0oNEpku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA2AC3277B;
	Tue,  9 Jul 2024 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523733;
	bh=5GTwNyO22b1l5cUx5eBXcixgjT/YzgHmQWuaLTsU0LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0oNEpkuj/eSGp2P1h1B52J9NBFzXouEkC8FLU00t/85FPd3AZlr1JHiqHsPHEiGb
	 E2vKw2QpIyHY1HApX5zE4I9RKrOJoT2O2qPzVruE02vF3RqrpdcHnietPMN5HTp9KC
	 fnAuisKKjYXRa9OzdIamiaCVWIVEWJVYrEtR5I4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+d79afb004be235636ee8@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Hillf Danton <hdanton@sina.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 091/139] nilfs2: add missing check for inode numbers on directory entries
Date: Tue,  9 Jul 2024 13:09:51 +0200
Message-ID: <20240709110701.698944450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit bb76c6c274683c8570ad788f79d4b875bde0e458 upstream.

Syzbot reported that mounting and unmounting a specific pattern of
corrupted nilfs2 filesystem images causes a use-after-free of metadata
file inodes, which triggers a kernel bug in lru_add_fn().

As Jan Kara pointed out, this is because the link count of a metadata file
gets corrupted to 0, and nilfs_evict_inode(), which is called from iput(),
tries to delete that inode (ifile inode in this case).

The inconsistency occurs because directories containing the inode numbers
of these metadata files that should not be visible in the namespace are
read without checking.

Fix this issue by treating the inode numbers of these internal files as
errors in the sanity check helper when reading directory folios/pages.

Also thanks to Hillf Danton and Matthew Wilcox for their initial mm-layer
analysis.

Link: https://lkml.kernel.org/r/20240623051135.4180-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d79afb004be235636ee8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d79afb004be235636ee8
Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lkml.kernel.org/r/20240617075758.wewhukbrjod5fp5o@quack3
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c   |    6 ++++++
 fs/nilfs2/nilfs.h |    5 +++++
 2 files changed, 11 insertions(+)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -143,6 +143,9 @@ static bool nilfs_check_page(struct page
 			goto Enamelen;
 		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
 			goto Espan;
+		if (unlikely(p->inode &&
+			     NILFS_PRIVATE_INODE(le64_to_cpu(p->inode))))
+			goto Einumber;
 	}
 	if (offs != limit)
 		goto Eend;
@@ -168,6 +171,9 @@ Enamelen:
 	goto bad_entry;
 Espan:
 	error = "directory entry across blocks";
+	goto bad_entry;
+Einumber:
+	error = "disallowed inode number";
 bad_entry:
 	nilfs_error(sb,
 		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -121,6 +121,11 @@ enum {
 	((ino) >= NILFS_FIRST_INO(sb) ||				\
 	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS & BIT(ino))))
 
+#define NILFS_PRIVATE_INODE(ino) ({					\
+	ino_t __ino = (ino);						\
+	((__ino) < NILFS_USER_INO && (__ino) != NILFS_ROOT_INO &&	\
+	 (__ino) != NILFS_SKETCH_INO); })
+
 /**
  * struct nilfs_transaction_info: context information for synchronization
  * @ti_magic: Magic number


