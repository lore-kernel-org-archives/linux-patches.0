Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BAE168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E76C433C7;
	Wed, 20 Sep 2023 12:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214047;
	bh=moYdV/CoGZkRXjIkvT6nRMI2vzS6kRMzQcj/scq4gvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snnvSFVyiO1fhvVmNZVxkszWDD+Fj0au3sR2cOVey8awXHyVf2c/QSShxqsau7t85
	 /PXMxsfCkKiWr8KbCTbMT4txez3N7gxZvQoGQ3MZpQDsB8LtEbIIc2Xr3yMCVJ3Oo0
	 nOooXAZWmIRYVo4plEqNb90Y49PBf/0MfbKPucFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruiwen Zhao <ruiwen@google.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 093/110] ovl: fix failed copyup of fileattr on a symlink
Date: Wed, 20 Sep 2023 13:32:31 +0200
Message-ID: <20230920112833.906447027@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Amir Goldstein <amir73il@gmail.com>

commit ab048302026d7701e7fbd718917e0dbcff0c4223 upstream.

Some local filesystems support setting persistent fileattr flags
(e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
Some of those persistent fileattr flags are reflected to vfs as
in-memory inode flags (e.g. S_NOATIME).

Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lower file
as an indication that a the lower file may have persistent inode fileattr
flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.

However, in some cases, the S_NOATIME in-memory flag could be a false
indication for persistent FS_NOATIME_FL fileattr. For example, with NFS
and FUSE lower fs, as was the case in the two bug reports, the S_NOATIME
flag is set unconditionally for all inodes.

Users cannot set persistent fileattr flags on symlinks and special files,
but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL fileattr
flag are inheritted to symlinks and special files from parent directory.

In both cases described above, when lower symlink has the S_NOATIME flag,
overlayfs will try to copy the symlink's fileattrs and fail with error
ENOXIO, because it could not open the symlink for the ioctl security hook.

To solve this failure, do not attempt to copyup fileattrs for anything
other than directories and regular files.

Reported-by: Ruiwen Zhao <ruiwen@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217850
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: <stable@vger.kernel.org> # v5.15
Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -583,7 +583,8 @@ static int ovl_copy_up_inode(struct ovl_
 	if (err)
 		return err;
 
-	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
+	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
+	    (S_ISREG(c->stat.mode) || S_ISDIR(c->stat.mode))) {
 		/*
 		 * Copy the fileattr inode flags that are the source of already
 		 * copied i_flags


