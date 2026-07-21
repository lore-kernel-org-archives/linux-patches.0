Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC73C372B5E;
	Tue, 21 Jul 2026 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654716; cv=none; b=aoP7Tag8Spw1SVJdiSYh8ZpBOBND1tcGOjbRSBlcDOtN7n/48BCd24LRHJqpjmFPHUsUvfD9mzy0APqJx3YdjvxK7mVhRzt+IzAo0jS97NBul8YiwYOHyi51APK7qu9gz/WKB9Tbo4fodNmshA6wVHoAOR5MSZvu6KOYktvTFGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654716; c=relaxed/simple;
	bh=VK36zH5JPw0nyZvm89f0BR9AfwvxpTmVHi/CIgNh6Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raWc7xuwivkYDrn0mQUhfhu4hWdY6M7yxpAMCdNeZfJ2VoS7EdsY1Xm1s9pqzFF2ZTqPeaNF7Uu+2lO5f1Vrm5qZ1F8LKkMJourMNnPRCIi59uu4uUhIP12MNMAIxwwO/Ws4TkhNSJT9dzuZae1rX38Ps6GNvw32Ok3w50SwqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdP/uM5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdP/uM5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2FC1F000E9;
	Tue, 21 Jul 2026 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654714;
	bh=URuR/h2iPjSbtTDrJsn3ryxWpWsvFhOr7wVgXkhkUts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdP/uM5LSlbd1oXyb4tZ/9oLCPMlQWrb8Y5Aars3auVO4EqLBqYEY0YNDxCgJHQfU
	 7EnbVMlAaVCfse4wcTOxfN+EDL3hfbRY0Q3Rqn+Fs2/ofSvgtrKhE0fGkkF7nEQZIU
	 I+CdFt5ce84P3TDr1sOnV1mDprjrgum2H6zT/vCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1811/2077] sctp: validate STALE_COOKIE cause length before reading staleness
Date: Tue, 21 Jul 2026 17:24:44 +0200
Message-ID: <20260721152635.460850058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -74,7 +74,8 @@ static enum sctp_disposition sctp_sf_do_
 					const struct sctp_association *asoc,
 					const union sctp_subtype type,
 					void *arg,
-					struct sctp_cmd_seq *commands);
+					struct sctp_cmd_seq *commands,
+					struct sctp_errhdr *err);
 static enum sctp_disposition sctp_sf_shut_8_4_5(
 					struct net *net,
 					const struct sctp_endpoint *ep,
@@ -2529,9 +2530,15 @@ enum sctp_disposition sctp_sf_cookie_ech
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
@@ -2573,13 +2580,13 @@ static enum sctp_disposition sctp_sf_do_
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
@@ -2590,8 +2597,6 @@ static enum sctp_disposition sctp_sf_do_
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	err = (struct sctp_errhdr *)(chunk->skb->data);
-
 	/* When calculating the time extension, an implementation
 	 * SHOULD use the RTT information measured based on the
 	 * previous COOKIE ECHO / ERROR exchange, and should add no


