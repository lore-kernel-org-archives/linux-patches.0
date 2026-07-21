Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697F73B47D3;
	Tue, 21 Jul 2026 20:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665915; cv=none; b=hXEVSJkFtjLxcFHIMnlSKCXhq5OS4hLvKRW0mxU038ZF5hvvrFFDUAuD6DrJr8sgR0KTVceZPuEHIfPXT6ktY1Qakqngh+GPSRCl6fPc45WVm7wHR34NmOVrLcZL4j8IOiylcltrCSLJJwxc++Wmrf13YgX0/Zoed+3UdoZ2Quw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665915; c=relaxed/simple;
	bh=eVPreAiMHKkksRRBTPh9buvU8w6mHAE8MQS28oNRMe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bmyf5JGZ2EIM8Y329FZ8bAh6uLJc0E+md3iNsDe1wSuTXwqeCZGeUN4jXpFaEs9aymAc7B/JG/s1gSgeoEE6PQsvLHJLMlJeaRmNq1tHanuGJcK/1C/ggdsC/gHIhjQqGBBZZzC84va/J4gsIkBFrt+yDqg7aDzHKPM8Gw7eYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wO73JYn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wO73JYn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF2B1F000E9;
	Tue, 21 Jul 2026 20:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665914;
	bh=oIA/QCQ6Al1GXWfo1KAH8mW3bqM2FmSB1aWbOslTsis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wO73JYn9lHpyj+xJiY82KWj2QyoRt1oS8+Rt1ATh7ieUaw+GfqBxLGXQ6jWW+oWjC
	 rpT018stvVRrDJQxR9VosHhsmwDXBmGI3COQVoUo7lLEGu2CDEzuP7NJfwarFCC21x
	 RCtfPIWbNyvUS+CN73s4I+zqrGguAtmlNrOCCE+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0484/1266] configfs_lookup(): dont leave ->s_dentry dangling on failure
Date: Tue, 21 Jul 2026 17:15:21 +0200
Message-ID: <20260721152452.671615480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2df99cd1034d4e..c3fac94f66f212 100644
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



