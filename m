Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620224;
	b=TdzezfO+3nX2wFtfQZUuZHtDDov5RdIlzHH850Gx0QiFP2AsI02U6RQVFYuQEHaFux00
	 HPY8a8BR11vqJ9Sy4A/yBaDT+haXzHDY0Fwp4yY2Y5nqh+SYLYwwmjmcM9uKBX23N5aYJ
	 bXik4CWY/0uagoTr9RHY0GSmzDhMOcfo7yPLVZewW4HJ5EVypSTvSi0LczyyEt+lww6Ee
	 ex+1Ro2pEuCU9uJ7aukYTtVlYkK+dIWmS3e59HtXARJNs/oCNJ037ma0YgaQApjP4/4Vi
	 XQUFZiYt8JpdWbxjPI0eeWBYPHaIU6XpPdng0JWEnqnfP8ThFf/M0G2K7q3VuLhRbuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKGIPNUY3sQcx7nJRDgfOo4ivLozEPtaGeAzjhJUXA0=;
	b=taTFeqX4NrfFVcp5lmaEhIsTrSVWmoJ5Fu8ULXS62qgxMbjMSRzw4N2iQaiueFA0XpeR
	 geaD7wsJmpox1O1hUSiiEm0aBvXwqh+v1hWVyerw7InOqW5QsNwS6oAVZgM3IMoTk+8LO
	 doyWcorHAaDa3lF4bWKBsnPkb3W4dYwOxpN6hhDH+HfsgQWzInTtqh0Y8dkbIqYv1irXi
	 1s4TfNvkARoMt2bRtmYdAbz4DMUPXJRN39vOWejcaLxoH8hk60JcpujS0wOQ2YGAVup7a
	 4krK+MzDiOAJhIjIIWD4Gns1rNtR6/RodmlMZVYjtxIv2P7QHw8pbQ2f/BC3XMvGrYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpBdcE5S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE7606A31E;
	Wed, 25 Nov 2026 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpBdcE5S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC981F000C6;
	Wed, 25 Nov 2026 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620224;
	bh=NKGIPNUY3sQcx7nJRDgfOo4ivLozEPtaGeAzjhJUXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpBdcE5ScnDAD1HeMhv4KLGGfSmufTkqV/o8GIrbwNvHlVD+cj66b/gMQKL7xkbMx
	 UJrS3L06oHKsgOx/+F72PClkgYi2DTU5Sp0QPWLUj2gOdpaOeecIt905iewk6Ht4Qu
	 n4WPo1yT5T4hyPxo3iWlATAhpHO6a3bQt/mL1yyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0850/1005] smb: client: dont spend read retries on reads cut short by a reconnect
Date: Wed, 25 Nov 2026 15:36:28 +0100
Message-ID: <20261125143841.622522203@linuxfoundation.org>
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

commit 1d4fcbfad120ddc30b81651f12096bfc84052f9a upstream.

smb2_readv_callback() always retries a read cut short by a reconnect,
but still asks cifs_io_should_replay() whether to mark it as a replay.
On a soft mount that spends one of the mount's retransmissions and grows
the backoff, so a later replayable error on the reissued read can fail
it early.

Mark such reads as replays without consulting the mount's retries, as
already done for writes.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4739,6 +4739,7 @@ smb2_readv_callback(struct TCP_Server_In
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
+	bool cut_short = false;
 
 	if (rdata->got_bytes) {
 		rqst.rq_iter	  = rdata->subreq.io_iter;
@@ -4787,6 +4788,7 @@ smb2_readv_callback(struct TCP_Server_In
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
 do_retry:
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+		cut_short = true;
 		rdata->result = -EAGAIN;
 		if (server->sign && rdata->got_bytes)
 			/* reset bytes number since we can not check a sign */
@@ -4859,7 +4861,7 @@ do_retry:
 
 	/* see if we need to retry */
 	if (is_replayable_error(rdata->result) &&
-	    cifs_io_should_replay(rdata))
+	    (cut_short || cifs_io_should_replay(rdata)))
 		rdata->replay = true;
 
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,


