Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7052222D1;
	Thu, 13 Feb 2025 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457522; cv=none; b=CPqff9U5LRDpJiRmF0EFzBJorUzvtK+ELI7sUIo6aKrQNfe1hUyp3BaIVboxXXCoRl5Ai9/2utH0BIM76XTr0ai91UiCT/aIvnS+aj2873GsuWx41g7umqhc5SN9FzQq2U7a+xke2TDArYp+mF8a4mfwlzH4t9Z/qDTeOWH/Fmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457522; c=relaxed/simple;
	bh=uBsI8QDqPh3jgivXSm1FbeG4V2WkZf/WFkOJV1zgf1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js9W3IP3GurU3LcGPQSmwTtIMFkeMDlb3FIQ4SxdbqNbeZwE+9HouhXKiWSqAoLwk66RIlPiXvvr+e+vdMISjty3wwSTplfdyPwAkJkmFLis5Iy5t7a6/6ONO62s9I7Eum4in/id/Nq/XCCiHznijjNmjc4EI+CcTb9AdRfX4oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADlhC2SW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADlhC2SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D412C4CED1;
	Thu, 13 Feb 2025 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457522;
	bh=uBsI8QDqPh3jgivXSm1FbeG4V2WkZf/WFkOJV1zgf1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADlhC2SWn4cMm+VACCABCXAz/wm12sB9ZV14RF1JrSTpulerWJ9N/Mw1P1IC41l75
	 wInaq86ehswT38ofyvF5oXaUGLXFHDdCtfa3J2KnWEAH/ibYn3PH4pLDHq3V8bTp0k
	 81BhrpsH4UUjZfPEhSqy/TFfhbc73b9cAcnQ0Iho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 136/422] smb: client: change lease epoch type from unsigned int to __u16
Date: Thu, 13 Feb 2025 15:24:45 +0100
Message-ID: <20250213142441.796523379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meetakshi Setiya <msetiya@microsoft.com>

commit 57e4a9bd61c308f607bc3e55e8fa02257b06b552 upstream.

MS-SMB2 section 2.2.13.2.10 specifies that 'epoch' should be a 16-bit
unsigned integer used to track lease state changes. Change the data
type of all instances of 'epoch' from unsigned int to __u16. This
simplifies the epoch change comparisons and makes the code more
compliant with the protocol spec.

Cc: stable@vger.kernel.org
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h  |   14 +++++++-------
 fs/smb/client/smb1ops.c   |    2 +-
 fs/smb/client/smb2ops.c   |   18 +++++++++---------
 fs/smb/client/smb2pdu.c   |    2 +-
 fs/smb/client/smb2proto.h |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -320,7 +320,7 @@ struct smb_version_operations {
 	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
-				 unsigned int epoch, bool *purge_cache);
+				 __u16 epoch, bool *purge_cache);
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
@@ -515,12 +515,12 @@ struct smb_version_operations {
 	/* if we can do cache read operations */
 	bool (*is_read_op)(__u32);
 	/* set oplock level for the inode */
-	void (*set_oplock_level)(struct cifsInodeInfo *, __u32, unsigned int,
-				 bool *);
+	void (*set_oplock_level)(struct cifsInodeInfo *cinode, __u32 oplock, __u16 epoch,
+				 bool *purge_cache);
 	/* create lease context buffer for CREATE request */
 	char * (*create_lease_buf)(u8 *lease_key, u8 oplock);
 	/* parse lease context buffer and return oplock/epoch info */
-	__u8 (*parse_lease_buf)(void *buf, unsigned int *epoch, char *lkey);
+	__u8 (*parse_lease_buf)(void *buf, __u16 *epoch, char *lkey);
 	ssize_t (*copychunk_range)(const unsigned int,
 			struct cifsFileInfo *src_file,
 			struct cifsFileInfo *target_file,
@@ -1415,7 +1415,7 @@ struct cifs_fid {
 	__u8 create_guid[16];
 	__u32 access;
 	struct cifs_pending_open *pending_open;
-	unsigned int epoch;
+	__u16 epoch;
 #ifdef CONFIG_CIFS_DEBUG2
 	__u64 mid;
 #endif /* CIFS_DEBUG2 */
@@ -1448,7 +1448,7 @@ struct cifsFileInfo {
 	bool oplock_break_cancelled:1;
 	bool status_file_deleted:1; /* file has been deleted */
 	bool offload:1; /* offload final part of _put to a wq */
-	unsigned int oplock_epoch; /* epoch from the lease break */
+	__u16 oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
@@ -1545,7 +1545,7 @@ struct cifsInodeInfo {
 	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
-	unsigned int epoch;		/* used to track lease state changes */
+	__u16 epoch;		/* used to track lease state changes */
 #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
 #define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
 #define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -377,7 +377,7 @@ coalesce_t2(char *second_buf, struct smb
 static void
 cifs_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	cifs_set_oplock_level(cinode, oplock);
 }
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3931,22 +3931,22 @@ static long smb3_fallocate(struct file *
 static void
 smb2_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	server->ops->set_oplock_level(cinode, oplock, 0, NULL);
 }
 
 static void
 smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache);
+		       __u16 epoch, bool *purge_cache);
 
 static void
 smb3_downgrade_oplock(struct TCP_Server_Info *server,
 		       struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache)
+		       __u16 epoch, bool *purge_cache)
 {
 	unsigned int old_state = cinode->oplock;
-	unsigned int old_epoch = cinode->epoch;
+	__u16 old_epoch = cinode->epoch;
 	unsigned int new_state;
 
 	if (epoch > old_epoch) {
@@ -3966,7 +3966,7 @@ smb3_downgrade_oplock(struct TCP_Server_
 
 static void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	oplock &= 0xFF;
 	cinode->lease_granted = false;
@@ -3990,7 +3990,7 @@ smb2_set_oplock_level(struct cifsInodeIn
 
 static void
 smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		       unsigned int epoch, bool *purge_cache)
+		       __u16 epoch, bool *purge_cache)
 {
 	char message[5] = {0};
 	unsigned int new_oplock = 0;
@@ -4027,7 +4027,7 @@ smb21_set_oplock_level(struct cifsInodeI
 
 static void
 smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
-		      unsigned int epoch, bool *purge_cache)
+		      __u16 epoch, bool *purge_cache)
 {
 	unsigned int old_oplock = cinode->oplock;
 
@@ -4141,7 +4141,7 @@ smb3_create_lease_buf(u8 *lease_key, u8
 }
 
 static __u8
-smb2_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
+smb2_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
 	struct create_lease *lc = (struct create_lease *)buf;
 
@@ -4152,7 +4152,7 @@ smb2_parse_lease_buf(void *buf, unsigned
 }
 
 static __u8
-smb3_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
+smb3_parse_lease_buf(void *buf, __u16 *epoch, char *lease_key)
 {
 	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
 
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2335,7 +2335,7 @@ parse_posix_ctxt(struct create_context *
 
 int smb2_parse_contexts(struct TCP_Server_Info *server,
 			struct kvec *rsp_iov,
-			unsigned int *epoch,
+			__u16 *epoch,
 			char *lease_key, __u8 *oplock,
 			struct smb2_file_all_info *buf,
 			struct create_posix_rsp *posix)
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -282,7 +282,7 @@ extern enum securityEnum smb2_select_sec
 					enum securityEnum);
 int smb2_parse_contexts(struct TCP_Server_Info *server,
 			struct kvec *rsp_iov,
-			unsigned int *epoch,
+			__u16 *epoch,
 			char *lease_key, __u8 *oplock,
 			struct smb2_file_all_info *buf,
 			struct create_posix_rsp *posix);


