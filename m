Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DEF1482F5;
	Wed,  7 May 2025 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644325; cv=none; b=VYXGj1xbG+XV+TpU1NVSNWviFKay+WhYiK69OiIwtcjEIVPlylnBZJFs+9R1CtrDwGZIuizAdLgbrAu8ynKEHX5RYT3Ju9s0ElwLRcOkyO6qBjpvvCL1qHGa9pXlIRyDpH0AqNKP5aNGHnDYboXAYInpCnEMUKBgAOGl7xk6r+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644325; c=relaxed/simple;
	bh=rBqYelILdz8TQOr4iIvKt4b0SMv4GqHa/s6ZUiW+E5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0rEnKpb//U9/G2zKR1Fobl4bqbbWaKEYEjsAQ4e+tNb3TV1mBZKcrGTTA6wM07lFiCcp3lTGk/F7ud7tw9ed9WsDflum3tFnEuBgurgegX7RFwGU9Q66wkvO+GrbZ+fsV+JUoEwla0FdpaO4HlYKfdjUqEJFyP0zDQdTBFcPjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obWP8yMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obWP8yMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4319C4CEE2;
	Wed,  7 May 2025 18:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644325;
	bh=rBqYelILdz8TQOr4iIvKt4b0SMv4GqHa/s6ZUiW+E5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obWP8yMcHc+/9plFoxSbXNbkpRq2jggyk8C9bwLc4FEKQXOzG42OJUGZwR2IUtfgh
	 MWa+r2ZeGNoFVHFi7SgyQeejw0EVozk6gSasUEuDw39B4BJuabC4EmraMcAEFdkq8g
	 7OPdjEzfwn9yCauzl+YW8ghyzQITrSy9nj91eow4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.14 183/183] bcachefs: Change btree_insert_node() assertion to error
Date: Wed,  7 May 2025 20:40:28 +0200
Message-ID: <20250507183832.277993777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 63c3b8f616cc95bb1fcc6101c92485d41c535d7c upstream.

Debug for https://github.com/koverstreet/bcachefs/issues/843

Print useful debug info and go emergency read-only.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/btree_update_interior.c |   17 ++++++++++++++++-
 fs/bcachefs/error.c                 |    8 ++++++++
 fs/bcachefs/error.h                 |    2 ++
 3 files changed, 26 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -35,6 +35,8 @@ static const char * const bch2_btree_upd
 	NULL
 };
 
+static void bch2_btree_update_to_text(struct printbuf *, struct btree_update *);
+
 static int bch2_btree_insert_node(struct btree_update *, struct btree_trans *,
 				  btree_path_idx_t, struct btree *, struct keylist *);
 static void bch2_btree_update_add_new_node(struct btree_update *, struct btree *);
@@ -1782,11 +1784,24 @@ static int bch2_btree_insert_node(struct
 	int ret;
 
 	lockdep_assert_held(&c->gc_lock);
-	BUG_ON(!btree_node_intent_locked(path, b->c.level));
 	BUG_ON(!b->c.level);
 	BUG_ON(!as || as->b);
 	bch2_verify_keylist_sorted(keys);
 
+	if (!btree_node_intent_locked(path, b->c.level)) {
+		struct printbuf buf = PRINTBUF;
+		bch2_log_msg_start(c, &buf);
+		prt_printf(&buf, "%s(): node not locked at level %u\n",
+			   __func__, b->c.level);
+		bch2_btree_update_to_text(&buf, as);
+		bch2_btree_path_to_text(&buf, trans, path_idx);
+
+		bch2_print_string_as_lines(KERN_ERR, buf.buf);
+		printbuf_exit(&buf);
+		bch2_fs_emergency_read_only(c);
+		return -EIO;
+	}
+
 	ret = bch2_btree_node_lock_write(trans, path, &b->c);
 	if (ret)
 		return ret;
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -11,6 +11,14 @@
 
 #define FSCK_ERR_RATELIMIT_NR	10
 
+void bch2_log_msg_start(struct bch_fs *c, struct printbuf *out)
+{
+#ifdef BCACHEFS_LOG_PREFIX
+	prt_printf(out, bch2_log_msg(c, ""));
+#endif
+	printbuf_indent_add(out, 2);
+}
+
 bool bch2_inconsistent_error(struct bch_fs *c)
 {
 	set_bit(BCH_FS_error, &c->flags);
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -18,6 +18,8 @@ struct work_struct;
 
 /* Error messages: */
 
+void bch2_log_msg_start(struct bch_fs *, struct printbuf *);
+
 /*
  * Inconsistency errors: The on disk data is inconsistent. If these occur during
  * initial recovery, they don't indicate a bug in the running code - we walk all


