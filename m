Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D21E0B7A;
	Wed,  6 Nov 2024 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898512; cv=none; b=QYZRgyT1f+wKnJ0fWL/GOGm7JVNWePsoAgwGX9QeXTseGaSJqHLK4WzDuuExNq/TJo7xV7vwDY32NiqXqeU2n5jktMyp/et4Ydf2Ji90AwWIlwr91XZxZStv1woGuqP6GoalX90dC/3AN3KYSrsApJSNxw8g8rFP7ZghyRBfHVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898512; c=relaxed/simple;
	bh=E0V/+jzPx5t/jcXi3hz5mHqk+WvjfdbCBstzKrRG01s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjPPlMQDIsNBYgPU8d3yrLe6asSdGqNzqWlGl+Sa78WC9KN/cKLC2cReSC+/VVjWKiHRbxeDPueBKxf5R7HuYp1uA7wecTo+wQPdl+ghFNF8UM+5XKMkLTg8fxpk5ZvgGiHjin87HoyoyctdBErrCXySGDn2GVc5B/DFlwbg2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnA9frwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnA9frwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6016C4CED3;
	Wed,  6 Nov 2024 13:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898512;
	bh=E0V/+jzPx5t/jcXi3hz5mHqk+WvjfdbCBstzKrRG01s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnA9frwz0sf3OpQaBxmEEZbAsIeiCEwWyFrf3UP4NRHtM2iwYOddCn7Z5uxLAikvs
	 24KfzHfUxl48Y5wxAHCTAABMKT6xnJeThRMuEavlUnzPf+plJyO2N4JKLvWm6ceWk3
	 KNoKvaNF6IHjIBfUHe6UfpZWGRQ8I9nsPFzh/7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 262/462] ocfs2: remove unreasonable unlock in ocfs2_read_blocks
Date: Wed,  6 Nov 2024 13:02:35 +0100
Message-ID: <20241106120337.997283721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

commit c03a82b4a0c935774afa01fd6d128b444fd930a1 upstream.

Patch series "Misc fixes for ocfs2_read_blocks", v5.

This series contains 2 fixes for ocfs2_read_blocks().  The first patch fix
the issue reported by syzbot, which detects bad unlock balance in
ocfs2_read_blocks().  The second patch fixes an issue reported by Heming
Zhao when reviewing above fix.


This patch (of 2):

There was a lock release before exiting, so remove the unreasonable unlock.

Link: https://lkml.kernel.org/r/20240902023636.1843422-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240902023636.1843422-2-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/buffer_head_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -237,7 +237,6 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */


