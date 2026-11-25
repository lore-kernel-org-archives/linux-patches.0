Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625974;
	b=dutYtMKR7YxAdwMsGoPNf2A2AIcclRq3LWu6DejZv8Z0CEUSMY9wKayPJPrBHxll6VqC
	 paqDW0ZB0vIwXZG3ebUDRcmdRZgoRJPnGyqy2Pcspolg4YSWuKl97q5f8Twyvu+ZujjLA
	 iujyz2vrPkMFfJTxYVao0oojPRv9Yr60BUzUIYrSbg67JdY4QRCt3Pypwogcm2u9lQOFX
	 MTK2A2dP4VDdHwMcFhrvOrVuwecOWOsR5zze2WzYJALcU9zscMnRpW+5Y5KYoVfXeH3Hm
	 a/LrhTkOzafN6eRrdt5z6kureZBC/Rvcb0zEoictJwARjM8a4YorWOlH5h2z7bcj05w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A12mYFa4HiShVlTTOK2dPsA4NIKuV4v/6u6K+EjoC38=;
	b=oPySq6NCK8eoA8jdCLVw5L6Mf+Raibx1/2rXsoYzJXAenugCHiomZV8rDbKsF4Gl3wDC
	 y5dVw/wlITGTLL1D1eTQ8oI8ynMrYxznCmy0x2c4vrHZYa0qd5ygH6RLcmDvC4/Qvgd0y
	 2F5/AmO3sVVZ/pdYCPkSFzw8jXeu71fXDx6u2iM8y7UUf2waI0DtDo4el5/IRdsET8dOr
	 zme+8toTN1xasVte/2iP8rNbVp47UwNiteIoiTfhVjkq1zoOEpELiYxbbOg/zzBVdwVAn
	 pIfbFAV9aljhDBZnsY4ALLluZ1x0dvqTUSYGGR9Y6XpCcW42D84BeNYrhVCwYd0adSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BZ/QO0KH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD690606A321;
	Wed, 25 Nov 2026 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZ/QO0KH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D731F000C6;
	Wed, 25 Nov 2026 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625974;
	bh=A12mYFa4HiShVlTTOK2dPsA4NIKuV4v/6u6K+EjoC38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ/QO0KHGcrd8Eluwo+F3mCQFP/WFa7VUy7/ytQeGsc1a1z0tKwnJ4ZVZ5J92HqUG
	 tRg8Oun6mMsv/iZqfd0F4Iw6Vdfb/VhCi9UXryLAnpKbKR9J//Cz6Wjk6es7gpX/nf
	 p4s62XxRL0dHmoqSEA9WHw/UzG6IY8CJ/ACTwL9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 689/816] smb: client: issue writes from a worker if the task is dying
Date: Wed, 25 Nov 2026 15:37:17 +0100
Message-ID: <20261125143905.133095383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -158,6 +158,7 @@ struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 struct workqueue_struct	*serverclose_wq;
 struct workqueue_struct	*cfid_put_wq;
+struct workqueue_struct	*cifs_writeback_wq;
 __u32 cifs_lock_secret;
 
 /*
@@ -2016,9 +2017,16 @@ init_cifs(void)
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
@@ -2089,6 +2097,8 @@ out_destroy_netfs:
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_writeback_wq:
+	destroy_workqueue(cifs_writeback_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2134,6 +2144,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_writeback_wq);
 	destroy_workqueue(cifsiod_wq);
 }
 
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2051,6 +2051,7 @@ extern struct workqueue_struct *cifsoplo
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_writeback_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -97,10 +97,16 @@ retry:
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
@@ -134,6 +140,24 @@ fail:
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


