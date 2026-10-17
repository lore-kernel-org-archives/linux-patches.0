Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4A83C6A5C;
	Sat, 17 Oct 2026 17:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257482; cv=none; b=qfxfLWQ3KM07hJ/uEDd+b+LFT/ckPaEZ/xeehrNZdU9EqBGstbUrhGP4sOmTfJzCZ7GkwD691kDZy/weIlCiU2t3NSNR57IZSLFl7TSPNr90NwQKuM4ROf5Y/mfcWLP/aHv2O0MzSfC+MuD5TfSU5PVtK8Bxyd78mHD9S8ynZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257482; c=relaxed/simple;
	bh=KBNEk8ZciJBKn2BE+fJzPyrLm6oQV6D+0a7nhFeiZQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9JSjQjiwgTXAr8m/RKX2ezdxTXn32KAEwHndSBRpfF/U/5XP9eS9L6cdZ5ftdKtDhWJWT/J7pU8DOh0IQlTIhNBlsxpBpMS/GVji3ZW+NWaq21B52XCnHv8kiS9zLnECtm3nf+WsBhGJCimBnFfgXquVmpI6YleTDVjr9uUywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2q90eKZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2q90eKZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082F51F000C4;
	Sat, 17 Oct 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257481;
	bh=UTCGXC07vr7Z8SgTGL93VeiyJKj84H3zJmFSwKcfUaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2q90eKZOoMYOa3l1yJmR7UIScIGWYz4y8UwiCpPIwiehreZIeRmS0dYTRpmM6FZsB
	 NTcaPJ9vxbKqpottqvMoMfIFdOKLvbSeDpXrKs/VCMSUKjqvmhPZ/yt9FGl9PkoEXC
	 hqZMkTUwKEQQquuHC+82pwQ9kIEP7WE+8mXDor44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 0531/1674] fs: refuse fspick() on internal superblocks
Date: Sat, 17 Oct 2026 17:46:43 +0200
Message-ID: <20261017160444.730346787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,6 +191,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const
 	ret = -EINVAL;
 	if (target.mnt->mnt_root != target.dentry)
 		goto err_path;
+	/* kernel-internal superblocks are nobody's to reconfigure */
+	if (target.dentry->d_sb->s_flags & SB_NOUSER)
+		goto err_path;
 
 	fc = fs_context_for_reconfigure(target.dentry, 0, 0);
 	if (IS_ERR(fc)) {


