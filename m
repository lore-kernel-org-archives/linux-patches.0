Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549BC29B764;
	Mon, 12 May 2025 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073092; cv=none; b=TmDhyh50nn0NIwOydHe6puZJukcIdGZ6DkSJbj0F8OPqwZ/XtPW2jQ1vOM6V4EeknbZN9fWHED2INat/V0d804qUyo+osbbNYXDXQJubwp4Ik+316+xJCRckYXwAfiljDcFTeNuD6oK9L1/6NEs7zOV0HfmqpAa7/26lDbLprfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073092; c=relaxed/simple;
	bh=RMJNKyIKw876za9y8z2vgxq/gPNbJahPj+b6V8ycI8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ad7GtLU93Plu4cMBFD5loBD1hp7VDDGrZ7RYE/MhGWrbGIbO/4R+VszT0WqoyR+PtP3nNGNjcd6IPyoD+nPObnDcoguFdb7zzqTl8PTPT9OUdZihQXOnvo4OqTxj4ayQOQkZx0eG44RW5eSlCK2k3YzSOo1ByNz3fiboulQzMAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPy4xS7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPy4xS7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64212C4CEE9;
	Mon, 12 May 2025 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073092;
	bh=RMJNKyIKw876za9y8z2vgxq/gPNbJahPj+b6V8ycI8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPy4xS7BssRQcb+v46A+5H+FAkyUNQBVN+TF0+jQbA4E+2ro+wtV70t4rOn8bqR8l
	 SeLAxmGuXtS8ccFC2nTDLdofLMI26IsB7UU4iYgJMVP2mf6AN2LfaJvH4Bc9tUK0im
	 Qr+MyVOLpz7KU/wcQx31GVLp9yl9hawsZxRChO1iXrQOiDVwbhPEW03N3jYmzY3gEB
	 U0JaU90VGfylSrUrpcXaairV24vTIFTVn8ipemsPTpgIHWb290zD3hn/cnw01osaPS
	 kghM4uujin1a8C3mAwCxeGrEJ4sK0GNas2xKUeuCJKGRRdLj8Ot11wMCkR3Jqc5Hng
	 l6qbZZelLblqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 11/11] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon, 12 May 2025 14:04:26 -0400
Message-Id: <20250512180426.437627-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180426.437627-1-sashal@kernel.org>
References: <20250512180426.437627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.28
Content-Transfer-Encoding: 8bit

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
index bd601ab26e781..28727a1b4b118 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -750,12 +750,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 	smp_mb();			// see mntput_no_expire()
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

