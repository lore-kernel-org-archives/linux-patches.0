Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0B42F6E5;
	Thu, 16 Jul 2026 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212066; cv=none; b=aP2NZvBEMh5YtJVByTlCX4eSpz810Wk4RNqiM07VJpVJ9fD9ghKFNbLylMuZNBB5AKN23fswQVPGNqbH/CEjPVZHOGMo9fg5sW/rzrfGVQ5VGmiClxb3wltCdDJ+oZMf7GPNqZyJFWm834RTRSZMLIglenu5YMF773/DfDBEZrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212066; c=relaxed/simple;
	bh=//zd58Q4LJWFQhCHY8srtQmY8fTS7y6/YPUSDEgYIWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jahm7NdxcvfN/Ds7ootvqrwMOq0ZnGzseMUYav4y7KOKmSX7BInxjLTVe0hEfgXWYFn9B39K1b5bNwRkXIuVBhhcxlyv/L/dxI4CJsmGPj5jXF3Hm1RBn+AuqY/57L0m9C0UMmiJKuQhM1t1bvgegVXXGZacgIRdTwCgCBksVR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDEcjBfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDEcjBfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5441F000E9;
	Thu, 16 Jul 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212065;
	bh=CgcPWdnDW1TUApTTWcn3yGLrOSqoPUDc5tnxFVdTX94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDEcjBfMiF2S/f1dF5FjWRM+COucnvAX0HgqPJXDL0SaDnZ08CWKefczx2T9rRZSR
	 kH3dHP22loyncqTkZtvRUYJwDFzwsbVs/gL+lL9VRDvfxlbVo/mPrE0yNJak80ytRc
	 W7076Im94I4Le6F5shISZijrTi+HSYCuyQ3gAzuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 184/349] smb: client: fix atime clamp check in read completion
Date: Thu, 16 Jul 2026 15:31:58 +0200
Message-ID: <20260716133037.499936454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 0b043279e73880bee21d3b1f221bafda5af1b27e upstream.

cifs_rreq_done() updates the inode atime to current_time(inode) after a
netfs read.  It then preserves the CIFS rule that atime should not be
older than mtime, because some applications break if atime is less than
mtime.  That rule only requires clamping when atime < mtime.

The current check uses the raw non-zero result of timespec64_compare().
It therefore takes the clamp path for both atime < mtime and
atime > mtime.  The latter is the normal case when reading an older file:
the newly recorded atime is newer than the file mtime.  The completion
handler then immediately moves atime back to mtime, losing the access
time that was just recorded.  Userspace tools that rely on atime, such as
stat, find -atime, backup tools or cold-data classifiers, can therefore
see a recently read CIFS file as not recently accessed.

This is easy to miss because the bug is silent: read I/O still succeeds,
no error is reported, and many systems either do not check atime after
reads or mount with policies such as relatime/noatime.  It becomes
visible when a CIFS file has an mtime older than the current time, the
file is read, and the local inode atime is inspected before a later
revalidation replaces the cached timestamps.

Clamp only when atime is actually older than mtime.  This matches the
same atime/mtime rule used when applying CIFS inode attributes.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -288,7 +288,7 @@ static void cifs_rreq_done(struct netfs_
 	/* we do not want atime to be less than mtime, it broke some apps */
 	atime = inode_set_atime_to_ts(inode, current_time(inode));
 	mtime = inode_get_mtime(inode);
-	if (timespec64_compare(&atime, &mtime))
+	if (timespec64_compare(&atime, &mtime) < 0)
 		inode_set_atime_to_ts(inode, inode_get_mtime(inode));
 }
 


