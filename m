Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D855349CCF;
	Sat, 30 May 2026 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159430; cv=none; b=XHjL/ppkBOtWZw34fYntWVPUhRrSvqRWoTBWYA7f1TTTwmx1AWlEIEK0lmWakIr3JnV5Jecu05xmrGTP+RFIPQNEUb5aepTcHzNlcEjuxMD8ew+2Q09jkemZc97Sq5BFLIlwO8AKm7kwTSF7OdwsyfN7rlMynvO6oDpgwY8Q7dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159430; c=relaxed/simple;
	bh=vHAr7IOGBTtSq2PAKTxOOu/XDW/rIAcc1yQhr3Umwoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjmPjXpjCIuSi89VgYY2MwOpjW4weO46UWWM+XIBk0WVbbzJYCGrkySWeR+Iz07BbUHTSqQ+gm+cExsP5IggjdvDTFavUJ4MdcVY8s4C5NL4dgiEpDLX/cIE6tDXoHHOXRWWYg7Qslvl1pingTDhNKAchVk4kL+HquTY+6ma8kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir69DYLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir69DYLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C81F00893;
	Sat, 30 May 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159429;
	bh=Jpw/8mG9RP8ZLN6ar4VOaVL8+zW1OTquT9zEOJzRffE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir69DYLMz3keIk7f4zzsNyyYg/aAG3EJ0viKvmJc2raT+gQReKDVRgM5na2tpSYHq
	 g8TYCkBL0DllpiUhDYTP0fNfqY2CjdIvhQ+qsAbd40KwTM8VyeESOJ8C1lGhblkxri
	 BbL66u7cBiEqBBpXlR7SoMZ83N3mDCmsgdyWRs1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/969] ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
Date: Sat, 30 May 2026 17:54:07 +0200
Message-ID: <20260530160303.900253206@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 7bc5da4842bed3252d26e742213741a4d0ac1b14 ]

KASAN reports a use-after-free write of 4086 bytes in
ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted on
a loop device.  The actual bug is an out-of-bounds write past the inode
block buffer, not a true use-after-free.  The write overflows into an
adjacent freed page, which KASAN reports as UAF.

The root cause is that ocfs2_try_to_write_inline_data trusts the on-disk
id_count field to determine whether a write fits in inline data.  On a
corrupted filesystem, id_count can exceed the physical maximum inline data
capacity, causing writes to overflow the inode block buffer.

Call trace (crash path):

   vfs_copy_file_range (fs/read_write.c:1634)
     do_splice_direct
       splice_direct_to_actor
         iter_file_splice_write
           ocfs2_file_write_iter
             generic_perform_write
               ocfs2_write_end
                 ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
                   ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
                     memcpy_from_folio     <-- KASAN: write OOB

So add id_count upper bound check in ocfs2_validate_inode_block() to
alongside the existing i_size check to fix it.

Link: https://lkml.kernel.org/r/20260403063830.3662739-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62c1793956716ea8b28a
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1430,6 +1430,16 @@ int ocfs2_validate_inode_block(struct su
 			goto bail;
 		}
 
+		if (le16_to_cpu(data->id_count) >
+		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(data->id_count),
+					 ocfs2_max_inline_data_with_xattr(sb, di));
+			goto bail;
+		}
+
 		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",


