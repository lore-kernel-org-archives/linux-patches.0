Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D674F4CEB;
	Tue, 13 Oct 2026 11:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892382; cv=none; b=LgeTzK1e88a3i1fk14fZMbycMxqHJ9ZVoTIT6QRP0J0py3GrnwIME8FVWMFKGEowULj4e9Ml3O1/245eZrxUs3KcrcY67dE3ZOzQcyoFU2CLLYItopgwOoodaUKeRSyuGszghIX/dOk1r4SZ/ZQmayX3/nrkrUZj9b2zOMDSqyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892382; c=relaxed/simple;
	bh=Eai4+5jjepUsx8X1fhaUdRnammiQ5xacbQvSPglGO8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2FSyn5gsIb1eMx+QReJ6o5s6nHwh/clQMhUi1IbEwd5ggpdLUwwNiIgb7+kfhhyCgP30Y9amB47mP0kCkeFJGVZ0MKndzawDiunQfX/6nSU/0Vvr2zHxH1M6JVWEeqM8U/WiLibct1tYvWkb4WwEkr/ULeOfO+RjwFpkdjqOJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uX41yBZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uX41yBZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE0D1F000FF;
	Tue, 13 Oct 2026 11:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892380;
	bh=YI+gbq10oVVETeey1+SzZawoWpv1wDSMP5mdS3Lh1eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uX41yBZwnLHevZPFq+h3DBhMCWeG7IkVYC/+enrqpjewvFWcF9BpxOq3kSqA/yJYh
	 3CP1ICc8Bk2K/fPXEA7jywBi++CMjYLXXK4/JnruIhTtO3kND/6g7fw7oFWoPK4nTy
	 XERO2ecl1I3sDPgH69D26vHMde5RV4cVjGR6ChTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 153/281] fs: refuse fspick() on internal superblocks
Date: Tue, 13 Oct 2026 13:37:49 +0200
Message-ID: <20261013112858.874345024@linuxfoundation.org>
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

commit 02587a4af82adccaef8e3b3624b4e7f1c401632d upstream.

There's a few instances where a internal superblock is reachable by
fspick(). Block that. graft_tree() and fsmount() already refuse them.
fanotify refuses mount and superblock marks on them for the same reason.

Fixes: cf3cba4a429b ("vfs: syscall: Add fspick() to select a superblock for reconfiguration")
Cc: stable@vger.kernel.org # v5.2+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-6-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fsopen.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -190,6 +190,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (target.dentry->d_sb->s_flags & SB_NOUSER)
+		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {


