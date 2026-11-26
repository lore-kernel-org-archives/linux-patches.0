Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704624;
	b=CRBqdbwrWgoZmnOws68htcgiC6aPhZW8n7gCxcUZAqpL36nIavTmhymA6cvKOqJICir2
	 HEgjd3i1ckoGkDSdmCk5Ao8xxx9shAzJT9AW64YIGa6IrMEEHWB5qhOmZd6O5dMzF9P90
	 acxsNfcAAoSG5e5oDUwLusKA2yf36wCTK1XCAxuCT0tQjCuOcFDQOAoC5ad+GNYUe1E7z
	 GqaiUSROduUUUZh3THI2Y6v18Mw12OLg7s1v99OYo313AYnPdc15R7ph1XqBm9u0EsX1E
	 1PzrfWMuif88c/0eoqfW5EA9TC4vnUFBH9TcN4gyeOGjBUvaPNFG6Ho268rkY/9eM2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j3d167u+SaorwlbMJqy3ruo5ksxOB37RMtpGmwtPQa4=;
	b=1VdoZE6QCuKZzKg/sn06AlbU69I4m1yaEq+UVj5GNyeCJ+/Gx43vZl21Fz5iKiWVJozA
	 egRxKql9y9aSO/b1sAK6jz76rcZLlZKh35626DtjOfGR5ajZqeM2Tsqu1I4VKaLB1W5c6
	 34+D5Qyebp2JKenc91Ryrm+9+NwTDlQyymnnK6pYweIsP6W0Z1AGExDqncAY9xWwqGxjz
	 2ycY5pcl00lVsf7mwjNRi7N4f83Tzg0dy8dm/ToHwwNRhaO7XBOPp6blDQySQBYJk5urF
	 wbMujdNFIDLlllAy2ud7sO8hmslpPKSkbbjnHvt3o98tY0EGcKTE6b22ki6RoFyD3+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FWAxIvQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71130606A31C;
	Thu, 26 Nov 2026 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FWAxIvQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23941F000C6;
	Thu, 26 Nov 2026 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704623;
	bh=j3d167u+SaorwlbMJqy3ruo5ksxOB37RMtpGmwtPQa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWAxIvQwuEMJtggBL4RdlNrcgDNNQfar88YsJdqvlyViSfSua2IFFtTsDSpMDSdOu
	 k09OwOswXYId8RluYrXDdhR2tsdBLp9nac73g+WSNctviz+xcvntgLWaH6JwzxUwnm
	 S3hOVfN6E4OX+V9/X/8pG72Hu9PqgTkvPQMm0jfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 186/265] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
Date: Thu, 26 Nov 2026 15:38:36 +0100
Message-ID: <20261126143618.213815833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Budding <tim.budding@gmail.com>

commit 3097fba868019924e92b8786ebd473992565f015 upstream.

When an I-FORWARD-TSN skips the message being partially delivered on a
stream, sctp_intl_skip() passes the MID from the I-FORWARD-TSN to the
PARTIAL_DELIVERY_ABORTED notification as pdapi_seq. That MID is the
highest one skipped on the stream, so when more than one message is
skipped, the notification names a later message instead of the one
whose partial delivery was aborted.

Report the MID being partially delivered, sin->mid_uo or sin->mid,
instead.

Reproduced on an unmodified kernel with the pdapi and pdapi_uo tests of
the sctp_ifwdtsn.sh selftest added later in this series, which pass
with this fix. Reproduction and fix done with AI assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/179293012867.3134.16497481637722705271@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-3-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream_interleave.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1253,7 +1253,7 @@ static void sctp_intl_skip(struct sctp_u
 	if (flags & SCTP_FTSN_U_BIT) {
 		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
-			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
+			sctp_intl_stream_abort_pd(ulpq, sid, sin->mid_uo, 0x1,
 						  GFP_ATOMIC);
 		}
 		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
@@ -1265,7 +1265,7 @@ static void sctp_intl_skip(struct sctp_u
 
 	if (sin->pd_mode) {
 		sin->pd_mode = 0;
-		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
+		sctp_intl_stream_abort_pd(ulpq, sid, sin->mid, 0x0, GFP_ATOMIC);
 	}
 
 	sctp_intl_reasm_flush_mid(&ulpq->reasm, sid, mid);


