Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04701DF27C;
	Tue,  8 Oct 2024 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393422; cv=none; b=UQRPbQPMzp8k1yKRNiny9HZ6ZWzUVHYZnyKpgCBO5CfBoCpmhKIyfmiaU9HV84S4N/y5rHv6dY83nPO/tx2w+RqrCuQzsjlrKJgENlLnigGNNewuL/RCmJZ4T76IeTEktDSdy140T2VSK903DhMd9x3HP7/Td1CIC7ReSXsrmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393422; c=relaxed/simple;
	bh=O7qwIHYTujJHFKTFeXtTzhxUJOznEPalT0EetOmC60w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQsLyt9Ltoo09tn3P+xZDrH/gnYgTsm1C3PCST/GxWkrThje4kMtNlyb+19b0cON3122M2Obi4y8xd2n4yHFqc7xDmJiJkUtiT06w373bk7YeEmmpxDzlC9W4xhBsZ3upN9dLKdF4nr4EUu5ctDOpFhVQE2JNveA9cX8eeNqc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUT+HYgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUT+HYgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDD8C4CECC;
	Tue,  8 Oct 2024 13:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393422;
	bh=O7qwIHYTujJHFKTFeXtTzhxUJOznEPalT0EetOmC60w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUT+HYgAxqs91v2U96Rn+fA28hzlUWfX5Y4SxgN2mWX64/lTVTWWV/yyGRqIzDY1j
	 aOQksXkgGqSs442R3q23iFhOoDzQoF1bepvZe0BvnlXxw6CbjeJAq9ck8VEZvcqwAg
	 EOjyvgyUf7WdrbgsSQ0H06iUn2rVZFOvFtUZVdhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/386] jfs: Fix uninit-value access of new_ea in ea_buffer
Date: Tue,  8 Oct 2024 14:06:32 +0200
Message-ID: <20241008115635.213730194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17faf8d355290..49e064c1f5517 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -434,6 +434,8 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
 	int rc;
 	int quota_allocation = 0;
 
+	memset(&ea_buf->new_ea, 0, sizeof(ea_buf->new_ea));
+
 	/* When fsck.jfs clears a bad ea, it doesn't clear the size */
 	if (ji->ea.flag == 0)
 		ea_size = 0;
-- 
2.43.0



