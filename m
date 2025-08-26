Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DD92BDC3B;
	Tue, 26 Aug 2025 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207815; cv=none; b=OXxHSy0Q/3r46Ke5vemsZ0YYqvAbafaxRiEspnOVq/tCZgNPWYU0Zv8D5PjGGofJNCccIpB3QzxzIHH1JGkyb9WVXT9HTN2AiY9XULFL26aZJouGsx7f2zYNyMC9KzPV51UFfCcLqWOQhnpFmwrt750Bt8ELXxb6vmLoss3UzlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207815; c=relaxed/simple;
	bh=qZ8cNq5y2K09BLxyvebjhct7sNS8HeVcwJQssQ/bJz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGKQGpBpxYbZfOrzAhS7TZ3XT73yMLDfgDcBcRgOkXeuA4Sppd9ocCfgyjlJJOG7yQPzUpixhDIcj2tFTNKDmE54qactPX7Uftm7KWYi0bsWCswIfOaRzcrJJMJGsv9+MklQEgLZ7ciZgsq/N22ddhu2LJPXs31iCs99lo/szTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs2uOl4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs2uOl4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA56C4CEF1;
	Tue, 26 Aug 2025 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207815;
	bh=qZ8cNq5y2K09BLxyvebjhct7sNS8HeVcwJQssQ/bJz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs2uOl4IwKR/J7cruVPk8jisL+3fRnKoUpundpCKB968CRpo8vqHEVwoQqed3hKiT
	 kYCYNjMigIYIiv7ePeOcALuRlNPSRxoxK1+UFDd7Yivx3l8G+3uyfeNHCl2JX1ViL0
	 m+3oiEifzinDV2acJQ+S15/A2NoXo0ITH1pPR2u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.16 328/457] ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()
Date: Tue, 26 Aug 2025 13:10:12 +0200
Message-ID: <20250826110945.451585411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit 5f1c8965e748c150d580a2ea8fbee1bd80d07a24 upstream.

ovl_create_temp() treats "workdir" as a parent in which it creates an
object so it should use I_MUTEX_PARENT.

Prior to the commit identified below the lock was taken by the caller
which sometimes used I_MUTEX_PARENT and sometimes used I_MUTEX_NORMAL.
The use of I_MUTEX_NORMAL was incorrect but unfortunately copied into
ovl_create_temp().

Note to backporters: This patch only applies after the last Fixes given
below (post v6.16).  To fix the bug in v6.7 and later the
inode_lock() call in ovl_copy_up_workdir() needs to nest using
I_MUTEX_PARENT.

Link: https://lore.kernel.org/all/67a72070.050a0220.3d72c.0022.GAE@google.com/
Cc: stable@vger.kernel.org
Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Tested-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Fixes: c63e56a4a652 ("ovl: do not open/llseek lower file with upper sb_writers held")
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -779,7 +779,7 @@ static int ovl_copy_up_workdir(struct ov
 		return err;
 
 	ovl_start_write(c->dentry);
-	inode_lock(wdir);
+	inode_lock_nested(wdir, I_MUTEX_PARENT);
 	temp = ovl_create_temp(ofs, c->workdir, &cattr);
 	inode_unlock(wdir);
 	ovl_end_write(c->dentry);


