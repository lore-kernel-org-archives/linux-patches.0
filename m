Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0064233262B;
	Mon, 20 Apr 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700502; cv=none; b=byD+fcPumJ7BGuLU0yJLZ6YWPQ4whSbjy4FNSg8Ljwv7R+eX/bhbir2rRCtT5ZNjD3/Ws7i5Dl5soIP94/GTIZRwkISBjqE+BjS45ZKG6JtYsuWdRKKLOLNjy35w4sbHQDRkSV2HXQIFFryauE3OyaEkmKqO4ZBLiVujPqWgeRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700502; c=relaxed/simple;
	bh=J2Wfr8GEHkXgh4DsXlLz+Gffyopc0toprSZoyDZbkHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGb55ufxzUG8FAsmZcPW3Ml7lUcOTcqtOgY+fMg8M25oEB4gsRxLO8hDo3w2jCJuiCZRz04m5OiLTYz1tHNCpqpOZ3X2GHQqFAvZEIk0+9J0FROv0AVjlsPgjd1K23tczP1+2Fp3EMmm6KBDdYoJCWsGoKQ2eUPkC/J8ULykb9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgehlRWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgehlRWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA2C19425;
	Mon, 20 Apr 2026 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700501;
	bh=J2Wfr8GEHkXgh4DsXlLz+Gffyopc0toprSZoyDZbkHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgehlRWtHvqOvvxNRK0ju2i7k05X4sEL1R11zzZ8TgcDZgAoHSP0t1T1a2VBUIGNG
	 FxE3n5asW1YQREpK4V12N9hDKXZOisLlz0UZ7G62hpLxEHQ+g6zg/sYpGEBPc94tNA
	 a/iVarbL1GMk+9TZCpQMjRxcPDXvQve6fYONsbpg=
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
Subject: [PATCH 6.19 197/220] ocfs2: validate inline data i_size during inode read
Date: Mon, 20 Apr 2026 17:42:18 +0200
Message-ID: <20260420153941.119819939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1494,12 +1494,25 @@ int ocfs2_validate_inode_block(struct su
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
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {


