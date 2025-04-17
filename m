Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66CC1A3178;
	Thu, 17 Apr 2025 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913916; cv=none; b=YePnVViwnHP3fKlgVBrLKY9vXTcqv+2xD6OjiHz2R/nUVdMb9YIS2DlbI6ePWhl9A70tiT0JHGaJynkUE6x7xr510/ntrFMqPaiSc3TC4EQmT1Yva0NBiENk2ffM5tqAuG56SRZDQ+C9Iok9tDCtIDUOP2x2jYOgPEv6mZPVI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913916; c=relaxed/simple;
	bh=/6wP+uCidGuqot0utOd6zMR4OSBWxyW4VnmLvjSXNBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdY1fkooky8Ju3XY4GcHCkQHin8X5cglr1Dj8BBvzuDIwI1l9Pat46opmRko9+uukt2JWiI6J2ALzdK2JPSmyEjZfiTLJuKsXqGbP1kbgVBEYm/dsp9wpPtpKaV7A8iIj4oEioutTQ/lbF2tT0k2UVAM1WRDPt0bx4wBa2N403I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orFBX8Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orFBX8Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C1DC4CEE7;
	Thu, 17 Apr 2025 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913916;
	bh=/6wP+uCidGuqot0utOd6zMR4OSBWxyW4VnmLvjSXNBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orFBX8Vn2/GN+0eAcDvTqUY64DSFywivgOGDh63CRv6mLYWihcBMqFp/BypefAa01
	 dfNrybpP2717smzf6mPEq6hVTP4JJAJXthrw+JXqDcivaASTaWtq1ZAA7VLjFswitn
	 o1CjxhdMvHl0NqzM9rzVPn3w0GVIUYXE45rwQ2U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/414] umount: Allow superblock owners to force umount
Date: Thu, 17 Apr 2025 19:46:41 +0200
Message-ID: <20250417175113.146680752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e1ff7aa34dec7e650159fd7ca8ec6af7cc428d9f ]

Loosen the permission check on forced umount to allow users holding
CAP_SYS_ADMIN privileges in namespaces that are privileged with respect
to the userns that originally mounted the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/r/12f212d4ef983714d065a6bb372fbb378753bf4c.1742315194.git.trond.myklebust@hammerspace.com
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cb08db40fc039..6a22882d5f54c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1986,6 +1986,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1995,7 +1996,7 @@ static int can_umount(const struct path *path, int flags)
 		return -EINVAL;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED) /* Check optimistically */
 		return -EINVAL;
-	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+	if (flags & MNT_FORCE && !ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
-- 
2.39.5



