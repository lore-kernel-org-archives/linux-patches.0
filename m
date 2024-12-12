Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513F217F34;
	Thu, 12 Dec 2024 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018082; cv=none; b=W5oWY2cW1B9V8Dstn3ZwVL19eEWi/bu9EDxIG3qw1qhWs6yjFPRRshRzXxYcvCJCkpvz1Qw1ahz4gAhxhCK1zz51RxR4LRTLAXC2ybiwDjDsPJB1Ku0n8fG7OnjkqvzaHU90FX1qWFqtvXP0AaczZxnLJtlppFFoWWSnjdOIe7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018082; c=relaxed/simple;
	bh=8JvFLS4Y+T6X3S37rx5mseXiE2t2Lhz5ETD705YPeo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY/wrRbMx5X+AwE0TfqdDibLwzhwSYYIb8b4LTq79+Njap1XfjXXk+sx6EDOIV9SXZWL9/kB+PFEEfEOO9dy0V1ZmNJftrFsKyiIQsI4QCpFG/iD/DbPHAy8RGik6F+78FqwRSlntmg/zKN45bJNbPY+ju5O90oMhDYRNsU1eRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUl9mYFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUl9mYFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D0C4CECE;
	Thu, 12 Dec 2024 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018082;
	bh=8JvFLS4Y+T6X3S37rx5mseXiE2t2Lhz5ETD705YPeo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUl9mYFfhDkxrN3ClvUN8HPhhtejopM+uS+YHahjIGzdAEZDvpuN9Bl9K2sC0vYog
	 gG0V/Mi6ICDIJf26VZIO2bI2pmKQkVHNBGMXxs9aCDC/f+KEIFNXdHLeJJ3Q6UIL5U
	 UmnWfuHR5B6cbUQ0/FsONy+V2+SuiglMJajEqM3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 162/356] fs/smb/client: cifs_prime_dcache() for SMB3 POSIX reparse points
Date: Thu, 12 Dec 2024 15:58:01 +0100
Message-ID: <20241212144251.037259124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralph Boehme <slow@samba.org>

commit 8cb0bc5436351de8a11eef13b7367d64cc0d6c68 upstream.

Spares an extra revalidation request

Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/readdir.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -71,6 +71,8 @@ cifs_prime_dcache(struct dentry *parent,
 	struct inode *inode;
 	struct super_block *sb = parent->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	bool posix = cifs_sb_master_tcon(cifs_sb)->posix_extensions;
+	bool reparse_need_reval = false;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int rc;
 
@@ -85,7 +87,21 @@ cifs_prime_dcache(struct dentry *parent,
 		 * this spares us an invalidation.
 		 */
 retry:
-		if ((fattr->cf_cifsattrs & ATTR_REPARSE) ||
+		if (posix) {
+			switch (fattr->cf_mode & S_IFMT) {
+			case S_IFLNK:
+			case S_IFBLK:
+			case S_IFCHR:
+				reparse_need_reval = true;
+				break;
+			default:
+				break;
+			}
+		} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+			reparse_need_reval = true;
+		}
+
+		if (reparse_need_reval ||
 		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
 			return;
 


