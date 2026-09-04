Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4004A4119FD;
	Fri,  4 Sep 2026 05:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498701; cv=none; b=p1fsOSMlttcko9q7plHY41fYBrK79904YVMZIjwu+mSAdfUsfTFTyeEtgu/iSb6tuQb8ftjY0ZqKYO9rYjJYuK0GYY1D6FN9xxhUyNXOnad+NnVT729zT3DhFjRJ8Y02JuSAwSoNNrzSl7crjs+i3tHrJW+9xbDsCXN0XzqiEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498701; c=relaxed/simple;
	bh=ZQnyHyCddpVS+CBw13DjlowuSL3aQQfzsTI87YBjX74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+FLweAEKk7uHlWeT5ISso01G6yt9eSJmePxgK0FjZLWYpWdkxuphQudSFBeelEYJDUM4vQAq49UXpx3fqfOitBoGNAU5SRPHpWP6/LnIBCW1NklBcvG83B7nitGRvjQC834pZn3KPbRMSH4Vf0+ElpI9N2T14qdjBaFbB5ASvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyAPtL8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyAPtL8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA8D1F00A3D;
	Fri,  4 Sep 2026 05:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498700;
	bh=1x019+g/rOw1HHbXQBkdHON+aot6nv3YORVcm4BgZqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyAPtL8p+BbFXZm1YeJoRd/9XzrG9dO90lzdwCucYj/4URpAQmP/ngv4VnVnELvDq
	 c7VMdeBdiz1FoiRkS5ukebnG+I8UyVqbIQN6lCXeeAgWvuHp0T5vcPEISNqeNeqy0S
	 8snb5Zpvvy+qDEbUwfIzNx3dj9DUscRz6rJnWS70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 155/713] nfsd: size fh_verify server sockaddr slot by xpt_locallen
Date: Fri,  4 Sep 2026 06:52:03 +0200
Message-ID: <20260904045807.302141223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 71d068490098b1d23c63b2345e40675d3a1ca763 upstream.

The nfsd_fh_verify and nfsd_fh_verify_err tracepoints declare the
server sockaddr slot sized by xpt_remotelen but fill it from
xpt_local using xpt_locallen:

    TP_STRUCT__entry(
            ...
            __sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
            ...
    )
    TP_fast_assign(
            ...
            __assign_sockaddr(server, &rqstp->rq_xprt->xpt_local,
                              rqstp->rq_xprt->xpt_locallen);
            ...
    )

When xpt_locallen exceeds xpt_remotelen, __assign_sockaddr's memcpy
writes past the reserved ring-buffer slot. In the reverse direction
(xpt_locallen < xpt_remotelen) the slot is oversized and the
unwritten tail leaks prior ring-buffer contents to trace consumers.

The write-past-end case is reachable on NFS/UDP. svc_xprt_set_remote()
is only called from svc_tcp_accept() (net/sunrpc/svcsock.c) and from
the RDMA connect path; svc_create_socket() for UDP calls only
svc_xprt_set_local(), so xpt_remotelen stays 0 for the xprt's
lifetime. Every fh_verify trace for an NFSv2/v3-over-UDP request
then copies 16 or 28 bytes from xpt_local into a zero-byte slot.

The other NFSD tracepoints that record the server address
(NFSD_TRACE_PROC_CALL_FIELDS, NFSD_TRACE_PROC_RES_FIELDS,
SVC_RQST_ENDPOINT_FIELDS) already size the server slot by
xpt_locallen; nfsd_fh_verify and nfsd_fh_verify_err were the only
exceptions.

Fix by sizing the server slot with xpt_locallen so the declared slot
matches the copy length. The client slot and its assignment already
agree on xpt_remotelen and are left untouched.

Fixes: 051382885552 ("NFSD: Instrument fh_verify()")
Fixes: 948755efc951 ("NFSD: Replace dprintk() call site in fh_verify()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-1-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/trace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -271,7 +271,7 @@ TRACE_EVENT_CONDITION(nfsd_fh_verify,
 	TP_CONDITION(rqstp != NULL),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
@@ -310,7 +310,7 @@ TRACE_EVENT_CONDITION(nfsd_fh_verify_err
 	TP_CONDITION(rqstp != NULL && error),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)


