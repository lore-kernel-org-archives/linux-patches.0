Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9814C394476;
	Mon, 23 Mar 2026 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277063; cv=none; b=JDqXVs6Twdfy9mjMGB7Dv7BVQ541i5NmiSCchFBz75Y6CAuUCb3FnyYxqVVvVXNlppvOz/zgptBflDYA9Kcngcbwg+36qTX5VHD0mp/owWCgj4G6L4Z7+IvP95fMlKb2GChq7p5Smzd3dx6Sq0/9zXYTl/hvphuRmGwVBrkPxGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277063; c=relaxed/simple;
	bh=xskb2567+iJ9D2HNsmKxC1ZfjiSWsIwjfI0rwRgPWX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmmwzwWYttE3glMdbchl2PSXvsA/oaXqgWCA5+QeMF54gxJdK1M+v/LNhosXeo1acIzPB4rcTHhx37aSdeEgtM2P8GopNgGQLXDUiy3R3BJELHnMy2JSIBk5w1RQDZA24As+TP790obgnN9149QdaD4ssnGKFLvxBiMQ6Jo0+40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwouSMfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwouSMfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000FDC4CEF7;
	Mon, 23 Mar 2026 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277063;
	bh=xskb2567+iJ9D2HNsmKxC1ZfjiSWsIwjfI0rwRgPWX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwouSMfVZ9W/4yY1Vyv23i7MpGtFgrCJuC7ZcrF4PpoBTvgFY1YGtstAaAeAmvau/
	 coyNS5wDbc92QPlaMdSQwPMZKN2UyN9Qv1sNimLs9c0K5vqdRsJYDwVXmVPIuPk6Mo
	 P2TLVGHMAf+notFfZa77LkPDVQmyKKhEDaedUDyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicholas Carlini <npc@anthropic.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 307/460] nfsd: fix heap overflow in NFSv4.0 LOCK replay cache
Date: Mon, 23 Mar 2026 14:45:03 +0100
Message-ID: <20260323134534.039559360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 5133b61aaf437e5f25b1b396b14242a6bb0508e2 upstream.

The NFSv4.0 replay cache uses a fixed 112-byte inline buffer
(rp_ibuf[NFSD4_REPLAY_ISIZE]) to store encoded operation responses.
This size was calculated based on OPEN responses and does not account
for LOCK denied responses, which include the conflicting lock owner as
a variable-length field up to 1024 bytes (NFS4_OPAQUE_LIMIT).

When a LOCK operation is denied due to a conflict with an existing lock
that has a large owner, nfsd4_encode_operation() copies the full encoded
response into the undersized replay buffer via read_bytes_from_xdr_buf()
with no bounds check. This results in a slab-out-of-bounds write of up
to 944 bytes past the end of the buffer, corrupting adjacent heap memory.

This can be triggered remotely by an unauthenticated attacker with two
cooperating NFSv4.0 clients: one sets a lock with a large owner string,
then the other requests a conflicting lock to provoke the denial.

We could fix this by increasing NFSD4_REPLAY_ISIZE to allow for a full
opaque, but that would increase the size of every stateowner, when most
lockowners are not that large.

Instead, fix this by checking the encoded response length against
NFSD4_REPLAY_ISIZE before copying into the replay buffer. If the
response is too large, set rp_buflen to 0 to skip caching the replay
payload. The status is still cached, and the client already received the
correct response on the original request.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Reported-by: Nicholas Carlini <npc@anthropic.com>
Tested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    9 +++++++--
 fs/nfsd/state.h   |   17 ++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5809,9 +5809,14 @@ nfsd4_encode_operation(struct nfsd4_comp
 		int len = xdr->buf->len - (op_status_offset + XDR_UNIT);
 
 		so->so_replay.rp_status = op->status;
-		so->so_replay.rp_buflen = len;
-		read_bytes_from_xdr_buf(xdr->buf, op_status_offset + XDR_UNIT,
+		if (len <= NFSD4_REPLAY_ISIZE) {
+			so->so_replay.rp_buflen = len;
+			read_bytes_from_xdr_buf(xdr->buf,
+						op_status_offset + XDR_UNIT,
 						so->so_replay.rp_buf, len);
+		} else {
+			so->so_replay.rp_buflen = 0;
+		}
 	}
 status:
 	op->status = nfsd4_map_status(op->status,
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -473,11 +473,18 @@ struct nfs4_client_reclaim {
 	struct xdr_netobj	cr_princhash;
 };
 
-/* A reasonable value for REPLAY_ISIZE was estimated as follows:  
- * The OPEN response, typically the largest, requires 
- *   4(status) + 8(stateid) + 20(changeinfo) + 4(rflags) +  8(verifier) + 
- *   4(deleg. type) + 8(deleg. stateid) + 4(deleg. recall flag) + 
- *   20(deleg. space limit) + ~32(deleg. ace) = 112 bytes 
+/*
+ * REPLAY_ISIZE is sized for an OPEN response with delegation:
+ *   4(status) + 8(stateid) + 20(changeinfo) + 4(rflags) +
+ *   8(verifier) + 4(deleg. type) + 8(deleg. stateid) +
+ *   4(deleg. recall flag) + 20(deleg. space limit) +
+ *   ~32(deleg. ace) = 112 bytes
+ *
+ * Some responses can exceed this. A LOCK denial includes the conflicting
+ * lock owner, which can be up to 1024 bytes (NFS4_OPAQUE_LIMIT). Responses
+ * larger than REPLAY_ISIZE are not cached in rp_ibuf; only rp_status is
+ * saved. Enlarging this constant increases the size of every
+ * nfs4_stateowner.
  */
 
 #define NFSD4_REPLAY_ISIZE       112 


