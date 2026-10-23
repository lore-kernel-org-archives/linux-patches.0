Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774006;
	b=FZopIUdfkcvP1tbxOPQXtbESAtfIHB6LHn5/2Qoz5p6KkCD2F0qeazM6ff2Ik6tIm8fy
	 gi6iara6cr/oGU6ELtVH1TAx6TLH7lj/rK5gewxHXRdL5Bq4/dcsen8XFK9zSGxxX2MzB
	 wnVDYGZ4Kzhtxi2CZAmpeUyA37BfeL/sDC7MroO9CHmMsk7OnV9LQSjTlh8krdQfCn2j9
	 eDZP1DXhAI7CjRQffOSNt9xsAA+pSe2edBYPs9nLC4l0GlguO8Axdou3yhtzOFmBfF2ZF
	 CMlf8u08Y12Y7/9EXdAdbbYE+3CUVxfNXs6r3gv9NG0AzrgdvSG3eliatzYa8pJ8Rqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hAOtVy7+TrFNutHzlgZ7WgjUaxmtllVpwroP/5n22+Q=;
	b=m+az9kMT2oEkLHKCZYdwDECVb0Yg9RxPbOSXD4ajqq90Zg7gxr2DggLZK+y4lFlhM2VS
	 KadwLyQYGVhTVuRfNUmMUcmFgmDOiKVeDUXLT8rBzJZodDimq2nyCKlA3X2k0y2aGVfYN
	 mP9rNmg2hFv22Gt5h0Qx101ZuU58Yjas+mnMrEVT/G9RnVX17OJXNneBvH0QXARA6n3wA
	 ojateMj+5lkisYLdJgzr8vejunwoVXKdFcS+U63mdbYDsdzkC8/ZxH7pxPTLUIU9JhY+C
	 rQu1FN2LrINhSSG4Ng4y/Crrj6lfIQvoHRlE7bmsGslg/c+C2/zS3HbHZ+DelPyd3xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiIZ5mPQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FA3606A338;
	Fri, 23 Oct 2026 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiIZ5mPQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F00F1F01825;
	Fri, 23 Oct 2026 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774006;
	bh=hAOtVy7+TrFNutHzlgZ7WgjUaxmtllVpwroP/5n22+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiIZ5mPQmtYvlEKVx++mOVBhlckfzwwHcrgZeeYHNwEb7oSVgN/4H/WOW1IYh/mu8
	 7hlKUFCn2MY3EnbC8k5i3ooKOTEQPDBHKLxfa2B11w+tFf6anwptsEunzb9WtZpMrd
	 BINoFejcp7X91ItXyZif5xQSsZBM0orfa9b4HMjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 088/193] sctp: revalidate output stream after association connect wait
Date: Fri, 23 Oct 2026 18:36:05 +0200
Message-ID: <20261023163716.288356243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -1829,10 +1834,9 @@ static int sctp_sendmsg_to_asoc(struct s
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
@@ -1847,6 +1851,11 @@ static int sctp_sendmsg_to_asoc(struct s
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


