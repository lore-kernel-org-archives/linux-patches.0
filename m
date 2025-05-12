Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8901A08CA;
	Mon, 12 May 2025 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072216; cv=none; b=YqDOX23F/hFAq87E6pBESerall354C/M8YqG+KKBPfjZ8dJ5wArG1q30k+Pq/mchx9JXmAjUqME/2EYXRsCoG8GHnLwuz99jFmnbIppz0BMVfyBVd+OmUFN9IDpndyMvSP0NEjkAIPiw+2HVM0f27KVZFzMjLZm6XAiEvsiWZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072216; c=relaxed/simple;
	bh=owYdZD0IANjbladgwIX2SAbUeNy9vB3eQDJvk+ySDFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxo9DKnxqvSczepISK9qmWs9roepZFve7TDmiAXRDjCVxFUIIKHnxue0MAton0bv3fZ9XHc+jFFacgzI1nNtUYxiMrNSy6k6iHGP1hR6ecZQ8Q1CzbFh79QTDYxNa+bp+Te3wG1YwcniJQCji8q/R7LJ1ZtuFdsYqYgTGEbOFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAsTHLoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAsTHLoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA1EC4CEE7;
	Mon, 12 May 2025 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072216;
	bh=owYdZD0IANjbladgwIX2SAbUeNy9vB3eQDJvk+ySDFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAsTHLoNslKpMWhCu7WJ9wyx1EXSj0DtVl/58/xKHBKWLJHehGGI9DjbFu94rY1No
	 d/UdTs/9T6Pu21aZOd9thW228YsMvFxMANV4ssAKvuZvk5gS0wbq01+6bsJ0a+XuvK
	 RNCzjHuW7wSdIuapZzeCLqTM/dLN6ZhtfROnCpdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 171/197] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon, 12 May 2025 19:40:21 +0200
Message-ID: <20250512172051.347069154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 65781e19dcfcb4aed1167d87a3ffcc2a0c071d47 ]

do_umount() analogue of the race fixed in 119e1ef80ecf "fix
__legitimize_mnt()/mntput() race".  Here we want to make sure that
if __legitimize_mnt() doesn't notice our lock_mount_hash(), we will
notice their refcount increment.  Harder to hit than mntput_no_expire()
one, fortunately, and consequences are milder (sync umount acting
like umount -l on a rare race with RCU pathwalk hitting at just the
wrong time instead of use-after-free galore mntput_no_expire()
counterpart used to be hit).  Still a bug...

Fixes: 48a066e72d97 ("RCU'd vfsmounts")
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 280a6ebc46d93..5b84e29613fe4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -778,7 +778,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1956,6 +1956,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



