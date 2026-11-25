Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622138;
	b=N/0ZzibTWUM4g3phWGV5UtVJn452b5gnS3li36CZKRn+1OjO6+KTd9NXswYizNOV2bfV
	 kPTt60f4HWZQbzXgARa0B3EHqIVbx2zfmB3AID6qZUk8odtIgU4O4HUNGh2IfjqU1/6oq
	 bUgCOTP/TDfgjmLymms2PWQQF9iiSsyhgU2uI1PIue8gFDb0DDtvqbuaIQ4GpxZ3aEim8
	 w5GbjhzBf7pUC7NVfWOtAD76U6Dc5rz74obCfZuOwnMNQ8c8o5TK6LvVXRjfJ+RZajC8x
	 FEyaPp7fyyPduZVbracYFqz7DhDGwPsQo6cN0FoqSo2aDFels8j8BWHyOCdG/NntPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aRqoHczYwkAbfj2mgn+BrVtxvOUnFfnXXofAjA60fps=;
	b=fUWlG3fYln2Ahcpwpj2N6OZHdW7lWywKDy4cmoy8WCvludCGQIiCb59aCk3PS1Y0zBQt
	 jaBpwHFWpVS/qUy6XSFgcXJLc//0nxgb4pyblEOwFevxY9pPA32hbGLd2Xr4DboTOk/or
	 3JmJ+3UBHDL78poz7YZ7GgHCFplWHpQJ1LCzoggMAbVdwCxYUE/IFmUcRkyawSRsWTeWW
	 HN48aec1Aleq4skiEMlD8sy+1skBtG9VvIoU/9ql2MOhEfbAfVjjD79WSidFSclXuFU7M
	 vWc8xsthHz/U0M+0ZAVbs7dlg5KMfKhBhg8036cP4NujmvqVTobwXHoxIW33zbL9Z/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+MG5IOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAA4606A323;
	Wed, 25 Nov 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+MG5IOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113041F000D8;
	Wed, 25 Nov 2026 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622137;
	bh=aRqoHczYwkAbfj2mgn+BrVtxvOUnFfnXXofAjA60fps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+MG5IOQeeeWEksGDLvn+h4IfAlWrph/E2XTRya2OE4AWB1UvWEopAqhzzFhSQL7s
	 q25qBt8zYUI/11ZpYIzPk9QRUn3sgzjOt2mfjz6TEGHq0JszLVjcLX77G9XSsdQFZf
	 biJ0Hfq1aGhhwNH0Jj0tbhD5YwMnrT73P0q5Iatg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Chris Mason <mason@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/990] net: skbuff: uncharge trimmed zerocopy frags on error
Date: Wed, 25 Nov 2026 15:30:01 +0100
Message-ID: <20261125143832.260992297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 8b67debdfbf6b370312ebec5c9e0a1c39b5c7733 ]

__zerocopy_sg_from_iter() accounts for the frags that it adds even when
it returns an error: it adds the growth of skb->truesize to
sk_wmem_queued and, unless the skb is pure zerocopy, charges it to the
socket.

On error, skb_zerocopy_iter_stream() cannot free the skb, as it may hold
data from an earlier send. It trims the new frags, but leaves
skb->truesize and their accounting in place.

Repeated failed sends to the same skb accumulate this stale accounting.
This can inflate TCP memory accounting past tcp_mem, and can wrap
skb->truesize, leading to a use-after-free of the socket.

Undo the accounting after the trim. If the trim fails, the frags and
their accounting remain. The trim only fails if the skb is cloned,
which is not expected for the unsent skb at the TCP write queue tail.

The issue was found by an LLM.

Fixes: 52267790ef52 ("sock: add MSG_ZEROCOPY")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Chris Mason <mason@kernel.org>
[willemb: revised commit message]
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261105223512.3647504-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4ee359dfe93bc..07df2030ccf2a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1859,6 +1859,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct ubuf_info *uarg,
 			     struct net_devmem_dmabuf_binding *binding)
 {
+	unsigned int orig_truesize = skb->truesize;
 	int err, orig_len = skb->len;
 
 	if (uarg->ops->link_skb) {
@@ -1879,12 +1880,18 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
 				      binding);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+		u32 delta_truesize = skb->truesize - orig_truesize;
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
 		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
-		___pskb_trim(skb, orig_len);
+		if (!___pskb_trim(skb, orig_len)) {
+			skb->truesize -= delta_truesize;
+			sk_wmem_queued_add(sk, -delta_truesize);
+			if (!skb_zcopy_pure(skb))
+				sk_mem_uncharge(sk, delta_truesize);
+		}
 		skb->sk = save_sk;
 		return err;
 	}
-- 
2.53.0



