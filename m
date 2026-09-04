Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD0421235;
	Fri,  4 Sep 2026 06:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502611; cv=none; b=AonnElJDPtoaIqxzfhp0ifspmUtrAp/mOleSIOhJKt3Rua3sFMlit1yYt9rVZSjB65mfSim50NOmmUzZloN6zDrmeV4KT742cCfqwYQSEAUVEmLVuXS+3q2J+elWugZQPJtxVEcDtXwDzMvJ2UTzYw6dGCs+9h3dOzPFmywXRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502611; c=relaxed/simple;
	bh=YfU5pn1eL98koPOcZoM+WLkdtk2Hanv2d5KM+HSpvnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNClm5dSFj2f5AuOK+ElTVLg2fvgVokKi8XR23hnpLYjhv61a/zAB4rMP8X7gYDErrGiXI7oUwyc184dcKwDeXOfIWhw5JdnT4VOPauui07xxE9chIJpXPpzoR+PltpuqoXKKt6idoguKma9y3fzbTmabS0Ove7rSYApQt5IHBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWvOnh5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWvOnh5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CD51F00A3D;
	Fri,  4 Sep 2026 06:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502610;
	bh=7yNHZPdok5wrtTxb6FRunlDmLXUdUMoCH+BnZ7Lig5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWvOnh5zVdj/bqYD4+FRVYkIFwh7F04WZWA0dRYaf+NPs/JYntu4UVyU5XNxQSUEo
	 OTfpKHUF7PSoIJhzS52AmD4UsP88+6eTTqs2d2pMpW2T+8nPVgkCpnk7mqHH3a2zBd
	 pIaZUBrX7VbeqcdWoXn55mKUjL0YhREmfri36b/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 266/403] sctp: drop a chunk if its transport was removed
Date: Fri,  4 Sep 2026 07:01:09 +0200
Message-ID: <20260904045740.910288872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 03a9d10ecf71f54b2af8020935f2033d4a132be5 upstream.

sctp_rcv() resolves the transport once per packet and leaves it in
chunk->transport. The lookup reference, or the one sctp_add_backlog() takes
if the socket is owned by userspace, keeps it around until the chunk has
been processed.

An authenticated ASCONF DEL-IP can remove it in the meantime.
sctp_assoc_rm_peer() takes the transport out of the association and calls
sctp_transport_free(), which tags it dead and drops the reference the
association held. There is a window on both paths: the packet can sit on
the socket backlog, and on the direct path the lookup completes before
bh_lock_sock().

The DATA chunk in that packet puts the removed transport back into
asoc->peer.last_data_from. Once the packet is done that reference goes
away and the transport is freed by RCU, so the next delayed SACK carries
the pointer into the SACK chunk and sctp_outq_select_transport() reads the
freed transport's state.

Drop the chunk in sctp_inq_push(), next to the existing rcvr->dead check.
Both paths reach it with the association's socket lock held. The peer
retransmits it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/aoUJHQmxL0LFIMCw@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/inqueue.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -71,8 +71,11 @@ void sctp_inq_free(struct sctp_inq *queu
  */
 void sctp_inq_push(struct sctp_inq *q, struct sctp_chunk *chunk)
 {
-	/* Directly call the packet handling routine. */
-	if (chunk->rcvr->dead) {
+	/* Directly call the packet handling routine.  Drop the chunk if the
+	 * receiver or the transport it was looked up on is gone.
+	 */
+	if (chunk->rcvr->dead ||
+	    (chunk->transport && chunk->transport->dead)) {
 		sctp_chunk_free(chunk);
 		return;
 	}


