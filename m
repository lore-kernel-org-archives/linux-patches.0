Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A75D33D6F8;
	Tue, 13 Oct 2026 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895927; cv=none; b=SWzWvyl74lf+A+//j5dZa1NwmC2IE5RuB2hXbY6UbJ1xKixr2IcYtPnj6MZV1Od2pTriCno/hoinyoiUgI8fq/YAnNqbD9IbNMNIjj7lq/8utBnfWBAaV31dFFem6cNX1MAhBARumFErom64Bm67d602NSyFl+NYIhVbr5Dqb50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895927; c=relaxed/simple;
	bh=O9Mr5c/8OFVCRM/92Blg9T7sQqodk7o8jwYe10R7rr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCa6gcnk1S/sytDvxfV594qTNRPl0dkKnOvtL2gKiVBFn0OnHu5KJV0pnOHHXTiRx/mSWlrpBFrlCuIVSWq/TwLsaUTAHLcczkfovpkBzAu44fRxwtwEpamlMNWx65fuL9Das+DQIxQPrMAnVwF17MSkUJBKn7fThDn4NXWR7MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfJ9zdkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfJ9zdkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F6D1F000FF;
	Tue, 13 Oct 2026 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895925;
	bh=3FrWFGt6lhe0HePU/v2kqDqTlbzjtg8hbgJxt7y+Kdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfJ9zdkpT5y0Mq3WwPx/62qwZWePiFZ0r9645+5/S5FuFPMp1J+yyglL7FuCo/9Ro
	 HD6ETNGqORX38XSaZnb0tjqC1tjX/YeUuAiVf8lK+RAkuyHp/PRSYI5rwxsp0bt8rI
	 n7QSYelF6eMy46tovn5HWkI9cHDwNEiudZm3Yy1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 439/497] fs: refuse fspick() on internal superblocks
Date: Tue, 13 Oct 2026 13:40:06 +0200
Message-ID: <20261013112918.302757628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


