Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210042;
	b=nFbjSgrTSSrlG24LlqT7CJEXCJUhMcKFuqIpR4fOLYgLoJcoEB5UkWCsqGCWPCmDYkDc
	 MfHfgohUHehv12/rKTakTF09tUGAUpr5Kbq1wNhAaA5umlkzebsKWwIw7vJ6E/kC10gjP
	 y7kfOCxMi2H5h1VqQb3ZoCZy7raFO+EjtcyZc7X5JKnJidvndovrinh1KpZCkogbbihed
	 u4qwTVtpMIiISxlzigP2uqLzs7XHt/1PdxqGLBdm9i+vfIo6RAVUZyuUwAAJ6Ixphqp77
	 QH/cOuALa4u3HJyoPktx4qXA0ve9TPXtPKgQbwTB2aUWlOWqvPy7/iOuAmj+MfA1PdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HoLpXPkbptDJj4NCgR2+Xi8bSOqzbPgWyXu7x9BlWhE=;
	b=OTKNRYH+cVTSTByCG5DOs8b5DEhgZkOfQOoWunler+QJYYoF3uZn2tgthymnu9G9g63t
	 oBpDwMzJZU2TzY2U+QxZZxIF5g5XvQNxVHHW3RaGe2MUGoV7yzPNxD0zyJAzwRxP3rFrb
	 pAwZ0litWjHtr71kMXKeSgVI9WHqG1kTIzy5fFUaZcDbtZG85ORJZMsq/kykTB8JTfLZE
	 9bKeXLkbhcYYaGlmOJKStA7HXtjG+LobXDUomC/cZqf4ceN7KNGo8H5s9VyjebFlqdM4W
	 FIw2MI/18ad/rZ77sMUV+umDHeieq4E2CcYzR/nNbpw91iDvm5Xm1zdhMTVlkdTgUgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qI0I4FLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4DB606A32D;
	Wed, 28 Oct 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qI0I4FLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FA61F01825;
	Wed, 28 Oct 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210042;
	bh=HoLpXPkbptDJj4NCgR2+Xi8bSOqzbPgWyXu7x9BlWhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qI0I4FLX+miEARp0hCj8Lut/ekeUpgeGu40gLs67UFfJIMO3/OLJ2kCvaMLj3xaSQ
	 rbGYhWBPvjsljbvcD1YYw1egJkAjzKll68wM+hQ4CNo5pqcTV/vmI4LaxUcfooDVuY
	 moToV+uIwtJ8VN20M7qqWwciCry0Nk73ci0uS+Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 049/168] sctp: revalidate output stream after association connect wait
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028165944.249327160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


