Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620353;
	b=my2GUgQJrz3jfCDzBCC2YTpp+RHDBXGXO15ZsblSQUKmb8z/WVaH0tIWzGPFsJSwfHXt
	 HXtSiGRYX4qJVZp7d3CgeRIsobZJFif3epUsr5wMi/y+ttcHyRRFtnLzlSlkAkDfsYvt6
	 iissMiNyr9+o3Xe+T1CdAVvYErRrpgL3tjhJfu6tcnvNGAStSGYbiCSmL/2Nc1j6eNV95
	 Fhd/jy0cilIGDa0h+99KG3OIaDdfabUzbpsudJpNhhHlcHJSY9P9b3aAjHnenfIPQ1UUt
	 0o3TlFBExstbHyS4wg0z0lZyFoU0BvRw67J27MBiRNimyfI+w/0wjAsE7vmVrqLQkPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2x+E61xPpivOjdxGYpnXRTm1VionBGreWPo0q2E+ghI=;
	b=SqBKSj/5v+4+U6S19ddh32RskZAj9dE6P14/Cm7JvVZ/mwdP0LAqmApI2OmazbT5637l
	 t8VAWwdsCD1ZunFR4JaM6VBMOANP71jjARGER6K6+UgJC/LaNkmnngdz9wSbCL2GEJBUa
	 5SqgIh7bvK1F0z3ga6vc1SA5+b2+11xj3ss6JKD5rvn9bWuLQXNAmJrrfeGy4a3Uo/840
	 klehps+AnaFv1sOQwycKIQ+6l3HCgS8XshJaCB5q6fepYjs0WJ+e61XucMN/OdFujahwx
	 kTsCQg5ekrzGLHcDQ+2z++KbJN3JDodcd/2/h62U1vugLXICrCsB5t8pjVnYB9U9UGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doLyZPqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FF4606A31E;
	Wed, 25 Nov 2026 15:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doLyZPqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AEA1F000C6;
	Wed, 25 Nov 2026 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620353;
	bh=2x+E61xPpivOjdxGYpnXRTm1VionBGreWPo0q2E+ghI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doLyZPqjKs7ZEcfJzBemzPMQhcUUUZvv5k9zTkBDuFVEN7zOapcf8oMoNvnEz41W6
	 gtxJe6ikFYYisI+DcXB5UHqsP4Q+ISDBVf0xks9s5Gz1z8tTnmIaJo3eoh8tw3rzs6
	 FAPfD88jJ0PVGAIXOETdGJ7iwg2bhfJ7UpSGpzys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0844/1005] smb: client: retry writeback on interrupts and allocation failures
Date: Wed, 25 Nov 2026 15:36:22 +0100
Message-ID: <20261125143841.485486823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit fb39fbd782bcd2dccd05f633bc6ac348209dc272 upstream.

Issuing writes from a worker only helps when the task is already dying
at issue time.  A fatal signal can still arrive after that check and
before __smb_send_rqst() checks again, or while waiting for a credit in
cifs_call_async(), or in the middle of a send.  The write then fails
with -ERESTARTSYS, which isn't a replayable error, so netfs marks the
subrequest failed and drops its folios clean:

  netfs_sreq: R=000041f6[2] UPLD SUBMT ... s=400000 0/400000
  smb3_write_err: R=000041f6[2] ... offset=0x400000 len=0x400000 rc=-512
  netfs_failure: R=000041f6[2] UPLD ... upload e=-512

losing 4MiB of a 64MiB file closed by a task killed meanwhile.  A failed
memory allocation while building or sending a write drops its data the
same way.

No server status maps to an interrupt error or to -ENOMEM, so for
writeback such errors always mean the client gave up locally.  Mark the
subrequest for retry, with backoff and giving up on umount -f, as cifs
did with is_retryable_error() before switching to netfslib and as NFS
does for these errors.  netfs collects writeback from a workqueue, so
the retry gets prepared and issued with no signals pending.

Only the SMB2 read and write paths sleep before replaying, so SMB1 would
resend such writes right away.  Move the sleep to cifs_issue_read() and
__cifs_issue_write().

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c    |   14 ++++++++++++++
 fs/smb/client/smb2pdu.c |   12 ++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -179,6 +179,9 @@ static void __cifs_issue_write(struct ne
 	if (wdata->req->cfile->invalidHandle)
 		goto fail;
 
+	if (wdata->replay && wdata->cur_sleep)
+		msleep(wdata->cur_sleep);
+
 	wdata->server->ops->async_writev(wdata);
 out:
 	return;
@@ -312,6 +315,9 @@ static void cifs_issue_read(struct netfs
 	    subreq->rreq->origin != NETFS_DIO_READ)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 
+	if (rdata->replay && rdata->cur_sleep)
+		msleep(rdata->cur_sleep);
+
 	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
 	rc = rdata->server->ops->async_readv(rdata);
 	if (rc)
@@ -2705,6 +2711,14 @@ void cifs_write_subrequest_terminated(st
 		spin_unlock(&inode->i_lock);
 	}
 
+	if ((is_interrupt_error(result) || result == -ENOMEM) &&
+	    wreq->origin == NETFS_WRITEBACK && cifs_io_should_replay(wdata)) {
+		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq,
+				 netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	}
+
 	netfs_write_subrequest_terminated(&wdata->subreq, result);
 }
 
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4913,12 +4913,8 @@ smb2_async_readv(struct cifs_io_subreque
 
 	shdr = (struct smb2_hdr *)buf;
 
-	if (rdata->replay) {
-		/* Back-off before retry */
-		if (rdata->cur_sleep)
-			msleep(rdata->cur_sleep);
+	if (rdata->replay)
 		smb2_set_replay(server, &rqst);
-	}
 
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(io_parms.length,
@@ -5315,12 +5311,8 @@ smb2_async_writev(struct cifs_io_subrequ
 	}
 #endif
 
-	if (wdata->replay) {
-		/* Back-off before retry */
-		if (wdata->cur_sleep)
-			msleep(wdata->cur_sleep);
+	if (wdata->replay)
 		smb2_set_replay(server, &rqst);
-	}
 
 	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
 		 io_parms->offset, io_parms->length, iov_iter_count(&wdata->subreq.io_iter));


