Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3EA2FA658;
	Tue, 17 Jun 2025 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179111; cv=none; b=IiwwSFB2Bel6fjeumb0XC+mZgba1wWFnFdXCIF6s5M8gygDxTQPsjjFenVl+kaDsC5oc5Jz6Lv1c0QLEJy2m9pNkqAaFAgpx+4ZWIETNxUfGl5G/qox6B+TmA9qbZuPoQwkViHf6/4YG0IppgJa+c+UibkXnXdeP2jyWKTPZSHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179111; c=relaxed/simple;
	bh=0P92VuA0gmOjHEsbbbgnjP/j/C5fy3zaq7lGNE9j3Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMVhAK/QZvNjYev6ByJZO7yxqzZKdvJIK8NC4brxX7tUxVLp3MRRH04UCDxrHdSwuSZvze3V9+Se0AvK+3fn4loJt92G082tKnZDw7RcNE/Il2a6VlJbiY6QHaIo3j9q/hkanKOi44G0A65BnXX81F3nwsGfyRPtMeENvma47c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpgUZ9oZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpgUZ9oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1EAC4CEE3;
	Tue, 17 Jun 2025 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179111;
	bh=0P92VuA0gmOjHEsbbbgnjP/j/C5fy3zaq7lGNE9j3Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpgUZ9oZCNVfH89+g/6I4VNjy4/PCVuX99B3LbxZQQ5seuI20oM/5qwFPz19yDoNY
	 8s8WvUEHVxatfJYVVC7Gf15iaFNSeeaqHIt2XlgCyVDBGLOcKoqC4QcVbRqMWEEM+N
	 KJfmZ2z967GXvstoYUHvZI42PtSfq7+teLod5JNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 652/780] finish_automount(): dont leak MNT_LOCKED from parent to child
Date: Tue, 17 Jun 2025 17:26:00 +0200
Message-ID: <20250617152518.026292035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bab77c0d191e241d2d59a845c7ed68bfa6e1b257 ]

Intention for MNT_LOCKED had always been to protect the internal
mountpoints within a subtree that got copied across the userns boundary,
not the mountpoint that tree got attached to - after all, it _was_
exposed before the copying.

For roots of secondary copies that is enforced in attach_recursive_mnt() -
MNT_LOCKED is explicitly stripped for those.  For the root of primary
copy we are almost always guaranteed that MNT_LOCKED won't be there,
so attach_recursive_mnt() doesn't bother.  Unfortunately, one call
chain got overlooked - triggering e.g. NFS referral will have the
submount inherit the public flags from parent; that's fine for such
things as read-only, nosuid, etc., but not for MNT_LOCKED.

This is particularly pointless since the mount attached by finish_automount()
is usually expirable, which makes any protection granted by MNT_LOCKED
null and void; just wait for a while and that mount will go away on its own.

Include MNT_LOCKED into the set of flags to be ignored by do_add_mount() - it
really is an internal flag.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 5ff9d8a65ce8 ("vfs: Lock in place mounts from more privileged users")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mount.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index 6904ad33ee7a3..1a3136e53eaa0 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -65,7 +65,8 @@ enum mount_flags {
 	MNT_ATIME_MASK = MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME,
 
 	MNT_INTERNAL_FLAGS = MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL |
-			     MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED,
+			     MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED |
+			     MNT_LOCKED,
 };
 
 struct vfsmount {
-- 
2.39.5



