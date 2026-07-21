Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F446A60E;
	Tue, 21 Jul 2026 19:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661867; cv=none; b=VcN2HGzmBcT/WAzizMjL9V1wd0jEAZKFpS0S7jgeBJTbA/x56l6NAE1kJk+RS4YdfnbH5zeSsNlaFJl4iLjGAARPEvszANIp0iMPWRDQRZuNLgedu4ZUuCVDG5b3wQfzMFqFemnV4puRBxFLi05ImZjPbqy7HD5ymHQ6IIuYXfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661867; c=relaxed/simple;
	bh=vlF2eUZXo1IOSot70cn0HZiTmRPkMHN+8v+cXc0Vkp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7NDzS7jG77dnoLf0TNk/QarFrKe1mLwNm4bxR+1S6X1QCdBwYX4MaBQGi9NPdVkwMVusZMf3NQ5Tv3feSHLwN/STtRGw+Ga4Nc9aoJKjUUDqbAgMPbN6b5rbuhBGeHwWtS2zzIILei0mZbjtXq0w7myZUq0+xYzGDk4pUtqnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhU5Lx9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhU5Lx9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC831F000E9;
	Tue, 21 Jul 2026 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661866;
	bh=JGhIhG7LECSvVgookAHGwZ/UpDHN4iUdMNR2DWsYdaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhU5Lx9IxMr5SRFA0cYx+7Dantcuxvkmd62wVAJAdf45pNvHZ2LRuRnnfQ3s90GJQ
	 L25MM0V4FjA+UTLvusAQlPcqbdpd8wmuzKAjHNgsjcb8y+gZwvgNP1xpbXtPifvVW2
	 edxK7n/24ckkalu0xpipu/JFrgGRWSYd44FJy1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0226/1276] configfs_lookup(): dont leave ->s_dentry dangling on failure
Date: Tue, 21 Jul 2026 17:11:09 +0200
Message-ID: <20260721152451.148745694@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 10da12d352b7b2bb330a8609fdda9a58bf0e9856 ]

Normally ->s_dentry is cleared when dentry it's pointing to becomes
negative (on eviction, realistically).  However, that only happens
if dentry gets to be positive in the first place; in case of inode
allocation failure dentry never becomes positive, so ->d_iput()
is not called at all.

We do part of what normally would've been done by configfs_d_iput()
(dropping the reference to configfs_dirent) manually, but we do
not clear ->s_dentry there.  Sloppy as it is, it does not matter in
case of configfs_create_{dir,link}() - there configfs_dirent does
not survive dropping the sole reference to it.

However, for configfs_lookup() it *does* survive, with a dangling
pointer to soon to be freed dentry sitting it its ->s_dentry.

Subsequent getdents(2) in that directory will end up dereferencing
that pointer in order to pick the inode number.  Use after free...

This is the minimal fix; the right approach is to set the linkage
between dentry and configfs_dirent only after we know that we have
an inode, but that takes more surgery and the bug had been there
since 2006, so...

Fixes: 3d0f89bb1694 ("configfs: Add permission and ownership to configfs objects") # 2.6.16-rc3
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index e5b6a427f31cd9..47123ac17b0573 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -462,6 +462,9 @@ static struct dentry * configfs_lookup(struct inode *dir,
 
 			inode = configfs_create(dentry, mode);
 			if (IS_ERR(inode)) {
+				spin_lock(&configfs_dirent_lock);
+				sd->s_dentry = NULL;
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 				return ERR_CAST(inode);
 			}
-- 
2.53.0



