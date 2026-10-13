Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7A71990C7;
	Tue, 13 Oct 2026 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893161; cv=none; b=lrGUrLKP4WMglYdW1nwReylRDk6yvqgnZZhILqzvnS4Xpe2BIUgAHfOROuheBHV6gvYLDWgBIbINbMUAez9vC+qt7oOAbxYeshfMZiZWkFqaZ4bd6qP6reRhUxf1GLEPQIQ5SyYkxzsriXB12b3HdLhRff7okLhlYeuacSZQpQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893161; c=relaxed/simple;
	bh=n5lSst/fKjPN9GB2fr23i8pZXa+i61BDPjmSrk7rDAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtb1CDChQQhH9HKm7dArtUQiCU0Cpf6Ri8sqQS/LEig/jTVZWVXdT5cotJqxWSPdcvHa20fVGT7Utsq5S0HKFmHFuL1pkwB6hv7ZVbvkMuDf3lyi4D/Qg5HdOj4WSOVrguil3n3ICA1V14In/frjjv/Rtpb5g2CHnUs1HQepn00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krZALOkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krZALOkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE05A1F000FF;
	Tue, 13 Oct 2026 12:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893160;
	bh=iC6YlVAeOnsC8pIuqsv4NSY95J+xXTAlLaYhdVnI1VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krZALOkxHoTogPpmvKVM3WSD/yW03VWkFVbI+YL/4sRNBu6bnscgx+X/5+W5dLEXH
	 UpZ7oKgAW4AMSFPhQrsjJCKWxdNa4flA4wNqlhUXFZsErf9fAM433QIWTJEWfP9tLL
	 9iIR8D1NjTTV160XtuJdzXevA6HH+ADcj1UCrjac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 133/621] fs: refuse fspick() on internal superblocks
Date: Tue, 13 Oct 2026 13:32:08 +0200
Message-ID: <20261013112924.014212412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


