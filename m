Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5235C20A5EE;
	Thu, 12 Dec 2024 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024772; cv=none; b=T7voi8l1ZVaX/xISaHLGPzRDHoPInw8+0yak62jACyof9oi0Eihp3BeAOSJ87HUVrOi4ocor5WY6c6pYci8fA4Zui4DBicloR2R+dQp+Cm8cfFR3hTKbH8Hg6A1Bm83ad32knjlT/3u7TT7dXyCvYJ4ProCqKcS+sJxM8h2Upgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024772; c=relaxed/simple;
	bh=KmLjjcVSCxS7+BhOuZpZAUAuo0ptkn+f39bGZeTtzMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMhJpZB7C9JpEmIUIdLIdxUERtcSDHwLVMagdEU3eS9MfO5q4T9Xw/sFstq/Mm993uRQywOPkT/7rCr7JThe4Uw1BEjODnEovOw91N4X2zd0C5rm1jgzjqgpx/oj0n2lOqdnFvRHA+tJls0d0KsKhEEOL7PDbK6uJMpukGw5d+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSn1fYAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSn1fYAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05C9C4CECE;
	Thu, 12 Dec 2024 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024772;
	bh=KmLjjcVSCxS7+BhOuZpZAUAuo0ptkn+f39bGZeTtzMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSn1fYAgJu6F1wVpPn9yLukyTjC2rj9j3TWdYzcysnm/UrjU5Ab8LuIF5Yej7MLyW
	 WdsNviJVHo6/jVddVMkAB4G4MstR+pWspCE0KrY0bHmO5xPIviPNpNGZrpaEqsl+gE
	 2YxRN5JP4oZrphowl3deVBVvDqvbSQx3CLeMj4dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/459] jfs: fix array-index-out-of-bounds in jfs_readdir
Date: Thu, 12 Dec 2024 16:02:24 +0100
Message-ID: <20241212144309.805978887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7ce1bea44c5..a3d1d560f4c86 100644
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



