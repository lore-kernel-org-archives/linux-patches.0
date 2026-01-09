Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A135B128;
	Fri,  9 Jan 2026 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960590; cv=none; b=gSSF0CN/XYMnJ/383YYbZ0K2cQpq4eTokHZZ8ufD/CQIaVn562KsWTxqPN5yC3s+HC2w5Rn3791W7JPF+F049myyLmsjSTPSgPlW9lf2dbcmRIpjMXHpMz1hzQdkLXUEdG3toiTJg1/eIwBQPC8TNOqqgHykl7E/tn7sbpNdmZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960590; c=relaxed/simple;
	bh=M6G4WeIa4mrSv4J4GvbhOeEHECY9IWNrzeqb4AaRFwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUv8VYhz9tTGfpovDB64fBqQPi84axYjWic1S3E11RfajKanm0dzNq+dP7GtcRUcDTan93NfWpvetqL/usFPc82adjeUdfmWw+9tjnezmkzSkH27WhDKxxYZ5woMsdEfJA9Wl2UQyJSJ0M9hhaDzDERfxN1trMZbCXI5TW2WYYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND5n/qgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND5n/qgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3E6C2BCAF;
	Fri,  9 Jan 2026 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960590;
	bh=M6G4WeIa4mrSv4J4GvbhOeEHECY9IWNrzeqb4AaRFwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ND5n/qgb0dvUe/4u93ho48GuHu0h51LCMlPIJ2yAU8HTdxlFpejuRL6QuVsSxBwnn
	 8NeAXFawaXQngA5R2PGBssEgcbdFcE462diQMwqdv1RYl+vYi9YCljnbphqiY2quE8
	 GyFmElQI0GILoLAflkyZ/pW0elOA/LW1//cne+kw=
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
Subject: [PATCH 6.6 456/737] ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Fri,  9 Jan 2026 12:39:55 +0100
Message-ID: <20260109112151.148178426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1923,6 +1923,16 @@ static int ocfs2_claim_suballoc_bits(str
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


