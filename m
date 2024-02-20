Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD723446C9;
	Tue, 20 Feb 2024 21:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465069; cv=none; b=kEOnZ62O+NMOzbh1+/8z2c2Q6j+/st0gx+hh+JtxaUA5b2bFuMtucC935wz8J/pwaEkc9+iX55ZZDX8YrBwVWD2YRDwifZ6s6q1LwI7xFWHniBCn9ENjtmKa+71LA4taU/St1xU6Pr50PsYZtlxAKG2XIoV9qvyXFs2wK3r0z5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465069; c=relaxed/simple;
	bh=dTNfgSZUWeHzo2LUbgQ+LqHoK4uXTUvXBrBB+F+VknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juS8rBQrv5jmz4rU5uF2asXj4abX7j/TiPZEynLbLOICQCraQ2j0L2dSsxbkrH5RScBbHdE7knb0/GVCexEDHKO065jdMBsEGOzyEm40YLzMskqji1+aUDSNtchehlBaSU1JdlOqj2kF91qHKXxf0Nf6DHb1/+1gIyJ3X62DjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSK/RN90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSK/RN90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46371C433F1;
	Tue, 20 Feb 2024 21:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465069;
	bh=dTNfgSZUWeHzo2LUbgQ+LqHoK4uXTUvXBrBB+F+VknQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSK/RN90p5RmBrUth18tjwDplFP12PTYT4R4mvg49y+F2v+SgJh5cjto5DQwyeRLA
	 WxIlXkRHOOm/MRYlQlHxSWmbURbwVyTC40RSmJy56ytIPfJCMZOfWM8hNcPyaGq9yc
	 FDO5z5HZQ91Ov+29Wu4kFDZ7de/l4KY5u/EguETI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 196/309] eventfs: Warn if an eventfs_inode is freed without is_freed being set
Date: Tue, 20 Feb 2024 21:55:55 +0100
Message-ID: <20240220205639.311596045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 5a49f996046ba947466bc7461e4b19c4d1daf978 upstream.

There should never be a case where an evenfs_inode is being freed without
is_freed being set. Add a WARN_ON_ONCE() if it ever happens. That would
mean there was one too many put_ei()s.

Link: https://lore.kernel.org/linux-trace-kernel/20240201161616.843551963@goodmis.org

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -73,6 +73,9 @@ enum {
 static void release_ei(struct kref *ref)
 {
 	struct eventfs_inode *ei = container_of(ref, struct eventfs_inode, kref);
+
+	WARN_ON_ONCE(!ei->is_freed);
+
 	kfree(ei->entry_attrs);
 	kfree_const(ei->name);
 	kfree_rcu(ei, rcu);
@@ -84,6 +87,14 @@ static inline void put_ei(struct eventfs
 		kref_put(&ei->kref, release_ei);
 }
 
+static inline void free_ei(struct eventfs_inode *ei)
+{
+	if (ei) {
+		ei->is_freed = 1;
+		put_ei(ei);
+	}
+}
+
 static inline struct eventfs_inode *get_ei(struct eventfs_inode *ei)
 {
 	if (ei)
@@ -679,7 +690,7 @@ struct eventfs_inode *eventfs_create_dir
 
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {
-		put_ei(ei);
+		free_ei(ei);
 		ei = NULL;
 	}
 	return ei;
@@ -770,7 +781,7 @@ struct eventfs_inode *eventfs_create_eve
 	return ei;
 
  fail:
-	put_ei(ei);
+	free_ei(ei);
 	tracefs_failed_creating(dentry);
 	return ERR_PTR(-ENOMEM);
 }
@@ -801,9 +812,8 @@ static void eventfs_remove_rec(struct ev
 	list_for_each_entry(ei_child, &ei->children, list)
 		eventfs_remove_rec(ei_child, level + 1);
 
-	ei->is_freed = 1;
 	list_del(&ei->list);
-	put_ei(ei);
+	free_ei(ei);
 }
 
 /**


