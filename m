Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060884;
	b=nsN81sqciWGTOpUrmUYE0ttg3yjwKUrFS+xhgSrBIqBLa797gBCJ/p9lZkSWXTRT5fUc
	 N8bBxwcn0Z3h/DKpW3ec65n/fn9qG3SHgIixzGAPG1nU67f21ulJyWvvejDBDDK0zWFDo
	 20trwXeVW4ut2lvlhNVcA5EER5xWxSDk8UyqHV5jlmGEXDq3eZ/aIewQrwnSXivzhFjfS
	 jL6sMWNbMaHXfaSvfdTp1uYlrcjBm+Ar6xRgkC/gDVTQvK9AD1LtDdGXF71vV+pDmt6cj
	 lnk174JnuvhAmTQODnNrke22r7fcItEpj+pVqDrYZJc67mt9omq3XHMgPv5xL8XGhRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kEJRQcCPYtuFv/YINnX6qMHhtLtp/iunttpEbWaB5H4=;
	b=j711y95rjo07TOOMUjRGMLvbAhumXKZUE3fUfFBQIzYUKcYkW1DR3z7Ds2FGDQ8TVwiK
	 Y4EqB1QRIeTLu9l/XEd1PGY4Isbw3D96Uip36RdysGsGXlas5y8+8k0/GsMIG5v4bA3QE
	 4wng7lw3Qc1wpRl40pH4Zl2b2xkbg0rRXLTgonKD60Yn1DmkA3yOw2UvA2N/KzoAg7ml8
	 o8X/xdkcGo2OIQHizKVGwlM28S08c/PKtmEmsjahzZdbtmUm05r6mh8oc506e4QcucoJ9
	 QCS5bfBLBdPxKsv/w7B43cJiqSAHY/5zQIUBgD984SgaVnJITQeC7hDHA9kjY035Tiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQZHQSpS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A744606A336;
	Sat,  7 Nov 2026 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQZHQSpS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220CB1F0089F;
	Sat,  7 Nov 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060884;
	bh=kEJRQcCPYtuFv/YINnX6qMHhtLtp/iunttpEbWaB5H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQZHQSpSigafAjyRXCPoR5iJo6pY5PR1McLyMz20WjvEpnD9icAv0XZhjH49cJUxk
	 mZJl4HU5TheS+reQGaXjEJskAJzJQqS4ysxzxYCf2SexoDlupOz1uSFGRttyyJDD4/
	 nYjn/WRu9QJkL6hXFxEuhz9/bJNMbVG3nVw15Bok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0263/1536] net/rds: dont use unpin_user_pages_dirty_lock() from atomic context
Date: Sat,  7 Nov 2026 08:37:59 -0500
Message-ID: <20261107135005.068934271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit d100966325f782aa7775e5f0e8fb04f66f56308e ]

rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
send completion path via

  rds_ib_tasklet_fn_send()
    rds_ib_send_cqe_handler()
      rds_message_put()
        rds_message_purge()
          rds_rdma_free_op() / rds_atomic_free_op()

which runs in tasklet (softirq) context.  Both functions unpin the
user pages of the op with unpin_user_pages_dirty_lock(), which uses
set_page_dirty_lock() and thus may take the folio lock and sleep.
Sleeping in softirq context is not allowed and can deadlock or crash.

Dirtying the pages with the non-sleeping set_page_dirty() instead
would just trade one bug for another, as pointed out during review:
the pinned range can be file-backed.  rds_pin_pages() pins with
FOLL_LONGTERM, which refuses fs-dax but takes the page-cache pages
of a MAP_SHARED file mapping just fine, and RDS does not restrict
what memory the caller registers as an RDMA destination.

For a file-backed page, set_page_dirty() from a tasklet can take
non-irq-safe filesystem locks (e.g. mapping->i_private_lock and
inode->i_lock in block_dirty_folio()) and deadlock against the task
it interrupted.  Without the folio lock, it races with truncation
clearing folio->mapping, which is the race set_page_dirty_lock()
exists to close.  The pre-pin_user_pages() version of this code
dirtied pages that way from the tasklet, so that bug is older than
the sleeping unpin.

The page dirtying therefore has to move to process context, not
merely avoid the folio lock.  When the final rds_message_put() runs
in atomic context, rds_rdma_free_op() and rds_atomic_free_op() now
leave the op's pages pinned and flag the op. Later, rds_message_put()
hands the message to a work item that unpins the flagged ops' pages
and frees the message from process context. Here,
unpin_user_pages_dirty_lock() is safe outside the atomic context.
Everything else keeps running in the caller's context exactly as
before: the rest of the purge - the zerocopy completion, the socket
put and the MR reference drops - as well as RDMA writes, whose pages
the remote side only reads and which unpin without dirtying,
everything on rds_tcp, and final puts that already happen in process
context (socket close, connection teardown).

Deferring only the unpin means the work item touches nothing but the
pinned pages and the rds module's own memory: it cannot call back
into a transport module, so it changes nothing about the transports'
shutdown and unload ordering.  rds_exit() drains any pending unpin
work via destroy_workqueue(rds_wq) before the module goes away.

