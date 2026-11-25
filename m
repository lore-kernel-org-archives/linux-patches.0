Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625844;
	b=A7OnHsEKE/33R1+njYHAgUSGNH3iPgx+555g4X2KNFh5Jfx62LwDxvyegWBKhpahrvOi
	 kDdn0hzaIJsBfgnOsiu3S0cOdfI39BGNqOD3xyrJGSWlTVE4fSmb4+JoeUWMSVzcSqWvo
	 INqzqli2tnI6BoxeFpE6s8fkviW49Ra1az/RrQLIiSTurBxjBtmoVPkqR+LaitDJZbuvZ
	 +mqT6DWrZgNXOMklx9Y2apW9JVM6ca4P5hmKwefNkqsJCawmA8a8JIUBzPhOSHVFWBXEO
	 hboO5i078OVCoOOA/FxHy4RDDtBWITPcoSAuEhLC6EJ4HGbTTkhrp7+RCA6YKKCdktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NjQ9uor0c6MsMnUDqlpfsXcouRna/B3VAnzc7J6volM=;
	b=osY+aowYGOCE72xi+1yiVmtvqoUn2OBnwSOypDAxSVxO2JOCpsPEAQjYHLu7ID0TAxhp
	 E/ajuec5qp3jVStb0NzGug5s8eDW+IIL9qCbZxJ1ac/gSlSBkbfpRWuwSTZinPiuJ9WO8
	 kl1/8+77N04iy5CnjJDmtNpaNZ1xsUp3wE8v8RWEB2BPI4TwdaDg9vQ8CCeTBozNYmc8U
	 7d7wEVLnzESrMPXMSjbvbo7mCLIWgieIv1P524uAZfM285I6VcQVPZd4PGjo6SL4iNaoG
	 zLJaw9lVCe+5nVrDOomJQJkPvtVihW7Io78Y5MfDZUBmBBTz+wtCINnGQO224ajyKeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQjmfdOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E22606A31E;
	Wed, 25 Nov 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQjmfdOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B571F000C4;
	Wed, 25 Nov 2026 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625844;
	bh=NjQ9uor0c6MsMnUDqlpfsXcouRna/B3VAnzc7J6volM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQjmfdOQWLxc1oduSolnOQvUVc67rFGEMnIFvojPQS1zY8JaNEcLUkug6uZ02I/Ph
	 kdUNuJGsbE4TpDC7wRTY6dtmWnT2b1OfMhHIyCVGqBjl6n9u6220zjNOPPlfSeEQKY
	 MJYyLJmjetqrVXqQg29klNwGwfJuN7KgORKOIUBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 647/816] sctp: abort unordered partial delivery when its message is skipped
Date: Wed, 25 Nov 2026 15:36:35 +0100
Message-ID: <20261125143904.159805813@linuxfoundation.org>
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

commit 05852c8b70f2291a50bb3f740a66ce9caf9cb98d upstream.

When an I-FORWARD-TSN skips unordered messages on a stream,
sctp_intl_skip() only aborts the stream's unordered partial delivery if
the MID being delivered is lower than the skipped MID. If the skipped
message is the one being partially delivered, partial delivery stays in
progress: no PARTIAL_DELIVERY_ABORTED is sent, and the next unordered
message on the stream is delivered as the rest of the abandoned one.

Abort the partial delivery when the MID being delivered is at or below
the skipped MID, as the ordered case already does.

Reproduced on an unmodified kernel with the uo_pd test of the
sctp_ifwdtsn.sh selftest added later in this series; its partial
delivery checks pass with this fix. Reproduction and fix done with AI
assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-2-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream_interleave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1255,7 +1255,7 @@ static void sctp_intl_skip(struct sctp_u
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);


