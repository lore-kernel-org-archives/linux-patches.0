Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625854;
	b=KmfMZHRn/5ArplhFZPyvrOoc3R55QgYX06K6xCO5h+A1gqYRutg2i5+aWHrsIcIkjvNq
	 +vAU8xlx+Kd3u5B3ldYUQOA1o4e8SibndreqOlNcwr1znEy7P952CrqElnlrhN5uWKOx2
	 exuhf0BVHOhRTcHDDsIjBmE95MP9OFpUVr7hWPcdPMu6dg8ou3bETHiAgiB/98lw6wzPc
	 ox4CceTNR6+q9InX8EvN0rIq1pK2ovhZgIyvD0ulTffsIjQLpaB+Y1ycH5CkVmIFQEYzf
	 9tsC4uE+2doZTLMiZwXGjfnP8cukEg7jR0iO4RN5FPPmK2+ckwuM9sc6jB42wjSgDgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUzZ5fB7xZozepo3dIgvp6XClYJHfP8dqXcDU2A4Fqc=;
	b=3R+O5LbjTsnh4nh6W0EVh1eJP0Y7m8EDnuH50eVklLXrSMtZHz7cUu3DrgXsWao0tNuP
	 2iTuQG85/WNfXffo51Y5KKPBmROlypvMAQOwu57n7zZbphyFaFyhW4CNVtS1xFn4b37Br
	 DLIHUNjTZvleatr5iIfIck4fxwxvB712OVjWr0iN/5PN/CZeHjG8gedRDT3+I8eoZGGga
	 ETbI0ah3mgyQmSDWd8ys8dAiqh4ZHj5jzCFG7KjBLCNww9cKir2p5UtPcA81VNjUdpNTe
	 xjL/hGY5aJSR6/jz76H17PyOGuGVz17Rh7dl+iUDjc6r0SDYVSXU9iJ4rECUasbkMMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyUFP0KB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B552E606A321;
	Wed, 25 Nov 2026 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dyUFP0KB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09B61F000D1;
	Wed, 25 Nov 2026 16:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625854;
	bh=SUzZ5fB7xZozepo3dIgvp6XClYJHfP8dqXcDU2A4Fqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyUFP0KBdH9OxOxg08bJwLAqXZSQJhfThnuwtZvaOuqYNCOVJzumEpHvbbypayQZ7
	 HvUTqFTPJTvsPdd89ZzQAcdf4dd3T/oZY2t+s7kWqFhnlW6C4eVsnSRlMQ5Vyb6d60
	 iVhdsEw8IrCHm4J3qhRA44KiCguUTWZW9W7lwUrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 650/816] sctp: fix I-FORWARD-TSN handling of fragments on other streams
Date: Wed, 25 Nov 2026 15:36:38 +0100
Message-ID: <20261125143904.228656567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Budding <tim.budding@gmail.com>

commit 5b9cfc6491a6e32e7315dc222992c7dbd5baa3e9 upstream.

sctp_report_iftsn() incorrectly frees queued I-DATA fragments in two
cases. First, it drops any queued fragments with TSN less than or equal
to the New Cumulative TSN. This prevents reconstruction of messages
still being received on other streams and can fully block an ordered
stream. Second, it calls sctp_intl_abort_pd() if the New Cumulative TSN
equals the highest TSN seen. This check exists for association resets
but can be inadvertently triggered by any I-FORWARD-TSN that arrives
before data with a higher TSN, causing data loss and, if a partial
delivery is in progress on an ordered stream, an aborted association.

Fix the first by freeing fragments from sctp_intl_skip() based on
stream, U bit, and MID instead of TSN. Fix the second by moving the call
to sctp_intl_abort_pd() from sctp_report_iftsn() to the corresponding
reset handlers.

Observed in real use as unexpected message loss. Reproduced on an
unmodified kernel with the sctp_ifwdtsn.sh selftest added later in this
series, which passes with this fix. Reproduction and fix done with AI
assistance.

Fixes: 47b20a88566f ("sctp: implement report_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-4-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c            |    2 ++
 net/sctp/stream_interleave.c |   32 +++++++++++---------------------
 2 files changed, 13 insertions(+), 21 deletions(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -749,6 +749,7 @@ struct sctp_chunk *sctp_process_strreset
 	 */
 	max_tsn_seen = sctp_tsnmap_get_max_tsn_seen(&asoc->peer.tsn_map);
 	asoc->stream.si->report_ftsn(&asoc->ulpq, max_tsn_seen);
+	asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);
 
 	/* G1: Compute an appropriate value for the Receiver's Next TSN -- the
 	 *     TSN that the peer should use to send the next DATA chunk.  The
@@ -1028,6 +1029,7 @@ struct sctp_chunk *sctp_process_strreset
 			LIST_HEAD(temp);
 
 			asoc->stream.si->report_ftsn(&asoc->ulpq, mtsn);
+			asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);
 
 			sctp_tsnmap_init(&asoc->peer.tsn_map,
 					 SCTP_TSN_MAP_INITIAL,
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1203,28 +1203,21 @@ static void sctp_report_fwdtsn(struct sc
 	sctp_ulpq_abort_pd(ulpq, GFP_ATOMIC);
 }
 
-static void sctp_intl_reasm_flushtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
+static void sctp_intl_reasm_flush_mid(struct sk_buff_head *reasm, __u16 sid,
+				      __u32 mid)
 {
 	struct sk_buff *pos, *tmp;
 
-	skb_queue_walk_safe(&ulpq->reasm, pos, tmp) {
+	skb_queue_walk_safe(reasm, pos, tmp) {
 		struct sctp_ulpevent *event = sctp_skb2event(pos);
-		__u32 tsn = event->tsn;
 
-		if (TSN_lte(tsn, ftsn)) {
-			__skb_unlink(pos, &ulpq->reasm);
-			sctp_ulpevent_free(event);
-		}
-	}
+		if (event->stream < sid)
+			continue;
+		if (event->stream > sid || MID_lt(mid, event->mid))
+			break;
 
-	skb_queue_walk_safe(&ulpq->reasm_uo, pos, tmp) {
-		struct sctp_ulpevent *event = sctp_skb2event(pos);
-		__u32 tsn = event->tsn;
-
-		if (TSN_lte(tsn, ftsn)) {
-			__skb_unlink(pos, &ulpq->reasm_uo);
-			sctp_ulpevent_free(event);
-		}
+		__skb_unlink(pos, reasm);
+		sctp_ulpevent_free(event);
 	}
 }
 
@@ -1232,11 +1225,6 @@ static void sctp_report_iftsn(struct sct
 {
 	/* Move the Cumulattive TSN Ack ahead. */
 	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
-	/* purge the fragmentation queue */
-	sctp_intl_reasm_flushtsn(ulpq, ftsn);
-	/* abort only when it's for all data */
-	if (ftsn == sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
-		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
 }
 
 static void sctp_handle_fwdtsn(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk)
@@ -1260,6 +1248,7 @@ static void sctp_intl_skip(struct sctp_u
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);
 		}
+		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
 		return;
 	}
 
@@ -1271,6 +1260,7 @@ static void sctp_intl_skip(struct sctp_u
 		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
 	}
 
+	sctp_intl_reasm_flush_mid(&ulpq->reasm, sid, mid);
 	sctp_mid_skip(stream, in, sid, mid);
 
 	sctp_intl_reap_ordered(ulpq, sid);


