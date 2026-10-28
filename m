Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209393;
	b=XE58c3NfGGvyURrowHYJWrGauZ0vyYZ7u2+yeDJkaPLoIl8ivYo0vRZwH2+Xr5jBdBo2
	 4nHGGFqqkna1EwWD4tQ1EKI3pUzIUswFOcT4cgSXzxHxKZCHD2aoqfYomHlNCzzuQfVGK
	 a+7ylIYsMMG8S3gR28Hani4g2bTg0xbLWo3Ed58Tgsvebm74vFarGkQ6qIBogWH66sISj
	 jlc5r50/zM0JEl5WV3wtYgVkveqqpjeRJNoZqBOMRLAIkJEFEvaiMD0ESN1qaunQoPmHr
	 0d9il6z8st0ps4BCQ4EdHNWoAsSZBbHCsZzN3SI8cbXNQFWyeor9ToVq+SnmrxmyvYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4LS5CnNU+KOqr+mwSdYwtjgxw+zBs/ZME3IERctpdwM=;
	b=FEWe+e/FaMABBGtCMSqK1z5ADXfZnFWI3BFVn+ycUUG3eT/zdksk5uefJ89ql37F59E6
	 rBnmCZGzwc9VmAgREPLRFGRYJl2tThOAgqe5eDsWNqs/Ok0rErQurthGm+Y5749AyZ4Ri
	 KHw97XARzuZEJnaafjDPZjtSPPdhB5e6uBb8H1pcGHgZT3Rxn6NAxFyyBdZw209PqjKkE
	 ZoQgb5Mlq0KyQ/RVgHeIpqMC6VIbM23lYopux/2K8T5Gv8iS1nncoHakSbZbfHtqVRF1b
	 0B3BBoFnNVr8392lPGGSEiF6/ZAIHwPYHqk1FlI94H8rjO8wN5BM37/96niPvnu5EDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxB+JTM3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFEE606A31C;
	Wed, 28 Oct 2026 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YxB+JTM3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC501F01825;
	Wed, 28 Oct 2026 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209392;
	bh=4LS5CnNU+KOqr+mwSdYwtjgxw+zBs/ZME3IERctpdwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxB+JTM3USSEFSgc1mw9pu8LJYk2AMQe02NkFaDGW3k+bKKG5rQQeONrhAwnqAf6M
	 vYFdeyX3qQTP4pUVzGDbMXTqjzFlh5vM02hkk5EPxrFaWz4rHIigdjJ9ejmxoWETvL
	 3dEqtpGeSIlrm6m+eOo21zkJLILvkG/tVz8h5Ul4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 454/516] sctp: revalidate output stream after association connect wait
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028170014.235443145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit b7ad72414c673ce1fa1f463e807cd4f34f8be9bf upstream.

When message interleaving is enabled, the first send waits for association
establishment before building its data chunks.  The wait drops the socket
lock, and handshake processing can reduce the output stream count to the
peer-advertised inbound stream count.  sctp_stream_init() then frees the
extension of every removed stream.

The sender resumes with the stream that it checked before the wait.  If the
peer removed that stream, sctp_outq_tail() later dereferences its NULL
extension.  Fatal-oops policies then panic the host.

KASAN: null-ptr-deref in range [0x38-0x3f]
RIP: sctp_outq_tail+0x49e/0xaa0
Call Trace:
 sctp_primitive_SEND
 sctp_sendmsg_to_asoc
 sctp_sendmsg

A range check alone is insufficient.  Stream reconfiguration can grow the
output count again while the lock is released without recreating extensions
freed by the earlier shrink.  The stream can then be in range while its
extension remains NULL.  The send-buffer wait has the same issue.

Factor the range and extension checks into a helper and repeat both after
each send-path wait that drops the socket lock.  Once the lock is
reacquired, the validation remains stable through data creation and
queueing.

If validation fails after the connect wait, the auto-created association is
already established.  Return ESRCH so the existing caller path keeps it
under state-machine ownership instead of freeing it directly, which would
leave protocol, counter and socket state inconsistent.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261007035739.3472432-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1785,6 +1785,18 @@ static int sctp_sendmsg_check_sflags(str
 	return 1;
 }
 
+static int sctp_sendmsg_check_stream(struct sctp_association *asoc,
+				     struct sctp_sndrcvinfo *sinfo)
+{
+	if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt))
+		return -EINVAL;
+
+	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext))
+		return sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
+
+	return 0;
+}
+
 static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				struct msghdr *msg, size_t msg_len,
 				struct sctp_transport *transport,
@@ -1799,16 +1811,9 @@ static int sctp_sendmsg_to_asoc(struct s
 	long timeo;
 	int err;
 
-	if (sinfo->sinfo_stream >= asoc->stream.outcnt) {
-		err = -EINVAL;
+	err = sctp_sendmsg_check_stream(asoc, sinfo);
+	if (err)
 		goto err;
-	}
-
-	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
-		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
-		if (err)
-			goto err;
-	}
 
 	if (sp->disable_fragments && msg_len > asoc->frag_point) {
 		err = -EMSGSIZE;
@@ -1832,10 +1837,9 @@ static int sctp_sendmsg_to_asoc(struct s
 		err = sctp_wait_for_sndbuf(asoc, transport, &timeo, msg_len);
 		if (err)
 			goto err;
-		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
-			err = -EINVAL;
+		err = sctp_sendmsg_check_stream(asoc, sinfo);
+		if (err)
 			goto err;
-		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
@@ -1850,6 +1854,11 @@ static int sctp_sendmsg_to_asoc(struct s
 				err = -ESRCH;
 				goto err;
 			}
+			err = sctp_sendmsg_check_stream(asoc, sinfo);
+			if (err) {
+				err = -ESRCH;
+				goto err;
+			}
 		} else {
 			wait_connect = true;
 		}


