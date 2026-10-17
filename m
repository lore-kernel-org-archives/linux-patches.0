Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C329632FA18;
	Sat, 17 Oct 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259211; cv=none; b=dk6CcU1MLYg7Tza9YuR5+FsDWb6m2IVzGO2oadt4QOYlWrIpgfkNywPomcasAH4aO4dF40VtMIB/EChb6ZaTv0PA52G2XKMVgSqR/OIqNtKdKZiqgYxUeLgZMJ3O8kOb3JZBQhbCukhf3H8iZFfmg3A13cEEtINzZODPEcv/ui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259211; c=relaxed/simple;
	bh=d4ZERmRFTeszG1ROkc9Zxptfm8jTvkm60jDh6hlhntM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1jMRfwHXWsGz8Pr+haYZva6GtJqin5cLAMZvNXcckEbPwBiz+agPUEHvXBMymEugwI0eZqBsWvxZAKmj8rLPBnv4POZG+gsfnLZiyYD9Q8s1xqCwPpyVkDnnLsLOxkgukGdGqBN9reLtsg6Lp14Ep3Pilm0xdjuOZpGNM4jOeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHvZv2Zk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHvZv2Zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35361F000C4;
	Sat, 17 Oct 2026 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259209;
	bh=BFlT44vUPgCUl4ZlPnO48OHAec20G565IYZavvVVaro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHvZv2ZkoTxVrLI51zQVRI4cHLysN9foc84RN4vjI/v/BRwp/UMjVRTsdIy+YqzrS
	 /f37BRCQZYqdKw2OCdbmSgJ05AzhKao3b4gFRpgWtU4yxXCfGUZV6TKQjumLPcKjJS
	 Zvys77meH7gCrf+n+E11cXQuYSLPHrexc77+g7Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1137/1674] sctp: add INIT verification after cookie unpacking
Date: Sat, 17 Oct 2026 17:56:49 +0200
Message-ID: <20261017160500.344950657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 414c5447fe6a200613dd46d7fdc8454622076cb1 ]

In SCTP handshake, the INIT chunk is initially processed by the server
and embedded into the cookie carried in INIT-ACK. The client then
returns this cookie via COOKIE-ECHO, where the server unpacks it and
reconstructs the original INIT chunk.

When cookie authentication is enabled, the cookie contents are protected
against tampering, so reusing the unpacked INIT without re-verification
is safe.

However, when cookie authentication is disabled, the reconstructed INIT
can no longer be trusted. In this case, the INIT must be explicitly
validated after unpacking to avoid processing potentially tampered data.

Add sctp_verify_init() checks after cookie unpacking in COOKIE-ECHO
processing paths (sctp_sf_do_5_1D_ce() and sctp_sf_do_5_2_4_dupcook())
when cookie_auth_enable is disabled. On failure, the new association is
freed and the packet is discarded.

Also tighten cookie validation in sctp_unpack_cookie() by verifying the
embedded chunk type is SCTP_CID_INIT before treating it as an INIT
chunk.

Finally, update sctp_verify_init() to validate parameter bounds using
the actual embedded INIT length instead of chunk->chunk_end, since the
INIT stored in COOKIE-ECHO may not span the entire chunk buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/ebcbbac574815b0850f371b4bdb02f2e602b94d3.1782341592.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c |  5 ++++-
 net/sctp/sm_statefuns.c  | 36 +++++++++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 73b5c0dba69fa..fd9fa4b651262 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1781,6 +1781,8 @@ struct sctp_association *sctp_unpack_cookie(
 	bear_cookie = &cookie->c;
 
 	ch = (struct sctp_chunkhdr *)(bear_cookie + 1);
+	if (ch->type != SCTP_CID_INIT)
+		goto malformed;
 	chlen = ntohs(ch->length);
 	if (chlen < sizeof(struct sctp_init_chunk))
 		goto malformed;
@@ -2338,7 +2340,8 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 	 * VIOLATION error.  We build the ERROR chunk here and let the normal
 	 * error handling code build and send the packet.
 	 */
-	if (param.v != (void *)chunk->chunk_end)
+	if (param.v != (void *)peer_init +
+		       SCTP_PAD4(ntohs(peer_init->chunk_hdr.length)))
 		return sctp_process_inv_paramlength(asoc, param.p, chunk, errp);
 
 	/* The only missing mandatory param possible today is
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a2f24e56c6262..0b54e45f241c6 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -707,11 +707,12 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 					 struct sctp_cmd_seq *commands)
 {
 	struct sctp_ulpevent *ev, *ai_ev = NULL, *auth_ev = NULL;
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_association *new_asoc;
 	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
-	struct sctp_chunk *err_chk_p;
 	struct sctp_chunk *repl;
+	enum sctp_cid cid;
 	struct sock *sk;
 	int error = 0;
 
@@ -785,6 +786,19 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
+	peer_init = (struct sctp_init_chunk *)(chunk->subh.cookie_hdr + 1);
+	cid = peer_init->chunk_hdr.type;
+	if (!sctp_sk(sk)->hmac &&
+	    !sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+			      &err_chk_p)) {
+		sctp_association_free(new_asoc);
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+	if (err_chk_p)
+		sctp_chunk_free(err_chk_p);
+
 	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -798,7 +812,6 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	/* This is a brand-new association, so these are not yet side
 	 * effects--it is safe to run them here.
 	 */
-	peer_init = (struct sctp_init_chunk *)(chunk->subh.cookie_hdr + 1);
 	if (!sctp_process_init(new_asoc, chunk,
 			       &chunk->subh.cookie_hdr->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
@@ -2215,10 +2228,12 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_association *new_asoc;
+	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
 	enum sctp_disposition retval;
-	struct sctp_chunk *err_chk_p;
+	enum sctp_cid cid;
 	int error = 0;
 	char action;
 
@@ -2287,6 +2302,21 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	switch (action) {
 	case 'A': /* Association restart. */
 	case 'B': /* Collision case B. */
+		peer_init = (struct sctp_init_chunk *)
+				(chunk->subh.cookie_hdr + 1);
+		cid = peer_init->chunk_hdr.type;
+		if (!sctp_sk(ep->base.sk)->hmac &&
+		    !sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+				      &err_chk_p)) {
+			sctp_association_free(new_asoc);
+			if (err_chk_p)
+				sctp_chunk_free(err_chk_p);
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
+						commands);
+		}
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+		fallthrough;
 	case 'D': /* Collision case D. */
 		/* Update socket peer label if first association. */
 		if (security_sctp_assoc_request((struct sctp_association *)asoc,
-- 
2.53.0



