Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6CA13C918;
	Thu, 12 Dec 2024 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025774; cv=none; b=p2Lz+sl7EE/ikU9UB2DjU6V3CKGi1hSW2ZsRkebukZVpnuS3Oy3/Ey2hmGJ+Q7Y/yxM554VR8LYlEpbYonHYhDPwPU1llyXisRuDN84J5uz1D7NhwInNi6VZsXRhaWmSiZa5HUgNHNN1NhcDY+yTa5vSiLLMyXz/BnFG5CClfPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025774; c=relaxed/simple;
	bh=ijlPM8pw1YD9YRENd0+gVZHmRzSGaBMhZtlobUTVHyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmEyikeytbDRJySm3JJxJ2ilpt0dQaEs5j0yvX4nHaywPnW5F2f/B7dNOmleFCEVYG44CaXnUpmqvUPlTK3SfuHLGMc2d4nm9ow74A+xxBCCmVEK47oNEZxYLWiFsdEIX5sCCp9/nUrsM1EtqyGOmZ9PiWO1ia/+GDyfkRG3sGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDahvjpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDahvjpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F17C4CECE;
	Thu, 12 Dec 2024 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025774;
	bh=ijlPM8pw1YD9YRENd0+gVZHmRzSGaBMhZtlobUTVHyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDahvjpyaUmO8ZlQcIx8lJMSpuuEh20DXPUyf9pb+5mgheKIfS4SWei8nMoFaYB0a
	 GX3YQwH0XdSBeJTKX49h1+u5S+CU3HItcTqq6odQDpNGIEJy9UWfTu+Yx//wk8gqTK
	 W3p3vTZK/oloC0ojRWnlkPUbJLKl763Xhfdr+o+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 284/321] jfs: fix array-index-out-of-bounds in jfs_readdir
Date: Thu, 12 Dec 2024 16:03:22 +0100
Message-ID: <20241212144241.197114877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit 839f102efb168f02dfdd46717b7c6dddb26b015e ]

The stbl might contain some invalid values. Added a check to
return error code in that case.

Reported-by: syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0315f8fe99120601ba88
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index bd198b04c388f..4692c50d615f0 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3187,6 +3187,14 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		stbl = DT_GETSTBL(p);
 
 		for (i = index; i < p->header.nextindex; i++) {
+			if (stbl[i] < 0 || stbl[i] > 127) {
+				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+					i, stbl[i], (long)ip->i_ino, (long long)bn);
+				free_page(dirent_buf);
+				DT_PUTPAGE(mp);
+				return -EIO;
+			}
+
 			d = (struct ldtentry *) & p->slot[stbl[i]];
 
 			if (((long) jfs_dirent + d->namlen + 1) >
-- 
2.43.0



