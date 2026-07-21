Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3CD44AB8E;
	Tue, 21 Jul 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674296; cv=none; b=UbYnec3Jd2VpsPHzz6HUnQ+Nw58u7xBSlupSYXzXV1Xl89JaKcFNI5q9euRUTeYHUxAHzcTPb6m1b0I990pbr2qAum3LNL4+oxcezhA/emYt521SbPUGZIUaKOyRRt/0qasa8iDIcJTwyq8B0XB3UhbC03j7opJS4s+zuGnB5F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674296; c=relaxed/simple;
	bh=md59uUhL3SzC8TbRxCntjSHDIOzNMVcoEc6myG+4aRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbY2kATK4pk5vXN3rI+TFlA3+UxWZY/eu5AmwXg9Fg2zqYyc7u12U4UxpEjbTrZsnMSwlILkNj0zU0IzEzPqkrg2QxNK7Ol7dsZMX0Lk9VhVjxhVxyLrcVpZxinFURduEhoNJxC0+XymspMhmpUt0gmHm55r/EzFTZv83PD1OWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLwoTVSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLwoTVSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A7D1F000E9;
	Tue, 21 Jul 2026 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674294;
	bh=/G5MX5N0DdyDuhFb7tnDiOaVG60v+HsD7DZnPKPQZUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLwoTVSIxld1xtYp9GqkMCRMb00AsJZcFCsMVu3YDbhqpbrDwz4EFxDXvSPaQgHPI
	 2trSR2G7uVYQArNWfFvFfu1+cK/PegccEOh2Tpjp0Gv60oKU4mzd/P/LZPZUVtFGgJ
	 JfIPcmofVlhUrMkh52q/su09hDziQBAu2e8G3lEg=
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
Subject: [PATCH 5.10 486/699] ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
Date: Tue, 21 Jul 2026 17:24:05 +0200
Message-ID: <20260721152406.664906430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -480,8 +480,12 @@ bail:
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


