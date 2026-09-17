Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2451A144;
	Thu, 17 Sep 2026 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665223; cv=none; b=LwEH4mHgzVN+bIrcDkdWsE5whn9YS6a3TPfNXgKFgyZB0IcNXUVRJ0oIudOLBwBY2NJXambQOzcTTeTT5h/JaeFFY89EzoyTicsWU4MEKzKnW8TA4Qp5bBxTb+h9UG03gh/lURJMq5RCkeLR9aur3JCveTl4Awx65rEUuZOr4os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665223; c=relaxed/simple;
	bh=GibE1isU+OA2d78CuDykRI7S5WBIUmJqiLD2DSllMgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4JTgp0Lnb5SCbJvWqe/YLQSaZx+EJ2IQYmR+pLOY3nYrO2McdNqqAZRZqyhtI4MT+a016b4clzBPL87NX9n/Lhm4kZoXGmFxaGGeMqoRipIXR1cI88ruG9gKMhQYqAtGJN6sWlh6I3cjB8trFNxP95dABfkWJQ81j1qQJ+dqAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIFZX019; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIFZX019"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0741F000FF;
	Thu, 17 Sep 2026 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665221;
	bh=ECILtRBGOtxXCj9qZ9GJ3THn/N93seRsu4KwBhYIrs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YIFZX01994d7mxMqpI701YjjawpkCaBcM6egXjwR1z2R9SjBuh5sVhB5JEbFYgMGL
	 TTXPzK/st4PdpaLUBGjPxvIUXPhbA7XFiEEeubQ4pZeOytq/0J8jY2/ZdRlpqiHv+H
	 f+K1nKlMVUZwdqGeDUfkWGmMbhr/H20qUJdvbQ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0632/1250] smb/client: fix integer truncation in collapse range
Date: Thu, 17 Sep 2026 16:07:07 +0100
Message-ID: <20260917151609.012229400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 7811701d6af7db76481a82b9bc3c4adf7863acf5 ]

smb3_collapse_range() stores the ssize_t return value of
smb2_copychunk_range() in an int. A successful copy larger than
INT_MAX is truncated to a negative value and treated as an error.

Reproducer:

	MNT=/mnt/scratch

	truncate -s 2056M "$MNT/file"
	fallocate --collapse-range -o 1M -l 1M "$MNT/file"

Fix this by using __smb2_copychunk_range(), which reports success as
zero instead of returning the copied byte count.

Before this change, the reproducer fails with:

	fallocate: fallocate failed: Success

and the file size remains unchanged at 2056 MiB. After this change, the
reproducer succeeds and the file size becomes the expected 2055 MiB.

Fixes: 5476b5dd82c8 ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3c81c6cf143b6..1d740e8ba93bf 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3944,8 +3944,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	ictx->zero_point = old_eof;
 	netfs_wait_for_outstanding_io(inode);
 
-	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  old_eof - off - len, off);
+	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
+				    old_eof - off - len, off);
 	if (rc < 0)
 		goto out_2;
 
-- 
2.53.0



