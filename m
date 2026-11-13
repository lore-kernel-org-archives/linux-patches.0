Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590219;
	b=o1JdfZXQOG3BGD2kv+fXfF3HR4mAAWjHOYWibEzv5JCMae/VYwhh0pz/ukMr1ZXsAbjp
	 zIS4DL8dQLhHi+tf/v5Xnw00xqsjPFYtZr0gZsYZ3PfSCqY7ogTja2l9+pEOEGcFhAlxQ
	 7jAsYgHt57P3yTacLfSBKy58SlSulNeJbsDhdTudC0hPBgGQ4IY2dWQSO1jPSRAEpY1BK
	 JeEvM2quXqsYdMQ8j9P/GK/v3GBi5K/ZcG70YyfNRcz23/puXZ7uXwvguUwlRf/fduUcB
	 XFOIzsQJIKkQUWb3wBEcmA2FdOxmhVm/4PoEIBR2+tDoOloV6o/W+jwrJkfSIT1G33Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5wxtyKMddT09wMHChW99PKmgggfvmai4liXSft7Gcc=;
	b=k7sbpJuPM6CYjcDc41NS4Zj6oTbzIkxTEKKbhhCO0Vv3cHr0chgnaLFvc4DixWvPtwh/
	 v9gGN6onFbq9W8/s1nsiIrdPUwPyseON8Q24dEsO+dx1IndP5ZNfxHmMJ9/07jCMwPAy4
	 teA3uzUlcthON5UPTKGogXO/ogQ8R9UpKkvhpotxZM7iMcLpemfFP2GO0wmyXf7mUoPtc
	 i2gpLOfIsmfI9pt2JQFhJ4ehyEh2GjGBgMB5/2Yn7S1iAMe3mW+5G80c3l6ZtyzWnH6ek
	 +9zFewhi0P0e6SKsj2nm9m38RLbWOmufN9TNGwxgVeB+NP2v1YBEWIUxLqd+TuFPXJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1d4Ag/ga";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773A606C088;
	Fri, 13 Nov 2026 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1d4Ag/ga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1231F000C4;
	Fri, 13 Nov 2026 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590219;
	bh=q5wxtyKMddT09wMHChW99PKmgggfvmai4liXSft7Gcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1d4Ag/gaCfq2CsWY6yQPr1WVY0ay+ybmsnU+tawaIKldhtmO2iDna5wR98t8L9Dvp
	 fBrlIXIUUPsaIqSTkZxJXLcT8jL8lss+QSDLhdbNcTGiLR9jzlnYK2Tgr63Ohaoetg
	 ztVCTY2PqJIQcoJ6sSHj1rnZX9FTQT/eqO0R5aq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/686] sctp: account for chunk padding in sctp_init_cause()
Date: Fri, 13 Nov 2026 10:45:53 -0500
Message-ID: <20261113153828.486271012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masafumi Suzuki <shengshilingmu97@gmail.com>

[ Upstream commit ed6c53b27be492643da2017c6f8e2732be5edf1a ]

sctp_init_cause() accepts a chunk when skb_tailroom() can hold the
cause header and the payload. sctp_addto_chunk() then writes 0-3
bytes of padding before that header so the chunk stays 4-byte
aligned. The check does not include the padding, and the following
skb_put() calls skb_over_panic() from softirq.

Count the padding sctp_addto_chunk() is about to write. The cause
length on the wire stays the header plus the payload.

Found by LLM inspection, triggered and tested the fix.

Fixes: 8914f4bace3f ("sctp: add sctp_make_op_error_limited and reuse inner functions")
Cc: stable@vger.kernel.org
Signed-off-by: Masafumi Suzuki <shengshilingmu97@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261027082405.1297-1-shengshilingmu97@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 04716666b29ba..8e4e88b1d0c06 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -136,6 +136,7 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 		    size_t paylen)
 {
 	struct sctp_errhdr err;
+	int chunklen, padlen;
 	__u16 len;
 
 	/* Cause code constants are now defined in network order.  */
@@ -143,7 +144,13 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 	len = sizeof(err) + paylen;
 	err.length = htons(len);
 
-	if (skb_tailroom(chunk->skb) < len)
+	/* sctp_addto_chunk() pads the chunk up to a 4-byte boundary before
+	 * appending the cause, so account for that padding here as well.
+	 */
+	chunklen = ntohs(chunk->chunk_hdr->length);
+	padlen = SCTP_PAD4(chunklen) - chunklen;
+
+	if (skb_tailroom(chunk->skb) < padlen + len)
 		return -ENOSPC;
 
 	chunk->subh.err_hdr = sctp_addto_chunk(chunk, sizeof(err), &err);
-- 
2.53.0



