Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DFB3E49F5;
	Tue, 21 Jul 2026 22:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674447; cv=none; b=O3miGXedsxnnbtkIaXzvfxz9QTjY1koyhOVRWLlMSJDQRkWnoyOrn+xNgOOZv5Nt0vtQDrmb9umDzkiaTagn3vRln3QnCwaaji/UFNzEjdJdVusdtbZ1dnUDozoy38QjgW0vHHWtjGSgbF1vGMpc3AKQphoNb7SimOMH1QkymC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674447; c=relaxed/simple;
	bh=ZmzSl1JJxZoRdBX9GnDhX6PZL+JWPZ4Ayci3t+8MeJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhJo0N5Wt0d0v3ERNYezkfxt8eSCO+ls7gKh4g9CGxKsE207QYFvlaIycHhXvfR25/1fYw5TcUW1+/3xYyZJSjmi8/MBtn6Vdg7Av/k1vb97KWdTYIW/La4D15dt8mNdwmkgNtgqAZhUJtxYtjUAioRYoSRbTyJajJHx3809uGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci3fH95o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci3fH95o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5621F000E9;
	Tue, 21 Jul 2026 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674445;
	bh=/8qz19Xp2EA9uhv6F7cHvE14LvBmiVDl11vQeIrVE+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci3fH95oEfeMAxf/YjlEd+PfQsQ/Ju83fFlNk6OXKnasjudm8+tWo+t15dKQCG1Ui
	 qu/VR3PCqxXsi/XAlbF/tpOGqh+ODbVKzdlmSSvYd9l9WkLoyW9QrmRY16D3DZcaCp
	 ieTnYNn8oADZO3MPGegrt0wgISRuMJuLDXodwoys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 501/699] sctp: validate STALE_COOKIE cause length before reading staleness
Date: Tue, 21 Jul 2026 17:24:20 +0200
Message-ID: <20260721152406.997749016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -2419,9 +2420,15 @@ enum sctp_disposition sctp_sf_cookie_ech
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
@@ -2463,13 +2470,13 @@ static enum sctp_disposition sctp_sf_do_
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
@@ -2480,8 +2487,6 @@ static enum sctp_disposition sctp_sf_do_
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	err = (struct sctp_errhdr *)(chunk->skb->data);
-
 	/* When calculating the time extension, an implementation
 	 * SHOULD use the RTT information measured based on the
 	 * previous COOKIE ECHO / ERROR exchange, and should add no


