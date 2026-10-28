Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211781;
	b=5m7mGW6xe88NHHRl1l+vbsg7uoOnmq6dOcXj3VV2NM4ATN8dRTB5BvgY47TU8Svlc2Yz
	 dTccj83d0prSvG89XHakS2a2olPPkjfCL6o7xWQ4eOSc4LOwCVtPfjUv8VQ54684CfJXZ
	 EOlI16mrUOlKDVd1dOxHKfKacewjCmztZxQebfws/DJMR9915Rx3cVPHZov+h5DTD6/D+
	 S423jnuVqWBR2nzHZlNimNuiWE1BJU14/3FyQL6bSMizIJSq6b/8M8BL0ZmfuHHw9LYzy
	 lclJwNA7TyrPCbv6aOQY6tmW955tMIixXE8Xo+p2h7EFlZAxMCP3lLma1mfMC3PN6WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ALO8iJvm8ZZgWKlyJmOKmj+9ela6DyU6IEEl7R8ABJY=;
	b=fwNoDbR/rcD+BG8uMLyZc2uIlitu8e7nfkVBfbL5DoHDLZWAiV5K7WGWQVuADL/i0xyn
	 faB7LmP744VZecAqiNsZHZx4KcUJNlO4RT9AR1ikhkmfviQ/tiQY6NIyC9SaL5/Srd6Uv
	 KD56qMa4O7d743GKYHGa6kT41CeXoQykRZnMKTnIjpcWqYmTTp6fJSx8pssa90xITzWDR
	 40L9i+dnanQmKBVH/gMveueWkHEqYXHccrsaoThwtB3O8WUr1nxCJCcVXSrKjfv6VEYDi
	 4yB1EVtF5j6ykcsDvZ8kxY0odo7yZ9Cif7rGv/GnoiSNYHm0JHA5rpbOaSAPOQU4e8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oJQ/dLyU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2934E60A3802;
	Wed, 28 Oct 2026 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJQ/dLyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D64D1F01828;
	Wed, 28 Oct 2026 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211780;
	bh=ALO8iJvm8ZZgWKlyJmOKmj+9ela6DyU6IEEl7R8ABJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJQ/dLyUTAQ0l3amvhToHE1ec87hIIVysWHU/T9a/HusWBXyIPB7NfQytTR/Q9P+7
	 aRPz5gkKoAPHUuXTvUCjDvo0d523QIOY0T/Ncyj8r8vpgBGa0W/J30VfJ6Fgzik8kg
	 HLyIkP5sMKXQ/p6HO2cWcIe2EqVZDb1TnlDdxncs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 497/571] sctp: revalidate output stream after association connect wait
Date: Wed, 28 Oct 2026 18:00:44 +0100
Message-ID: <20261028170019.820652151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1783,6 +1783,18 @@ static int sctp_sendmsg_check_sflags(str
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
@@ -1797,16 +1809,9 @@ static int sctp_sendmsg_to_asoc(struct s
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
@@ -1830,10 +1835,9 @@ static int sctp_sendmsg_to_asoc(struct s
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
@@ -1848,6 +1852,11 @@ static int sctp_sendmsg_to_asoc(struct s
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


