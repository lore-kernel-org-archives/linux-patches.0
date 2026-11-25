Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623039;
	b=WQvK2Ex9jE8a8iLDzSpzxKoeKqBG75jYo24fuKelmTWXhd1TCZfq9AYcsiIRD7G7Omln
	 mqabeDtm7T/V41KNnk7B80BwmO4ZTlA5YOjETngjZI7Vpk+V+cXQtx9ErPJfoyFydA4DX
	 bQbpzY6if556vu2tIavDvv1uuAUNTmhOM0keeUGqprXn7ARmjx/2emxAkgsVP3xSD8F2n
	 qIuDJrxAQXHMM+Yrves6WZ5B8clueLoare7YF+E2E92sL/pfxe+P+I5ZouOEnjG57FZER
	 pyVUZBXGnxp27GsaFrLoQFvIKhDlGTBZadTcsPyk3TBvIhuuejKUvSd8+RCSimy9ePA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OVLHUR2oe+zY757bTpwE6aWTaywvUFhdWuZzEuEOJ6k=;
	b=KVqIFrhirtgsHsrEPJsPwqdHj4DI766DhrCPLoNUusn9vtmZRDjTN/AT4yUa9qcZeII5
	 3TuYbwn5F3wOEmagHE6yd1dE5lyzKIcBvZ6UeZ78UFITv5W7seYpH6c+KummGqTgasgbS
	 xl+xE8TGYnQH1qFe5yAWn0vWu9dy/lf+BqMITqlatPts1ckUdm79atI9eKmtO2ITsrKda
	 iwxrCD4sekn9COsq3b7g9jOgnsMl0I3+n6cYXLiowWHgraARYOAoYAQI6y3EVmiwzwFnm
	 xCcaK0zI9wsCK0ABwDV99G0yPbi4NixgFGE7jJvI1sxi+lDXP8aQY3DSw0uhqz7vT4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ohw+Tr22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF68D606A32E;
	Wed, 25 Nov 2026 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ohw+Tr22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3081F000CA;
	Wed, 25 Nov 2026 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623039;
	bh=OVLHUR2oe+zY757bTpwE6aWTaywvUFhdWuZzEuEOJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ohw+Tr22Ubw8CQ4S8zXPrjGeAQiYugAyv1cKk5f5bD1huoq9wS0D+JPpQUa/brvt1
	 dMoqu8gpnYxd/PysDt1goSZZHJUEeYz/yplqZBGx1d4GpfBZdH0GFhinhe3l7cG5Bn
	 9d8bb+z2w8OpSL4wB+rMnR8RQ2NvXyiFTahZJXqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 728/990] netfs: keep the prepare_read errno when abandoning read retries
Date: Wed, 25 Nov 2026 15:34:55 +0100
Message-ID: <20261125143839.125574004@linuxfoundation.org>
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

commit d88a0c3a96fd6d7228d04532cecb23f23676aa2d upstream.

When ->prepare_read() fails while retrying a read,
netfs_retry_read_subrequests() marks the subrequest failed and abandons
the rest, which overwrites the error of every failed subrequest with
-ENOMEM.  The reader then gets -ENOMEM for e.g. a handle that couldn't be
reopened (-EHOSTDOWN, -ENOENT), a credit wait interrupted by a signal
(-ERESTARTSYS) or umount -f (-EIO).  The first pass doesn't have this
problem, as netfs_cancel_read() keeps the errno.

Record the errno of ->prepare_read() in the subrequest and keep the error
of subrequests that already failed, using -ENOMEM only for those
abandoned while still waiting for a retry.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_retry.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -28,6 +28,7 @@ static void netfs_retry_read_subrequests
 	struct netfs_io_subrequest *subreq;
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct list_head *next;
+	int ret;
 
 	_enter("R=%x", rreq->debug_id);
 
@@ -140,8 +141,11 @@ static void netfs_retry_read_subrequests
 
 			/* Renegotiate max_len (rsize) */
 			stream->sreq_max_len = subreq->len;
-			if (rreq->netfs_ops->prepare_read &&
-			    rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = 0;
+			if (rreq->netfs_ops->prepare_read)
+				ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -222,7 +226,9 @@ static void netfs_retry_read_subrequests
 				part = netfs_limit_iter(&source, 0, part, stream->sreq_max_segs);
 
 			netfs_stat(&netfs_n_rh_download);
-			if (rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -258,7 +264,9 @@ abandon:
 		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
-		subreq->error = -ENOMEM;
+		if (!subreq->error ||
+		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+			subreq->error = -ENOMEM;
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}


