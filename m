Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A3332E152;
	Mon, 27 Oct 2025 19:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591858; cv=none; b=VN+ka8Cbrz7HA3Z3ytmQLBn1+bJ4Zd/wQ6NxfRVFR5iWyxVrs6hwYsAu8bCW8O8N3+5tlFnwReHNSEbWqjZaqx4dCjjRLeFoNm5QyAC7LN0E41Y8JHrzfmhXIboEcLI8zPAYzXCwalEFuIJmiDVktTwi+CQbUXFaiZdpQBeVH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591858; c=relaxed/simple;
	bh=b2BsWYnZLRQZDPpKVQRoLrMmWrDa6Fhuq3j6U0/3mzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApgV7Q0FLZHLJXbZGeQxIgaV1AN7icJNaW9YwF/tAP5fBgUIr8Tm45DBVSmPLWXlR0dnKpvTZEqriEvfQYOG/shaEt+el5gfgbUA3mGaOH1QLAqfX4XkWgRXKUU1nw6KGe/WZ9AfAQssi2i6fTciFi8/CQSZLOJNUBlR2/PLFw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTs7+Vwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTs7+Vwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A5C4CEF1;
	Mon, 27 Oct 2025 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591857;
	bh=b2BsWYnZLRQZDPpKVQRoLrMmWrDa6Fhuq3j6U0/3mzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTs7+VwjoatVBtKor1+ZLn6Zeh4ZTS+4gcih0p+gNvhj+vttRK7UhAONC38ukl1Dr
	 zCuoLv1ALUbdZUfE6/5CpiVBQqL2EY5nZ/V79aqjTLZyY4tksk8XprRnhGzXjnxsIZ
	 /DjoXbQByA4wf6TrMYItJY233QG+2ANqoiKpHoxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/123] splice, net: Add a splice_eof op to file-ops and socket-ops
Date: Mon, 27 Oct 2025 19:35:04 +0100
Message-ID: <20251027183447.045484526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2bfc66850952b6921b2033b09729ec59eabbc81d ]

Add an optional method, ->splice_eof(), to allow splice to indicate the
premature termination of a splice to struct file_operations and struct
proto_ops.

This is called if sendfile() or splice() encounters all of the following
conditions inside splice_direct_to_actor():

 (1) the user did not set SPLICE_F_MORE (splice only), and

 (2) an EOF condition occurred (->splice_read() returned 0), and

 (3) we haven't read enough to fulfill the request (ie. len > 0 still), and

 (4) we have already spliced at least one byte.

A further patch will modify the behaviour of SPLICE_F_MORE to always be
passed to the actor if either the user set it or we haven't yet read
sufficient data to fulfill the request.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Jan Kara <jack@suse.cz>
cc: Jeff Layton <jlayton@kernel.org>
cc: David Hildenbrand <david@redhat.com>
cc: Christian Brauner <brauner@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: linux-mm@kvack.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b014a4e066c5 ("tls: wait for async encrypt in case of error during latter iterations of sendmsg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c            | 31 ++++++++++++++++++++++++++++++-
 include/linux/fs.h     |  1 +
 include/linux/net.h    |  1 +
 include/linux/splice.h |  1 +
 include/net/sock.h     |  1 +
 net/socket.c           | 10 ++++++++++
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 5dbce4dcc1a7d..e8591211044a3 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -767,6 +767,17 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
+/*
+ * Indicate to the caller that there was a premature EOF when reading from the
+ * source and the caller didn't indicate they would be sending more data after
+ * this.
+ */
+static void do_splice_eof(struct splice_desc *sd)
+{
+	if (sd->splice_eof)
+		sd->splice_eof(sd);
+}
+
 /*
  * Attempt to initiate a splice from a file to a pipe.
  */
@@ -869,7 +880,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
-			goto out_release;
+			goto read_failure;
 
 		read_len = ret;
 		sd->total_len = read_len;
@@ -909,6 +920,15 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 	file_accessed(in);
 	return bytes;
 
+read_failure:
+	/*
+	 * If the user did *not* set SPLICE_F_MORE *and* we didn't hit that
+	 * "use all of len" case that cleared SPLICE_F_MORE, *and* we did a
+	 * "->splice_in()" that returned EOF (ie zero) *and* we have sent at
+	 * least 1 byte *then* we will also do the ->splice_eof() call.
+	 */
+	if (ret == 0 && !more && len > 0 && bytes)
+		do_splice_eof(sd);
 out_release:
 	/*
 	 * If we did an incomplete transfer we must release
@@ -937,6 +957,14 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 			      sd->flags);
 }
 
+static void direct_file_splice_eof(struct splice_desc *sd)
+{
+	struct file *file = sd->u.file;
+
+	if (file->f_op->splice_eof)
+		file->f_op->splice_eof(file);
+}
+
 /**
  * do_splice_direct - splices data directly between two files
  * @in:		file to splice from
@@ -962,6 +990,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		.flags		= flags,
 		.pos		= *ppos,
 		.u.file		= out,
+		.splice_eof	= direct_file_splice_eof,
 		.opos		= opos,
 	};
 	long ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a8d708fe08b30..72a956d243c2e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2104,6 +2104,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+	void (*splice_eof)(struct file *file);
 	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
diff --git a/include/linux/net.h b/include/linux/net.h
index ba736b457a068..9054f17e4b631 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -187,6 +187,7 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+	void		(*splice_eof)(struct socket *sock);
 	int		(*set_peek_off)(struct sock *sk, int val);
 	int		(*peek_len)(struct socket *sock);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc3..41a70687be853 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -38,6 +38,7 @@ struct splice_desc {
 		struct file *file;	/* file to read/write */
 		void *data;		/* cookie */
 	} u;
+	void (*splice_eof)(struct splice_desc *sd); /* Unexpected EOF handler */
 	loff_t pos;			/* file position */
 	loff_t *opos;			/* sendfile: output position */
 	size_t num_spliced;		/* number of bytes already spliced */
diff --git a/include/net/sock.h b/include/net/sock.h
index 3158cf0269ac9..b987074f80965 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1229,6 +1229,7 @@ struct proto {
 					   int *addr_len);
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
+	void			(*splice_eof)(struct socket *sock);
 	int			(*bind)(struct sock *sk,
 					struct sockaddr *addr, int addr_len);
 	int			(*bind_add)(struct sock *sk,
diff --git a/net/socket.c b/net/socket.c
index bb2a209e3e28d..1d71fa44ace45 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -129,6 +129,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
+static void sock_splice_eof(struct file *file);
 
 #ifdef CONFIG_PROC_FS
 static void sock_show_fdinfo(struct seq_file *m, struct file *f)
@@ -163,6 +164,7 @@ static const struct file_operations socket_file_ops = {
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,
+	.splice_eof =	sock_splice_eof,
 	.show_fdinfo =	sock_show_fdinfo,
 };
 
@@ -1037,6 +1039,14 @@ static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 	return sock->ops->splice_read(sock, ppos, pipe, len, flags);
 }
 
+static void sock_splice_eof(struct file *file)
+{
+	struct socket *sock = file->private_data;
+
+	if (sock->ops->splice_eof)
+		sock->ops->splice_eof(sock);
+}
+
 static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
-- 
2.51.0



