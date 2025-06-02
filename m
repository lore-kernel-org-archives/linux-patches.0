Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C49230981;
	Mon,  2 Jun 2025 14:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874556; cv=none; b=gy2rGWhlQoxG6hM/AZZB7T/9Ehd/tdBEGh/ZnhqemUgL96j6ZzL5lYjVTY5E6UEvlkvX6CHPJn1DAHSn19jMrRMce/7gc6gzsIcOVhElnGGSWokxx892yP7OzF2hH4W0Kt4mGdQ92+yM5e05Ue6nX8K1nInNcfoy7CtxHyUVXeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874556; c=relaxed/simple;
	bh=qzlZ8KlSrcevxiBjlcK4pd1tZhikZOZF/oi5no+O1Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMiw1MxLbao3Ec073Nb+nNfRCNeue0awNoVz/eBtPDgoekuukyh/0DkRN0qewcb4EC0Hbvdv/mzerjHzJlRO2b8Xg4HmkJ7vZSSEZ3phcu8hF3IPiI0JzyOg2Zf1lo846+wQaivLBDRBhVJXATvExn5Vn9Xwf5yJD6ph0fj3kFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMRIjc5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMRIjc5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F77C4CEEB;
	Mon,  2 Jun 2025 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874556;
	bh=qzlZ8KlSrcevxiBjlcK4pd1tZhikZOZF/oi5no+O1Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMRIjc5l5UJzig6veXZhLPXVBAtqKb8uuckjhWb/4J3csakiDzw9PXBJL/aA9NOsk
	 deNJ+spANp5+1DAJBT/OfDuucBmm5nLWobFcpCuglu9Ye/1bL46g25igTwP04UcdB5
	 xkg/mmzHmnKPnvAULTkDF/1gQR6caIgESwueVXc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/204] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon,  2 Jun 2025 15:46:34 +0200
Message-ID: <20250602134258.077341688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 281f08eaba5b9..809ec3acb147c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -569,7 +569,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1588,6 +1588,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



