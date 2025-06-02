Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CF41FBC90;
	Mon,  2 Jun 2025 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874286; cv=none; b=UQc/GulMSMfx1YgbQhwcKbkQquXt09nVX7dDQfulaofnZOMeUX/AJwFDc4rojCa4PK3XB36k7BgQ5bdijtGYSz+M2DkfJ7qRMNhbbG/kYCK9tdDTw5LGtEXSvldI6ilvKZSKdYEkuS7t0oCxxjtObCu2ldMXPzj3u3vE9xFrt6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874286; c=relaxed/simple;
	bh=NqHHVjh0DPeFcKI6TfJBU3/N0agNJZ5cdEmBoPk5vGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEbn/D5RSSMxCK2lA6Rch+8h8Tjjtp/48OgAP4i7hekA4G1cfAaDsTMzh6RnHnwOCPRMdmgwymnXhukT1/gG6/n71rXIhe2xIvmLXw6oGU1fibdm8ehyOi79wpGb6guyL1Pf8+zIhx+aIUbuRAlMvEix3Zk122YnAMWKm7iyZOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVqs/kyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVqs/kyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2CC4CEEB;
	Mon,  2 Jun 2025 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874286;
	bh=NqHHVjh0DPeFcKI6TfJBU3/N0agNJZ5cdEmBoPk5vGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVqs/kygGH5MzfJxt2xL/1Cw7xSB0dGqqtD6tAUU+NnpzUOV+5hGwX9rUehH+MW2c
	 yXaPMJaAXVpG2y9r5oMMNb5b3Qf4GHHQZzGMX3Kz8q6m78QsmvSk7wjennqYSydfOM
	 n/xCFHjSOvR3BD5vxcuqcbhpcJHb2VWYzLKTrbLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 402/444] af_unix: Allocate struct unix_edge for each inflight AF_UNIX fd.
Date: Mon,  2 Jun 2025 15:47:46 +0200
Message-ID: <20250602134357.232336393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 29b64e354029cfcf1eea4d91b146c7b769305930 upstream.

As with the previous patch, we preallocate to skb's scm_fp_list an
array of struct unix_edge in the number of inflight AF_UNIX fds.

There we just preallocate memory and do not use immediately because
sendmsg() could fail after this point.  The actual use will be in
the next patch.

When we queue skb with inflight edges, we will set the inflight
socket's unix_sock as unix_edge->predecessor and the receiver's
unix_sock as successor, and then we will link the edge to the
inflight socket's unix_vertex.edges.

Note that we set NULL to cloned scm_fp_list.edges in scm_fp_dup()
so that MSG_PEEK does not change the shape of the directed graph.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240325202425.60930-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    6 ++++++
 include/net/scm.h     |    5 +++++
 net/core/scm.c        |    2 ++
 net/unix/garbage.c    |    6 ++++++
 4 files changed, 19 insertions(+)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -33,6 +33,12 @@ struct unix_vertex {
 	unsigned long out_degree;
 };
 
+struct unix_edge {
+	struct unix_sock *predecessor;
+	struct unix_sock *successor;
+	struct list_head vertex_entry;
+};
+
 struct sock *unix_peer_get(struct sock *sk);
 
 #define UNIX_HASH_MOD	(256 - 1)
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -22,12 +22,17 @@ struct scm_creds {
 	kgid_t	gid;
 };
 
+#ifdef CONFIG_UNIX
+struct unix_edge;
+#endif
+
 struct scm_fp_list {
 	short			count;
 	short			count_unix;
 	short			max;
 #ifdef CONFIG_UNIX
 	struct list_head	vertices;
+	struct unix_edge	*edges;
 #endif
 	struct user_struct	*user;
 	struct file		*fp[SCM_MAX_FD];
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -90,6 +90,7 @@ static int scm_fp_copy(struct cmsghdr *c
 		fpl->max = SCM_MAX_FD;
 		fpl->user = NULL;
 #if IS_ENABLED(CONFIG_UNIX)
+		fpl->edges = NULL;
 		INIT_LIST_HEAD(&fpl->vertices);
 #endif
 	}
@@ -383,6 +384,7 @@ struct scm_fp_list *scm_fp_dup(struct sc
 		new_fpl->max = new_fpl->count;
 		new_fpl->user = get_uid(fpl->user);
 #if IS_ENABLED(CONFIG_UNIX)
+		new_fpl->edges = NULL;
 		INIT_LIST_HEAD(&new_fpl->vertices);
 #endif
 	}
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -127,6 +127,11 @@ int unix_prepare_fpl(struct scm_fp_list
 		list_add(&vertex->entry, &fpl->vertices);
 	}
 
+	fpl->edges = kvmalloc_array(fpl->count_unix, sizeof(*fpl->edges),
+				    GFP_KERNEL_ACCOUNT);
+	if (!fpl->edges)
+		goto err;
+
 	return 0;
 
 err:
@@ -136,6 +141,7 @@ err:
 
 void unix_destroy_fpl(struct scm_fp_list *fpl)
 {
+	kvfree(fpl->edges);
 	unix_free_vertices(fpl);
 }
 


