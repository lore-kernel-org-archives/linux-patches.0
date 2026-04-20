Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7120133DED5;
	Mon, 20 Apr 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699914; cv=none; b=pirtP7CaKqeNcCvje0C4fKfqMZ3lR7u+3HXYDEPePaR2S97CLNBXYGWUh6XNNrkBylhVatk65sTzCsajvgRCOrLK75qoa/DBiVdetlQe1Pp5pX8CgWg3OdxajPYEbFeS7FsTiKG6/arNAZvz1fXvqIJdZayi/Aj+VDuTosZQMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699914; c=relaxed/simple;
	bh=9+hrE42LZJ7NM0DlQSq/pcHDOMg/f8dCwllW63yMitc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ3P6D4XB50VIketM/MzqAW9+IW5l1dS635U/9mwog4PWRVF3qM1IRMk6ckVRvGa4xUdrP5N+cB+EX9/IE2HGxckRlmjVAjEoCrj517RR3jopAVC91lQy9S5kb8BIZijijXQ2ux5Q2Rv7+jfd3qPH3PnTd7M7kEX8j3L3h3Gsj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pkwaly9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pkwaly9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835B9C19425;
	Mon, 20 Apr 2026 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699914;
	bh=9+hrE42LZJ7NM0DlQSq/pcHDOMg/f8dCwllW63yMitc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pkwaly9GRez5qIea0zUaAsmOOomKxU9rmPAzrTTlzRCJ8qagH1KZO8HwdVfsup2As
	 zH7IGBktO2MMzRXtxdQS4DmW7prHparpBw77Fhf8NYh0/3AzatfE9/2KpPYnfI6onW
	 +t6DeGNmLpOOgHIrCsMnz3QVM42vPOGynKhhrAv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 47/76] ocfs2: handle invalid dinode in ocfs2_group_extend
Date: Mon, 20 Apr 2026 17:41:58 +0200
Message-ID: <20260420153912.538141158@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

commit 4a1c0ddc6e7bcf2e9db0eeaab9340dcfe97f448f upstream.

[BUG]
kernel BUG at fs/ocfs2/resize.c:308!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_group_extend+0x10aa/0x1ae0 fs/ocfs2/resize.c:308
Code: 8b8520ff ffff83f8 860f8580 030000e8 5cc3c1fe
Call Trace:
 ...
 ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 ...

[CAUSE]
ocfs2_group_extend() assumes that the global bitmap inode block
returned from ocfs2_inode_lock() has already been validated and
BUG_ONs when the signature is not a dinode. That assumption is too
strong for crafted filesystems because the JBD2-managed buffer path
can bypass structural validation and return an invalid dinode to the
resize ioctl.

[FIX]
Validate the dinode explicitly in ocfs2_group_extend(). If the global
bitmap buffer does not contain a valid dinode, report filesystem
corruption with ocfs2_error() and fail the resize operation instead of
crashing the kernel.

Link: https://lkml.kernel.org/r/20260401092303.3709187-1-gality369@gmail.com
Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
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
 fs/ocfs2/resize.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -303,9 +303,13 @@ int ocfs2_group_extend(struct inode * in
 
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
-	/* main_bm_bh is validated by inode read inside ocfs2_inode_lock(),
-	 * so any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass validation, so treat this as corruption. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		ret = ocfs2_error(main_bm_inode->i_sb,
+				  "Invalid dinode #%llu\n",
+				  (unsigned long long)OCFS2_I(main_bm_inode)->ip_blkno);
+		goto out_unlock;
+	}
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
 		ocfs2_group_bitmap_size(osb->sb, 0,


