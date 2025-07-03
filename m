Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB32E7BBE;
	Thu,  3 Jul 2025 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554575; cv=none; b=PtFY2cGSBR/C/rVvPuzoZQU4WAhV3Qh1pqU0rlxUOB1oJ/FF25VyB5PTQFeDxXGvdM37SK+Kt0VwTIB8hyMFfkLmCbZhjCkTKpTsDnafAupEVrbjwKaMuEUY7iUF4OXLsAn2ffyPKdahEyvzjJ/1LFjnk2rJSciE4Zf6+IwUObs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554575; c=relaxed/simple;
	bh=nvtHURu4Y28uzKNRS05T2vwnUBvtOravSoCed+evr94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaExO3Ob5r+OEwyRHkUopGyXCr9V8WSI1fDLgOFLufcNGAgoDIItCpfDRC1i2KnDTgKqUp37utk+V7OsIM5rtzl7Fcomcuaa3S0wzw0IJREVHU48HBsxILrgzJXZbGsiP8wZ90qRAGjszxp3WmEX2uRDTDonZVzg0aGQwVfPlVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNmSAD31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNmSAD31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C690C4CEE3;
	Thu,  3 Jul 2025 14:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554575;
	bh=nvtHURu4Y28uzKNRS05T2vwnUBvtOravSoCed+evr94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNmSAD31ApLgE5/Z50eOc1tg1FzpHaN703isfpO2e3sXVeI+04OtKroqS7Bajv+Py
	 Y+PEEsof5x04tr1LTO9kc3ReX0MPVmk9FTr2mohkTTssj567JbG7VgyVohuTS+yw97
	 JhsjRNeTMSD8p0cKvN1YtydbRdAq3sdFb0v24vg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Jha <njha@janestreet.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 013/263] sunrpc: dont immediately retransmit on seqno miss
Date: Thu,  3 Jul 2025 16:38:53 +0200
Message-ID: <20250703144004.821024520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Jha <njha@janestreet.com>

[ Upstream commit fadc0f3bb2de8c570ced6d9c1f97222213d93140 ]

RFC2203 requires that retransmitted messages use a new gss sequence
number, but the same XID. This means that if the server is just slow
(e.x. overloaded), the client might receive a response using an older
seqno than the one it has recorded.

Currently, Linux's client immediately retransmits in this case. However,
this leads to a lot of wasted retransmits until the server eventually
responds faster than the client can resend.

Client -> SEQ 1 -> Server
Client -> SEQ 2 -> Server
Client <- SEQ 1 <- Server (misses, expecting seqno = 2)
Client -> SEQ 3 -> Server (immediate retransmission on miss)
Client <- SEQ 2 <- Server (misses, expecting seqno = 3)
Client -> SEQ 4 -> Server (immediate retransmission on miss)
... and so on ...

This commit makes it so that we ignore messages with bad checksums
due to seqnum mismatch, and rely on the usual timeout behavior for
retransmission instead of doing so immediately.

Signed-off-by: Nikhil Jha <njha@janestreet.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6f75862d97820..21426c3049d35 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2771,8 +2771,13 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 	case -EPROTONOSUPPORT:
 		goto out_err;
 	case -EACCES:
-		/* Re-encode with a fresh cred */
-		fallthrough;
+		/* possible RPCSEC_GSS out-of-sequence event (RFC2203),
+		 * reset recv state and keep waiting, don't retransmit
+		 */
+		task->tk_rqstp->rq_reply_bytes_recvd = 0;
+		task->tk_status = xprt_request_enqueue_receive(task);
+		task->tk_action = call_transmit_status;
+		return -EBADMSG;
 	default:
 		goto out_garbage;
 	}
-- 
2.39.5



