Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A42EAEA;
	Fri, 24 Nov 2023 18:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1C0DXjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B4C433C8;
	Fri, 24 Nov 2023 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852222;
	bh=Mu9w67G/hVG5FCjiLPFJ1WT0XHjLYicHOdS14QGfmI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1C0DXjFEzGsFQ7gwMjPJsacPAcbjsdmduzOpilEe/T82N7xZ69XvRyTh7LGBhSKn
	 swFLdUFjlqJ4jR/pVCT1Gv7xe7902+Q0E/y9OSnXAlU7RMyorxvfyt4pwAeutWZpnc
	 mA7Z/GReOfu0G2sFWNRhabXZZSXcKIPSL56Ce634=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 268/372] smb3: fix creating FIFOs when mounting with "sfu" mount option
Date: Fri, 24 Nov 2023 17:50:55 +0000
Message-ID: <20231124172019.412644058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 72bc63f5e23a38b65ff2a201bdc11401d4223fa9 upstream.

Fixes some xfstests including generic/564 and generic/157

The "sfu" mount option can be useful for creating special files (character
and block devices in particular) but could not create FIFOs. It did
recognize existing empty files with the "system" attribute flag as FIFOs
but this is too general, so to support creating FIFOs more safely use a new
tag (but the same length as those for char and block devices ie "IntxLNK"
and "IntxBLK") "LnxFIFO" to indicate that the file should be treated as a
FIFO (when mounted with the "sfu").   For some additional context note that
"sfu" followed the way that "Services for Unix" on Windows handled these
special files (at least for character and block devices and symlinks),
which is different than newer Windows which can handle special files
as reparse points (which isn't an option to many servers).

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifspdu.h |    2 +-
 fs/smb/client/inode.c   |    4 ++++
 fs/smb/client/smb2ops.c |    8 +++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2570,7 +2570,7 @@ typedef struct {
 
 
 struct win_dev {
-	unsigned char type[8]; /* IntxCHR or IntxBLK */
+	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO*/
 	__le64 major;
 	__le64 minor;
 } __attribute__((packed));
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -567,6 +567,10 @@ cifs_sfu_type(struct cifs_fattr *fattr,
 			cifs_dbg(FYI, "Symlink\n");
 			fattr->cf_mode |= S_IFLNK;
 			fattr->cf_dtype = DT_LNK;
+		} else if (memcmp("LnxFIFO", pbuf, 8) == 0) {
+			cifs_dbg(FYI, "FIFO\n");
+			fattr->cf_mode |= S_IFIFO;
+			fattr->cf_dtype = DT_FIFO;
 		} else {
 			fattr->cf_mode |= S_IFREG; /* file? */
 			fattr->cf_dtype = DT_REG;
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5215,7 +5215,7 @@ smb2_make_node(unsigned int xid, struct
 	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
 	 */
 
-	if (!S_ISCHR(mode) && !S_ISBLK(mode))
+	if (!S_ISCHR(mode) && !S_ISBLK(mode) && !S_ISFIFO(mode))
 		return rc;
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
@@ -5263,6 +5263,12 @@ smb2_make_node(unsigned int xid, struct
 		pdev->minor = cpu_to_le64(MINOR(dev));
 		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
 							&bytes_written, iov, 1);
+	} else if (S_ISFIFO(mode)) {
+		memcpy(pdev->type, "LnxFIFO", 8);
+		pdev->major = 0;
+		pdev->minor = 0;
+		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
+							&bytes_written, iov, 1);
 	}
 	tcon->ses->server->ops->close(xid, tcon, &fid);
 	d_drop(dentry);


