Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174F83FD956;
	Sat, 12 Sep 2026 09:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204096; cv=none; b=HfoNN4CXjmjjdqCjjUkVKdvo4LJswH5P4+54EfDlJInYA12KMpDwSEjswOIDMFTaqgN6nGhuvhVySHtzKUFHsCtv1BWQEqYxY/4gccLWFy4lcmnoWLV+A5QhNFepjT89SyoSvn6m9sa0Hq3XTXaIy1rfr6Fa+xgapWjlvfqcWh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204096; c=relaxed/simple;
	bh=uj1WBrpgr46Djjgltm+V1A8rXF+OuPwQ+ZY5t4wfxtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ess71OIpODm0miM2JMT87pAuv1bpuaWn99wz0ah4c1jge73wXyvNYv9xbxdkBETLSASmYmEtwtAwK9ywuWaTU8oeDT2cZoguL0hR6VLBVDQo+5kGDNMuWm2e2iImplkuVLrpfC3mdS187Nycsrl0qNkpgjH095gHmHzmnSX8mDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x95lKghq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x95lKghq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14921F000FF;
	Sat, 12 Sep 2026 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204093;
	bh=UNPmolwqHBfZgklqST1F8kYsCmVuZWq68yXkojlO/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x95lKghq5llRaCowh8GWGcXvJkjuruB+S/S7Qvk/LpYwvp2+IAFDzpRveKZcRjypt
	 qYp+QMLVJ/sqjPY2u1vwgsb2vkbFjp0DwPz1cwKC6mYL2D/iJkuOCJ3eymw1btKrdc
	 af0ag4YICdXoEv6aHbMgiPduDAxAAAOjW4hqL8So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1541/1815] ksmbd: add procfs monitoring for active shares
Date: Sat, 12 Sep 2026 08:54:51 +0200
Message-ID: <20260912065725.183001372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1248f400e0997b6e881454488baaf91f8e1828d5 ]

There is no kernel-side view of the share configurations currently cached
by active tree connections.

