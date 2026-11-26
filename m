Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704611;
	b=TZcWocjT4e3WUPDf+Sg3LqrZiiGDeZQYiSTkyOMSu70jpoXhtPNzaQBUgT+pYw09qLPG
	 g8S06sQdqRmX3eBvFLYQg2U2nD3yKZPM+EqOfY7zuuDEd21UJb0BjFT9fkyVxyoDytIrw
	 WUA2QszUogmu3zIHhyeS9SwFF33Cj3MKetCq9ZEUkI0RzuqPc75c5zsYRyd5sLydIQyWc
	 oGWxrupAE1xbYBatvbsmEKdJHhqolNaN3c7E7sC7SixLrt0S5dZkhJMqRIlZcHWtS/pnY
	 5ecamuoBUHD9oA9vtqLS5kbTYrSoLR7IohIWxFjumTFs2XZw/OCaZGvYS5wf5ol0p5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZReucJIgUaOjHIz5qFHeCgTE5Tb9SgEPPuEBaeLp0Q=;
	b=mEiH5FVsdcaJy7V1fqA4NA6UsJKCq3dLTTTkjRcOhz2QDuiOw0pV2ZK79TJ/tnRj0FTU
	 D9uUz8P3+3Use98qACZ+qsTEdI9IVr1ksHRAFVJ/ekkfxI3X6XS7SYdsMs++cZ8NaMMtI
	 GBUFpHDO12pbUA2ZjZXAS4H3NwZKIvSvvVlWk7XY791l5FUENJS58wqOO1nv7GZhZeede
	 0gaQ36XPXbZeRI/b5qm2Pfl3rsCTxRvTyDpiMo0Fk0je8h2MXwWGekKzDRjHOEbA+rnvl
	 EH/ivIylwhe58R4X3petqm0yvFWGGPfhVYPHMrDdV60ymCtHxH7mT8rJ/9LYcrvvkyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFhQXZI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F6F606A31E;
	Thu, 26 Nov 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFhQXZI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188461F000C0;
	Thu, 26 Nov 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704611;
	bh=JZReucJIgUaOjHIz5qFHeCgTE5Tb9SgEPPuEBaeLp0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFhQXZI8o1RoK6BLEweQcawYIIyakL7zDeU9t86uGkMqANRTdylWGY5OEB2iOoCfK
	 NOaItoRzWWl6Y1jox7YDbIgPB0nE2Pp9hylTLoZgFkjmtN+63GHBDEoj3jAwxSS981
	 CzcCPyzIAF2O1EXj1j72AD6jkyc/tXXwP8X+gvfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 182/265] sctp: abort unordered partial delivery when its message is skipped
Date: Thu, 26 Nov 2026 15:38:32 +0100
Message-ID: <20261126143617.944689821@linuxfoundation.org>
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
@@ -1263,7 +1263,7 @@ static void sctp_intl_skip(struct sctp_u
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);


