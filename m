Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4608646A616;
	Tue, 21 Jul 2026 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649093; cv=none; b=kvBQsAvoJHe4oyJK/jQPxLWEiiYaWwtgFCZgqtt52XeGD7EC5CNfH4l10aydeU9xWEz2osf/gyruUain/BLKEkNI+NRjqGo1rlsWFJ2Sj8ptQrVxAVdN6b16ICK4VdttEzk9sTo8DtVyZH5un1LxqJOwye5KiUf9L0pWbicERXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649093; c=relaxed/simple;
	bh=JPHyjeE3mKoMweIZt8n7c1i71slXc/ds0R+KNk56GQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf9jKWrc72wbTOBNNQTfCs+4hSUZFrEEle0KbbOWmJF+4yPTDEnG4ufZ2JSjx9kWA61ib4FbrF1EAphNsUYQoh1JmrYd4LViB32OU2fZK/zQzqFP+E3mQxtTzFCUR53L073JIGtR3rnKee8Ph5lJkY+xT/L97WlA+IUw4jxX/zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqX1Ivs6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqX1Ivs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A445B1F00A3A;
	Tue, 21 Jul 2026 15:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649092;
	bh=JZ6WCBoBmww90PFT4TpJR7DsAuFibpniWVwAGEhFVCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqX1Ivs6Hjmgo4dPp9wywUbvb3fT3dE08kNo63rni2Kls9rMrU0W2S0cJEUfIz8Z/
	 z8CQAPp89ruthedlJXG4su1qHth9hSpMgWE9QtBYHNxMKg68krXBjq2Qg8x++BszF6
	 fZL3fHxgWGBMAT/ZzpR5eSoCgz/n1ame4Xe/dCFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0446/2077] configfs_lookup(): dont leave ->s_dentry dangling on failure
Date: Tue, 21 Jul 2026 17:01:59 +0200
Message-ID: <20260721152603.291485543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 362b6ff9b908f1..e84483a0836d8e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -486,6 +486,9 @@ static struct dentry * configfs_lookup(struct inode *dir,
 
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



