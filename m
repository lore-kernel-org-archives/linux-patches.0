Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364D41DC1A7;
	Mon, 12 May 2025 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071131; cv=none; b=fGP/NhnPffzcT6lhDnq6PGPHc6UNnhbYr3sxaWx/Yko9dBAI1V98eP0w4EAaw+DpaV85ukzL0p6cqIMuJOifkrZTzQ0/8GDaCdFflOiSOdUbQCDpABwBK4NZH52wMVeDRn8F0rGeF05b3cczIfbOU7jVbbsxOMotc6EF2FPCEmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071131; c=relaxed/simple;
	bh=RYia2EtB3EYH/mDcCnK8fqoMM7Lq3tegvU+eC2Np9ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsNUJ6Mzqt7dx/uVSicwLReT8vAEYYBAJKPp0BqqXh8JzjRVYS3pPKvA26gM9OUXx/A4wlbfB6Jn5FQMIgb0t8rfU392ucXX0xKcQQDJBi6E5tXeDd3oO+h6cJ06eAnPUU8wMREbd8VgeqSCGgXUkrgjt9pv5HCYnq3etR0jlAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdSiWUiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdSiWUiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B82C4CEE7;
	Mon, 12 May 2025 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071130;
	bh=RYia2EtB3EYH/mDcCnK8fqoMM7Lq3tegvU+eC2Np9ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdSiWUiFTmVZjb++mSoHoPG8XyGmmP0S8FDSEw/DEttBGT/13EZdPXUMYEjqDLdWb
	 jfLsp4fD6dN6oA2b21XrL4L2VKr7vZfwlRDsHNUD6y4BUKLbB0Y8qQ7PtNMJBIlEWt
	 qGsgZjTugJaYJhFw+3STN98HHH8FXT3pl+Xg+UYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/54] do_umount(): add missing barrier before refcount checks in sync case
Date: Mon, 12 May 2025 19:30:02 +0200
Message-ID: <20250512172017.657178832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 642baef4d9aaa..27ec6d0a68ff5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -586,7 +586,7 @@ int __legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 		return 0;
 	mnt = real_mount(bastard);
 	mnt_add_count(mnt, 1);
-	smp_mb();			// see mntput_no_expire()
+	smp_mb();		// see mntput_no_expire() and do_umount()
 	if (likely(!read_seqretry(&mount_lock, seq)))
 		return 0;
 	if (bastard->mnt_flags & MNT_SYNC_UMOUNT) {
@@ -1664,6 +1664,7 @@ static int do_umount(struct mount *mnt, int flags)
 			umount_tree(mnt, UMOUNT_PROPAGATE);
 		retval = 0;
 	} else {
+		smp_mb(); // paired with __legitimize_mnt()
 		shrink_submounts(mnt);
 		retval = -EBUSY;
 		if (!propagate_mount_busy(mnt, 2)) {
-- 
2.39.5



