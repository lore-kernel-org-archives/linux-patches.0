Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037657;
	b=Alt/nJvPsqefPAbcMfo/+Dy/q7fBNKPDdPTYgdkjuC+uZcrJrVS+UqPOAiNPSU2211+o
	 hJN6VsZkDYuzzyh3wuKuuB9w6TzkTpzHeUY/nrRtLNtYme3WpnTVRW8o76GX3SebWtQua
	 w0O5HdS5CEiTorqhmVuOUVQVIzUDnQcsYbsI0XdIub4MK6GMyfX1H6tfzlfK37sPOOhCJ
	 alh4mLlvknlegJlgFzOzu6C6QSl7KU/cTgeSAJULioPim/kGTfLBEwBcLXuon+IO3OijI
	 51cW6SzdYzdQwy5Re7dySWFXmlY/xu+rX5uzACRHwKD+PPCKxHdsM+2ibw+saaV+LIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NHCcZU3IXz4pix+0Q2z0KG0tFsmss0sJqxU7G/qiNGc=;
	b=2GmE5IiOqm/s0W4m728y3ilv7IKo/TyNpCswQkqLHLWGLgodRDxDrhlGsDaFBfmR6MEL
	 2j/TmgnllrEbO9Mqz4xURugfE45xbxirtoxFJmOAp+/GPQmFUlNJFKAgB6ewAhjHdzX9Z
	 2l9b5JfIU8RHnMkx8ozBCJtROhUOFETqPxNnoLON3dFlCryVPUV6t4i2eGFPOEca0zMsJ
	 AIGRO4/U5jUuAa7faG8rXiyszEAyvHsRYSkltI2Pl2ISq8UFhWXCHnRecvL5w9Ce3Xg4e
	 /7df4rGPmhsrSCqtMqbLxlcMLTUrCPc4ptQkMMPvGmEj/OFdgA4C4EBO9sEUoPdFZGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPr0AyfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F1606A31C;
	Wed, 18 Nov 2026 21:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPr0AyfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BCB1F000C4;
	Wed, 18 Nov 2026 21:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037657;
	bh=NHCcZU3IXz4pix+0Q2z0KG0tFsmss0sJqxU7G/qiNGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPr0AyfDzE3Ni9WebSwbPIV3MauX1hYPT/ncZIMKA+MWD9riiSnGp1TX1uhX9uw24
	 VEAbnEwX9AMRB/SXUkfIlAWCuhNRIjlFa3mV6iD7ethRrlebVovoBdnW5PKgwwo1Zu
	 yiUDwda0w1lHS06imLEenJELIg7BsrEhje/6zSxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1422/3318] sctp: account for chunk padding in sctp_init_cause()
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118150403.373389976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4d663210f825f..c2f716e68d6e0 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -145,6 +145,7 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 		    size_t paylen)
 {
 	struct sctp_errhdr err;
+	int chunklen, padlen;
 	__u16 len;
 
 	/* Cause code constants are now defined in network order.  */
@@ -152,7 +153,13 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
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



