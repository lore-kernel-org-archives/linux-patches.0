Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908474EFFD4;
	Tue, 13 Oct 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892404; cv=none; b=W5mvY9wQNaWDXu4tsGZsIGe04sy7/aXRh48ghcXpmLuYGn2GunEy8ZLpkr0oCCxwljlJ3ys7iEB7x0LKbkehnQf+zP2kBYoMg5txVI3PIkyIb6as7SNBm82Yj8yWVAoROZ6qBpc+kmtHrOHyO9SspkF8CuzqdhZLRcNFesTBSSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892404; c=relaxed/simple;
	bh=5mj/VPaKiMkbTNQm7dGOsjZnZ6WHDHK1GWRMufKfnNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV8VI2uLjgMgla7QNZOATwHBcQBvusLL9/uk0EEKxyB2gVAdYirE3nEQKUStPSvFhSAVGhpcVlSkUzSU5q9lwRh0AeZ6i0akxnVMRJ3jxsenPlPCHTazFpJ4sAZw04P2FhrD/ivLeDQb7iwKh1oprvqRNkoC1rDm77by3XW8jGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB5uupGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB5uupGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E841E1F000FF;
	Tue, 13 Oct 2026 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892401;
	bh=PjWzWxM/gXsFyy+xrxfxQJm+7fugIGjdIBbrGoxDtho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dB5uupGimuED5BVoS51WyBNL3bAHxP6FiWVaHb4TGjvuHlkpSOt5dBgqQLC9JbeFc
	 4jhqjN9Oe2UeFvBgeMW43SMT1xJza99+kYWFkQU7f0JwjGOd26G4NFe9wSa8VtfSrh
	 3MPH2nCjdNsndmequ2MpMAqtI/bXcr57nlUHImD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 160/281] namespace: dont reconfigure internal superblocks via remount and umount
Date: Tue, 13 Oct 2026 13:37:56 +0200
Message-ID: <20261013112859.047369040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit d791606bb915a8f27e36657696fd1d9a216c5c08 upstream.

Commit 02587a4af82a ("fs: refuse fspick() on internal superblocks")
blocked fspick() on SB_NOUSER superblocks. But that's not the only way
to reconfigure_super(). mount(MS_REMOUNT) and umount() of the caller's
root without MNT_DETACH. The root of an empty mount namespace is a
nullfs mount and all mount namespaces share that superblock:

  nullfs: fspick: FAIL errno=22 (Invalid argument)
  nullfs: mount(MS_REMOUNT|MS_RDONLY): ok(0)
  nullfs after remount: statfs(/): magic=0x4e554c4c flags=0x21 RDONLY
  nullfs: umount2("/", 0): ok(0)

Refuse both like fspick() does. Only root in the initial user namespace
can do this and nullfs is empty and immutable so the flags don't buy
anything. But they show up in statfs() for the root of every mount
namespace on the host.

Fixes: 9d4e752a24f7 ("namespace: allow creating empty mount namespaces")
Cc: stable@vger.kernel.org # v7.1+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-11-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs_context.c | 4 ++++
 fs/fsopen.c     | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index 23ad66cd94e1..a50584df97be 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -315,6 +315,10 @@ struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 					unsigned int sb_flags,
 					unsigned int sb_flags_mask)
 {
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (dentry->d_sb->s_flags & SB_NOUSER)
+		return ERR_PTR(-EINVAL);
+
 	return alloc_fs_context(dentry->d_sb->s_type, dentry, sb_flags,
 				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE);
 }
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 9d5a7a22b529..ae19e5136598 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -190,9 +190,6 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
-	/* kernel-internal superblocks are nobody's to reconfigure */
-	if (target.dentry->d_sb->s_flags & SB_NOUSER)
-		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {
-- 
2.56.0



