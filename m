Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041938;
	b=iIyMkmRQT2Vy9D8D47ZHDGL40b28oVL2Z0Ek+uMhh54wBhOqiIGJL+DLRCHQa5mtrnTb
	 nKTOZsjar/SmaqpNfQYkLZAFKy/v6gxBCFXLmxosMhKQvuWnNsr/DLynafVcfzE8MRUUb
	 GZ8tc6Q6ySKLxD3ffV2Lx7F2yVuxOTLT6GC+/ATTKtkw9xxfUHDxr/MKqroIh+OmIhAM/
	 Ace+ZaPHZMIC3V1Y9Ptz0Xtg9EaR+Qul4pdG1c+Xe5KJaAQtfSQo3nx7SxgXK6scFOOAq
	 X5exsj83FDFKalAZShg/N5mboynrst2Bc16BGkx9CHDXh1yvWwAycNeR6JWVPQ+8igQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otWKtFuTW7+G3vwsv5FhoZc8Zl48+wTXp18sjmbfqf8=;
	b=UdPSjO7VvS7LLmI7ncth8/MYPUXxf655Zl+Xv8/6fd52n/+JBzIY24Wh4FvqHXSd9EA5
	 qap0bRVbBWCe9YkSJFBBEiUQZmDzoPkl8CJeZFsMr14XTBvidxD2uwh67V15eErnH4qW2
	 JpUI3qKJllLqACoca/e680KvQkL9d9cxfNrr1gJF3ozEclysQqAbjyzo4iZNblIzD8/DP
	 dC2xenwaXQ/VrsELd3hW04H6sCMQaRncDrJqeQdzpq4vq9f3LZxkQ3qHtoLfljoPiCw88
	 sphDRVy38RoiGwygo746w0zUlc7JZT/3Wcxo3iwredU/8v/EeP1UFli+tvg/EXDbseQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryk7Ih8h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB412606A31C;
	Wed, 18 Nov 2026 22:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryk7Ih8h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074131F000C4;
	Wed, 18 Nov 2026 22:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041938;
	bh=otWKtFuTW7+G3vwsv5FhoZc8Zl48+wTXp18sjmbfqf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryk7Ih8hOt+j/vQy2NIzfi2anXiNG8z+Cj4yQF3r8G2RuiOS+Mv8J2oHNfxbdPmL0
	 ezxb6keXgsLl7XEvdymLAJGBsUvyk3/NRiLfHiVhTxJeUhlJw4hFHNREjNhlvPZZlk
	 D1vjgZ+UC0ziIJxKYrBdiDiN17BVQKfCdLxJu1Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2993/3318] net: Helper to move packet data and metadata after skb_push/pull
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150450.058180078@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 8989d328dfe7c7a3b9f4b9f0ef60006d277f81cc ]

Lay groundwork for fixing BPF helpers available to TC(X) programs.

When skb_push() or skb_pull() is called in a TC(X) ingress BPF program, the
skb metadata must be kept in front of the MAC header. Otherwise, BPF
programs using the __sk_buff->data_meta pseudo-pointer lose access to it.

Introduce a helper that moves both metadata and a specified number of
packet data bytes together, suitable as a drop-in replacement for
memmove().

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-skb-meta-rx-path-v4-1-5ceb08a9b37b@cloudflare.com
Stable-dep-of: 12d07c38e1b0 ("bpf: Don't let bpf_skb_adjust_room() use up the MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 75 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8153b96c4977c..d6167cc0280c4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4409,6 +4409,81 @@ static inline void skb_metadata_clear(struct sk_buff *skb)
 	skb_metadata_set(skb, 0);
 }
 
+/**
+ * skb_data_move - Move packet data and metadata after skb_push() or skb_pull().
+ * @skb: packet to operate on
+ * @len: number of bytes pushed or pulled from &sk_buff->data
+ * @n: number of bytes to memmove() from pre-push/pull &sk_buff->data
+ *
+ * Moves @n bytes of packet data, can be zero, and all bytes of skb metadata.
+ *
+ * Assumes metadata is located immediately before &sk_buff->data prior to the
+ * push/pull, and that sufficient headroom exists to hold it after an
+ * skb_push(). Otherwise, metadata is cleared and a one-time warning is issued.
+ *
+ * Prefer skb_postpull_data_move() or skb_postpush_data_move() to calling this
+ * helper directly.
+ */
+static inline void skb_data_move(struct sk_buff *skb, const int len,
+				 const unsigned int n)
+{
+	const u8 meta_len = skb_metadata_len(skb);
+	u8 *meta, *meta_end;
+
+	if (!len || (!n && !meta_len))
+		return;
+
+	if (!meta_len)
+		goto no_metadata;
+
+	meta_end = skb_metadata_end(skb);
+	meta = meta_end - meta_len;
+
+	if (WARN_ON_ONCE(meta_end + len != skb->data ||
+			 meta_len > skb_headroom(skb))) {
+		skb_metadata_clear(skb);
+		goto no_metadata;
+	}
+
+	memmove(meta + len, meta, meta_len + n);
+	return;
+
+no_metadata:
+	memmove(skb->data, skb->data - len, n);
+}
+
+/**
+ * skb_postpull_data_move - Move packet data and metadata after skb_pull().
+ * @skb: packet to operate on
+ * @len: number of bytes pulled from &sk_buff->data
+ * @n: number of bytes to memmove() from pre-pull &sk_buff->data
+ *
+ * See skb_data_move() for details.
+ */
+static inline void skb_postpull_data_move(struct sk_buff *skb,
+					  const unsigned int len,
+					  const unsigned int n)
+{
+	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
+	skb_data_move(skb, len, n);
+}
+
+/**
+ * skb_postpush_data_move - Move packet data and metadata after skb_push().
+ * @skb: packet to operate on
+ * @len: number of bytes pushed onto &sk_buff->data
+ * @n: number of bytes to memmove() from pre-push &sk_buff->data
+ *
+ * See skb_data_move() for details.
+ */
+static inline void skb_postpush_data_move(struct sk_buff *skb,
+					  const unsigned int len,
+					  const unsigned int n)
+{
+	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
+	skb_data_move(skb, -len, n);
+}
+
 struct sk_buff *skb_clone_sk(struct sk_buff *skb);
 
 #ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
-- 
2.53.0



