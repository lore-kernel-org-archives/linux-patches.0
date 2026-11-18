Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046354;
	b=S1P89fiLqvKZYeC+Y7xgewAaHwMpdvTYPMo1BkNopPVFkjiw9qEmKc/pzymdeRXkVaRz
	 eklu5rESJhN1cGd4QBSuwX0I2lkD0dRTJKGSY8r9hz86/8I9FCqmnGD2E/HbuHfWp3t5a
	 RjCFdWv42aDmqdqyQYnBO6CGv07K6wcBtUbZk9BO4q9zDgfddAz4tnlAnjNMH4STsShKW
	 g4IswkxaekRfYd//P3jjvtCBGQ1DtOVhKFwA/tR1yquO0UtIWLLsi+2bHswmTFNsvUS5x
	 8I7SBjt8NNdkewMuVZ7kTlicRjb959eGpBdlMWNiMKwZbZkaDwNx5mI/pCg4x25WGHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEr5mZR8CFD+X6xve0VbUDDLhOCbYd+cdBqIv6on52c=;
	b=L25ZleMNUJBD94c31LNSDSTjGN1SlSXGUA4IFNMHMrvNsR8EOcKFUIvr35NgafvrUEip
	 aCJgBmmeJLHSkYLHltxUJAf3/BZkvC8+iyHlf3Ln96xcCZ3eftXmmT4Y7cSI80AGbiLWm
	 rlqCw0qJrcbg64tUrM8Ro8isdv5PTsBskuhMcEGV5YxsNb3TJ8GtdLDKHeLXm0OonmK55
	 D9cU78hZM4y8PYJQoAo9yg3FSD14Vr1AlC8ZmY5rIAbeJwETd5ywS1iogywH/qd+Fqcbp
	 QYbfceqqKPfM1wCr1AAlcpsRDTg/uihb/PBxuN1cTBK1TLrZV5fP55vplcOSzp9cfqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7oIFdJA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70C606A325;
	Wed, 18 Nov 2026 23:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7oIFdJA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AEB1F000C4;
	Wed, 18 Nov 2026 23:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046353;
	bh=XEr5mZR8CFD+X6xve0VbUDDLhOCbYd+cdBqIv6on52c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7oIFdJA1cDzXCFuPHNZRmt1rMs1Y8WbLtQ72tjUSvgvOvzkPgnjkXU6mxcUlqK9U
	 WUM9BSce0lSEdjfKD9tDvM+1CQmpARkAXeGmwHECotZx8ttQuDQjK691SRvaRTjn/8
	 +8Uv2Oou4KV3l8IVBfbgElP8nrgd3hAD59eCLKZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1210/2857] sctp: account for chunk padding in sctp_init_cause()
Date: Wed, 18 Nov 2026 15:37:24 +0100
Message-ID: <20261118150245.160958997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b5ade45d6c66f..4f3133bd649a9 100644
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



