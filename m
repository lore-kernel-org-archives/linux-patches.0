Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808BE430CDC;
	Tue, 21 Jul 2026 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663751; cv=none; b=die96Fqe1YFVSlSaENgzoRgB1KUph/gQHEPRE0BYRju9TubJA4k/IghuCtDnACrN/ujUAIDBDfQqwGITlu/CvCWhQ6OT+GTC6mMrZMlxr0agrKESPB5WhAcYVm1hwrEIcC5J+QPupz10mvedxkIiLnlo6/PeOTrPOIJyN5cDbwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663751; c=relaxed/simple;
	bh=WM5VUh/1EyGOYXkGekAnovpe69FUgZedWFp20vkJW5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/LLsIOS5NPj/JvJWla0pmqPK7+rtiff81OdwD0GTJIPhcIwHUUFindUm87stBxmp8JLm0PcXHpgC2JRh4We/lznlv7CCKlFPU6/91sG0aDe/pPE0AVld12kY2tupKbRH1zcgeU6b9mWNFQADRwgx6IPnYkzlzmS0YYoGdYoyFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq1odHRM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq1odHRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE0D1F000E9;
	Tue, 21 Jul 2026 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663750;
	bh=KbmaJBa6eYh/LwxkWCM3eD6o3kQcwRNYbsJvnkl8VXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cq1odHRMYylYcKji9s9dlMS+Nr9TwU82JFJKxXwTyMDu00EZpN3SHgav/OAFjjQU0
	 DlUy9x1PzuMyf3c8wM7F5guSJzDez+6ePV41pRdUkOFuTY2N8r2iapYrE1aXG3IWy/
	 U8PGxh6QhVRR/pnipiqwcslXtBGybFwGFdSndSm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0941/1276] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Tue, 21 Jul 2026 17:23:04 +0200
Message-ID: <20260721152507.089674420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 93c8c6ea90be9e9df8fe14048ad4e3caad0770a6 upstream.

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
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
 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;


