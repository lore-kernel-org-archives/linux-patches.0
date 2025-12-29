Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B803330649;
	Mon, 29 Dec 2025 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025767; cv=none; b=NLtEkINu1Dc8kqpib5h+zb6Rap9T7F22VYLEmBS/V1ooaW7wzpPdWXHAa0F4dHGBrbeGMXqcSV6F+Jdwmud/9y3H4VVzyvkmphxkv08eoACgRLZx7PHwyLVU4jhMU/3Df9IotTXF2akiI3jQpmBGVyS+E5WCpZuipFUHxEtBiLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025767; c=relaxed/simple;
	bh=28A3rzDHKPfOCQScprrWGpFR4J9SMam7g+rHJn39uEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rT8CTj6ACz5/w1wkSCoMaTH+NytOC7Nxn5hMKI0w6GqKwPHz3ehnE0vbpDcVnCR6BtCEwuISLkUeTZIIvZ6jmE6RUmFMUwHZ6QO7FgpdA75esd5mQkjuBOxmmOIh5F68NrXUuIrHLS2vGOmWold+V7SAbB0OwtmmlEtyuMidAmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBmvmueo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBmvmueo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B692C4CEF7;
	Mon, 29 Dec 2025 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025766;
	bh=28A3rzDHKPfOCQScprrWGpFR4J9SMam7g+rHJn39uEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBmvmueom6doyZKBfdvE7eOzysh9zW3jmpLeZkUQt/1EXBwpAQUrvOCYYt5P93Swb
	 vjuSBEfD7QxlOVUcidna/PZRI0UgHY8DDgCX1QzaLnUdXl27lEBKk8EwlWj3cxNfke
	 fKx5BcvHtHUlacFRiv5MJe3uz4H3ZpM6fqFSl2HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 329/430] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon, 29 Dec 2025 17:12:11 +0100
Message-ID: <20251229160736.436677945@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prithvi Tambewagh <activprithvi@gmail.com>

commit 039bef30e320827bac8990c9f29d2a68cd8adb5f upstream.

syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
`cl_next_free_rec` field of the allocation chain list (next free slot in
the chain list) is 0, triggring the BUG_ON(!cl->cl_next_free_rec)
condition in ocfs2_find_victim_chain() and panicking the kernel.

To fix this, an if condition is introduced in ocfs2_claim_suballoc_bits(),
just before calling ocfs2_find_victim_chain(), the code block in it being
executed when either of the following conditions is true:

1. `cl_next_free_rec` is equal to 0, indicating that there are no free
chains in the allocation chain list
2. `cl_next_free_rec` is greater than `cl_count` (the total number of
chains in the allocation chain list)

Either of them being true is indicative of the fact that there are no
chains left for usage.

This is addressed using ocfs2_error(), which prints
the error log for debugging purposes, rather than panicking the kernel.

Link: https://lkml.kernel.org/r/20251201130711.143900-1-activprithvi@gmail.com
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/suballoc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,16 @@ static int ocfs2_claim_suballoc_bits(str
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has invalid next "
+				     "free chain record %u, but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le16_to_cpu(cl->cl_next_free_rec),
+				     le16_to_cpu(cl->cl_count));
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;


