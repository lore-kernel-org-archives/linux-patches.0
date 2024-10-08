Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D832190663;
	Tue,  8 Oct 2024 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390918; cv=none; b=LUj5JHMN7BacO48xk+lWWbLEqPzUqkaHwWaHCa9KytXyfagVHTfEj5uBrYF6l1pf+3FdWPHAt34qk9kiDOeOPNp2kyeWnWaM/UGAPw5/weCeSMBJ1egusVav0csqHegxQLyDhH9DpshJNY5jdiGsdMa8e041a58ETrwmF5VJYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390918; c=relaxed/simple;
	bh=Fuw844+Qb7EUaV1QCjj9aLrOMzboOlm73EEkV6DbOPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=if+uy2ShwqXu/syMXe3a5BDhPFzSPWKoZvvVSQjZne70+JyD8VfWMAqDOa5nkiQuZnjn4Wt8POcMh1a6WsbfMBe/1fPswLwGZ5gQVg/MCaiXCSSOVCURkoNottzQc6aCn6DqQGATJv83zBK7OHhT7n1NZdIclHXNFpyDekIwfSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6j/15NP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6j/15NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74810C4CEC7;
	Tue,  8 Oct 2024 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390917;
	bh=Fuw844+Qb7EUaV1QCjj9aLrOMzboOlm73EEkV6DbOPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6j/15NPKFWDg65EkAuOSWE8FISmlZqJFLX3JKRImGkvTqZs4gscDx18QQ5/n+u6t
	 Doru7TZ1S471GmVS63r7KHjlxO9ctBzKw3MZPiOub0Wq8/FuF1x1akmHIqIB2ebElU
	 uXQqzt4ihjcbLVmtFayIjrtAeTpJ980cWDniD2Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 401/482] smb3: fix incorrect mode displayed for read-only files
Date: Tue,  8 Oct 2024 14:07:44 +0200
Message-ID: <20241008115704.189550706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 2f3017e7cc7515e0110a3733d8dca84de2a1d23d upstream.

Commands like "chmod 0444" mark a file readonly via the attribute flag
(when mapping of mode bits into the ACL are not set, or POSIX extensions
are not negotiated), but they were not reported correctly for stat of
directories (they were reported ok for files and for "ls").  See example
below:

    root:~# ls /mnt2 -l
    total 12
    drwxr-xr-x 2 root root         0 Sep 21 18:03 normaldir
    -rwxr-xr-x 1 root root         0 Sep 21 23:24 normalfile
    dr-xr-xr-x 2 root root         0 Sep 21 17:55 readonly-dir
    -r-xr-xr-x 1 root root 209716224 Sep 21 18:15 readonly-file
    root:~# stat -c %a /mnt2/readonly-dir
    755
    root:~# stat -c %a /mnt2/readonly-file
    555

This fixes the stat of directories when ATTR_READONLY is set
(in cases where the mode can not be obtained other ways).

    root:~# stat -c %a /mnt2/readonly-dir
    555

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -800,10 +800,6 @@ static void cifs_open_info_to_fattr(stru
 		fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_REG;
 
-		/* clear write bits if ATTR_READONLY is set */
-		if (fattr->cf_cifsattrs & ATTR_READONLY)
-			fattr->cf_mode &= ~(S_IWUGO);
-
 		/*
 		 * Don't accept zero nlink from non-unix servers unless
 		 * delete is pending.  Instead mark it as unknown.
@@ -816,6 +812,10 @@ static void cifs_open_info_to_fattr(stru
 		}
 	}
 
+	/* clear write bits if ATTR_READONLY is set */
+	if (fattr->cf_cifsattrs & ATTR_READONLY)
+		fattr->cf_mode &= ~(S_IWUGO);
+
 out_reparse:
 	if (S_ISLNK(fattr->cf_mode)) {
 		if (likely(data->symlink_target))
@@ -1233,11 +1233,14 @@ handle_mnt_opt:
 				 __func__, rc);
 			goto out;
 		}
-	}
-
-	/* fill in remaining high mode bits e.g. SUID, VTX */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+		/* fill in remaining high mode bits e.g. SUID, VTX */
 		cifs_sfu_mode(fattr, full_path, cifs_sb, xid);
+	else if (!(tcon->posix_extensions))
+		/* clear write bits if ATTR_READONLY is set */
+		if (fattr->cf_cifsattrs & ATTR_READONLY)
+			fattr->cf_mode &= ~(S_IWUGO);
+
 
 	/* check for Minshall+French symlinks */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {


