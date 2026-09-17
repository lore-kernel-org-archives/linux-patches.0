Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ABE3D890F;
	Thu, 17 Sep 2026 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668751; cv=none; b=gIIiLIJAYLHCbPNZsL2LQVK5kiGh6SllDM3CqnOLy6r5jfwjFSbwwh9FX430s8AzmNjiBNJYtgt7V7U9Xn8clmjaIzcSUeLmc5T5eb9l84aRSVyvOAIGTncBUZyl7qPOqrPRwUfSK/k28V20JU9dKgFp1EsUVHiFMV7WNc++ffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668751; c=relaxed/simple;
	bh=/vvHbmrSI9/iW/BDBPd7WhV0XY7W4/bhNXkBptUbZTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/Yww6/MS7PRhZUg3nTqEuTLiSeJ8/FBZF838z18nSb0cI+/gY1FM8ZviM1oDDQ7DkTar03o2UU2M63vUyObrPgH9Tf9RDbFwZzPOoiZbNLoT/Tfr/jgxHCRK/y8/4LPg/XZlrp4a1vl6l0Y1dPzuXtikIB944Y7vdOq5V0pY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytxfRcn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytxfRcn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C881F00893;
	Thu, 17 Sep 2026 18:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668750;
	bh=sykxM8fx9pzkVBc8InmzTiZJ3ttLyY+uZG3UZRP0F0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytxfRcn8aZeFqAWmsTmB4Bss3Wx+Vhh1JCtEG0EUIg8gwYvOJY15dHOGSydkbn6un
	 ol+lL+pR6npYqPGSHvn4za5mKNCI2XIa28vtRjU1Qs169uo03H/BQoC6fM3f5a62xr
	 nrXpFCJ5cTEIV/HTrC2p9QkgveERGZ5hvbN7oTL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0530/1102] smb/client: fix integer truncation in collapse range
Date: Thu, 17 Sep 2026 16:07:53 +0100
Message-ID: <20260917151553.103791474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index c420720b1d190..8dc045669c6a0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3904,8 +3904,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
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



