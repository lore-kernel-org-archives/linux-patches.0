Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1D244AB9D;
	Tue, 21 Jul 2026 21:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670106; cv=none; b=G8zSw4LUY589XB1m2ssTtqRXhCdMYvyOEBL9qFLvRRaXZ8Cylj+4bzphMKe9qVaZFBl0E/nGf+Hw3NKZO0Xga1Y9N1/AY1yGdCKrgYJvbF9VbETz5lErVO49X36eSHaFZ8UoCylIk0mKymVI51PH8uCug5t8gzpVjch4114zsBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670106; c=relaxed/simple;
	bh=Wemm6+y4fkm70bJsMDgEdtk6sQgos+zlKvPGJ8LvlbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0Rf8Tl6EzpxIyh+z1U8/XWvtZxKYb1Fh5Vq9KsX3bEo668+JQQ62uqsnWSsHsCpOvN8p+AAHlf2gulL7YkNAvwNZsjw+2LkLzaFxOuplSyFrHrA/baM+QddHJy+oV/YVwVub3iB459pvZp4QCMQYMa7DQgT/3DjCP5fFYhiJUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dt2o+KjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dt2o+KjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C971F000E9;
	Tue, 21 Jul 2026 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670105;
	bh=M8/OyWo8LiM1fo6eTdalKP80zlgdDmO/yuKMHhsqJJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dt2o+KjGFA62yVpjOes+Sw+HnlIWR5gx+ncfjE8ApDIQNht+mXf4MS9f1a2YbkLbN
	 8Y3lkL0+HT20lhBeITPd7rR/wPJ7OXtGnrkP2GlMb84vQiEd8xa997lQoXhcgnw/Tm
	 RQuY8lBPxazCQivwi4yl2iGenUfxblZDCDECkb3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0808/1067] ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
Date: Tue, 21 Jul 2026 17:23:29 +0200
Message-ID: <20260721152442.631825000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

commit f9ab30c96b0f00c20c6dac93681bdae3a033d229 upstream.

[BUG]
A direct write over unwritten extents can panic the kernel in
ocfs2_assure_trans_credits() when the journal aborts during DIO
completion. The crash is a general protection fault from a NULL pointer
dereference.

[CAUSE]
ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
marking each written under a single journal handle. If the journal
aborts (for example after an I/O error) while the extent tree is being
updated, the handle is left aborted with its transaction pointer
cleared. The extent merge treats that failure as not critical and
reports success, so the loop keeps using the handle.
ocfs2_assure_trans_credits() reads the handle's remaining credits
without first checking whether the handle is aborted, and that read
dereferences the cleared transaction pointer.

[FIX]
A journal abort is recorded in the handle itself, so callers are
expected to test the handle rather than rely on a returned error.
Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
helpers already do, and return -EROFS when the handle is aborted.

Link: https://lore.kernel.org/airKTsM1fRVN-Wj7@dev
Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
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
 fs/ocfs2/journal.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -478,8 +478,12 @@ bail:
  */
 int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
 {
-	int old_nblks = jbd2_handle_buffer_credits(handle);
+	int old_nblks;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
+	old_nblks = jbd2_handle_buffer_credits(handle);
 	trace_ocfs2_assure_trans_credits(old_nblks);
 	if (old_nblks >= nblocks)
 		return 0;


