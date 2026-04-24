Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258AA3563D4;
	Fri, 24 Apr 2026 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037968; cv=none; b=nvTI2JxM8myR6gMLp12TDENQ2smG3hBN43V73PgYVEvk85U+stoeB7wOkBMf2TlWWn1GqW93k3TG2+x7W0UfPcO5OA1nWAHfoye4bSZ37AAj0Z60AxWKIRL+7LWpLDc9DMuFT9k4XPxnuCDBPlPHJe0omEltvlZMmNpemdoazlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037968; c=relaxed/simple;
	bh=Q5q2ek22QfVEouU29NOh0Qf/00WCtSqbrqvuDDii2KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wrg7H6u3hxI5juK2ztIJvnDMFSWs1LYpfsXj7XQhrNTr3mBX0qLl5WbeScfAQNac6Szk8mCiNMMRsdpT6koABNlExhN2i0LOF5YOUTbgvVb0wvWiTzme8S5E910yfhPETx+liJFhM9h196MjRCn+DhzthojjytY/ebrGqKMDmEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YISZOU51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YISZOU51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DB1C19425;
	Fri, 24 Apr 2026 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037968;
	bh=Q5q2ek22QfVEouU29NOh0Qf/00WCtSqbrqvuDDii2KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YISZOU51MzbdQGvAoF0lbc4/RFfDJwxdyU3t9g3H7Dz5H/BcrYFAqRVQRt9OE+uqw
	 T8y8smJcb4/P364f5i3MusN8M6GNweGA69FA79Onq8Id76YooXfxx2vUG3hWhgWOCU
	 zm7gFeULFGK2STkbNMf5BnLY2ztsKhOeS1o62Jp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/166] ocfs2: validate inline data i_size during inode read
Date: Fri, 24 Apr 2026 15:30:53 +0200
Message-ID: <20260424132602.103393297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 1524af3685b35feac76662cc551cbc37bd14775f ]

When reading an inode from disk, ocfs2_validate_inode_block() performs
various sanity checks but does not validate the size of inline data.  If
the filesystem is corrupted, an inode's i_size can exceed the actual
inline data capacity (id_count).

This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline data
buffer, triggering a use-after-free when accessing directory entries from
freed memory.

In the syzbot report:
  - i_size was 1099511627576 bytes (~1TB)
  - Actual inline data capacity (id_count) is typically <256 bytes
  - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
  - This triggered a UAF in ocfs2_check_dir_entry()

Fix by adding a validation check in ocfs2_validate_inode_block() to ensure
inodes with inline data have i_size <= id_count.  This catches the
corruption early during inode read and prevents all downstream code from
operating on invalid data.

Link: https://lkml.kernel.org/r/20251212052132.16750-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251211115231.3560028-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212040400.6377-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7bc5da4842be ("ocfs2: fix out-of-bounds write in ocfs2_write_end_inline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1419,12 +1419,25 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
-	    le32_to_cpu(di->i_clusters)) {
-		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
-				 (unsigned long long)bh->b_blocknr,
-				 le32_to_cpu(di->i_clusters));
-		goto bail;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le32_to_cpu(di->i_clusters)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: %u clusters\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le32_to_cpu(di->i_clusters));
+			goto bail;
+		}
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
 	}
 
 	rc = 0;


