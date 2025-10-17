Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6B723EAA7;
	Fri, 17 Oct 2025 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716546; cv=none; b=iKmqTiiMj10dZdcsm6QfGWYrJEwa1sU8E9igHY4rLNK2cCC2hVS5H2gvn9+rsh8bho94rfgx4CaA9mFKCKwop85zgtk0IFYqa9GbU/YYFw9F0MbiRcoTvl6Z/MX1wD2gWecytMBTdOjbyBsXnMi84eSiwvXxdGut54LJ3XUmFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716546; c=relaxed/simple;
	bh=0LYGgC5Gfrl65/0BCMFy87ZFfxU+YowaCCfvii0ItVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eno6bkK0g0vTwoGbM/zx9GKgVfQFDaLeI1KnfnmPeMbtufM8kdC28gJh1UFKzTwoB2dGlgI2PFcqTVr84MmWLPDkTyYEXdhu0yPUHRbQ2R7NmijZlrG38XQ9s7GY/S6lpok2NgIjQDdFhorNvROKPxO/kNVhPjJQUkmFyPBmTd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUtlahxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUtlahxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410F8C4CEE7;
	Fri, 17 Oct 2025 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716546;
	bh=0LYGgC5Gfrl65/0BCMFy87ZFfxU+YowaCCfvii0ItVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUtlahxweskBnrpyd+uioGX4UTIt6LU+qDEUGDtJgyLoIswtktwUjMF5jcGmyNVo7
	 KuzjZbZCAACEzQINTKm/1jVy4bo6Jp/WjydrVLNirGx/CkmBKG6EnBIqJID0pmYNyf
	 a/fN48krjzljy3GnIs9UFVHzZ1n2zbyNDrtWkWQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/276] Squashfs: reject negative file sizes in squashfs_read_inode()
Date: Fri, 17 Oct 2025 16:55:22 +0200
Message-ID: <20251017145150.825311698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b ]

Syskaller reports a "WARNING in ovl_copy_up_file" in overlayfs.

This warning is ultimately caused because the underlying Squashfs file
system returns a file with a negative file size.

This commit checks for a negative file size and returns EINVAL.

[phillip@squashfs.org.uk: only need to check 64 bit quantity]
  Link: https://lkml.kernel.org/r/20250926222305.110103-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20250926215935.107233-1-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d580e5.a00a0220.303701.0019.GAE@google.com/
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -193,6 +193,10 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*


