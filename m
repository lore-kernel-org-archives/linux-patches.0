Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E19B21CA07;
	Mon,  2 Jun 2025 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877286; cv=none; b=Pivp/GJSBRGUOeaew3Ea9SNIO3BkQY9tMuxtcU/8W0Md3E2luQEfluBT54GNBP3xeEEEgXaEVLLmDEfg7/RibGv5NJAokFb4tkHA1NW77aDAHoic+cqUZ/Es4DAyF2CN9TYKwjPFfw2AR9xaulF/3j0wBzgtONN8alTLYeIoRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877286; c=relaxed/simple;
	bh=f4jQyzjFUlo3xmsiY8Jq0s58L6kAY4Tno+HWA4TYTiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGJwkQJiYW+RyfcYUB5Xwx07TGNypL9oU9Qh5vfgXTVu0FYTqz5kO8vPS5yiQNK9U2OfN8hUDB9RjpBOyT2pU7TwFxwGAJoK++GvLu7Ck5UV/fFKsnn9cc6ekDIHDNQ4uTP24+kLOR5t+M+Dw4370d6L18VtETE8F7cEi+zj0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzbKSxWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzbKSxWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EFFC4CEEB;
	Mon,  2 Jun 2025 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877286;
	bh=f4jQyzjFUlo3xmsiY8Jq0s58L6kAY4Tno+HWA4TYTiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzbKSxWd/bhonuud4AXp833Fs9aDl+w3n2IUMxFGTukxzE2VUSsVf8y4migWTi6fM
	 BXNefmkn7rKqLeBsqAzGzlhM6GK1/JBxxjczzFdIHbQA3miLtdGyQMR4x2r9ntIc9t
	 cNaHQHpzdjtGdFeT0O88wFiXijJHw4Jcmbov/qwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/325] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon,  2 Jun 2025 15:48:25 +0200
Message-ID: <20250602134329.086428160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 250cf3693060a5f803c5f1ddc082bb06b16112a9 ]

... or we risk stealing final mntput from sync umount - raising mnt_count
after umount(2) has verified that victim is not busy, but before it
has set MNT_SYNC_UMOUNT; in that case __legitimize_mnt() doesn't see
that it's safe to quietly undo mnt_count increment and leaves dropping
the reference to caller, where it'll be a full-blown mntput().

Check under mount_lock is needed; leaving the current one done before
taking that makes no sense - it's nowhere near common enough to bother
with.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 0dcd57a75ad49..211a81240680d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -632,12 +632,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
-	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
-		mnt_add_count(mnt, -1);
-		return 1;
-	}
 	lock_mount_hash();
-	if (unlikely(bastard->mnt_flags & MNT_DOOMED)) {
+	if (unlikely(bastard->mnt_flags & (MNT_SYNC_UMOUNT | MNT_DOOMED))) {
 		mnt_add_count(mnt, -1);
 		unlock_mount_hash();
 		return 1;
-- 
2.39.5



