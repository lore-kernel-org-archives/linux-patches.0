Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585434;
	b=jfCOh9LMHLQFk3DAZU8vRhDBkNI4ePAvf+sfdCV6ttG/KsmrO9oDuDP982UoRIjxs4Hh
	 UsFKhcubjQoJ+r4h8GqVzWxGW7T4x4+O7+lE3wqsRoG3eWmxFulYhpzkHXm0LoKLdNjsX
	 DjY55YzJZkE7HYe1mY39loOlXkXiWb32XMLHYSNKLKHP7OzZoFWF54xPnx41jJ911D4zh
	 7oALU0e5nXt8vgDyFxZ+ncMOIkyCQy1mpSun+uiBlS0Op23jclAsUB8Ef7U/iKiEDzm4f
	 FQbagjXswHb5z7FbrqAZ1pmVNA/GfkzinTN7839dZIjweB2+yAabkmSqFI4vTf9vSNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SmYQqWM1xVZCWcFdyYz1pnXu/XrAHaIAS6DBzQaDQw=;
	b=JpcA8LoRmykGew1Wve7wHgS7uf0PEfzaW4XAoJCeqAELtFupBqAQ9DYCrErqcdtduICT
	 jPZ8a2GFAJYvI/w1ncRAMOgQUgcRJzBAlaiJEadxJ7FS/AWBWlnFMtl0xbarppqqHfadb
	 1fEvBYxwk7Cf4xYGiBPECanlbQP5Azl2ykRGU9BRAcUw5iHCLsVnvczAZBQu7IIRlC4m1
	 i8nCVvApJkIJ8QgD7yis7/p1VyWUelhfpJM4lxTO1H5gtlzS5u2KIiM9ziRxOC6CFBBm6
	 BeDykUznubo+/cpQQBQFMFiokwGhhB3bi+TwvbSiMfE8pHKZQl4YHe5/sWVl6j++hBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sj+spFhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7009360A5BCB;
	Fri, 13 Nov 2026 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sj+spFhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C66E1F000C5;
	Fri, 13 Nov 2026 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585434;
	bh=1SmYQqWM1xVZCWcFdyYz1pnXu/XrAHaIAS6DBzQaDQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sj+spFhCGkj7XCe7c0kGIe1gqcrFqM/fhn6/2Vsqeifz4DcOVA3+RGPl2bomrWmZN
	 ABKlgqnc+Yj5GTyasEF8HMx/72u4d91Hw85wlg7AIuHCnJDwoAvUNXn3PgZ7csseYq
	 2rcV1roTxXCSOPZcjbCgY2htTBNZ3aduVUahqzg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 094/507] sctp: account for chunk padding in sctp_init_cause()
Date: Fri, 13 Nov 2026 10:46:38 -0500
Message-ID: <20261113153757.253312119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 84a4c97d0f755..8933caadcdb66 100644
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



