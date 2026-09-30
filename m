Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4E4F93A8;
	Wed, 30 Sep 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784335; cv=none; b=bGa0ZNMrWrmhKjzUWqf1WWER5CQS+u1/v8/rYtAlJ6h2BT3yS7UExj3w0ixNeV54qBHO0JZrYUMgvBgV0cn/i6LEauqIkLRKNOeOE8FnCH5L8E29E+XUdrezNa27LwW8/UbY14LPsi5RlTiIoJzt/MCOeb/FV3Fkf4NtcAXMpf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784335; c=relaxed/simple;
	bh=i1OBgIC52wM5QjWAKWJcsXciKUgYkTRGlHgRi4pU9bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7TzlIyv5tK/xfaLCounq2Nss4XgtMxFbxFlByoP8Idg5dgyxQQxVp8h2KT+Xv0NWmwt72egw8hwsiGEuiHaiEtZ6Mkf9yd4tppoiNhGc0Bayuu0VpDalmRfKCMjCFYClRtlyA0ph8zkyhC0rDyvLrz7kkwkCtfk8OfNZV1U4yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1LW7H95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1LW7H95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29901F000FF;
	Wed, 30 Sep 2026 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784329;
	bh=DJoQwkbkwYaTFD9RwlSjmP5kqy7aBnKbllLf4iP4FSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1LW7H95ta2oXOPwMaEohLHrvM4prOIzqOsCTJ9Xn55HgQMnjC1vND7qYlGMPYSxo
	 czFQ48FlXgGA2rXKG/2lfuZVa7UswejgKx2wFvnQKoTw2RAbDbyJYdj8rqYpFSIdGI
	 9ttR91YuUb6LQkMlX1c5L2MaTZKQNext6Z7fETKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/982] omfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:29 +0200
Message-ID: <20260930152418.373275806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 18c3d6fcb557f920c9143711497625e70153874c ]

omfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-11-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/omfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 9773846daa4bc..760f675a73d92 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -480,7 +480,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -532,7 +533,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Use sys_blocksize as the fs block since it is smaller than a
 	 * page while the fs blocksize can be larger.
 	 */
-	sb_set_blocksize(sb, sbi->s_sys_blocksize);
+	if (!sb_set_blocksize(sb, sbi->s_sys_blocksize))
+		goto out_brelse_bh;
 
 	/*
 	 * ...and the difference goes into a shift.  sys_blocksize is always
-- 
2.53.0



