Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ED31DF72C;
	Tue,  8 Oct 2024 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394034; cv=none; b=sJ28LGAJRML7NKW9/PbHCnyvuLUYAxcg1Fggu9Fqh3ONJk1GvM4b0JcOBXQb4P3l9I0Woa5jCg7lBcPfFXTZ5M4I5Q/P2jTr7gtyXJDgTFJ+Oscx2+BUkLb1fcSMj5KEfUyGv4BadeknJFSlmHcTfPAxpAXn5Nu4zWpUKYthZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394034; c=relaxed/simple;
	bh=sHgkpXZ1PqPKI3HD7MWI1qJJDXwDbKVcdkV1LcnptL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrF5b6KxBFzQMU6RUwX0dUp81bP/8JoqAut90VcJN8IWswzQni2uec1YLUQFElityxPxFCGZTyU27oo1cymDYJXegyWWgSxA7nrwH9o3mY097zZ+S96vSTs4ypTtYA6+nYDHPJPSt3HTWT1D0n2NsF4fwcOu0+/r28zJ510AVY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeJsnsVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeJsnsVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19242C4CEC7;
	Tue,  8 Oct 2024 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394034;
	bh=sHgkpXZ1PqPKI3HD7MWI1qJJDXwDbKVcdkV1LcnptL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeJsnsVGdSu7sSIvTPWDrPxgEBhcsnF++ohQ84x4ohgTsvVDcZJ5OB4LjJxzKa6ui
	 RBkm5eS5PinuEwUUSAWeAPV6YX9NODnINF7A76TnA2n/R/jYsaKVo0pLPHuCF4dvph
	 3onht4jrZ1hFteF8BZfIl8741d6XFE3kEDAuLqCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 296/386] smb3: fix incorrect mode displayed for read-only files
Date: Tue,  8 Oct 2024 14:09:01 +0200
Message-ID: <20241008115641.034982165@linuxfoundation.org>
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
@@ -779,10 +779,6 @@ static void cifs_open_info_to_fattr(stru
 		fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_REG;
 
-		/* clear write bits if ATTR_READONLY is set */
-		if (fattr->cf_cifsattrs & ATTR_READONLY)
-			fattr->cf_mode &= ~(S_IWUGO);
-
 		/*
 		 * Don't accept zero nlink from non-unix servers unless
 		 * delete is pending.  Instead mark it as unknown.
@@ -795,6 +791,10 @@ static void cifs_open_info_to_fattr(stru
 		}
 	}
 
+	/* clear write bits if ATTR_READONLY is set */
+	if (fattr->cf_cifsattrs & ATTR_READONLY)
+		fattr->cf_mode &= ~(S_IWUGO);
+
 out_reparse:
 	if (S_ISLNK(fattr->cf_mode)) {
 		if (likely(data->symlink_target))
@@ -1212,11 +1212,14 @@ handle_mnt_opt:
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


