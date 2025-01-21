Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F971F8930;
	Tue, 21 Jan 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482166; cv=none; b=aBDsP3OPmcdlWfghS9QDAQvNimDxbDPvQO7uGPNKGU0QNd/tM7xOlRwar6dug/lBKKJzAzQQbbAXjR7+Ed6RD9k+ToOU/v3A2R7m4FQhQ4RKf9ppGBHNTI1BfPyjFb+x35FYshwzNnlwSz+al3zfGTuQ7G8XaiwNPHe5XifUc2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482166; c=relaxed/simple;
	bh=mpZE5zY5dg8qJh4Gu9+QZknDfDbxb3qSCHcGJTe1RAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0LMmR+W8DCNWJ3MKn//a8AyrewTql6puUeEZOv0PDyT+lFeR84XS+JIN3P7pZw4+xoWCCSHHKMXkxCapibK21shp8yEqz7KG3A4HaCbIVQK/0CXE1M5h0+4cSYuEzkMi0Zl1c9oiJg18pkafVQJ8VzHBKZiRDResSjCmWuSYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=om46LfQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om46LfQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD7FC4CEE1;
	Tue, 21 Jan 2025 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482166;
	bh=mpZE5zY5dg8qJh4Gu9+QZknDfDbxb3qSCHcGJTe1RAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om46LfQBrE7FYm4H9xg9cazwyuwZTsZiTtCimKNO+xU9fkPc9177zQCvERRkVnMb8
	 y1RDFIo+p7fX7kdA1SWdjk7d/DGdYm1RUywoefl8pkUX1BkgfeguzMDvZa70MIcJU7
	 d0dSXhMl/YCSEJOiSdKLw67lnQ/9vxyQCLPBHlhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/72] hfs: Sanity check the root record
Date: Tue, 21 Jan 2025 18:51:52 +0100
Message-ID: <20250121174524.432845384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit b905bafdea21a75d75a96855edd9e0b6051eee30 ]

In the syzbot reproducer, the hfs_cat_rec for the root dir has type
HFS_CDR_FIL after being read with hfs_bnode_read() in hfs_super_fill().
This indicates it should be used as an hfs_cat_file, which is 102 bytes.
Only the first 70 bytes of that struct are initialized, however,
because the entrylength passed into hfs_bnode_read() is still the length of
a directory record. This causes uninitialized values to be used later on,
when the hfs_cat_rec union is treated as the larger hfs_cat_file struct.

Add a check to make sure the retrieved record has the correct type
for the root directory (HFS_CDR_DIR), and make sure we load the correct
number of bytes for a directory record.

Reported-by: syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2db3c7526ba68f4ea776
Tested-by: syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com
Tested-by: Leo Stone <leocstone@gmail.com>
Signed-off-by: Leo Stone <leocstone@gmail.com>
Link: https://lore.kernel.org/r/20241201051420.77858-1-leocstone@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 6764afa98a6ff..431bdc65f7231 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -418,11 +418,13 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto bail_no_root;
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
 	if (!res) {
-		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
+		if (fd.entrylength != sizeof(rec.dir)) {
 			res =  -EIO;
 			goto bail_hfs_find;
 		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
+		if (rec.type != HFS_CDR_DIR)
+			res = -EIO;
 	}
 	if (res)
 		goto bail_hfs_find;
-- 
2.39.5



