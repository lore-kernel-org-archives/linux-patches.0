Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705620;
	b=mcfx0nhm77ghA8ez7tLdUwyu+g55h8kzmRV7hvJxgFnLViKo48eCVm3FJmmORUpdbkQJ
	 mW/n3Ir5U6TF7wy4Tfo39YdL9gMDSnQPzMkKRVE93OXel2rKcrRDL6fjhZ+eZTxwOtU1c
	 Iih7B/HHjPR5oT+tH8weW2McmUlcP6Q9HOZLKfF8psfRi2ootjPbUlnf49vZxK6dahhHk
	 4wqhaVwZUdtGzWyalA0YiVzF9YKntQFo3/MYaFRNIGbFtAGKmIc9j7ij5n5W2yj2n34yY
	 nP5YtOEBH0PD1NKGqe1Or8LUaa1Mm0lz4Y7+U0MCKo2aSzNozI8oU1sOO7MAfHovoGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZEm7iQKn9B+DQL/4qPSSa+ZbuTMWTEDra2jz9Vfee8=;
	b=V06/XNxZ1bFvwq3LyW3GX/xGYkx+OC1487d1DvNynqNDtMk1TBKG0xcI7Ty9DJGWgQ6V
	 aXPRMaXfFoaUTJj6LTsKu+uE8M1mIQu/+81zgr0MHMP7exlMFp9Y7JUsXJSXuh4vD+Pbl
	 ZBoVxGAmmS5uiugMLPoTO83brSoYal1CvHgJMRoLSjqNwa9lBzC2pjG49yA1/q7BFZAVm
	 bEBMT5/V5mOEFUhR7ecEKlEwMni9u1ftChSh9RQcIpQ9quGs6YwBKmwq4aKz4hyq6t1Jz
	 bikKu7Hm0lgHYi7iPk28MO83ANpl8G0FU5axu9sDS5JvL7mraoPyJ47vLIBBQ0HYkGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwSLJFJU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F30606A31E;
	Thu, 26 Nov 2026 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwSLJFJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3931F000CA;
	Thu, 26 Nov 2026 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705620;
	bh=LZEm7iQKn9B+DQL/4qPSSa+ZbuTMWTEDra2jz9Vfee8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwSLJFJUX65K2uibJ3MCqwYQflGAJdv8ZG9JTurWmXyM56QlXHrVPYMUkZhhTmHjA
	 u0sXaMGj7jO2zuoQQPchfYJjdDw2wmmvgB9guCaVlVc3lAYsLGphpKIDhqbJsWwduu
	 eNkwvxx1R1hVYPKFBdXZiBXAkKqchycgNAcKyPIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 222/319] sctp: abort unordered partial delivery when its message is skipped
Date: Thu, 26 Nov 2026 15:39:50 +0100
Message-ID: <20261126144011.760102583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