The Oracle UEK kernel avoids the sleeping unpin by calling
set_page_dirty() directly from the tasklet, which is subject to the
file-backed page problem above, so this deliberately does not follow
UEK here.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 26 +++++++++++++++++++++++++
 net/rds/rdma.c    | 49 ++++++++++++++++++++++++++++++++++++-----------
 net/rds/rds.h     | 10 ++++++++++
 3 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 5d9286da53c9a..abd87e97b2737 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -180,6 +180,19 @@ static void rds_message_purge(struct rds_message *rm)
 		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
+static void rds_message_unpin_worker(struct work_struct *work)
+{
+	struct rds_message *rm = container_of(work, struct rds_message,
+					      m_unpin_work);
+
+	if (rm->rdma.op_unpin_deferred)
+		rds_rdma_op_unpin_pages(&rm->rdma);
+	if (rm->atomic.op_unpin_deferred)
+		rds_atomic_op_unpin_page(&rm->atomic);
+
+	kfree(rm);
+}
+
 void rds_message_put(struct rds_message *rm)
 {
 	rdsdebug("put rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
@@ -187,8 +200,21 @@ void rds_message_put(struct rds_message *rm)
 	if (refcount_dec_and_test(&rm->m_refcount)) {
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		BUG_ON(!list_empty(&rm->m_conn_item));
+
 		rds_message_purge(rm);
 
+		/* A final put in atomic context cannot dirty the ops'
+		 * user pages on unpin, so rds_rdma_free_op() and
+		 * rds_atomic_free_op() deferred it.  Finish the unpin,
+		 * and the free, from process context.
+		 */
+		if (rm->rdma.op_unpin_deferred ||
+		    rm->atomic.op_unpin_deferred) {
+			INIT_WORK(&rm->m_unpin_work, rds_message_unpin_worker);
+			queue_work(rds_wq, &rm->m_unpin_work);
+			return;
+		}
+
 		kfree(rm);
 	}
 }
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 34d9333e4229f..37695056756be 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -483,22 +483,36 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 		kref_put(&mr->r_kref, __rds_put_mr_final);
 }
 
-void rds_rdma_free_op(struct rm_rdma_op *ro)
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro)
 {
 	unsigned int i;
 
+	for (i = 0; i < ro->op_nents; i++) {
+		struct page *page = sg_page(&ro->op_sg[i]);
+
+		/* Mark page dirty if it was possibly modified, which
+		 * is the case for a RDMA_READ which copies from remote
+		 * to local memory
+		 */
+		unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
+	}
+}
+
+void rds_rdma_free_op(struct rm_rdma_op *ro)
+{
 	if (ro->op_odp_mr) {
 		kref_put(&ro->op_odp_mr->r_kref, __rds_put_mr_final);
+	} else if (in_task() || ro->op_write) {
+		/* An RDMA write's pages are only read by the remote
+		 * side; unpinning without dirtying does not sleep.
+		 */
+		rds_rdma_op_unpin_pages(ro);
 	} else {
-		for (i = 0; i < ro->op_nents; i++) {
-			struct page *page = sg_page(&ro->op_sg[i]);
-
-			/* Mark page dirty if it was possibly modified, which
-			 * is the case for a RDMA_READ which copies from remote
-			 * to local memory
-			 */
-			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
-		}
+		/* Dirtying the pages on unpin can sleep; leave them
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ro->op_unpin_deferred = 1;
 	}
 
 	kfree(ro->op_notifier);
@@ -507,7 +521,7 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 	ro->op_odp_mr = NULL;
 }
 
-void rds_atomic_free_op(struct rm_atomic_op *ao)
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao)
 {
 	struct page *page = sg_page(ao->op_sg);
 
@@ -515,6 +529,19 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
 	unpin_user_pages_dirty_lock(&page, 1, true);
+}
+
+void rds_atomic_free_op(struct rm_atomic_op *ao)
+{
+	if (in_task()) {
+		rds_atomic_op_unpin_page(ao);
+	} else {
+		/* Dirtying the page on unpin can sleep; leave it
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ao->op_unpin_deferred = 1;
+	}
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 5b1c072e2e7ff..7a5863c118edd 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -424,6 +424,12 @@ struct rds_message {
 
 	void			*m_final_op;
 
+	/* Unpins the ops' user pages and frees the message from
+	 * process context when the final put happens in atomic
+	 * context: dirtying the pages on unpin can sleep.
+	 */
+	struct work_struct	m_unpin_work;
+
 	struct {
 		struct rm_atomic_op {
 			int			op_type;
@@ -447,6 +453,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			struct scatterlist	*op_sg;
 			struct rds_notifier	*op_notifier;
 
@@ -462,6 +469,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			unsigned int		op_bytes;
 			unsigned int		op_nents;
 			unsigned int		op_count;
@@ -938,6 +946,8 @@ int rds_cmsg_rdma_map(struct rds_sock *rs, struct rds_message *rm,
 			  struct cmsghdr *cmsg);
 void rds_rdma_free_op(struct rm_rdma_op *ro);
 void rds_atomic_free_op(struct rm_atomic_op *ao);
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro);
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao);
 void rds_rdma_send_complete(struct rds_message *rm, int wc_status);
 void rds_atomic_send_complete(struct rds_message *rm, int wc_status);
 int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
-- 
2.53.0



