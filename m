Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7D473C68;
	Tue, 21 Jul 2026 22:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672490; cv=none; b=JhdIa9x06Z3XdULGqEQKC72gJR0llYhakWejgHzXjw+XTSBhgNfvW2Nx3MxTS2iN8t6GD8GmE/fgP0r206TZDpGz4g0kZgROFTLEVQohYwrlA/N19yLoe1DsX7TdGJLMemV6RDU/90xeZqm4DXosQWIC+96j7B9tZQTr0Nx93xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672490; c=relaxed/simple;
	bh=rhuiuuyILWCA2eJq/LTZlHanekW6OoNjgEiCaQfs23I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naUvb4gXqCfoVfpwB6K71w8/WlpCKwtCcIu6VkraD8IR5WN3Q3w0EjGooAdSzQGZ1haInqNPzxHD26saAPFRtXo551eVd3FI/SJUwNr/OaDS3nP09o2S+X1XJxjw8jNHU05ZkilWUnDGh8P84QTZCZoUZ4Mxn4nz7SSGhxxFS+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR/7Thj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR/7Thj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9E31F000E9;
	Tue, 21 Jul 2026 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672489;
	bh=D2bl+gf3SXs2hJ9fHLQsdCVlrJ79opsGvmnRrwlc3+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BR/7Thj+UG7NS9sjGJV/i9SpkKM8VyBrUEnxXR6Be3B1F7Nj50V0Gm5eEsZ9s+B/K
	 mXcjaFErvKFZAUrCs/Lq5XqeNkKgL3rjVcu7Grcn+MzUVAxwHp/oScNgCr4fUr5SPE
	 p8qNYVA9fwo1qEaa2aup3FizCG9jGOZTekf8VMK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 645/843] sctp: validate STALE_COOKIE cause length before reading staleness
Date: Tue, 21 Jul 2026 17:24:40 +0200
Message-ID: <20260721152420.576722569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 1cd23ca80784223fa2204e16203f754da4e821f8 upstream.

When an ERROR chunk with a STALE_COOKIE cause is received in the
COOKIE_ECHOED state, sctp_sf_do_5_2_6_stale() reads the 4-byte Measure
of Staleness that follows the cause header:

	err   = (struct sctp_errhdr *)(chunk->skb->data);
	stale = ntohl(*(__be32 *)((u8 *)err + sizeof(*err)));

err is the first cause in the chunk, not the STALE_COOKIE cause that
caused the dispatch, and nothing guarantees the staleness field is
present. sctp_walk_errors() only requires a cause to be as long as the
4-byte header, so for a STALE_COOKIE cause of length 4 the read runs
past the cause, and for a minimal ERROR chunk past skb->tail. The value
is echoed to the peer in the Cookie Preservative of the reply INIT,
leaking uninitialized memory.

sctp_sf_cookie_echoed_err() already walks to the STALE_COOKIE cause, so
check its length there and pass it to sctp_sf_do_5_2_6_stale(), which
reads that cause instead of the first one. A STALE_COOKIE cause too
short to hold the staleness field is discarded.

The read is reachable by any peer that can drive an association into
COOKIE_ECHOED, including an unprivileged process using a raw SCTP socket
in a user and network namespace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260704033545.2438373-2-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -73,7 +73,8 @@ static enum sctp_disposition sctp_sf_do_
 					const struct sctp_association *asoc,
 					const union sctp_subtype type,
 					void *arg,
-					struct sctp_cmd_seq *commands);
+					struct sctp_cmd_seq *commands,
+					struct sctp_errhdr *err);
 static enum sctp_disposition sctp_sf_shut_8_4_5(
 					struct net *net,
 					const struct sctp_endpoint *ep,
@@ -2479,9 +2480,15 @@ enum sctp_disposition sctp_sf_cookie_ech
 	 * errors.
 	 */
 	sctp_walk_errors(err, chunk->chunk_hdr) {
-		if (SCTP_ERROR_STALE_COOKIE == err->cause)
-			return sctp_sf_do_5_2_6_stale(net, ep, asoc, type,
-							arg, commands);
+		if (err->cause != SCTP_ERROR_STALE_COOKIE)
+			continue;
+		/* The staleness is only meaningful if the cause is long
+		 * enough to hold it; a shorter one is malformed.
+		 */
+		if (ntohs(err->length) < sizeof(*err) + sizeof(__be32))
+			break;
+		return sctp_sf_do_5_2_6_stale(net, ep, asoc, type,
+					      arg, commands, err);
 	}
 
 	/* It is possible to have malformed error causes, and that
@@ -2523,13 +2530,13 @@ static enum sctp_disposition sctp_sf_do_
 					const struct sctp_association *asoc,
 					const union sctp_subtype type,
 					void *arg,
-					struct sctp_cmd_seq *commands)
+					struct sctp_cmd_seq *commands,
+					struct sctp_errhdr *err)
 {
 	int attempts = asoc->init_err_counter + 1;
-	struct sctp_chunk *chunk = arg, *reply;
 	struct sctp_cookie_preserve_param bht;
 	struct sctp_bind_addr *bp;
-	struct sctp_errhdr *err;
+	struct sctp_chunk *reply;
 	u32 stale;
 
 	if (attempts > asoc->max_init_attempts) {
@@ -2540,8 +2547,6 @@ static enum sctp_disposition sctp_sf_do_
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	err = (struct sctp_errhdr *)(chunk->skb->data);
-
 	/* When calculating the time extension, an implementation
 	 * SHOULD use the RTT information measured based on the
 	 * previous COOKIE ECHO / ERROR exchange, and should add no


