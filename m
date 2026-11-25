Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620221;
	b=Bf+WzxGS+iwnVeGpyof/hIHoYfo3U22kFmY/lhvQgEnY/5iTOkzmP+nVRXBXvnh1/mlC
	 /l3kl0H+rNepT9my1pI3wwQEfLinUGftkdfyLbFRT4OE/y6b3CX87yz6jlafDMDf/RhF3
	 p8nYOuQa8PRQ4afGQ71lufFSQ+vZaDLBOUJ6ncmBh3heUhNW9LTxZ4Z+CkKgp428KWtf8
	 iOIBWTloQ+rCQfDPA+tg8MtGbiqudNaYrdv4wRdEpjLE/Q/jHbV7jDnz7lITYERT/Z2c/
	 XZY/jLg+QMzHWnhVN7MhgXC1og1zOmbY9ocZm8Bb8C0sGkJVcrnpKdZAi/oqpKHvQeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27Lkd5qke5CeTwWghb7oMq6M7I0pqIUml1+BpUd4Hhw=;
	b=fbhNMQeMuOEKjv2Mn54THdbPzcD0WSl2SDUvyGCGyODgse1G3ggRKM0mu+BVwecPpCsl
	 WjJQGMLc2sCD7mhp/mPSKN6x8pxEURwKVW+Hdi1m7kvFIrhVt/4p85k9bz8zWnxUBe5OH
	 S31YF3uyYrvaVwqp2kqj2Ed9k77IqHQBuRHSJC52RTQ5ki+J1hI7YkyDtT0kli/5G2eYe
	 xH1hqHRDc2QgRN+csU27hERn++Cg55Vjqq+DC5NMZXJwy1UwqB4ePL1XeUyu23iJ6CZZF
	 wcZT0WykhN97okaT6vEl0SLJZtTbjK0hdFenDv/DpSjOND5QJ3+rw/L5FkVARxhtaFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vyt6MDj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F46606A31E;
	Wed, 25 Nov 2026 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vyt6MDj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D21F000CA;
	Wed, 25 Nov 2026 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620220;
	bh=27Lkd5qke5CeTwWghb7oMq6M7I0pqIUml1+BpUd4Hhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vyt6MDjWRNVYEY1Zelo8TXdsmrOQIJOLP70647IQiYuQSJbn0mCx890hsn55LLYJ
	 D65dGsFgk3sLO4a3cxm8L0cylvNGFQqNhTHz+1eXQHbNwyUzMeBflY2NgGmrFBuSUu
	 F0fwnpLNZKH2KBa0bZUyktyPrBXoo2bMEb0kmP+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0849/1005] smb: client: dont retry failed writes forever regardless of mount options
Date: Wed, 25 Nov 2026 15:36:27 +0100
Message-ID: <20261125143841.600036785@linuxfoundation.org>
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

commit bb203c9af62adb59d82e8ecb715e778329e3b771 upstream.

smb2_writev_callback() marks a write for retry whenever the server fails
it with a replayable status, ignoring smb2_should_replay() and so the
hard and retrans mount options.  The latter is only used to decide on a
backoff, so on a soft mount with no retrans, a server that keeps failing
a write with e.g. STATUS_INSUFFICIENT_RESOURCES gets it resent forever,
thousands of times per second, hanging anything waiting on its
writeback:

  smb3_write_err: R=005c359e[2] ... offset=0x27000 len=0xfdf0 rc=-11
  (569410 times in 255 seconds, same subrequest, no growing delay)

Only retry such writes when cifs_io_should_replay() allows it, as already
done for send errors in smb2_async_writev(), otherwise let them fail.
Writeback thus keeps retrying them with backoff, within its retry
window.  Base the decision on the result of this attempt rather than on
wdata->result, which is never reset on success and may hold the error of
a previous attempt.

Writes cut short by a reconnect get retried regardless too.  Have
writeback ones go through cifs_io_should_replay() as well, so that they
back off and soft mounts give up on them after the retry window, as on
other replayable errors.  Other writes cut short keep being retried,
without spending the mount's retries, but as replays, since they may
have reached the server, unless umount -f stopped them, which fails them
with -EIO.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5096,6 +5096,7 @@ smb2_writev_callback(struct TCP_Server_I
 	};
 	unsigned int rreq_debug_id = wdata->rreq->debug_id;
 	unsigned int subreq_debug_index = wdata->subreq.debug_index;
+	bool cut_short = false;
 	ssize_t result = 0;
 	size_t written = 0;
 
@@ -5109,10 +5110,7 @@ smb2_writev_callback(struct TCP_Server_I
 		credits.instance = server->reconnect_instance;
 		result = smb2_check_receive(mid, server, 0);
 		if (result != 0) {
-			if (is_replayable_error(result)) {
-				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-				__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-			} else {
+			if (!is_replayable_error(result)) {
 				wdata->subreq.error = result;
 				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_bad);
 			}
@@ -5141,12 +5139,9 @@ smb2_writev_callback(struct TCP_Server_I
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-		result = -EAGAIN;
-		break;
+		fallthrough;
 	case MID_RETRY_NEEDED:
-		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		cut_short = true;
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -5200,9 +5195,17 @@ smb2_writev_callback(struct TCP_Server_I
 	wdata->credits.value = 0;
 
 	/* see if we need to retry */
-	if (is_replayable_error(wdata->result) &&
-	    cifs_io_should_replay(wdata))
+	if (is_replayable_error(result) &&
+	    ((cut_short && wdata->rreq->origin != NETFS_WRITEBACK &&
+	      !cifs_io_stopped(wdata)) ||
+	     cifs_io_should_replay(wdata))) {
 		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq,
+				 netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	} else if (cut_short && cifs_io_stopped(wdata)) {
+		result = -EIO;
+	}
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
 	release_mid(server, mid);


