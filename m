Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1715126BFF;
	Thu,  3 Jul 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553940; cv=none; b=nfjJgpKId1B7cb+pEJqip03GVUDoiGIdTkpKK86DWUyujjtf63vuIhdHI/IoYJMwoQxJ98PBDt1qvWBu/pl8qBq9UmIQpnaxlXG2LVDTiiZcx1oZWLaxvIRXa0rwYxMVvDqtyXia2bYLQFk5w/ummgfu4Vn9O0hJgZ/iuvDiWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553940; c=relaxed/simple;
	bh=EHgkoWigC64ksFKKmyYnWxMhvOHgIcZTuyLP4eXCqmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz3Zfo5NcHWJf5JKCSkdQrgAAp1C/R3MVZZbHl2PGy7cCk0u6ymeWrT+BEBjGEVguQpgKtCvmWxVFZUy5Vw4y2nQ9otpho91F1sijnzV7shbxpVlk+g3KFbZ8duhB71oC9aQTM0+yiUSZ0LHfgqH87pICeKEm3r07SeZRrh4y8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4DSTnd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4DSTnd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF6C4CEE3;
	Thu,  3 Jul 2025 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553938;
	bh=EHgkoWigC64ksFKKmyYnWxMhvOHgIcZTuyLP4eXCqmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4DSTnd3Cdbgspzj1B3AKt81WodHeJCfpfscKwiOZO9Kv4RgXA2xP+V609whs4BIO
	 YcF9qxOvPy2O1vbu5ovwhPICXCZJdnX0OBsGaeufXB3wI1CWDkh4bMf0R57V5qKWiz
	 VRmnifVZ6e6wNc+D9IRc2njsuXRkbCi8EhgOD/s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Jha <njha@janestreet.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/218] sunrpc: dont immediately retransmit on seqno miss
Date: Thu,  3 Jul 2025 16:39:17 +0200
Message-ID: <20250703143956.329733841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17a4de75bfaf6..e492655cb2212 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2749,8 +2749,13 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
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



