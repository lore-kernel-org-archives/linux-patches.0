Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE101DED40;
	Wed,  6 Nov 2024 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895381; cv=none; b=fh1TmFmc/a9/vy8wL8TkB+SQeT5RYIsOcPay1s9IAZZA9zPzR5ow+BWeYbsRsgN/IupcMeGqrK1xiZJDSFbd+FqB9QoXjXq7yyUReLWObvP5Nkc2uszEMkVbAzJ6MUcQ5jWszT30bPTab/2hLTEG8oGmp6mzYARsJ7zEuNe4rew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895381; c=relaxed/simple;
	bh=QFeJ1y0i9nX7xFpPGULBRW+knr1Bk9R0KE/CGE4ISc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCFTMYBqbowyp5BzXmwETxrJZwNJH/ympkp2UJ+XQyPvFUnr6tzIDjodGhbdIwWzxGvxRINd6loXnOYVkXQvoWcp/+AalAChV22RGpp7ZAy6bpcE4rSlQWIBYas5bmkAUJmNfaCvOGOFbOEKb09E1aOcYlmDpxZyZaTGFM4V6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OL06HnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OL06HnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A65BC4CECD;
	Wed,  6 Nov 2024 12:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895379;
	bh=QFeJ1y0i9nX7xFpPGULBRW+knr1Bk9R0KE/CGE4ISc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OL06HnF+Kn3KM6L7K1Xn74kECAhX/1tYPyY8ehOomWlPGDRJyOl97vGV64w2E/Pe
	 XD7mKcxT4wslNyHsDOc0+Q6nCvbX2KHt7FBnvE0+D3hSoX0F7/BmTl1AArhNeqH7Z/
	 iW8MFIfemqCGc9KjN7oMopoLShaOC54YoQ1IWsOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/350] jfs: Fix uninit-value access of new_ea in ea_buffer
Date: Wed,  6 Nov 2024 13:01:39 +0100
Message-ID: <20241106120325.149888076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit 2b59ffad47db1c46af25ccad157bb3b25147c35c ]

syzbot reports that lzo1x_1_do_compress is using uninit-value:

=====================================================
BUG: KMSAN: uninit-value in lzo1x_1_do_compress+0x19f9/0x2510 lib/lzo/lzo1x_compress.c:178

...

Uninit was stored to memory at:
 ea_put fs/jfs/xattr.c:639 [inline]

...

Local variable ea_buf created at:
 __jfs_setxattr+0x5d/0x1ae0 fs/jfs/xattr.c:662
 __jfs_xattr_set+0xe6/0x1f0 fs/jfs/xattr.c:934

=====================================================

The reason is ea_buf->new_ea is not initialized properly.

Fix this by using memset to empty its content at the beginning
in ea_get().

Reported-by: syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=02341e0daa42a15ce130
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 37b984692ca90..bb8c4583f0655 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -447,6 +447,8 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
 	int rc;
 	int quota_allocation = 0;
 
+	memset(&ea_buf->new_ea, 0, sizeof(ea_buf->new_ea));
+
 	/* When fsck.jfs clears a bad ea, it doesn't clear the size */
 	if (ji->ea.flag == 0)
 		ea_size = 0;
-- 
2.43.0



