Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59FE29B78F;
	Tue, 11 Nov 2025 01:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824029; cv=none; b=LjHGCXlIOTWfK+gKzA9Wz/TJMYMs7MjNb/8wACFmuWBb1Yhg3ckdop7L5b4yIcvkxmgYiAqd2dwOl3jKp/SDW70vpkJzYHB0vwcam7hE+rVBnb0Ks6a4Gq5Fv+VhaGOZUV9HlfKP78/ti9Px8RF6QVDpK0rnPqDub288Y39ydDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824029; c=relaxed/simple;
	bh=A72ECAJChx5QXODf9sAgnD6SwPtSfTug/a05UMGyHMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbVbjyNcclg25UiIIO7+l7gqUs3fLpDnMI5Vbl0HC4jnGOJR21XOiU6AvfDGZkRr5rBhYds8bEFDm/jZhYO7BE0+Rth+0Jwrd09ysQ/FbSWK4YQaPBZDvYWNXfK+Foxc+jNoaiRrHsntp/gi3SsBW41uovs30ql5bGrHbsTlvyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoGugIpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoGugIpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522D5C116B1;
	Tue, 11 Nov 2025 01:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824029;
	bh=A72ECAJChx5QXODf9sAgnD6SwPtSfTug/a05UMGyHMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoGugIpUDUBV00xgp6EgidU8vjVWCepzmnDowhX2koi55HcbX/aL49fEpVN8WEkSW
	 V2ketk4OnRq/7yDSrOVEoDsWjuiI6tR5ghs7BlssQMbxL8hAQ5L8q7pZkQ+D6+e6rM
	 iHNOqeYbDLQ+do1U6LjF32cxFlxc8VQKVJRKOq28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 423/849] move_mount(2): take sanity checks in beneath case into do_lock_mount()
Date: Tue, 11 Nov 2025 09:39:53 +0900
Message-ID: <20251111004546.667204668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d29da1a8f119130e6fc7d5d71029d402dabe2cb0 ]

We want to mount beneath the given location.  For that operation to
make sense, location must be the root of some mount that has something
under it.  Currently we let it proceed if those requirements are not met,
with rather meaningless results, and have that bogosity caught further
down the road; let's fail early instead - do_lock_mount() doesn't make
sense unless those conditions hold, and checking them there makes
things simpler.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c8c2376bb2424..fa7c034ac4a69 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2785,12 +2785,19 @@ static int do_lock_mount(struct path *path, struct pinned_mountpoint *pinned, bo
 	struct path under = {};
 	int err = -ENOENT;
 
+	if (unlikely(beneath) && !path_mounted(path))
+		return -EINVAL;
+
 	for (;;) {
 		struct mount *m = real_mount(mnt);
 
 		if (beneath) {
 			path_put(&under);
 			read_seqlock_excl(&mount_lock);
+			if (unlikely(!mnt_has_parent(m))) {
+				read_sequnlock_excl(&mount_lock);
+				return -EINVAL;
+			}
 			under.mnt = mntget(&m->mnt_parent->mnt);
 			under.dentry = dget(m->mnt_mountpoint);
 			read_sequnlock_excl(&mount_lock);
@@ -3462,8 +3469,6 @@ static bool mount_is_ancestor(const struct mount *p1, const struct mount *p2)
  * @to:   mount under which to mount
  * @mp:   mountpoint of @to
  *
- * - Make sure that @to->dentry is actually the root of a mount under
- *   which we can mount another mount.
  * - Make sure that nothing can be mounted beneath the caller's current
  *   root or the rootfs of the namespace.
  * - Make sure that the caller can unmount the topmost mount ensuring
@@ -3485,12 +3490,6 @@ static int can_move_mount_beneath(const struct path *from,
 		     *mnt_to = real_mount(to->mnt),
 		     *parent_mnt_to = mnt_to->mnt_parent;
 
-	if (!mnt_has_parent(mnt_to))
-		return -EINVAL;
-
-	if (!path_mounted(to))
-		return -EINVAL;
-
 	if (IS_MNT_LOCKED(mnt_to))
 		return -EINVAL;
 
-- 
2.51.0



