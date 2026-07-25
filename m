Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0E327703;
	Sat, 25 Jul 2026 06:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784959336; cv=none; b=H8hgK3ZxvBrxYN1T8xh7YDE5p5Kc+CczJKnHEHoJRSA2W3oQn99eJgYUCDmIDj7uyWTwTk2M8v569/Q9AJ5kbnusx0X0KMc/hyn1MliCp1vbmofg6jj/f0sC90mphnauQgf4rOmUxohJwnbQ8lh5sipT1M91IO9imnd3ncXRUfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784959336; c=relaxed/simple;
	bh=ytYAAkbuCAyqTYpJA3+OGV56etOtOzBEUF2sSpL8meI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=bAA53Bkoj2XWrrq/FhoTYdesb1ZFLQ8gmaXQ8OHVHRu7gbBgq2Rs9ZEyXZ4OCL/QivqImHqB8UUr/FU9uAlDp9JpZ/mecYgCZ4AMsTN9NJtb2S/s8KAnOpwPne0jcHnhDm7nbnMFNErv2f0XJGqcdgSTISnQwndK1PhfGzujPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwOe1ND5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwOe1ND5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13691F000E9;
	Sat, 25 Jul 2026 06:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784959334;
	bh=jTQ7MRvDDFxw3pfPXSbUszuLSKmS7xPRcilamo8tLCA=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=nwOe1ND5UtPQpRln2W3LkHpJntl7txpErUZNMUfLGbEqGG29OmLJUgiO6bphHS+lc
	 JRcVnfl/MvWnCCoxQRNMl+OOwuJUfL0/8uTFu4LoAWfh2x7I0FdRjziVSYby006qPY
	 bENPDuk2XtNsbQATGgULcvg3j4ceZ5Nv2qsrwVzY=
Subject: Patch "ext4: fix fd leak in EXT4_IOC_MOVE_EXT cross-sb validation" has been added to the 6.12-stable tree
To: gregkh@linuxfoundation.org,harshit.m.mogalapalli@oracle.com,patches@lists.linux.dev,yun.zhou@windriver.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sat, 25 Jul 2026 08:02:03 +0200
In-Reply-To: <20260725024029.1217577-1-yun.zhou@windriver.com>
Message-ID: <2026072503-jab-tabby-8f6d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ext4: fix fd leak in EXT4_IOC_MOVE_EXT cross-sb validation

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-fix-fd-leak-in-ext4_ioc_move_ext-cross-sb-validation.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-289044-greg=kroah.com@vger.kernel.org Sat Jul 25 04:41:06 2026
From: Yun Zhou <yun.zhou@windriver.com>
Date: Sat, 25 Jul 2026 10:40:29 +0800
Subject: ext4: fix fd leak in EXT4_IOC_MOVE_EXT cross-sb validation
To: <gregkh@linuxfoundation.org>
Cc: <harshit.m.mogalapalli@oracle.com>, <stable@vger.kernel.org>, <patches@lists.linux.dev>
Message-ID: <20260725024029.1217577-1-yun.zhou@windriver.com>

From: Yun Zhou <yun.zhou@windriver.com>

The backport of upstream commit c143957520c6 ("ext4: validate donor
file superblock early in EXT4_IOC_MOVE_EXT") uses a bare 'return -EXDEV'
which is safe upstream because the fd is managed via CLASS(fd) with
automatic cleanup (commit 8152f8201088 ("fdget(), more trivial
conversions")).

However, on 6.12.y the ioctl still uses the traditional fdget/fdput
pattern, so the bare return bypasses fdput(donor) at the mext_out label,
leaking the file reference.

Fix by setting err and using goto mext_out.

Fixes: 74796e886ca3 ("ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT")
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1372,8 +1372,10 @@ group_extend_out:
 			goto mext_out;
 		}
 
-		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
-			return -EXDEV;
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
+			err = -EXDEV;
+			goto mext_out;
+		}
 
 		err = mnt_want_write_file(filp);
 		if (err)


Patches currently in stable-queue which might be from yun.zhou@windriver.com are

queue-6.12/ext4-fix-fd-leak-in-ext4_ioc_move_ext-cross-sb-validation.patch
