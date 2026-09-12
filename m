Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F41279DC3;
	Sat, 12 Sep 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241421; cv=none; b=ce/PepmMHBDuxby6R5gLdo+o//KTXyB1Qam3UYPVRYeb5d4YbQDigMOpSeVYefI8swbL4/r070d7IQdVE/oZD2JS0brnDOkicVwACqtD7HKyyEeO/Y0FgtMmyLJVxsAeA/0amEh9HW3J6g7GHa9d0hh3yevuLHoHswA7f1bqE0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241421; c=relaxed/simple;
	bh=jluYCjzoYM9nUYrsK4AQN6j8iNPGfPlfpCYH30aZPY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hufjxXX+SC+QSSBuKMyz1JbYllJAT0t/brOA0jJ9vi5LuPysu4fC7DCQOCak2PB8OzUloHqhLhdBEm6pZwH4OF7/13lPgAHcREjaFkZSPcmquwTgYszZRdG5isnsluSQko9YPfnEBMo7ZElTIWCnNhKxSuwfBx2OByLmMG3x82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHO1iOn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHO1iOn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BA21F000FF;
	Sat, 12 Sep 2026 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241420;
	bh=3W1D6iP8TVD9frDtlmItIu2Yr49ZLJTwzZaQDA4XZ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHO1iOn4nHk1tkq9MOt7q0YUchqzPrl/DTexiU4iY7a/sVCWaHhMMQQ+R2xfF8STN
	 LzCsYJRZv4jQIBq4f+MEDBo+ZxFzn1Tuypy+gpo7J3v/trIrzbMBSs+DMfHsPqDieC
	 kMjNbMZioMrApqZphJcigd4Jnbc+gxfvxiHRpfZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 131/798] sctp: drop a chunk if its transport was removed
Date: Sat, 12 Sep 2026 08:55:59 +0200
Message-ID: <20260912065519.978220207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -63,8 +63,11 @@ void sctp_inq_free(struct sctp_inq *queu
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


