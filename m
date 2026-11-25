Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623392;
	b=4Q9z81VmFjfZxqTAQ5Ex2XSdpWJBtppiDLgH1OpAlcV1xJexNau/vmK30jhwNoVtC17U
	 BwpIFsRLNzyLRvFgmM/yIpQ4ONgfz7SXfNckcYsJxkmbuSCT7ReYaWjhWWSXOl4kzrM7y
	 9TrBaXKa0hI7qUMr4eKyFMMW9i6fV51+I0eBgUdHtIKhcbkqCoN+0f6F+jos1XPfs3NeC
	 Ct/8NC48EKrX1dB2x9TLY4I/tFOZ/wg0/XIzl/4oBFNBXwKG7KxJnImgQSqMIuLqeFR/b
	 o7jkY4uvfxw4aPSRdr2YL4ju69PovVqf+ESj9vdY/8UjS0HWw+iIiyncHF+T+iLPxsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KuzhSQ/YKnc0i6j4EXz5xVkM7khOJzneizTYfq65ZFw=;
	b=z8ewZBG/z8akG3Wl6EHRxq77nNX6yzdN3QIyNz/GgVxqDnoUFLcUiBYtNOfDrqlSzr3g
	 rI4Pr7O93vqUGbGyBtv5r8NbaRAnSXjeUikcwGfcOn4IWXN6khGUfPt+LQVq0KqiyxWpH
	 ctIfYKo3rzsMQvR/0Yrkp33CpQZEl3kMju0wc1IO3nzRA5Me1xA8x1CeBO9fu+1Adorgs
	 77gRIA3+aNodL0jkBJxvPKNWnbLoBDz35QaweZXr8G/aaxaBv+fsaEFC9KGDvDaYQ1QbO
	 ky2qR8f6ocXJapbMyHocNd3Naw0/1z2T1XM3BDxZxAeA8j0A0qhC9YK0v8tgIxBKyiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFzysqOI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B998606A31E;
	Wed, 25 Nov 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFzysqOI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC11F000C4;
	Wed, 25 Nov 2026 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623392;
	bh=KuzhSQ/YKnc0i6j4EXz5xVkM7khOJzneizTYfq65ZFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFzysqOIvKksTxNBeIk/kQ0kv8NvAvWBs5ra9l6E9WcoXniBfwPpxqwcMoeRh9M6h
	 YW8ilO/w0WgPYukXmlvI0DmnutENc9XS4gMFebgNg30/g2vzUBspxqorxq256dWI1m
	 KfHlLNnnDI8sGZuCvzcoM3wCrRqhlDEKIb8P8Yyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 845/990] smb: client: issue writes from a worker if the task is dying
Date: Wed, 25 Nov 2026 15:36:52 +0100
Message-ID: <20261125143841.826047556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 1a747bacf250959703c68fed1bb643f888dd3ad2 upstream.

A task with a fatal signal pending can't send on the socket:
__smb_send_rqst() refuses it upfront with -ERESTARTSYS, as SIGKILL can't
be blocked and a send interrupted halfway forces a reconnect.  Writeback,
however, runs in the context of whoever starts it, so when a dying task
flushes dirty pages - close() racing with SIGKILL, or fd teardown during
exit_group() - every write subrequest gets refused:

  smb3_write_err: ... offset=0x1400000 len=0x400000 rc=-512
  cifs_flush_err: ino=... rc=-512

Since the switch to netfslib, a failed upload ends writeback with the
folios clean, so the data is silently lost: the server ends up with
20MiB of a 64MiB file while stat(2) reports the full size.

Issue writeback subrequests of dying tasks from a new cifswritebackd
workqueue instead, like afs does for all of its writes, so they get sent
from a context with no signals.  Leave direct and unbuffered writes
alone, as their callers get the error.  Use a dedicated WQ_UNBOUND
workqueue as the writes may block for long on credits, sends or reopens,
e.g. on hard mounts with an unresponsive server, and must not hold up
other cifs work such as reconnects, nor starve the WQ_MEM_RECLAIM
rescuer of cifsiod_wq.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c   |   13 ++++++++++++-
 fs/smb/client/cifsglob.h |    1 +
 fs/smb/client/file.c     |   26 +++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -198,6 +198,7 @@ struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 struct workqueue_struct	*serverclose_wq;
 struct workqueue_struct	*cfid_put_wq;
+struct workqueue_struct	*cifs_writeback_wq;
 __u32 cifs_lock_secret;
 
 /*
@@ -2076,9 +2077,16 @@ init_cifs(void)
 		goto out_destroy_serverclose_wq;
 	}
 
+	cifs_writeback_wq = alloc_workqueue("cifswritebackd",
+					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!cifs_writeback_wq) {
+		rc = -ENOMEM;
+		goto out_destroy_cfid_put_wq;
+	}
+
 	rc = cifs_init_inodecache();
 	if (rc)
-		goto out_destroy_cfid_put_wq;
+		goto out_destroy_writeback_wq;
 
 	rc = cifs_init_netfs();
 	if (rc)
@@ -2149,6 +2157,8 @@ out_destroy_netfs:
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_writeback_wq:
+	destroy_workqueue(cifs_writeback_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2194,6 +2204,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_writeback_wq);
 	destroy_workqueue(cifsiod_wq);
 }
 
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2108,6 +2108,7 @@ extern struct workqueue_struct *cifsoplo
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_writeback_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -106,10 +106,16 @@ retry:
 #endif
 }
 
+static bool cifs_writeback_dying(struct netfs_io_subrequest *subreq)
+{
+	return subreq->rreq->origin == NETFS_WRITEBACK &&
+		fatal_signal_pending(current);
+}
+
 /*
  * Issue a subrequest to upload to the server.
  */
-static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct cifs_io_subrequest *wdata =
 		container_of(subreq, struct cifs_io_subrequest, subreq);
@@ -143,6 +149,24 @@ fail:
 	goto out;
 }
 
+static void cifs_issue_write_worker(struct work_struct *work)
+{
+	struct netfs_io_subrequest *subreq;
+
+	subreq = container_of(work, struct netfs_io_subrequest, work);
+	__cifs_issue_write(subreq);
+}
+
+static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+{
+	if (unlikely(cifs_writeback_dying(subreq))) {
+		subreq->work.func = cifs_issue_write_worker;
+		WARN_ON_ONCE(!queue_work(cifs_writeback_wq, &subreq->work));
+		return;
+	}
+	__cifs_issue_write(subreq);
+}
+
 static void cifs_netfs_invalidate_cache(struct netfs_io_request *wreq)
 {
 	cifs_invalidate_cache(wreq->inode, 0);


