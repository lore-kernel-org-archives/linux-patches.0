Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB56D38AC99;
	Sat, 17 Oct 2026 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255897; cv=none; b=eMjt0YWkoj+NkjKibhK8u/Jatu0lAhq1hbFJ7dRX5B7QmUvRR7JIUoAJ7fW+urTscPSJO7/vKSZ43ptfmkElBdZx8YTXNnpnjEGT4tRUN4mb1wTGkgcIeyKW9cWbXzetcnHiYWUmBd35HYQAPJNfbH5GijEMepr6sdubzHC1e/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255897; c=relaxed/simple;
	bh=qzMjM/FClBiPoGEoQCj1WZ+9fomSSUVP1NBwiAGHF2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVur0A+DCDFSaif40QL0YzFz9+fHCRoHHTfVg/bKZ2U8KZX7SY4j6DPutARSpJ3QM9fPEry+M0gWpe2fA5y+SY1Z8fe+1CGRWupGAC5ulcu2rF8WLL6AK9iHMDpg3GNWJOtEUw6NH84UQilD923eg8MAIPea0pJ/0TAEbK+dPZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hcTUJek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hcTUJek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FA21F000C4;
	Sat, 17 Oct 2026 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255896;
	bh=rWRudD3nqCsIcloIjUTyeuswqyy6M7k3WBzsBQGGQ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hcTUJek2a6TE2le6u8FQViGG4Dik7xHMFManDM+0WDykLEnhzlb6OAX0y0cw/MfX
	 z7CsyzmTVkDRi1h+qT2S/GPRDCUOE3Imm/RS+m0TZMqBCNb8AO7x5BlP8ugI+Q2wjL
	 C+LbGD9bRwsdyxGygMl251x8zNK8+9zrJFnp5FxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0056/1674] nfsd: size fh_verify server sockaddr slot by xpt_locallen
Date: Sat, 17 Oct 2026 17:38:48 +0200
Message-ID: <20261017160432.576917756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 71d068490098b1d23c63b2345e40675d3a1ca763 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d7ed49eef5911..6e57a9dba1a59 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -201,7 +201,7 @@ TRACE_EVENT(nfsd_fh_verify,
 	TP_ARGS(rqstp, fhp, type, access),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
@@ -240,7 +240,7 @@ TRACE_EVENT_CONDITION(nfsd_fh_verify_err,
 	TP_CONDITION(error),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
-- 
2.53.0