Add a shares proc entry that reports each active share name, type,
tree-connection count, create masks, and descriptive configuration flags.
Maintain a per-share tree-connection counter with the existing global
counter so the value can be read without walking every session.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 492b24b5b651 ("smb/server: update session counter under sessions table lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 57 +++++++++++++++++++++++++++++++
 fs/smb/server/mgmt/share_config.h | 25 ++++++++++++++
 fs/smb/server/mgmt/tree_connect.c |  2 ++
 fs/smb/server/server.c            |  1 +
 4 files changed, 85 insertions(+)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index b4f56e7338659..53d6f71dd8718 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -28,6 +28,62 @@ struct ksmbd_veto_pattern {
 	struct list_head	list;
 };
 
+#ifdef CONFIG_PROC_FS
+static const struct ksmbd_const_name ksmbd_share_flag_names[] = {
+	{KSMBD_SHARE_FLAG_AVAILABLE, "available"},
+	{KSMBD_SHARE_FLAG_BROWSEABLE, "browseable"},
+	{KSMBD_SHARE_FLAG_WRITEABLE, "writeable"},
+	{KSMBD_SHARE_FLAG_READONLY, "read-only"},
+	{KSMBD_SHARE_FLAG_GUEST_OK, "guest-ok"},
+	{KSMBD_SHARE_FLAG_GUEST_ONLY, "guest-only"},
+	{KSMBD_SHARE_FLAG_STORE_DOS_ATTRS, "store-dos-attrs"},
+	{KSMBD_SHARE_FLAG_OPLOCKS, "oplocks"},
+	{KSMBD_SHARE_FLAG_PIPE, "pipe"},
+	{KSMBD_SHARE_FLAG_HIDE_DOT_FILES, "hide-dot-files"},
+	{KSMBD_SHARE_FLAG_INHERIT_OWNER, "inherit-owner"},
+	{KSMBD_SHARE_FLAG_STREAMS, "streams"},
+	{KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS, "follow-symlinks"},
+	{KSMBD_SHARE_FLAG_ACL_XATTR, "acl-xattr"},
+	{KSMBD_SHARE_FLAG_UPDATE, "update"},
+	{KSMBD_SHARE_FLAG_CROSSMNT, "crossmnt"},
+	{KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY, "continuous-availability"},
+};
+
+static int proc_show_shares(struct seq_file *m, void *v)
+{
+	struct ksmbd_share_config *share;
+	int i;
+
+	down_read(&shares_table_lock);
+	hash_for_each(shares_table, i, share, hlist) {
+		seq_printf(m, "name:\t%s\n", share->name);
+		seq_printf(m, "type:\t%s\n",
+			   test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE) ?
+			   "pipe" : "disk");
+		seq_printf(m, "tree_connects:\t%d\n",
+			   atomic_read(&share->tree_connections));
+		seq_printf(m, "file_mask:\t0%07o\n", share->create_mask);
+		seq_printf(m, "directory_mask:\t0%07o\n", share->directory_mask);
+		seq_puts(m, "flags:\t");
+		ksmbd_proc_show_flag_names(m, ksmbd_share_flag_names,
+					   ARRAY_SIZE(ksmbd_share_flag_names),
+					   share->flags);
+		seq_puts(m, "\n\n");
+	}
+	up_read(&shares_table_lock);
+	return 0;
+}
+
+int create_proc_shares(void)
+{
+	if (!ksmbd_proc_create("shares", proc_show_shares, NULL))
+		return -ENOMEM;
+	return 0;
+}
+#else
+int create_proc_shares(void) { return 0; }
+#endif
+
 static unsigned int share_name_hash(const char *name)
 {
 	return jhash(name, strlen(name), 0);
@@ -156,6 +212,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 
 	share->flags = resp->flags;
 	atomic_set(&share->refcount, 1);
+	ksmbd_share_tree_conn_init(share);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, KSMBD_DEFAULT_GFP);
 	if (!share->name) {
diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index d4ac2dd4de204..d157545fe7d1d 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -24,6 +24,9 @@ struct ksmbd_share_config {
 	struct path		vfs_path;
 
 	atomic_t		refcount;
+#ifdef CONFIG_PROC_FS
+	atomic_t		tree_connections;
+#endif
 	struct hlist_node	hlist;
 	unsigned short		create_mask;
 	unsigned short		directory_mask;
@@ -60,6 +63,27 @@ static inline int test_share_config_flag(struct ksmbd_share_config *share,
 	return share->flags & flag;
 }
 
+#ifdef CONFIG_PROC_FS
+static inline void ksmbd_share_tree_conn_init(struct ksmbd_share_config *share)
+{
+	atomic_set(&share->tree_connections, 0);
+}
+
+static inline void ksmbd_share_tree_conn_inc(struct ksmbd_share_config *share)
+{
+	atomic_inc(&share->tree_connections);
+}
+
+static inline void ksmbd_share_tree_conn_dec(struct ksmbd_share_config *share)
+{
+	atomic_dec(&share->tree_connections);
+}
+#else
+static inline void ksmbd_share_tree_conn_init(struct ksmbd_share_config *share) {}
+static inline void ksmbd_share_tree_conn_inc(struct ksmbd_share_config *share) {}
+static inline void ksmbd_share_tree_conn_dec(struct ksmbd_share_config *share) {}
+#endif
+
 void ksmbd_share_config_del(struct ksmbd_share_config *share);
 void __ksmbd_share_config_put(struct ksmbd_share_config *share);
 
@@ -74,4 +98,5 @@ struct ksmbd_share_config *ksmbd_share_config_get(struct ksmbd_work *work,
 						  const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
+int create_proc_shares(void);
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index 3d04feaf8737a..dd1db3554caed 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -90,6 +90,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 		goto out_error;
 	}
 	ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS);
+	ksmbd_share_tree_conn_inc(sc);
 	kvfree(resp);
 	return status;
 
@@ -118,6 +119,7 @@ static int __ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_counter_dec(KSMBD_COUNTER_TREE_CONNS);
+	ksmbd_share_tree_conn_dec(tree_conn->share_conf);
 	if (atomic_dec_and_test(&tree_conn->refcount)) {
 		ksmbd_share_config_put(tree_conn->share_conf);
 		kfree(tree_conn);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 46a67642f814e..7d17e2901dabb 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -645,6 +645,7 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_unregister;
 	create_proc_sessions();
+	create_proc_shares();
 
 	ksmbd_server_tcp_callbacks_init();
 
-- 
2.53.0



