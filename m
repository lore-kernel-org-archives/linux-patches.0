Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C21E0B78;
	Tue,  8 Oct 2024 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393958; cv=none; b=aydAncKRO0Fh35kfHW0X2dw6otCbhzXvpwrlkxjgWRlE8yOxPdB74MSuC19xXgVeqqOt9Su54SwwFqZj7Jb1IDBzv2tTFp+/4/9OhgB64iDifPexcNgR4MzS4c5C86O9OaROprSldOAAZnjKjyL6pLxFi+pk60hYKbcV+j8dVfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393958; c=relaxed/simple;
	bh=HNwBem7igIlV1pEUu8KVXJ9lXIp+Nkz3YgIB5O3yGB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwulTu/bfR66g4LGHFpyDhd11JI/Heb7H/wXjQx0rP0fc5aqSb2S1BdoWqCo2NSVYU7oVCsWQXVy1+ax5ymJC1yG8QgvJ2fpfyVc+6nxBVSWYusTPWTxasqevsXttFSM56fRWAKWaeRQF1+Hmh/QMzqOVyvHSbPDChC5VXUqOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/Lh5zsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/Lh5zsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1D2C4CECE;
	Tue,  8 Oct 2024 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393958;
	bh=HNwBem7igIlV1pEUu8KVXJ9lXIp+Nkz3YgIB5O3yGB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/Lh5zsSe5RbIGG627L4/jIsNcBnNS2SA0Qc0IKn8uEpj07nqoU+LYD77bVTuDuGH
	 AyOIbVZWtyNhcxDTTanJHdWnDBnyXs2mXs2JZbEWpK5lpYSSA+FFA3MLBMOKie/thc
	 6fTMLZtSFHB5BF+uZ6n0+AGvirDpKXuV1QEmF0s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 305/386] cachefiles: fix dentry leak in cachefiles_open_file()
Date: Tue,  8 Oct 2024 14:09:10 +0200
Message-ID: <20241008115641.388345651@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit da6ef2dffe6056aad3435e6cf7c6471c2a62187c upstream.

A dentry leak may be caused when a lookup cookie and a cull are concurrent:

            P1             |             P2
-----------------------------------------------------------
cachefiles_lookup_cookie
  cachefiles_look_up_object
    lookup_one_positive_unlocked
     // get dentry
                            cachefiles_cull
                              inode->i_flags |= S_KERNEL_FILE;
    cachefiles_open_file
      cachefiles_mark_inode_in_use
        __cachefiles_mark_inode_in_use
          can_use = false
          if (!(inode->i_flags & S_KERNEL_FILE))
            can_use = true
	  return false
        return false
        // Returns an error but doesn't put dentry

After that the following WARNING will be triggered when the backend folder
is umounted:

==================================================================
BUG: Dentry 000000008ad87947{i=7a,n=Dx_1_1.img}  still in use (1) [unmount of ext4 sda]
WARNING: CPU: 4 PID: 359261 at fs/dcache.c:1767 umount_check+0x5d/0x70
CPU: 4 PID: 359261 Comm: umount Not tainted 6.6.0-dirty #25
RIP: 0010:umount_check+0x5d/0x70
Call Trace:
 <TASK>
 d_walk+0xda/0x2b0
 do_one_tree+0x20/0x40
 shrink_dcache_for_umount+0x2c/0x90
 generic_shutdown_super+0x20/0x160
 kill_block_super+0x1a/0x40
 ext4_kill_sb+0x22/0x40
 deactivate_locked_super+0x35/0x80
 cleanup_mnt+0x104/0x160
==================================================================

Whether cachefiles_open_file() returns true or false, the reference count
obtained by lookup_positive_unlocked() in cachefiles_look_up_object()
should be released.

Therefore release that reference count in cachefiles_look_up_object() to
fix the above issue and simplify the code.

Fixes: 1f08c925e7a3 ("cachefiles: Implement backing file wrangling")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240829083409.3788142-1-libaokun@huaweicloud.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/namei.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -594,14 +594,12 @@ static bool cachefiles_open_file(struct
 	 * write and readdir but not lookup or open).
 	 */
 	touch_atime(&file->f_path);
-	dput(dentry);
 	return true;
 
 check_failed:
 	fscache_cookie_lookup_negative(object->cookie);
 	cachefiles_unmark_inode_in_use(object, file);
 	fput(file);
-	dput(dentry);
 	if (ret == -ESTALE)
 		return cachefiles_create_file(object);
 	return false;
@@ -610,7 +608,6 @@ error_fput:
 	fput(file);
 error:
 	cachefiles_do_unmark_inode_in_use(object, d_inode(dentry));
-	dput(dentry);
 	return false;
 }
 
@@ -653,7 +650,9 @@ bool cachefiles_look_up_object(struct ca
 		goto new_file;
 	}
 
-	if (!cachefiles_open_file(object, dentry))
+	ret = cachefiles_open_file(object, dentry);
+	dput(dentry);
+	if (!ret)
 		return false;
 
 	_leave(" = t [%lu]", file_inode(object->file)->i_ino);


