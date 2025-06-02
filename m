Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9E51FE45A;
	Mon,  2 Jun 2025 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875755; cv=none; b=EuuXK0LLYwGC7kt+NxPa1fYELdmwBz6pAdxfJ3VJQ8QBLlARq4ost5AgJHgRDOENHwVFAwxTbvb+bTQkGcQqal291whVjeVAMG2C7jMGffAbGQx6GBQdwor+vcb71xScljC5NvLHMlCUa97ZcfxZax84DMD8e8q1wxQhzNyeDyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875755; c=relaxed/simple;
	bh=tjTeeSlZ6O/5nmLGXNLHgZANQkXTetrW7kqhbsyNEf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWd52rWjGeH5a98cdYWS++HXgVHpuUNI5WFBOZqV0sV6WcqUsVVn6K5i/0QohaYSDlrnYc9AkAgNbF249pBEoaBIEz30NEwpyP6Ohm/B0i9DcaWM+iYC8vxRDAKb8z+0rGHdniftBnfGmtHnZnzZe4jklxOH1AbJbttC3ko93YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShPiDQJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShPiDQJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4A8C4CEF0;
	Mon,  2 Jun 2025 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875755;
	bh=tjTeeSlZ6O/5nmLGXNLHgZANQkXTetrW7kqhbsyNEf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShPiDQJQx447dsfgqthCRu2tAHC8bOY7xxa9LNQU68dqXKWeMH44XV3JwxcxqDOq5
	 xlB1sZXCxBA9CMYx/EQA/SXD4c4gXWsUFtUcouBEz9HgVuSSK9XcLGcVyofFTR9tzS
	 u072QIaRPzr9/2gEQCYPeBoquEHqhvi+/aAXxZUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/270] __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock
Date: Mon,  2 Jun 2025 15:48:39 +0200
Message-ID: <20250602134316.877556576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e46267e7d29d1..869cc6e06d889 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -572,12 +572,8 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
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



