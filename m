Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ACC33CC2;
	Fri, 24 Nov 2023 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqo19GY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C489C433C8;
	Fri, 24 Nov 2023 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852290;
	bh=gPQnpx+V1Og/76iatNSWF7CetMLLymjjipACfTR0+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqo19GY/Qw6mHXy6m19U8mqbNTfJHrCIZfzFc0MpBsAYG67VgD30XEWYupFnYdKVO
	 Dviwl6XfLwVCigC0eR3xbu5oLfcby52AISU95/c6fXQNN8Umbn+++McyRr+cKtt2ry
	 rtrLhb+GUq7LYH0mkJTYG0XjVEhacuHNVLTg+9+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 272/372] smb: client: fix potential deadlock when releasing mids
Date: Fri, 24 Nov 2023 17:50:59 +0000
Message-ID: <20231124172019.530665691@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit e6322fd177c6885a21dd4609dc5e5c973d1a2eb7 upstream.

All release_mid() callers seem to hold a reference of @mid so there is
no need to call kref_put(&mid->refcount, __release_mid) under
@server->mid_lock spinlock.  If they don't, then an use-after-free bug
would have occurred anyways.

By getting rid of such spinlock also fixes a potential deadlock as
shown below

CPU 0                                CPU 1
------------------------------------------------------------------
cifs_demultiplex_thread()            cifs_debug_data_proc_show()
 release_mid()
  spin_lock(&server->mid_lock);
                                     spin_lock(&cifs_tcp_ses_lock)
				      spin_lock(&server->mid_lock)
  __release_mid()
   smb2_find_smb_tcon()
    spin_lock(&cifs_tcp_ses_lock) *deadlock*

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    7 ++++++-
 fs/smb/client/smb2misc.c  |    2 +-
 fs/smb/client/transport.c |   11 +----------
 3 files changed, 8 insertions(+), 12 deletions(-)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -79,7 +79,7 @@ extern char *cifs_compose_mount_options(
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
 extern void delete_mid(struct mid_q_entry *mid);
-extern void release_mid(struct mid_q_entry *mid);
+void __release_mid(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -694,4 +694,9 @@ struct super_block *cifs_get_tcon_super(
 void cifs_put_tcon_super(struct super_block *sb);
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
 
+static inline void release_mid(struct mid_q_entry *mid)
+{
+	kref_put(&mid->refcount, __release_mid);
+}
+
 #endif			/* _CIFSPROTO_H */
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -787,7 +787,7 @@ __smb2_handle_cancelled_cmd(struct cifs_
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -76,7 +76,7 @@ alloc_mid(const struct smb_hdr *smb_buff
 	return temp;
 }
 
-static void __release_mid(struct kref *refcount)
+void __release_mid(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -156,15 +156,6 @@ static void __release_mid(struct kref *r
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void release_mid(struct mid_q_entry *mid)
-{
-	struct TCP_Server_Info *server = mid->server;
-
-	spin_lock(&server->mid_lock);
-	kref_put(&mid->refcount, __release_mid);
-	spin_unlock(&server->mid_lock);
-}
-
 void
 delete_mid(struct mid_q_entry *mid)
 {


