Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717131F76D1;
	Tue, 21 Jan 2025 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483046; cv=none; b=HnKic3LjQ4+Fy6DYNHYl93qEqbNyu+KTStZwFnUW88YjPPpoyFsnanuFWqxoMajYd0X3iMJt8DVnBB93XctyclLF/dZ399MM4zaEHCL/wXzNKGCDOX8zBGFZWLs129l+vr/5AciIEWQ+lelqeI2uy+j4UutNGsYbpZ9RW6svrvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483046; c=relaxed/simple;
	bh=Z1z8SCfaUeiz0SpZjEe/5nPZS9/pTiXXeXhYoZfVLhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKPWouPrasmw8+80LzQxbNopoc7weAI+yIfXtNLOy4EgLSJHiD4v6mwbfFrsVkyRld1JmYBsBFhYs1aevyHjhjZL8MKgGknZciQjOTCryb1D1RJyJW4PeUtNAAOUetQJ5DEUDYFyx6FkV4OKtzroU7bCEXYsx/7ndPeAICPSJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmBh7PVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmBh7PVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6F2C4CEDF;
	Tue, 21 Jan 2025 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483045;
	bh=Z1z8SCfaUeiz0SpZjEe/5nPZS9/pTiXXeXhYoZfVLhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmBh7PViTGa8qCJ85vHkNlv7qevnF3ABKIlFco+CvPeHJQQq9YxGlEN45UFAGtbrk
	 gzE8NSgiiYmjDIePMRYT6cdtLkN1WbJ30IwJrejfZL0JZAFvBfVvlOfMlgAHsQPcSj
	 cLbfZbpjwh4ig6+8TfWFZnaHeXsUSyfwLcgyesfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/127] hfs: Sanity check the root record
Date: Tue, 21 Jan 2025 18:52:49 +0100
Message-ID: <20250121174533.394513753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12d9bae393631..699dd94b1a864 100644
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



