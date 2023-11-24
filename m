Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872D33063;
	Fri, 24 Nov 2023 18:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeN8h4pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1469DC433C8;
	Fri, 24 Nov 2023 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850033;
	bh=u+zi5cAcL3tV1PI4uguIYSAj0KWF8GWxsAxQmq097UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeN8h4pUCn7qFk8uAydtfvQdTkifeaynKZDv85wAI25+vlPLx+I6t0tyLvrgUwlYa
	 akseam+gy7l8l5TITuxKI6wSyOxM7WRKKFHGTc7YR/XTDMK9FA49aNja/hlXkbzcHe
	 d4MrCpYmjde7OpTDHlNFM5uxI7e5dul4HcKWrOCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 419/530] smb3: allow dumping session and tcon id to improve stats analysis and debugging
Date: Fri, 24 Nov 2023 17:49:45 +0000
Message-ID: <20231124172040.825620300@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

commit de4eceab578ead12a71e5b5588a57e142bbe8ceb upstream.

When multiple mounts are to the same share from the same client it was not
possible to determine which section of /proc/fs/cifs/Stats (and DebugData)
correspond to that mount.  In some recent examples this turned out to  be
a significant problem when trying to analyze performance data - since
there are many cases where unless we know the tree id and session id we
can't figure out which stats (e.g. number of SMB3.1.1 requests by type,
the total time they take, which is slowest, how many fail etc.) apply to
which mount. The only existing loosely related ioctl CIFS_IOC_GET_MNT_INFO
does not return the information needed to uniquely identify which tcon
is which mount although it does return various flags and device info.

Add a cifs.ko ioctl CIFS_IOC_GET_TCON_INFO (0x800ccf0c) to return tid,
session id, tree connect count.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_ioctl.h |    6 ++++++
 fs/smb/client/ioctl.c      |   25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -26,6 +26,11 @@ struct smb_mnt_fs_info {
 	__u64   cifs_posix_caps;
 } __packed;
 
+struct smb_mnt_tcon_info {
+	__u32	tid;
+	__u64	session_id;
+} __packed;
+
 struct smb_snapshot_array {
 	__u32	number_of_snapshots;
 	__u32	number_of_snapshots_returned;
@@ -108,6 +113,7 @@ struct smb3_notify_info {
 #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
 #define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct smb3_full_key_debug_info)
 #define CIFS_IOC_NOTIFY_INFO _IOWR(CIFS_IOCTL_MAGIC, 11, struct smb3_notify_info)
+#define CIFS_IOC_GET_TCON_INFO _IOR(CIFS_IOCTL_MAGIC, 12, struct smb_mnt_tcon_info)
 #define CIFS_IOC_SHUTDOWN _IOR('X', 125, __u32)
 
 /*
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -117,6 +117,20 @@ out_drop_write:
 	return rc;
 }
 
+static long smb_mnt_get_tcon_info(struct cifs_tcon *tcon, void __user *arg)
+{
+	int rc = 0;
+	struct smb_mnt_tcon_info tcon_inf;
+
+	tcon_inf.tid = tcon->tid;
+	tcon_inf.session_id = tcon->ses->Suid;
+
+	if (copy_to_user(arg, &tcon_inf, sizeof(struct smb_mnt_tcon_info)))
+		rc = -EFAULT;
+
+	return rc;
+}
+
 static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
 				void __user *arg)
 {
@@ -414,6 +428,17 @@ long cifs_ioctl(struct file *filep, unsi
 			tcon = tlink_tcon(pSMBFile->tlink);
 			rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
 			break;
+		case CIFS_IOC_GET_TCON_INFO:
+			cifs_sb = CIFS_SB(inode->i_sb);
+			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink)) {
+				rc = PTR_ERR(tlink);
+				break;
+			}
+			tcon = tlink_tcon(tlink);
+			rc = smb_mnt_get_tcon_info(tcon, (void __user *)arg);
+			cifs_put_tlink(tlink);
+			break;
 		case CIFS_ENUMERATE_SNAPSHOTS:
 			if (pSMBFile == NULL)
 				break;


