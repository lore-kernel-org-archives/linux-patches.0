Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D77F168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B42C433D2;
	Mon,  8 May 2023 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539778;
	bh=4n0HoGt+9HndQUFjYvRgE7Zx8/npkSWT88QGOCkHzNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbkGojf30xK1CXy2jAydEm1eD29HYImsOoiOLWItEqvDNMl5YtO8NJr2+5XyXdg22
	 UPwIrKgWGBEH1ZsL+WgHiwz0wuSZveROHVx4qZYQknjwbQr97WnqdXWmLg0Wzgn7F9
	 QLAoku8FKbwnBab/oH+1fsibi+JGZe/u1XR087ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	=?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 106/611] ceph: fix potential use-after-free bug when trimming caps
Date: Mon,  8 May 2023 11:39:08 +0200
Message-Id: <20230508094425.690622026@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit aaf67de78807c59c35bafb5003d4fb457c764800 upstream.

When trimming the caps and just after the 'session->s_cap_lock' is
released in ceph_iterate_session_caps() the cap maybe removed by
another thread, and when using the stale cap memory in the callbacks
it will trigger use-after-free crash.

We need to check the existence of the cap just after the 'ci->i_ceph_lock'
being acquired. And do nothing if it's already removed.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/43272
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |    2 -
 fs/ceph/debugfs.c    |   16 +++++++----
 fs/ceph/mds_client.c |   72 ++++++++++++++++++++++++++++++++-------------------
 fs/ceph/mds_client.h |    3 --
 fs/ceph/super.h      |    2 +
 5 files changed, 61 insertions(+), 34 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -430,7 +430,7 @@ void ceph_reservation_status(struct ceph
  *
  * Called with i_ceph_lock held.
  */
-static struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci, int mds)
+struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci, int mds)
 {
 	struct ceph_cap *cap;
 	struct rb_node *n = ci->i_caps.rb_node;
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -248,14 +248,20 @@ static int metrics_caps_show(struct seq_
 	return 0;
 }
 
-static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
+static int caps_show_cb(struct inode *inode, int mds, void *p)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct seq_file *s = p;
+	struct ceph_cap *cap;
 
-	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
-		   cap->session->s_mds,
-		   ceph_cap_string(cap->issued),
-		   ceph_cap_string(cap->implemented));
+	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (cap)
+		seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
+			   cap->session->s_mds,
+			   ceph_cap_string(cap->issued),
+			   ceph_cap_string(cap->implemented));
+	spin_unlock(&ci->i_ceph_lock);
 	return 0;
 }
 
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1632,8 +1632,8 @@ static void cleanup_session_requests(str
  * Caller must hold session s_mutex.
  */
 int ceph_iterate_session_caps(struct ceph_mds_session *session,
-			      int (*cb)(struct inode *, struct ceph_cap *,
-					void *), void *arg)
+			      int (*cb)(struct inode *, int mds, void *),
+			      void *arg)
 {
 	struct list_head *p;
 	struct ceph_cap *cap;
@@ -1645,6 +1645,8 @@ int ceph_iterate_session_caps(struct cep
 	spin_lock(&session->s_cap_lock);
 	p = session->s_caps.next;
 	while (p != &session->s_caps) {
+		int mds;
+
 		cap = list_entry(p, struct ceph_cap, session_caps);
 		inode = igrab(&cap->ci->netfs.inode);
 		if (!inode) {
@@ -1652,6 +1654,7 @@ int ceph_iterate_session_caps(struct cep
 			continue;
 		}
 		session->s_cap_iterator = cap;
+		mds = cap->mds;
 		spin_unlock(&session->s_cap_lock);
 
 		if (last_inode) {
@@ -1663,7 +1666,7 @@ int ceph_iterate_session_caps(struct cep
 			old_cap = NULL;
 		}
 
-		ret = cb(inode, cap, arg);
+		ret = cb(inode, mds, arg);
 		last_inode = inode;
 
 		spin_lock(&session->s_cap_lock);
@@ -1696,20 +1699,25 @@ out:
 	return ret;
 }
 
-static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
-				  void *arg)
+static int remove_session_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	bool invalidate = false;
-	int iputs;
+	struct ceph_cap *cap;
+	int iputs = 0;
 
-	dout("removing cap %p, ci is %p, inode is %p\n",
-	     cap, ci, &ci->netfs.inode);
 	spin_lock(&ci->i_ceph_lock);
-	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	cap = __get_cap_for_mds(ci, mds);
+	if (cap) {
+		dout(" removing cap %p, ci is %p, inode is %p\n",
+		     cap, ci, &ci->netfs.inode);
+
+		iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	}
 	spin_unlock(&ci->i_ceph_lock);
 
-	wake_up_all(&ci->i_cap_wq);
+	if (cap)
+		wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
 		ceph_queue_invalidate(inode);
 	while (iputs--)
@@ -1780,8 +1788,7 @@ enum {
  *
  * caller must hold s_mutex.
  */
-static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
-			      void *arg)
+static int wake_up_session_cb(struct inode *inode, int mds, void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	unsigned long ev = (unsigned long)arg;
@@ -1792,12 +1799,14 @@ static int wake_up_session_cb(struct ino
 		ci->i_requested_max_size = 0;
 		spin_unlock(&ci->i_ceph_lock);
 	} else if (ev == RENEWCAPS) {
-		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
-			/* mds did not re-issue stale cap */
-			spin_lock(&ci->i_ceph_lock);
+		struct ceph_cap *cap;
+
+		spin_lock(&ci->i_ceph_lock);
+		cap = __get_cap_for_mds(ci, mds);
+		/* mds did not re-issue stale cap */
+		if (cap && cap->cap_gen < atomic_read(&cap->session->s_cap_gen))
 			cap->issued = cap->implemented = CEPH_CAP_PIN;
-			spin_unlock(&ci->i_ceph_lock);
-		}
+		spin_unlock(&ci->i_ceph_lock);
 	} else if (ev == FORCE_RO) {
 	}
 	wake_up_all(&ci->i_cap_wq);
@@ -1959,16 +1968,22 @@ out:
  * Yes, this is a bit sloppy.  Our only real goal here is to respond to
  * memory pressure from the MDS, though, so it needn't be perfect.
  */
-static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
+static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	int *remaining = arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
+	struct ceph_cap *cap;
 
 	if (*remaining <= 0)
 		return -1;
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (!cap) {
+		spin_unlock(&ci->i_ceph_lock);
+		return 0;
+	}
 	mine = cap->issued | cap->implemented;
 	used = __ceph_caps_used(ci);
 	wanted = __ceph_caps_file_wanted(ci);
@@ -3911,26 +3926,22 @@ out_unlock:
 /*
  * Encode information about a cap for a reconnect with the MDS.
  */
-static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
-			  void *arg)
+static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	union {
 		struct ceph_mds_cap_reconnect v2;
 		struct ceph_mds_cap_reconnect_v1 v1;
 	} rec;
-	struct ceph_inode_info *ci = cap->ci;
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_reconnect_state *recon_state = arg;
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
+	struct ceph_cap *cap;
 	char *path;
-	int pathlen = 0, err;
+	int pathlen = 0, err = 0;
 	u64 pathbase;
 	u64 snap_follows;
 
-	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
-	     inode, ceph_vinop(inode), cap, cap->cap_id,
-	     ceph_cap_string(cap->issued));
-
 	dentry = d_find_primary(inode);
 	if (dentry) {
 		/* set pathbase to parent dir when msg_version >= 2 */
@@ -3947,6 +3958,15 @@ static int reconnect_caps_cb(struct inod
 	}
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (!cap) {
+		spin_unlock(&ci->i_ceph_lock);
+		goto out_err;
+	}
+	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
+	     inode, ceph_vinop(inode), cap, cap->cap_id,
+	     ceph_cap_string(cap->issued));
+
 	cap->seq = 0;        /* reset cap seq */
 	cap->issue_seq = 0;  /* and issue_seq */
 	cap->mseq = 0;       /* and migrate_seq */
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -541,8 +541,7 @@ extern void ceph_flush_cap_releases(stru
 extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
 extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
-				     int (*cb)(struct inode *,
-					       struct ceph_cap *, void *),
+				     int (*cb)(struct inode *, int mds, void *),
 				     void *arg);
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1190,6 +1190,8 @@ extern void ceph_kick_flushing_caps(stru
 				    struct ceph_mds_session *session);
 void ceph_kick_flushing_inode_caps(struct ceph_mds_session *session,
 				   struct ceph_inode_info *ci);
+extern struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci,
+					  int mds);
 extern struct ceph_cap *ceph_get_cap_for_mds(struct ceph_inode_info *ci,
 					     int mds);
 extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,


